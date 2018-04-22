class SocialNetworkNode{
  Agent agent;
  boolean isPainted;
  
public SocialNetworkNode(Agent a) {
 // - initializes a new SocialNetworkNode storing the passed agent. The node is unpainted initially.
  agent = a;
  isPainted = false;
}
public boolean painted(){
//  - returns true if this node has been painted.
return isPainted;
  
}
public void paint(){
//  - Sets the node to painted.
isPainted = true;
}
public void unpaint(){
//- Sets the node to unpainted.
isPainted = false;

}
public Agent getAgent(){
  //- Returns the agent stored at this node.
  return agent;
  
}

}