public class MainGameState extends GameState {
  private ArrayList backdrops;
  private GameObjectManager gameManager;
  
  public MainGameState(GameStateManager gameStateManager) {
    super(gameStateManager);
  }  
  
  public void init() {
    // Setup backdrop
    backdrops = new ArrayList();
    backdrops.add(new StarBackdrop(WIDTH, HEIGHT, 2));
    backdrops.add(new StarBackdrop(WIDTH, HEIGHT, 4));
    backdrops.add(new StarBackdrop(WIDTH, HEIGHT, 4));
  
    // Setup game object manager
    PlayerShip playerShip = new PlayerShip(new PVector(200, 500));
    PlayerHorde playerHorde = new PlayerHorde(new PVector(200, 100));
    gameManager = new GameObjectManager(playerShip, playerHorde);
    
  }
  
  // TODO: make this much cleaner
  public void handleInput() {
//    if(mousePressed) {
//      System.out.println("mouse pressed");
//      gameManager.setMouseHeld(true); 
//    }
    gameManager.parseInput();
  }
  
  public void update() {
    for(int backdropIndex = 0; backdropIndex < backdrops.size(); backdropIndex++) {
      Backdrop backdrop = (Backdrop)backdrops.get(backdropIndex);
      backdrop.step();
    }
    
    // logic update
    gameManager.step();
  
    // check and resolve collisions
    gameManager.checkCollisions();
    
  }
  
  public void draw(boolean debug) {
    background(0);
    for(int backdropIndex = 0; backdropIndex < backdrops.size(); backdropIndex++) {
      Backdrop backdrop = (Backdrop)backdrops.get(backdropIndex);
      backdrop.draw(debug);
    }
    gameManager.draw(debug);
  }
}
