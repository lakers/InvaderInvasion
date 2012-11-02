public class PlayerShip extends GameObject {
  public PVector destination;
  private int shotTimer;
  
  public PlayerShip(PVector position) {
    shotTimer = 20;
    this.position = position;
    destination = new PVector();
    
    PVector temp = new PVector(0.0, 5.0);
    boundingCircle = new BoundingCircle(PVector.add(temp, position), 25);
  }
  
  
  public void draw(boolean debug) {
    pushMatrix();
    PVector temp = new PVector(0.0, 5.0);
    boundingCircle.setPosition(PVector.add(temp, position));
    boundingCircle.draw(debug);
    fill(0);
    stroke(255);
    translate(position.x, position.y);
    triangle(-20.0, 20.0, 0.0, -20.0, 20.0, 20.0);
    popMatrix();
  }
  
  public boolean canShoot() {
    return (shotTimer == 20); 
  }
  
  public void shoot() {
     shotTimer = 0;
  }
  
  public void step() {
    shotTimer += 1;
    if(shotTimer > 20) {
      shotTimer = 20; 
    }
//    PVector toDest = PVector.sub(destination, position);
//    if(toDest.mag() > 3) {
//      toDest.normalize();
//      toDest.mult(3);
//      moveRelative(toDest);
//      
//    }
  }
}
