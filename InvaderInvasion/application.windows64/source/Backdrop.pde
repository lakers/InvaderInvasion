abstract class Backdrop extends GameObject {
  protected int backdropWidth;
  protected int backdropHeight;
  
  abstract void step();
  public boolean canShoot() {
    return false; 
  }
}
