SugarGrid myGrid;
AgentLineGraph agentGraph;

void setup() {
  size(800,400);
  /*
  SquareTester st = new SquareTester();
  st.test();  
  AgentTester at = new AgentTester();
  at.test();  
  SugarGridTester sgt = new SugarGridTester();
  sgt.test();  
  GrowbackRuleTester grt = new GrowbackRuleTester();
  grt.test();
  StackTester st = new StackTester();
  st.test();
  QueueTester qt = new QueueTester();
  qt.test();
  ReplacementRuleTester rrt = new ReplacementRuleTester();
  rrt.test();
  SeasonalGrowbackRuleTester sgrt = new SeasonalGrowbackRuleTester();
  sgrt.test();
  */
  int minMetabolism = 3;
  int maxMetabolism = 6;
  int minVision = 2;
  int maxVision = 4;
  int minInitialSugar = 5;
  int maxInitialSugar = 10;
  MovementRule mr = new PollutionMovementRule();
  AgentFactory af = new AgentFactory(minMetabolism, maxMetabolism, minVision, maxVision, 
                                     minInitialSugar, maxInitialSugar, mr);

  int alpha = 2;
  int beta = 1;
  int gamma = 1;
  int equator = 1;
  int numSquares = 4; 
  SeasonalGrowbackRule sgr = new SeasonalGrowbackRule(alpha, beta, gamma, equator, numSquares);
  
  myGrid = new SugarGrid(25,20,20, sgr);
  myGrid.addSugarBlob(8,8,2,5);
  myGrid.addSugarBlob(17,12,2,5);
  for (int i = 0; i < 100; i++) {
    Agent a = af.makeAgent();
    myGrid.addAgentAtRandom(a);
  }
  myGrid.display();
  frameRate(5);
  
  agentGraph = new AgentLineGraph(550,25,200,100);
  agentGraph.update(myGrid);
}

void draw() {
  myGrid.update();
  agentGraph.update(myGrid);
  myGrid.display();
}