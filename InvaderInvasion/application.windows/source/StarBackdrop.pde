class StarBackdrop extends Backdrop {
  private ArrayList stars;
  private int rate;
  
  public StarBackdrop(int w, int h, int r) {
    rate = r;
    backdropWidth = w;
    backdropHeight = h;
    
    //initialize list of stars
    stars = new ArrayList();
    
    for(int index = 0; index < 200; index++) {
       Star star = new Star();
       star.setPosition(new PVector(random(w), random(h)));
       stars.add(star);
    }
    
  }
  
  public void step() {
    for(int index = 0; index < stars.size(); index++) {
      GameObject star = (GameObject)stars.get(index);
      star.moveRelative(new PVector(0, rate)); 
      float y = star.getPosition().y;
      if(y > backdropHeight) {
        star.moveRelative(new PVector(0, -backdropHeight)); 
      }
    }
  }
 
  public void draw(boolean debug) {
    stroke(255);
    for(int index = 0; index < stars.size(); index++) {
       GameObject star = (GameObject)stars.get(index);
       star.draw(debug);
    }
    step();
  } 
  
  private class Star extends GameObject {
    public Star() {
      super(); 
    }
    
    public void draw(boolean debug) {
      pushMatrix();
      stroke(255);
      point(position.x, position.y);
      popMatrix(); 
    }
    
    public void step() {}
    
    public boolean canShoot() {
      return false; 
    }
  }
}

