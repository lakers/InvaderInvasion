public class Boss extends GameObject {
  private BossArm leftArm, rightArm;
  private GameObject target;
  private PVector destination;
  private PVector start;
  private PVector offStart;
  private final float MAX_SPEED = 1;
  private BoundingBox boundingBox;
  
  public Boss(PVector position) {
    this.position = position;
    leftArm = new BossArm();
    leftArm.setPosition(new PVector(position.x - 100.0, position.y));
    rightArm = new BossArm();
    rightArm.setPosition(new PVector(position.x + 100.0, position.y));
    destination = new PVector();
    destination.x = position.x;
    destination.y = position.y;
    start = new PVector();
    start.x = position.x;
    start.y = position.y;
    offStart = new PVector(0.0f, 0.0f);
    boundingBox = new BoundingBox(this.position, 100, 110, new PVector(0, 0));
  }
  
  public void setTarget(GameObject target) {
    this.target = target;
    leftArm.setTarget(target);
    rightArm.setTarget(target); 
  }
  
  public BoundingBox getBoundingBox() {
    return boundingBox; 
  }
  
  public void setDestination(PVector destination) {
    this.destination = destination; 
  }
  
  public void setStart(PVector start) {
     this.start = start;
     offStart = PVector.sub(start, position);
     destination = offStart;
  }
  
  // will return which arm fired the shot
  public BossArm shoot() {
    
     PVector mousePos = new PVector(mouseX, mouseY);
     if(leftArm.getBoundingCircle().collidingWith(mousePos)) { 
       return(leftArm);
     } else if (rightArm.getBoundingCircle().collidingWith(mousePos)) {
       return(rightArm);
     }
     return null;
  }
  
  public void step() {
    PVector dir = PVector.sub(destination, PVector.add(position, offStart));
    if(dir.mag() > 3.0f) {
      dir.normalize();
      dir.mult(MAX_SPEED);
      moveRelative(dir);
      leftArm.moveRelative(dir);
      rightArm.moveRelative(dir);
    }
    leftArm.step();
    rightArm.step();
  }
  
  public BossComponent checkCollision(GameObject other) {
    if(leftArm.getBoundingCircle().collidingWith(other.getBoundingCircle()) && leftArm.isAlive()) {
      return leftArm;
    } else if(rightArm.getBoundingCircle().collidingWith(other.getBoundingCircle()) && rightArm.isAlive()) {
      return rightArm; 
    }
    return null;
  }
  
  public boolean canShoot() {return false;}
  public void draw(boolean debug) {
    stroke(255);
    strokeWeight(3);
    fill(0);
    rect(position.x - 100, position.y - 40, 200, 40);
    rect(position.x - 30, position.y-20, 60, 30);
    strokeWeight(2);
    ellipse(position.x - 15, position.y - 5, 20, 20);
    ellipse(position.x + 15, position.y - 5, 20, 20);
    leftArm.draw(debug);
    rightArm.draw(debug); 
    
    
    PVector toTarget = new PVector(0, 1);
     if(target != null) {
       toTarget = PVector.sub(target.position, position);
     }
     toTarget.normalize();
     toTarget.mult(5);
     stroke(255, 0, 0);
     strokeWeight(3);
     ellipse(position.x - 15 + toTarget.x, position.y - 5 + toTarget.y, 2, 2);
     ellipse(position.x + 15 + toTarget.x, position.y - 5 + toTarget.y, 2, 2);
     strokeWeight(1);
    
    
    if(debug) {
      boundingBox.draw(debug); 
    }
  }
}
