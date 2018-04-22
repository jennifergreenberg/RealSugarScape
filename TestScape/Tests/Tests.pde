import java.util.LinkedList;
import java.util.Collections;

class SquareTester {
  void test() {
    
    // test constructor, get/set Sugar and MaxSugar
    // square with sugarLevel 5, maxSugarLevel 9, position (x, y) = (15, 15)
    Square s = new Square(5, 9, 20, 20); 
    assert (s.getMaxSugar() == 9);
    s.setMaxSugar(4);
    assert(s.getSugar() == 4);
    s.setSugar(s.getSugar()-1);
    assert(s.getSugar() == 3);
    s.setSugar(-1);
    assert (s.getSugar() == 0);
    s.setSugar(5);
    assert (s.getSugar() == 4);
    s.setMaxSugar(-1);
    assert (s.getMaxSugar() == 0);
    assert (s.getSugar() == 0);
    
    // test get/set Agent
    assert (s.getAgent() == null);
    Agent a = new Agent(3, 2, 4, null);
    s.setAgent(a);
    assert (s.getAgent() == a);
    
    s.setMaxSugar(10);
    s.setSugar(8);
    
    Square s2 = new Square(8, 10, 20, 20);
    s2.setAgent(new Agent(3, 2, 4, null));
    assert(!s2.equals(s));
    s2.setAgent(null);
    s2.setAgent(a);
    assert(s2.equals(s));
    assert(s.equals(s2));
    
    s.setSugar(11, true);
    assert(s.getSugar() == 11);
    assert(s.getMaxSugar() == 11);

    s.display(20);
  }
}


class AgentTester {
  void test() {
    
    // test constructor, accessors
    int metabolism = 3;
    int vision = 2;
    int initialSugar = 4;
    MovementRule m = null;
    Agent a = new Agent(metabolism, vision, initialSugar, m);
    assert(a.isAlive());
    assert(a.getMetabolism() == 3);
    assert(a.getVision() == 2);
    assert(a.getSugarLevel() == 4);
    assert(a.getMovementRule() == null);
    
    // movement
    Square s1 = new Square(5, 9, 10, 10);
    Square s2 = new Square(5, 9, 12, 12);
    s1.setAgent(a);
    a.move(s1, s2);
    assert(s2.getAgent().equals(a));
    
    // eat
    a.eat(s2);
    assert(a.getSugarLevel() == 9);
    
    // test get/set MovementRule
    
    // step
    a.step();
    assert(a.getSugarLevel() == 6);
    a.step();
    a.step();
    a.step();
    assert(a.getSugarLevel() == 0);
    assert(!a.isAlive());
  }
}

class SugarGridTester {
  void test() {
    GrowbackRule gr = null;
    int w = 2;
    int h = 2;
    int sideLength = 15;
    
    // constructor, accessors
    SugarGrid sg = new SugarGrid(w, h, sideLength, gr);
    
    assert(sg.getWidth() == 2);
    assert(sg.getHeight() == 2);
    assert(sg.getSquareSize() == 15);
    
    assert(sg.getSugarAt(0, 1) == 0);
    assert(sg.getMaxSugarAt(0, 1) == 0);
    assert(sg.getAgentAt(0, 1) == null);
    
    // add sugar blob
    int x = 0;
    int y = 1;
    int radius = 1;
    int max = 2;
    sg.addSugarBlob(x, y, radius, max);
    assert(sg.getSugarAt(0, 1) == 2);
    assert(sg.getSugarAt(0, 0) == 1);
    assert(sg.getSugarAt(1, 0) == 0);
    
    // distance
    Square s1 = new Square(5, 9, 10, 10);
    Square s2 = new Square(5, 9, 13, 14);
    assert(sg.euclideanDistance(s1,s2) == 5.0d);
    
    // vision
    LinkedList<Square> ll = sg.generateVision(1, 3, 4);
    assert(ll.size() == 2);
    
    // place agents
    int metabolism = 3;
    int vision = 2;
    int initialSugar = 4;
    Agent a01 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    Agent a10 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
       
    // display
    sg.placeAgent(a01, 0, 1);
    sg.placeAgent(a10, 1, 0);
    sg.display();
    
    // add agents at random
    Agent a1 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    Agent a2 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    sg.addAgentAtRandom(a1);
    Square s = sg.getLastAgentSquare();
    assert(s.getX() == s.getY());

  }
}

