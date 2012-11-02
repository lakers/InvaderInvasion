public class HexShooterShot extends GameObject {
  private static final float SPEED = 3.0f;
  private PVector direction;
  
  public HexShooterShot(PVector direction) {
    this.direction = direction; 
    boundingCircle = new BoundingCircle(position, 5);
  }
  
  public void step() {
    PVector temp = new PVector();
    temp.x = direction.x;
    temp.y = direction.y;
    temp.normalize();
    temp.mult(SPEED);
    moveRelative(temp);
    boundingCircle.setPosition(position);
  }
  
  public void draw(boolean debug) {
    stroke(255, 0, 0);
    ellipse(position.x, position.y, 20, 20); 
    boundingCircle.draw(debug);
  } 
  
  public boolean canShoot() {
    return false; 
  }
}
