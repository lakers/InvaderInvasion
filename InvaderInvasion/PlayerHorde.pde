public class PlayerHorde extends GameObject {
  private int summonTimer;
  
  public PlayerHorde() {
    summonTimer = 60; 
  }
  
  public void draw(boolean debug) {
    if(debug) {
      pushMatrix();
      stroke(255, 0, 255);
      noFill();
      ellipse(position.x, position.y, 10.0, 10.0);
      point(position.x, position.y);
      stroke(150, 0, 150);
      line(0, 200, 480, 200);
      popMatrix();
    } 
  }
  
  public boolean canSummon() {
    return (summonTimer == 60); 
  }
  
  public void summon() {
    summonTimer = 0; 
  }
  
  public void step(){
    summonTimer += 1;
    if(summonTimer > 60) {
      summonTimer = 60; 
    }
  }
  
  public boolean canShoot() {
    return false; 
  }
  
}
