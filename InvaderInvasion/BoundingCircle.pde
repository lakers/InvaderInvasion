public class BoundingCircle {
  private PVector position;
  private float radius;
  
  public BoundingCircle(PVector position, float radius) {
    this.position = position;
    this.radius = radius;
  } 
  
  public PVector getPosition() {
    return position; 
  }
  
  public float getRadius() {
    return radius; 
  }
  
  public boolean collidingWith(PVector other) {
    PVector distance = PVector.sub(position, other);
    return(distance.mag() < radius); 
  }
  
  public boolean collidingWith(BoundingCircle other) {
    PVector distance = PVector.sub(position, other.getPosition()); 
    return(distance.mag() < radius + other.getRadius());
  }
  
  public void setPosition(PVector position) {
    this.position = position; 
  }
  
  public void draw(boolean debug) {
    if(debug) {
      pushMatrix();
      stroke(255, 0, 255);
      noFill();
      ellipse(position.x, position.y, radius*2, radius*2);
      popMatrix();
    } 
  }
}
