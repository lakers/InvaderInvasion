public class PlayerShot extends GameObject {
  private int speed;
  
  public PlayerShot() {
     boundingCircle = new BoundingCircle(position, 5);
     boundingCircle.setPosition(position);
  }
  
  public void draw(boolean debug) {
    speed = 5;
    stroke(255);
    ellipse(position.x, position.y, 5, 5); 
    boundingCircle.draw(debug);
  }
  
  public void step() {
    position.y -= speed; 
    boundingCircle.setPosition(position);
  }
  public boolean canShoot() {
    return false; 
  }
}
