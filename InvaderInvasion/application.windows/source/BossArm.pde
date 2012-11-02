public class BossArm extends BossComponent {
  private float r = 60.0f;
  GameObject target;
  BoundingCircle boundingCircle;
  private int shotTimer;
  
  public BossArm() {
    super(10);
    target = null;
    position = new PVector();
    boundingCircle = new BoundingCircle(position, r);
    shotTimer = 30;
  }
  
  public BoundingCircle getBoundingCircle() {
    return boundingCircle; 
  }
  
  public void step() {
    boundingCircle.setPosition(position); 
    if(shotTimer < 30) {
      shotTimer++; 
    }
  }
  
  public boolean canShoot() {
    return(shotTimer >= 30 && isAlive());
  }
  
  public void shoot() {
    shotTimer = 0; 
  }
  
  public PVector toTarget() {
    PVector toTarg = new PVector();
    if(target != null) {
      toTarg = PVector.sub(target.position, position);
    }
    toTarg.normalize();
    return toTarg;
  }
  
  public void setTarget(GameObject target) {
    this.target = target; 
  }
  
   public void draw(boolean debug) {
     if(isAlive()) {
     pushMatrix();
     translate(position.x, position.y);
     float b = r * cos(PI/6.0);
     float a = r * sin(PI/6.0);
    
     stroke(0);
     strokeWeight(2);
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
     strokeWeight(3);
     ellipse(0, 0, 30, 30);
    
     PVector toTarget = new PVector(0, 1);
     if(target != null) {
       toTarget = PVector.sub(target.position, position);
     }
     toTarget.normalize();
     toTarget.mult(35);
    
     line(0, 0, toTarget.x, toTarget.y);
     strokeWeight(1);
    
     popMatrix();  
     
     if(debug) {
       boundingCircle.draw(debug); 
     }
     }
   }
}
