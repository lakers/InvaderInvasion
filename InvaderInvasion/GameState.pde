public abstract class GameState {
  private GameStateManager gameStateManager;
  
  public GameState(GameStateManager gameStateManager) {
    this.gameStateManager = gameStateManager; 
  }
  
  public abstract void init();
  
  public abstract void draw(boolean debug);
  public abstract void update(); 
  public abstract void handleInput();
}
