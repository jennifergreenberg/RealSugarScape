class Graph {
  protected int x;
  protected int y;
  protected int howWide;
  protected int howTall;
  private String xlab;
  private String ylab;
  
  /*  initializes a new graph to be drawn with its upper left corner 
  *   at coordinates (x,y), with the specified width and height, and the specified axis labels.
  *
  * tested visually.
  */
  public Graph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    this.x = x;
    this.y = y;
    this.howWide = howWide;
    this.howTall = howTall;
    this.xlab = xlab;
    this.ylab = ylab;
  }
  
  /* Draws a white rectangle at coordinates (x,y), with the specified height and width. 
  *  Then draws a black line along the bottom of the rectangle for the x-axis, 
  *  and a black line along the left side for the y-axis. 
  *  Uses the text() method to write xlab underneath the graph, and ylab to the left of the graph.
  *
  * tested visually.
  */
  public void update(SugarGrid g) {
    noStroke();
    fill(255);
    rect(x, y, howWide, howTall);
    stroke(0);
    strokeWeight(1); // might make a member
    line(x, y+howTall, x+howWide, y+howTall);
    line(x, y+howTall, x, y);
    fill(0);
    writeRotatedText(xlab, x+howWide, y+howTall+15, 0);
    writeRotatedText(ylab, x-5, y, -PI/2.0);
  }
  
  /* writes rotated text at position (x,y)
  */
  private void writeRotatedText(String s, int i, int j, float angle) {
    pushMatrix();
    translate(i, j);
    rotate(angle);
    text(s, -s.length()*8, 0 );
    popMatrix();
  }
}

abstract class LineGraph extends Graph {
  private int updates;
  
  /* Calls Graph constructor Passes argument to the super-class constructor, and sets the number of update calls to 0.
  *
  * tested visually.
  */
  public LineGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
    updates = 0;
  }
  
  /* 
  */
  public abstract int nextPoint(SugarGrid g);
  
  /*  Overrides the superclass update method. 
  *   If the "number of updates" -- the number of points updated so far -- is 0, calls the superclass update method. 
  *   Otherwise, calls nextPoint(g) to get the y-coordinate of the next point in the line. 
  *
  *   Draws a 1x1 square (color is your choice) at the point that would be at 
  *   (number of updates, nextpoint(g)) in the graph that is being plotted. 
  *
  *   Increases the number of updates by 1. 
  *
  *   If the number of updates exceeds the width of the graph, set the number of updates back to 0 
  *   (erasing the graph on the next call, and starting over). 
  *
  * tested visually.
  */
  public void update(SugarGrid g) {
    if (updates == 0) {
      super.update(g);
    }
    else {
      fill(0,0,255);
      rect(XOnScreen(updates),YOnScreen(nextPoint(g)), 1, 1);
    }
    if (++updates > howWide) {
      updates = 0;
    }
  }
  
  /* Converts graph x value to screen x value
  */
  private int XOnScreen(int XOnGraph) {
    return XOnGraph + x;
  }
  
  /* Converts graph y value to screen y value
  */
  private int YOnScreen(int YOnGraph) {
    return YOnGraph + y;
  }
}

class AgentLineGraph extends LineGraph {
  
  /* Constructor, calls parent constructor
  */
  public AgentLineGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "steps", "agents");
  }

  /*
  */
  public int nextPoint(SugarGrid g) {
     return g.getAgents().size();
  }
}