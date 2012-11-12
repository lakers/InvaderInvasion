public class MainMenuState extends GameState {
  private PFont font;
  private GameMenu gameMenu;
  private boolean canClick;
  private int inputCooldown;
  
  public MainMenuState(GameStateManager gameStateManager) {
    super(gameStateManager); 
  }
  
  public void init() {
    //String[] fontList = PFont.list();
    //println(fontList);
    gameMenu = new GameMenu();
    font = createFont("Courier New Bold", 32);
    
    canClick = true;
    inputCooldown = 20;
    stroke(255);
  }
  
  public void draw(boolean debug) {
    background(0);
    stroke(255);
    //textFont(font);
    //text("Invader Invasion", 80, 200);  
    gameMenu.draw(debug);
  }
  
  public void handleInput() {
    if(keyPressed) {
      if(inputCooldown == 20) {
        if(keyCode == DOWN) {
          gameMenu.selectNext(); 
          inputCooldown = 0;
        }
        if(keyCode == UP) {
          gameMenu.selectPrevious(); 
          inputCooldown = 0;
        }
        if(keyCode == RIGHT) {
          String command = gameMenu.selectCurrent();
          System.out.println(command);
          if(command.equals("startup new single ship game")) {
            gameStateManager.setCurrent("Main Game State");
          }
          inputCooldown = 0; 
        }
      } 
    }
  }
  
  public void update() {
    inputCooldown++;
    if(inputCooldown >= 20) {
      inputCooldown = 20; 
    }
  } 
}
