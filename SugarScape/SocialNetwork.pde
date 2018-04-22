import java.util.Queue;

class SocialNetwork {

  SugarGrid grid;
  ArrayList<Agent> friends = new ArrayList<Agent>();
  boolean[][] adjmatrix;
  ArrayList<SocialNetworkNode> nodes = new ArrayList<SocialNetworkNode>();
  public SocialNetwork(SugarGrid g) {
    //Initializes a new social network such that for every pair of Agents (x,y) on grid g, if x can see y (i.e. y is on a square that is in the vision of x), 
    //then the SocialNetworkNode for x is connected to the SocialNetworkNode for y in this new social network. Note that x might be able to see y even if y cannot 
    //see x.
    this.grid = g;

    if (grid != null) {
      friends = grid.getAgents();
      for (int n=0; n < friends.size(); n++) {
        SocialNetworkNode node =  new SocialNetworkNode(friends.get(n));
        nodes.add(node);
      }
      adjmatrix =  new boolean[nodes.size()][nodes.size()];
      for (int k=0; k< nodes.size(); k++) {
        for (int m=0; m< nodes.size(); m++) {
          if (k == m) {
            continue;
          } else {
            adjmatrix[k][m] = Connection(nodes.get(k), nodes.get(m));
          }
        }
      }
    }
  }

  public boolean Connection(SocialNetworkNode x, SocialNetworkNode y) {
    if (x == null || y== null){ 
      return false;
    }
    Agent xAgent = x.getAgent();
    for (int n = 0; n < grid.getWidth(); n++) {
      for (int k = 0; k < grid.getWidth(); k++) {
        if (grid.getAgentAt(n, k) != null && grid.getAgentAt(n, k) == (xAgent)) {
          LinkedList<Square> xVision = grid.generateVision(n, k, xAgent.getVision());
          for (int m = 0; m < xVision.size(); m++) {
            Agent AgentsSq = xVision.get(m).getAgent();
            if (AgentsSq != null && AgentsSq == (y.getAgent())) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  public boolean adjacent(SocialNetworkNode x, SocialNetworkNode y) {
    if (x == null || y== null){ 
      return false;
    }
    if (Connection(x, y)) {
      return true;
    }
    return false;
  }

  public List<SocialNetworkNode> seen(SocialNetworkNode x) {
    List<SocialNetworkNode> seen = new ArrayList<SocialNetworkNode>();
    if (x == null || x.getAgent() == null) {
      return null;
    }
    for (int n = 0; n < nodes.size(); n++) {
      if (adjacent(nodes.get(n), x)) {
        seen.add(nodes.get(n));
      }
    }
    return seen;
  }

  public List<SocialNetworkNode> sees(SocialNetworkNode y) {
    List<SocialNetworkNode> sees = new ArrayList<SocialNetworkNode>();
    if (y == null || y.getAgent() == null) {
      return null;
    }
    for (int n = 0; n < nodes.size(); n++) {
      if (adjacent(y, nodes.get(n))) {
        sees.add(nodes.get(n));
      }
    }
    return sees;
  }

  public void resetPaint() {
    for (int n = 0; n < nodes.size(); n++) {
      if (nodes.get(n).painted()) {
        nodes.get(n).unpaint();
      }
    }
  }

  public SocialNetworkNode getNode(Agent a) {
    if (a == null) {
      return null;
    }
    for (int k = 0; k < nodes.size(); k++) {
      if (nodes.get(k).getAgent().equals(a)) {
        return nodes.get(k);
      }
    }
    return null;
  }

  public boolean pathExists(Agent x, Agent y) {
    if (x == null || y == null || getNode(x) == null || getNode(x) == null) {
      return false;
    }
    SocialNetworkNode nodeForX = getNode(x);
    SocialNetworkNode nodeForY = getNode(y);
    ArrayList<SocialNetworkNode> seeX = new ArrayList<SocialNetworkNode>(sees(nodeForX));
    for (int n = 0; n < seeX.size(); n++) {
      if (seeX.get(n).painted() == false) {
        if (Connection(seeX.get(n), nodeForY)) {
          return true;
        } else {
          pathExists(seeX.get(n).getAgent(), y);
        }
      }
    }
    return false;
  }

  public List<Agent> bacon(Agent x, Agent y) {
    SocialNetworkNode nodeForX = getNode(x);
    Queue<SocialNetworkNode> walk = new LinkedList<SocialNetworkNode>();
    if (x==null || y ==null) {
      return null;
    } else if (x.equals(y)) {
      List<Agent>allAgents = new ArrayList<Agent>();
      allAgents.add(x);
      allAgents.add(y);
      return allAgents;
    }
    walk.add(nodeForX);
    nodeForX.paint();
    do {
      SocialNetworkNode front = walk.peek();
      ArrayList<SocialNetworkNode> neighbors = new ArrayList<SocialNetworkNode>(sees(front));
      walk.remove();
      for (int n = 0; n < neighbors.size(); n++) {
        if (neighbors.get(n).painted() == false) {
          walk.add(neighbors.get(n));
          neighbors.get(n).paint();
          if (neighbors.get(n).getAgent() == y) {
            List<Agent>allAgents = new ArrayList<Agent>();
            allAgents.add(x);
            for (int j = 0; j< walk.size(); j++) {
              allAgents.add(walk.poll().getAgent());
            }
            return allAgents;
          }
        }
      }
    } while (!walk.isEmpty());
    return null;
  }
}