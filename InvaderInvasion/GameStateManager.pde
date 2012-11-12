public class GameStateManager {
  private GameState current;
  private HashMap gameStates;
  
  public GameStateManager() {
     current = null;
     gameStates = new HashMap();
  }
 
  public void addState(GameState state, String name) {
    state.init();
    gameStates.put(name, state);
  }
  
  public void setCurrent(String name) {
    GameState state = (GameState)gameStates.get(name);
    if(state != null) {
      current = state;
    } 
  }
 
  public void run(boolean debug) {
    current.handleInput();
    current.update();
    current.draw(debug);
  } 
}
