import java.lang.Math;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Collections;

class SugarGrid {

  private Square[][] grid;
  private int width;
  private int height;
  private int squareSideLength;
  private GrowthRule growthRule;
  FertilityRule firt;
  ReplacementRule replaceRule;
  CombatMovementRule combRule;
  AgentFactory agFac;
  Map<Character, Integer[]> childbearing =  new HashMap<Character, Integer[]>();
  Map<Character, Integer[]> climacteric = new HashMap<Character, Integer[]>();
  
  // helper for addAgentAtRandom(): point (i, j) is represented in "reading order" by Integer j*width+i
  private ArrayList<Integer> randomPoints;
  private int randomPointIndex = 0;
  private Square lastAgentSquare;
  
  /* Initializes a new SugarGrid object with a w*h grid of Squares, 
  *  a sideLength for the squares (used for drawing purposes only) 
  *  of the specified value, and 
  *  a sugar growback rule g. 
  *  Initialize the Squares in the grid to have 0 initial and 0 maximum sugar.
  *
  */
  public SugarGrid(int w, int h, int sideLength, GrowthRule g) {
    this.width = w;
    this.height = h;
    this.squareSideLength = sideLength;
    growthRule = g;
    
    // make the grid, initially with 0-max-sugar Squares
    grid = new Square[width][height];
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        grid[i][j] = new Square(0, 0, i, j);
      }
    }
    
    randomPoints = new ArrayList<Integer>();
    for (int i = 0; i < width*height; i++) {
        randomPoints.add(i);
    }
    Collections.shuffle(randomPoints);
    lastAgentSquare = null;    
  }

  /* Accessor methods for the named variables.
  *
  */
  
  /* Accessors
  */
  public int getWidth() {
    return width;
  }
  
  public int getHeight() {
    return height;
  }
  
  public int getSquareSize() {
    return squareSideLength;
  }
  
  /* returns respectively the initial or maximum sugar at the Square 
  *  in row i, column j of the grid.
  *
  */
  public int getSugarAt(int i, int j) {
    assert(i >= 0 && j >= 0 && i < width && j < height);
    return grid[i][j].getSugar(); 
  }
 
  public int getMaxSugarAt(int i, int j) {
    assert(i >= 0 && j >= 0 && i < width && j < height);
    return grid[i][j].getMaxSugar(); 
  }

  /* returns the Agent occupying the square at position (i,j) in the grid, 
  *  or null if no agent is present there.
  *
  */
  public Agent getAgentAt(int i, int j) {
    assert(i >= 0 && j >= 0 && i < width && j < height);
    return null; // stubbed
  }
  
  /* returns a list of all agents on the SugarGrid at present.
  *
  * not tested.
  */
  public ArrayList<Agent> getAgents() {
    ArrayList<Agent> retval = new ArrayList<Agent>();
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        Agent a = grid[i][j].getAgent();
        if (a != null) {
          retval.add(a);
        }
      }
    }
    return retval;
  }

  /* places Agent a at Square(i,j), provided that the square is empty. 
  *  If the square is not empty, the program should crash with an assertion failure.
  *
  */
  public void placeAgent(Agent a, int i, int j) {
    assert(i >= 0 && j >= 0 && i < width && j < height);
    Square s = grid[i][j];
    if (s.getAgent() == null) {
      s.setAgent(a);
      lastAgentSquare = s;
    }
    else {
      assert(s.getAgent().equals(a));
    }
  }

  /* A method that computes the Euclidian distance between two squares on the grid 
  *  at (x1,y1) and (x2,y2). 
  *  Points are indexed from (0,0) up to (width-1, height-1) for the grid. 
  *  The formula for Euclidean distance is normally sqrt( (x2-x1)2 + (y2-y1)2 ) However...
  *  
  *  As in the book, the grid is a torus. 
  *  This means that an Agent that moves off the top of the grid ends up at the bottom 
  *  (and vice versa), and 
  *  an Agent that moves off the left hand side of the grid ends up on the right hand 
  *  side (and vice versa). 
  *
  *  You should return the minimum euclidian distance between the two points. 
  *  For example, euclidianDistance((1,1), (19,19)) on a 20x20 grid would be 
  *  sqrt(2*2 + 2*2) = sqrt(8) ~ 3, and not sqrt(18*18 + 18*18) = sqrt(648) ~ 25. 
  *
  *  The built-in Java method Math.sqrt() may be useful.
  *
  */
  public double euclideanDistance(Square s1, Square s2) {
    return Math.sqrt(Math.pow(s1.getX() - s2.getX(), 2) + Math.pow(s1.getY() - s2.getY(), 2));
  }
  
  /* Creates a circular blob of sugar on the gird. 
  *  The center of the blob is at position (x,y), and 
  *  that Square is updated to store a maximum of max sugar or 
  *  its current maximum value, whichever is greater. 
  *
  *  Then, every square within euclidian distance of radius is updated 
  *  to store a maximum of (max-1) sugar, or its current maximum value, 
  *  whichever is greater. 
  *
  *  Then, every square within euclidian distance of 2*radius is updated 
  *  to store a maximum of (max-2) sugar, or its current maximum value, 
  *  whichever is greater. 
  *
  *  This process continues until every square has been updated. 
  *  Any Square that has a new maximum value 
  *  should also have its Sugar level set to this maximum.
  *
  */
  public void addSugarBlob(int x, int y, int radius, int max) {
    Square xy = new Square(0, 0, x, y);
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        Square s = grid[i][j];
        int radii = (int) Math.ceil(euclideanDistance(s, xy)/radius);
        s.setSugar(s.getSugar() + Math.max(0, max - radii), true);
      }
    }
  }
  
  /* Returns a linked list containing radius squares in each cardinal direction, 
  *  centered on (x,y). 
  *
  *  For example, generateVision(5,5,2) should return the squares 
  *   (5,5), (4,5), (3,5), (6,5), (7,5), (5,4), (5,3), (5,6), and (5,7). 
  *
  *  returns all of these points that are on the grid; if radius < 0 returns an empty list  
  *
  *  When radius is 0, returns a list containing only (x,y). 
  *
  */
  public LinkedList<Square> generateVision(int x, int y, int radius) {
    LinkedList<Square> retval = new LinkedList<Square>();
    if (radius < 0) {
      radius = -radius;
    }
    for (int i = -radius; i <= radius; i++) {
      if (y+i >= 0 && y+i < height && x >= 0 && x < width) {
        retval.add(grid[x][y+i]);
      }
      if (x+i >= 0 && x+i < width && i != 0 && y >= 0 && y < height) {
        retval.add(grid[x+i][y]);
      }
    }
    return retval;
    
  }
  
  /* Adds agent at a Square
  */
  public void addAgentAt(Agent ag, int i, int j) {
    grid[i][j].setAgent(ag);
  }

  /* Updates the grid by one step. Each square on the grid is processed in turn, according the following steps:
   * 1. The GrowthRule of this grid is applied to the Square, possibly increasing its sugar level.
   * 2. If the square is not occupied, then we're done, and can go to the next square.
   * 3. If the square has an agent in it, then:
   *   a. Generate vision for the agent (based on the agent's vision radius)
   *   b. Apply the agent's movement rule to determine where the agent wants to move.
   *   c. Move the agent to its preferred square, provided the target square is not occupied.
   *   d. The agent consumes stored sugar based on its metabolic rate.
   *   e. If the agent is now dead, mark its current square as unoccupied.
   *   f. If the agent is still alive, it eats all the sugar on the current square.
   */
  public void update() {
    HashSet<Square> seenSquares = new HashSet<Square>();
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        Square s = grid[i][j];
        growthRule.growBack(s);
        Agent a = s.getAgent();
        if (a == null || seenSquares.contains(s)) {
          continue;
        }
        a.step(); // d and e before a, b, and c -- or could put step() inside Agent.move()
        if (!a.isAlive()) {
          s.setAgent(null);
          continue;
        }
        LinkedList<Square> vision = generateVision(i, j, a.getVision());
        Square dest = a.getMovementRule().move(vision, this, s);
        
        if (dest.getAgent() == null) {
          a.move(s, dest);
          seenSquares.add(dest);
        }
        a.eat(dest);
      }
    }        
  }
  
  /* Display each square
  */
  public void display() {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        grid[i][j].display(squareSideLength);
      }
    }    
  }
  
  /* inserts agent a at a randomly selected position on the grid. 
  * Puts the agent at the first unoccupied "random" position. Following these instructions: 
  *     You may use any method you like to determine where the agent is placed, 
  *     but it must place the agent at a different location each time, and 
  *     it must be possible for the agent to be placed at any unoccupied location.
  * The SugarGrid stores a randomly shuffled list of all square positions and cycles through the list
  *
  * Does nothing if all Squares are occupied
  */
  public void addAgentAtRandom(Agent a) {
    for (int i = 0; i < width*height; i++) {
      Integer idx = randomPoints.get(randomPointIndex++);
      if (randomPointIndex >= width*height) {
        Collections.shuffle(randomPoints);
        randomPointIndex = 0;
      }
      Square s = grid[idx%width][idx/width];
      if (s.getAgent() == null) {
        s.setAgent(a);
        lastAgentSquare = s;
        break;
      }
    }
  }
    
  /* Get square containing most recently placed agent - for testing
  */
  public Square getLastAgentSquare() {
    return lastAgentSquare;
  }
}

//killing
  public void killAgent(Agent a){
    a.IS = 0;
    println("dead agent");
    firt.isFertile(a);
  }
}