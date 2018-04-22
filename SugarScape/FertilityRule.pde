import java.util.*;

class FertilityRule{
    HashMap<Character, Integer[]> cdbgo;
    HashMap<Character, Integer[]> cco;
    HashMap<Agent, Integer> childbearing;
    HashMap<Agent, Integer> climacteric;
    HashMap<Agent, Integer> agentSugar;
    char sex;
  
public FertilityRule(HashMap<Character, Integer[]> childbearingOnset, HashMap<Character,Integer[]> climactericOnset){
     childbearing = new HashMap<Agent, Integer>();
     climacteric = new HashMap<Agent, Integer>();
     agentSugar = new HashMap<Agent, Integer>();
     this.cdbgo = childbearingOnset;
     this.cco = climactericOnset;
 }
 
 /*
  public void gift(Agent other, int amount){
      //int metabolism, int vision, int initialSugar, MovementRule m, char sex
   a.gift(child, a.getSugarLevel()/2);
   b.gift(child, b.getSugarLevel()/2);
   child.nurture(a, b);
   Square childplace = childSquare(childSquarePossibilities);
   childplace.setAgent(child);
   return child;
   }
   else{
     return null;
   }
 
 
 */
 
 public boolean isFertile(Agent a){
 if(a == null || a.isAlive() == false){
   childbearing.remove(a);
   climacteric.remove(a);
   return false;
 }
 if(childbearing.get(a) == null){
 //first time being passed
 sex = a.getSex();
 float cdbga = random(cdbgo.get(sex)[0], cdbgo.get(sex)[1] + 1);
 float ccoa = random(cco.get(sex)[0], cco.get(sex)[1] + 1);
 childbearing.put(a, int(cdbga));
 climacteric.put(a, int(ccoa));
 agentSugar.put(a, a.getSugarLevel());
 }
 
 if(childbearing.get(a) <= a.getAge() && a.getAge() < climacteric.get(a) && agentSugar.get(a) <= a.getSugarLevel()){
   return true;
 }
 else{
   return false;
 }
 }
 
 public boolean canBreed(Agent a, Agent b, LinkedList<Square> local){
   boolean bAvailable =false;
   int unpopulated = 0;
   for(int n = 0; n < local.size(); n++){
     if(local.get(n).getAgent() == null){
       unpopulated++;
     }
     else if (local.get(n).getAgent() == b){
       bAvailable = true;
   }
   }
   
   if(isFertile(a) == true && isFertile(b) == true && a.getSex() != b.getSex() && bAvailable == true && unpopulated >= 1){
   return true;  
   }
   else{
     return false;
   }
 }
 public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal){
   if(canBreed(a, b, aLocal) == false || canBreed(b, a, bLocal) == false){
     return null;
   }
   if(canBreed(a, b, aLocal) || canBreed(b, a, bLocal)){
     LinkedList<Square> childSquarePossibilities = new LinkedList<Square>();
     for(int n = 0; n < aLocal.size(); n++){
       Square asurr = aLocal.get(n);
       if(asurr.getAgent() == null){
         childSquarePossibilities.add(asurr);
       }
     }
     for(int k = 0; k < bLocal.size(); k++){
       Square bsurr = bLocal.get(k);
       if(bsurr.getAgent() == null){
         childSquarePossibilities.add(bsurr);
     }
   }
   
   
   Agent child = new Agent(childMetabolism(a, b), childVision(a, b), 0, a.getMovementRule(), childSex());
   //int metabolism, int vision, int initialSugar, MovementRule m, char sex
   a.gift(child, a.getSugarLevel()/2);
   b.gift(child, b.getSugarLevel()/2);
   child.nurture(a, b);
   Square childplace = childSquare(childSquarePossibilities);
   childplace.setAgent(child);
   return child;
   }
   else{
     return null;
   }
 }
 private int childMetabolism(Agent a, Agent b){
   int aMetabolism = a.getMetabolism();
   int bMetabolism = b.getMetabolism();
   float choose = random(0,2);
   if(int(choose) == 0){
     return aMetabolism;
   }
   else{
     return bMetabolism;
   }
 }
 
 private int childVision(Agent a, Agent b){
   int aVision = a.getVision();
   int bVision = b.getVision();
   float choose = random(0,2);
   if(int(choose) == 0){
     return aVision;
   }
   else{
     return bVision;
   }
 }
 private char childSex(){
   float choose = random(0,2);
   if(int(choose) == 0){
     return 'X';
   }
   else{
     return 'Y';
   }
 }
 private Square childSquare(LinkedList<Square> possibleSquares){
   Collections.shuffle(possibleSquares);
   float choose = random(0, possibleSquares.size());
   return possibleSquares.get(int(choose));
 }
 
}