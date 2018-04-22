import java.util.LinkedList;
import java.util.Collections;

interface MovementRule {
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public SugarSeekingMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    for (Square s : neighborhood) {
      if (s.getSugar() > retval.getSugar() ||
          (s.getSugar() == retval.getSugar() && 
           g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle)
          )
         ) {
        retval = s;
      } 
    }
    return retval;
  }
}

class PollutionMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public PollutionMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    boolean bestSquareHasNoPollution = (retval.getPollution() == 0);
    for (Square s : neighborhood) {
      boolean newSquareCloser = (g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle));
      if (s.getPollution() == 0) {
        if (!bestSquareHasNoPollution || s.getSugar() > retval.getSugar() ||
            (s.getSugar() == retval.getSugar() && newSquareCloser)
           ) {
          retval = s;
        }
      }
      else if (!bestSquareHasNoPollution) { 
        float newRatio = s.getSugar()*1.0/s.getPollution();
        float curRatio = retval.getSugar()*1.0/retval.getPollution();
        if (newRatio > curRatio || (newRatio == curRatio && newSquareCloser)) {
          retval = s;
        }
      }
    }
    return retval;
  }
}

class CombatMovementRule extends SugarSeekingMovementRule {
  //Initializes a new CombatMovementRule with the specified value of alpha.
  int a;
  Square chosen;
  Agent casualty;
  int sug;

  public CombatMovementRule(int alpha) {
    this.a = alpha;
  }

  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    //Moves the Agent according to the Combat Rule
    int count = 0;
    for (int n = 0; n< neighbourhood.size(); n++) {
      Square current = neighbourhood.get(n);
      if (current.getAgent() == null) {
        count++;
      }
    }
    if (count == (neighbourhood.size() - 1)) {
      return super.move(neighbourhood, g, middle);
    } else {
      LinkedList<Square> OG = neighbourhood;
      removingAgentsTribe(neighbourhood, middle);
      removingAgentsSugar(neighbourhood, middle);
      removingAgentsByVision(neighbourhood, g, middle);
      replaceSquare(neighbourhood, a);
      chosen = super.move(neighbourhood, g, middle);
      for (int n = 0; n < OG.size(); n++) {
        Square currentNew = OG.get(n);
        if (currentNew.getX() == chosen.getX() && currentNew.getY() == chosen.getY()) {
          chosen = currentNew;
        }
      }
      if (chosen != null) {
        if (chosen.getAgent() == null) {
          return chosen;
        } else {
          casualty = chosen.getAgent();
          int casualtySugar = casualty.getSugarLevel();
          if (casualtySugar > a) {
            sug = a;
          } else {
            sug = casualtySugar;
          }
          casualty.gift(middle.getAgent(), sug);
          chosen.setAgent(null);
          g.killAgent(casualty);
          return chosen;
        }
      }
      return null;
    }
  }
  public void removingAgentsTribe(LinkedList<Square> xyz, Square middle) {
    //looks at middle, removall all neighborhood memebers is same tribe as middle 
    Agent midAgent = middle.getAgent();
    if (midAgent != null) {
      boolean midAgentTribe = midAgent.getTribe();
      for (int n =0; n < xyz.size(); n++) {
          Agent agentOfN = xyz.get(n).getAgent();
        if (agentOfN != null && (agentOfN.getTribe() == midAgentTribe) && (midAgent != agentOfN)){
          xyz.remove(n);
        }
      }
    }
  }
  public void removingAgentsSugar(LinkedList<Square> xyz, Square middle) {
    //Remove from neighbourhood any Square containing an Agent that has at least as much sugar a the agent on the middle square.
    Agent midAgent = middle.getAgent();
    if (midAgent != null) {
      int sl = midAgent.getSugarLevel();
      for (int n =0; n < xyz.size(); n++) {
        Agent agentOfN = xyz.get(n).getAgent();
        if (agentOfN != null && agentOfN.getSugarLevel() >= sl) {
          xyz.remove(n);
        }
      }
    }
  }
  public void removingAgentsByVision(LinkedList<Square> xyz, SugarGrid g, Square middle) {
    //For each remaining Square in neighbourhood that contains an Agent, get the vision that the Agent on middle would have if it moved to that Square. 
    //If the vision contains any Agent with more sugar than the Agent on middle, and the opposite tribe, then remove the Square in question from neighbourhood.
    Agent midAgent = middle.getAgent();
    for (int n = 0; n < xyz.size(); n++) {
      LinkedList<Square> MiddleSees = g.generateVision(xyz.get(n).getX(), xyz.get(n).getY(), midAgent.getVision());
      for (int k = 0; k < MiddleSees.size(); k++) {
        Agent agentInVision = MiddleSees.get(k).getAgent();
        if (agentInVision != null && (agentInVision.getSugarLevel() > midAgent.getSugarLevel()) && (agentInVision.getTribe() != midAgent.getTribe()) && (n != xyz.size())) {
          xyz.remove(n);
        }
      }
    }
  }
  public void replaceSquare(LinkedList<Square> xyz, int alpha) {
    //Replace each Square in neighbourhood that still has an Agent with a new Square that has the same x and y coordinates, but a Sugar and MaximumSugar 
    //level that are increased by the minimum of alpha and the sugar level of the occupying agent.
    for (int n = 0; n< xyz.size(); n++) {
      Square current = xyz.get(n);
      if (current.getAgent() != null) {
        int inc;
        if (current.getAgent().getSugarLevel() > alpha) {
          inc = alpha;
        } else {
          inc = current.getAgent().getSugarLevel();
        }
        current = new Square(current.getSugar() + inc, current.getMaxSugar() + inc, current.getX(), current.getY());
      }
    }
  }
}