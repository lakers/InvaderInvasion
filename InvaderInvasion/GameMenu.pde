public abstract class GameMenuElement {
  protected String name;
  public GameMenuElement(String name) {
    this.name = name;
  } 
  public String getName() {
   return name; 
  }
  
  public abstract String execute(GameMenu gameMenu);
}

public class NewSingleShip extends GameMenuElement {
  public NewSingleShip(String name) {
    super(name); 
  }
  
  public String execute(GameMenu gameMenu) {
    return("startup new single ship game");
  } 
}

public class NewSingleEnemy extends GameMenuElement {
  public NewSingleEnemy(String name) {
    super(name); 
  }
  
  public String execute(GameMenu gameMenu) {
    return("startup new single enemy game");
  } 
}

public class GameMenuBack extends GameMenuElement {
  private GameMenuHeader parent;
  
  public GameMenuBack(String name, GameMenuHeader parent) {
    super(name);
    this.parent = parent;
  } 
  
  public String execute(GameMenu gameMenu) {
    gameMenu.setCurrent(parent);
    return("back");
  }
}

public class GameMenu {
  private GameMenuHeader current;
  private int selection;
  private PFont font;
 
  // TODO: should this be done externally?
  public GameMenu() {
    GameMenuHeader mainMenu =  new GameMenuHeader("Main Menu");
    GameMenuHeader singlePlayer = new GameMenuHeader("Single Player");
    GameMenuHeader multiPlayer = new GameMenuHeader("Multi Player");
    GameMenuHeader options = new GameMenuHeader("Options");
    
    GameMenuElement newSingleShip = new NewSingleShip("Ship");
    GameMenuElement newSingleEnemy = new NewSingleEnemy("Enemy");
    GameMenuBack newSingleBack = new GameMenuBack("Back", mainMenu);
    
    mainMenu.addElement(singlePlayer);
    mainMenu.addElement(multiPlayer);
    mainMenu.addElement(options);
    
    singlePlayer.addElement(newSingleShip);
    singlePlayer.addElement(newSingleEnemy);
    singlePlayer.addElement(newSingleBack);
    
    options.addElement(newSingleBack);
    
    current = mainMenu;
    selection = 0;
    font = createFont("Courier New Bold", 32);
    
  }
  
  public void setCurrent(GameMenuHeader current) {
    this.current = current;
    selection = 0; 
  }
  
  public int getSelection() {
    return selection; 
  }
  
  public void selectNext() {
    selection++;
    if(selection >= current.getSize()) {
      selection = 0; 
    }
  }
  
  public void selectPrevious() {
    selection--;
    if(selection < 0) {
      selection = current.getSize() - 1;
    } 
  }
  
  public String selectCurrent() {
    GameMenuElement element = (GameMenuElement)current.getElements().get(selection);
    System.out.println("Executing " + element.getName());
    return(element.execute(this)); 
  }
 
  public void draw(boolean debug) {
    background(0);
    stroke(255);
    textFont(font, 32);
    text("Invader Invasion", 80, 200); 
    textFont(font, 20);
    
    ArrayList elements = current.getElements();
    //System.out.println("Current menu " + current.getName() + " contains");
    text(current.getName(), 20, 240);
    
    textFont(font, 16);
    for(int index = 0; index < elements.size(); index++) {
      GameMenuElement element = (GameMenuElement)elements.get(index);
      if(index == selection) {
        //System.out.print(">");
        text(">" + element.getName(), 80, 260 + index * 12);
      } else {
        text(element.getName(), 80, 260 + index * 12);
      }
      //System.out.println(element.getName());
    }
  } 
}

public class GameMenuHeader extends GameMenuElement {
  private ArrayList gameMenuElements; 
  private int size;
  public GameMenuHeader(String name) {
    super(name);
    gameMenuElements = new ArrayList();
    size = 0;
  } 
  
  public String execute(GameMenu gameMenu) {
    gameMenu.setCurrent(this);
    return("Setting current to " + name);
  }
  
  public void addElement(GameMenuElement element) {
    gameMenuElements.add(element); 
    size++;
  }
  
  public ArrayList getElements() {
    return gameMenuElements; 
  }
  
  public int getSize() {
    return size; 
  }
}
