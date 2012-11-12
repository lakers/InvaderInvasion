public class BossMeter {
  private PVector position;
  private final float meterWidth = 300.0f;
  private final float meterHeight = 20.0f;
  private final float MAX = 200.0f;
  private float current;
  private final float stepSize = 0.1f;
  
  public BossMeter(PVector position) {
    this.position = position; 
    current = 0.0f;
  }
  
  public void step() {
    current += stepSize; 
    if(current >= MAX) current = MAX; 
  }
   
  public float getStatus() {
    return current/MAX; 
  }
   
  public void draw(boolean debug) {
    stroke(255);
    strokeWeight(2);
    fill(0);
    rect(position.x, position.y, meterWidth, meterHeight);
    fill(255,0,0);
    stroke(255, 0, 0);
    strokeWeight(1);
    rect(position.x + 1, position.y + 1, current/MAX * meterWidth - 3, meterHeight - 2);
  }
}