class GrowbackRuleTester {
  void test() {
    int r = 4;
    GrowbackRule gr = new GrowbackRule(r);
    Square s = new Square(5, 10, 40, 40);
    gr.growBack(s);
    assert(s.getSugar() == 9);
    gr.growBack(s);
    assert(s.getSugar() == 10);
  }
}

class SeasonalGrowbackRuleTester {
  void test() {
    int alpha = 2;
    int beta = 1;
    int gamma = 1;
    int equator = 1;
    int numSquares = 4; 
    SeasonalGrowbackRule gr = new SeasonalGrowbackRule(alpha, beta, gamma, equator, numSquares);
    Square s = new Square(5, 10, 0, 0);
    gr.growBack(s);
    assert(gr.isNorthSummer());
    assert(s.getSugar() == 7);
    gr.growBack(s);
    assert(gr.isNorthSummer());
    assert(s.getSugar() == 9);
    gr.growBack(s);
    assert(gr.isNorthSummer());
    assert(s.getSugar() == 10);
    s.setMaxSugar(15);
    gr.growBack(s);
    assert(!gr.isNorthSummer());
    assert(s.getSugar() == 12);
    gr.growBack(s);
    assert(!gr.isNorthSummer());
    assert(s.getSugar() == 13);
  }
}

class SugarSeekingMovementRuleTester {
  public void test() {
    SugarSeekingMovementRule mr = new SugarSeekingMovementRule();
    //stubbed
  }
}

class PollutionMovementRuleTester {
  public void test() {
    PollutionMovementRule mr = new PollutionMovementRule();
    //stubbed
  }
}


class AgentFactoryTester {
  public void test() {
    int minMetabolism = 3;
    int maxMetabolism = 6;
    int minVision = 2;
    int maxVision = 4;
    int minInitialSugar = 5;
    int maxInitialSugar = 10;
    MovementRule mr = new PollutionMovementRule();
    
    AgentFactory af = new AgentFactory(minMetabolism, maxMetabolism, minVision, maxVision, 
                                       minInitialSugar, maxInitialSugar, mr);
                                       
    Agent a = af.makeAgent();
    int m = a.getMetabolism(); 
    assert(m >= minMetabolism && m <= maxMetabolism);
    int v = a.getVision(); 
    assert(v >= minVision && v <= maxVision);
    int is = a.getSugarLevel(); 
    assert(is >= minInitialSugar && is <= maxInitialSugar);
  }
}

class ReplacementRuleTester {
  public void test() {
    int minMetabolism = 3;
    int maxMetabolism = 6;
    int minVision = 2;
    int maxVision = 4;
    int minInitialSugar = 5;
    int maxInitialSugar = 10;
    MovementRule mr = new PollutionMovementRule();
    
    AgentFactory af = new AgentFactory(minMetabolism, maxMetabolism, minVision, maxVision, 
                                       minInitialSugar, maxInitialSugar, mr);
                                      
    int minAge = 40;
    int maxAge = 80;
    ReplacementRule rr = new ReplacementRule(minAge, maxAge, af);
                                       
    Agent a = af.makeAgent();
    
    assert(rr.replaceThisOne(a) == false);
    int ls = a.getLifespan();
    assert(ls <= maxAge && ls >= minAge);
    a.step();
    a.setLifespan(a.getAge() - 1);
    assert(rr.replaceThisOne(a) == true);
    List<Agent> others = null;
    a = rr.replace(a, others);
    assert(rr.replaceThisOne(a) == false);    
  }
}

class PollutionRuleTester {
  public void test() {
    int gatheringPollution = 0;
    int eatingPollution = 0;
  
    PollutionRule pr = new PollutionRule(gatheringPollution, eatingPollution);
    //stubbed
  }
}