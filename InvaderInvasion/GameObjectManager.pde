public class GameObjectManager {
  private PlayerShip playerShip;
  private PlayerHorde playerHorde;
  private ArrayList playerObjects;
  private ArrayList hordeObjects;
  private boolean mouseHeld;
  
  private Boss testBoss;
  private BossMeter bossMeter;
  
  
  public GameObjectManager(PlayerShip playerShip, PlayerHorde playerHorder) {
    this.playerShip = playerShip;
    this.playerHorde = playerHorder;
    playerObjects = new ArrayList();
    hordeObjects = new ArrayList();
    mouseHeld = false;
    //testBoss = new Boss(new PVector(250.0f, 100.0f));
    testBoss = null;
    //testBoss.setTarget(playerShip);
    bossMeter = new BossMeter(new PVector(90,5));
  } 
  
  public PlayerShip getPlayerShip() {
    return playerShip; 
  }
  
  public PlayerHorde getPlayerHorde() {
    return playerHorde; 
  }
  
  public void addPlayerObject(GameObject playerObject) {
    playerObjects.add(playerObject); 
  }
  
  public void addHordeObject(GameObject hordeObject) {
    System.out.println("Adding horde object");
    hordeObjects.add(hordeObject); 
  }
  
  public void draw(boolean debug) {
    playerShip.draw(debug);
    playerHorde.draw(debug); 
    if(testBoss != null) {
      testBoss.draw(debug); 
    }
    for(int index = 0; index < playerObjects.size(); index++) {
      GameObject object = (GameObject)playerObjects.get(index);
      object.draw(debug);  
    }
    for(int index = 0; index < hordeObjects.size(); index++) {
      GameObject object = (GameObject)hordeObjects.get(index);
      object.draw(debug);  
    }
    
    bossMeter.draw(debug);
  }
  
  public void step() {
    playerShip.step();
    playerHorde.step();
    bossMeter.step();
    if(testBoss != null) {
      testBoss.step(); 
    }
    for(int index = 0; index < playerObjects.size(); index++) {
      GameObject object = (GameObject)playerObjects.get(index);
      object.step();  
      if(object.getPosition().y < 0) {
        playerObjects.remove(object);
        object = null; 
        System.out.println("Player Object out of bounds, removing");
      }
    }
    for(int index = 0; index < hordeObjects.size(); index++) {
      GameObject object = (GameObject)hordeObjects.get(index);
      object.step(); 
      if(object.canShoot()) {
        HexShooter hexShooter = (HexShooter)object;
        hexShooter.shoot();
        HexShooterShot shot = new HexShooterShot(hexShooter.toTarget());
        shot.setPosition(object.getPosition().x, object.getPosition().y);
        gameManager.addHordeObject(shot);
      } 
      if(object.getPosition().y > 660) {
        hordeObjects.remove(object);
        object = null; 
        System.out.println("Horde Object out of bounds, removing");
      }
    }
  }
  
  // TODO: implement collision detector and handler
  public void checkCollisions() {
    for(int sindex = 0; sindex < playerObjects.size(); sindex++) {
      GameObject shipObject = (GameObject)playerObjects.get(sindex);
      for(int hindex = 0; hindex < hordeObjects.size(); hindex++) {
        GameObject hordeObject = (GameObject)hordeObjects.get(hindex);
        if(shipObject.collidingWith(hordeObject)) {
          playerObjects.remove(shipObject);
          hordeObjects.remove(hordeObject); 
        }
      }
      if(testBoss != null) {
         BossComponent component = testBoss.checkCollision(shipObject);
         if(component != null) {
           component.changeHPRelative(-1);
           playerObjects.remove(shipObject); 
         }
      }
    }
    for(int index = 0; index < hordeObjects.size(); index++) {
      GameObject hordeObject = (GameObject)hordeObjects.get(index);
      if(playerShip.collidingWith(hordeObject)) {
        playerObjects.clear();
        hordeObjects.clear();
        playerShip.setPosition(new PVector(200, 500));
      } 
    }
  }
  
  // TODO: move to separate input handler, don't want this class to be too big!
  public void parseInput() {
    // move horde selector
    playerHorde.setPosition(mouseX, mouseY); 
    if(mouseHeld && testBoss != null) {
      if(testBoss.getBoundingBox().collidesWith(new PVector(mouseX, mouseY))) {
        testBoss.setDestination(new PVector(mouseX, mouseY)); 
      }
    }
  }
  
  public void setMouseHeld(boolean held) {
    if(mouseHeld == false && held == true) {
      if(testBoss != null) {
        if(testBoss.getBoundingBox().collidesWith(new PVector(mouseX, mouseY))) {
          testBoss.setStart(new PVector(mouseX, mouseY));
        }
      } 
    }
    
    mouseHeld = held; 
    if(testBoss != null && held == true) {  
      BossArm arm = testBoss.shoot(); 
      if(arm != null && arm.canShoot()) {
        arm.shoot(); 
        PVector toTarg = arm.toTarget();
        HexShooterShot shot = new HexShooterShot(toTarg);
        toTarg.mult(35);
        shot.setPosition(arm.getPosition().x + toTarg.x, arm.getPosition().y + toTarg.y);
        gameManager.addHordeObject(shot);
      }
    }
  }
  
  public void createHordeObject() {
    mouseHeld = false;
    if(mouseY < 150 && playerHorde.canSummon())
    {
      if(bossMeter.getStatus() >= 1.0) {
        if(testBoss == null) {
          testBoss = new Boss(new PVector(250.0f, 100.0f));
          testBoss.setTarget(playerShip);
        }
      } else {
        playerHorde.summon();
        HexShooter hexShooter = new HexShooter();
        hexShooter.setPosition(playerHorde.getPosition().x, playerHorde.getPosition().y);
        hexShooter.setTarget(playerShip);
        addHordeObject(hexShooter);
      }
    } 
  }
}
