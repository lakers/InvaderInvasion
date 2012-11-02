public class BossComponent extends GameObject {
  private int MAX_HP;
  private int currentHP;
  
  public BossComponent(int maxHP) {
    this.MAX_HP = maxHP;
    currentHP = maxHP; 
  }
  
  public boolean isAlive() {
    return (currentHP > 0); 
  }
  
  public void changeHPRelative(int change) {
    currentHP += change; 
  }
  
  public void step() {}
  public boolean canShoot() {return false;}
  public void draw(boolean debug) {  }
}
