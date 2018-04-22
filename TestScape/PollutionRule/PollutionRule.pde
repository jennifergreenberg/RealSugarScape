class PollutionRule {
  private int gatheringPollution;
  private int eatingPollution;
  
  /* initializes a new PollutionRule class with a specified pollution rate for gathering or eating sugar on a given square.
  *
  * not tested.
  */
  public PollutionRule(int gatheringPollution, int eatingPollution) {
    this.gatheringPollution = gatheringPollution;
    this.eatingPollution = eatingPollution;
  }
  
  /*  If s is not occupied, then does nothing. 
  *   If an agent a is occupying s, then the pollution level of s is increased 
  *   by eatingPollution points for every point of metabolism agent a has, 
  *   and by gatheringPollution points for every point of sugar currently on s. 
  *
  * not tested.
  */
  public void pollute(Square s) {
    if (s.getAgent() != null) {
      s.setPollution(s.getPollution() + eatingPollution*s.getAgent().getMetabolism() + gatheringPollution*s.getSugar());
    }
  }
}