public abstract class GameObject {
  protected PVector position;
  protected BoundingCircle boundingCircle;
  protected boolean visible;

  
  public GameObject() {
    position = new PVector();
    visible = true;
  } 
  
  public void setPosition(PVector position) {
    this.position = position; 
  }
  
  public void setPosition(float xpos, float ypos) {
    position.x = xpos;
    position.y = ypos; 
  }
  
  public PVector getPosition() {
    return position;
  }
  
  public void moveRelative(PVector direction) {
    position.add(direction);
  }
  
  public BoundingCircle getBoundingCircle() {
    return boundingCircle; 
  }
  
  public boolean collidingWith(GameObject other) {
    return (boundingCircle.collidingWith(other.getBoundingCircle())); 
  }
  
  public abstract void draw(boolean debug);
  public abstract void step();
  public abstract boolean canShoot();
}
