public class BoundingBox extends GameObject {
  private float boxWidth;
  private float boxHeight;
  PVector offset;
  
  public BoundingBox(PVector position, float boxWidth, float boxHeight, PVector offset) {
    this.position = position;
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
    this.offset = offset;
  } 
 
  public boolean collidesWith(PVector other) {
    if(other.x >= position.x + offset.x - boxWidth/2 && other.x <= position.x + offset.x + boxWidth/2) {
      return(other.y >= position.y + offset.y - boxHeight/2 && other.y <= position.y + offset.y + boxHeight/2);
    } else {
      return false; 
    }
  }

  public void step() {}
  public void draw(boolean debug) {
    if(debug) {
      strokeWeight(1);
      stroke(255,255,0);
      noFill();
      rect(position.x + offset.x - boxWidth/2, position.y + offset.y - boxHeight/2, boxWidth, boxHeight);
    } 
  }
  public boolean canShoot() {
    return false; 
  }
}
