public static final int WIDTH = 480;
public static final int HEIGHT = 640;

Backdrop backdrop0, backdrop1, backdrop2;
boolean debug;
GameObjectManager gameManager;

// input state for ship movement
// TODO: better input handling
boolean[] keys = new boolean[4];


void setup() {
  //System.out.println("Starting");
  debug = false;
  
  // setup display
  size(480, 640); 
  

  
  // TODO: make sub functions for individual setups
  // setup backdrop
  backdrop0 = new StarBackdrop(WIDTH, HEIGHT, 2);
  backdrop1 = new StarBackdrop(WIDTH, HEIGHT, 4);
  backdrop2 = new StarBackdrop(WIDTH, HEIGHT, 4);
  
  // setup player
  PlayerShip player = new PlayerShip(new PVector(200, 500));
  player.destination.x = player.getPosition().x;
  player.destination.y = player.getPosition().y;

  // setup horde
  PlayerHorde horde = new PlayerHorde();
  horde.setPosition(new PVector(200, 100));

  // Game Object Manager
  gameManager = new GameObjectManager(player, horde);
  
  // TEST AREA
  
  // /TEST AREA
}

void mouseReleased() {
  gameManager.createHordeObject();
  gameManager.setMouseHeld(false);
}

void mousePressed() {
  gameManager.setMouseHeld(true); 
}


// TODO: move to input handler
void keyPressed() {
  PVector dir = new PVector();
  int speed = 10;
  if(keyCode == UP) {
    keys[0] = true;
  }
  if(keyCode == DOWN) {
    keys[1] = true;
  }
  if(keyCode == LEFT) {
    keys[2] = true;
  }
  if(keyCode == RIGHT) {
    keys[3] = true;
  }
  if(key == 'd') {
    debug = !debug; 
  } 
  if (key == 'r') { // RESTART
    setup(); 
  }
}

void keyReleased() {
  if(keyCode == UP) {
    keys[0] = false;
  } else if(keyCode == DOWN) {
    keys[1] = false; 
  } else if(keyCode == LEFT) {
    keys[2] = false; 
  } else if(keyCode == RIGHT) {
    keys[3] = false; 
  } else if(keyCode == CONTROL) {
    PlayerShip ship = gameManager.getPlayerShip();
    if(ship.canShoot()){
      ship.shoot();
      PlayerShot shot = new PlayerShot();
      PVector temp = new PVector(0.0f, -15.0f);
      shot.setPosition(PVector.add(ship.getPosition(), temp));
      gameManager.addPlayerObject(shot);
    }
  }
}

// main draw loop
void draw() {
  gameManager.parseInput();
  
  // TODO: put this in input handler
  PlayerShip playerShip = gameManager.getPlayerShip();
  
  PVector dir = new PVector(0, 0);
  if(keys[0]) {
    if(playerShip.getPosition().y > 20.0) dir.y -= 5.0;
  }
  if(keys[1]) {
    if(playerShip.getPosition().y < HEIGHT - 25.0) dir.y += 5.0;
  }
  if(keys[2]) {
    if(playerShip.getPosition().x > 20.0) dir.x -= 5.0;
  }
  if(keys[3]) {
    if(playerShip.getPosition().x < WIDTH - 20.0) dir.x += 5.0; 
  }
  
  playerShip.moveRelative(dir);
  
  // logic update
  gameManager.step();
  
  // check and resolve collisions
  gameManager.checkCollisions();
  
  // draw
  background(0);
  
  // draw backdrop
  backdrop0.draw(debug);  
  backdrop1.draw(debug);
  backdrop2.draw(debug);

  gameManager.draw(debug);
}
