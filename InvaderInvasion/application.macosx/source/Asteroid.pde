public class Asteroid extends GameObject {
  private int rate;
  
  public Asteroid(int rate) {
    this.rate = rate; 
    boundingCircle = new BoundingCircle(position, 20);
  }
  
  public void step() {
    moveRelative(new PVector(0, rate));
    boundingCircle.setPosition(position);
  }
  
  public void draw(boolean debug) {
    fill(0);
    stroke(255);
    ellipse(position.x, position.y, 40, 40); 
    boundingCircle.draw(debug);
  }
  
  public boolean canShoot() {
    return false; 
  }
  
}
