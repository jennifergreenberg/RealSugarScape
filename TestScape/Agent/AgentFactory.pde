import java.util.Random;

public class AgentFactory {
  int minMetabolism;
  int maxMetabolism;
  int minVision;
  int maxVision;
  int minInitialSugar;
  int maxInitialSugar;
  MovementRule movementRule;
  
  /* public  - creates a new AgentFactory with the specified parameters.
  */
  public AgentFactory(int minMetabolism, int maxMetabolism, int minVision, int maxVision, 
                      int minInitialSugar, int maxInitialSugar, MovementRule m) {
    this.minMetabolism = minMetabolism;
    this.maxMetabolism = maxMetabolism;
    this.minVision = minVision;
    this.maxVision = maxVision;
    this.minInitialSugar = minInitialSugar;
    this.maxInitialSugar = maxInitialSugar;
    this.movementRule = m;
  }
  /* Returns a new Agent with randomly selected parameters. 
  * The Agent's metabolism must be between minMetabolism and maxMetabolism (inclusive). 
  * The Agent's vision must be between minVision and maxVision (inclusive). 
  * The Agent's initial sugar must be between minInitialSugar and maxInitialSugar (inclusive). 
  * The Agent's movement rule must be the same as the MovementRule used to construct this AgentFactory. 
  * Parameter values should be selected uniformly at random.
  */
  public Agent makeAgent() {
    Random r = new Random();
    int metabolism = minMetabolism + r.nextInt(maxMetabolism + 1 - minMetabolism);
    int vision = minVision + r.nextInt(maxVision + 1 - minVision);
    int initialSugar = minInitialSugar + r.nextInt(maxInitialSugar + 1 - minInitialSugar);
    return new Agent(metabolism, vision, initialSugar, movementRule);
  }
}