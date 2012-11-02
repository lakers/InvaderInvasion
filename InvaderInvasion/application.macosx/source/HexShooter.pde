public class HexShooter extends GameObject {
  private float r;
  GameObject target;
  float rate;
  private int shotTimer;
  
  public HexShooter() {
    shotTimer = 90;
    r = 20.0; 
    target = null;
    boundingCircle = new BoundingCircle(position, 20);
    rate = 1;
  }
  
  public void setTarget(GameObject target) {
    this.target = target; 
  }
  
  public void shoot() {
    shotTimer = 0; 
  }
  
  public boolean canShoot() {
    return (shotTimer == 90); 
  }
  
  public void step() {
    shotTimer += 1;
    if(shotTimer > 90) {
      shotTimer = 90; 
    }
    moveRelative(new PVector(0, rate));
    boundingCircle.setPosition(position); 
  }
  
  public PVector toTarget() {
    PVector toTarg = new PVector();
    if(target != null) {
      toTarg = PVector.sub(target.position, position);
    }
    toTarg.normalize();
    return toTarg;
  }
  
  public void draw(boolean debug) {
    pushMatrix();
    translate(position.x, position.y);
    float b = r * cos(PI/6.0);
    float a = r * sin(PI/6.0);
    
    stroke(0);
    fill(0);
    
    triangle(0, 0, r, 0, a, b);
    triangle(0, 0, a, b, -a, b);
    triangle(0, 0, -a, b, -r, 0);
    triangle(0, 0, -r, 0, -a, -b);
    triangle(0, 0, -a, -b, a, -b);
    triangle(0, 0, a, -b, r, 0);
    
    stroke(255);
    line(r, 0, a, b);
    line(a, b, -a, b);
    line(-a, b, -r, 0);
    line(-r, 0, -a, -b);
    line(-a, -b, a, -b);
    line(a, -b, r, 0);
    
    // draw gun
    strokeWeight(2);
    ellipse(0, 0, 10, 10);
    
    PVector toTarget = new PVector(0, 1);
    if(target != null) {
      toTarget = PVector.sub(target.position, position);
    }
    toTarget.normalize();
    toTarget.mult(13);
    
    line(0, 0, toTarget.x, toTarget.y);
    strokeWeight(1);
    
    popMatrix(); 
  }
}
