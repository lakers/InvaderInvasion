public class InputState {
  public boolean mouseHeld;
  public boolean[] keys;
  public PVector mousePos;
  
  public InputState() {
    keys = new boolean[10];
    clearState();
  }
  
  public void clearState() {
    mouseHeld = false;
    for(int i = 0; i < 10; i++) {
      keys[i] = false;
    } 
  }
  
  //public void setKey(String keyName) {
   // if(keyName.equals("UP")) {
   //   keys[0] = true;
   // } 
 // }
  
}
