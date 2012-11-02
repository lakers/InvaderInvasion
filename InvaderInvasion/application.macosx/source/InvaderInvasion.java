import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class InvaderInvasion extends PApplet {

public static final int WIDTH = 480;
public static final int HEIGHT = 640;

Backdrop backdrop0, backdrop1, backdrop2;
boolean debug;
GameObjectManager gameManager;

// input state for ship movement
// TODO: better input handling
boolean[] keys = new boolean[4];


public void setup() {
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

public void mouseReleased() {
  gameManager.createHordeObject();
  gameManager.setMouseHeld(false);
}

public void mousePressed() {
  gameManager.setMouseHeld(true); 
}


// TODO: move to input handler
public void keyPressed() {
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

public void keyReleased() {
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
public void draw() {
  gameManager.parseInput();
  
  // TODO: put this in input handler
  PlayerShip playerShip = gameManager.getPlayerShip();
  
  PVector dir = new PVector(0, 0);
  if(keys[0]) {
    if(playerShip.getPosition().y > 20.0f) dir.y -= 5.0f;
  }
  if(keys[1]) {
    if(playerShip.getPosition().y < HEIGHT - 25.0f) dir.y += 5.0f;
  }
  if(keys[2]) {
    if(playerShip.getPosition().x > 20.0f) dir.x -= 5.0f;
  }
  if(keys[3]) {
    if(playerShip.getPosition().x < WIDTH - 20.0f) dir.x += 5.0f; 
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
public class Asteroid extends GameObject {
  private int rate;
  
  public Asteroid(int rate) {
    this.rate = rate; 
    boundingCircle = new BoundingCircle(position, 20);
  }
  
  public void step() {
    moveRelative(new PVector(0, rate));
    boundingCircle.setPosition(position);
  }
  
  public void draw(boolean debug) {
    fill(0);
    stroke(255);
    ellipse(position.x, position.y, 40, 40); 
    boundingCircle.draw(debug);
  }
  
  public boolean canShoot() {
    return false; 
  }
  
}
abstract class Backdrop extends GameObject {
  protected int backdropWidth;
  protected int backdropHeight;
  
  public abstract void step();
  public boolean canShoot() {
    return false; 
  }
}
public class Boss extends GameObject {
  private BossArm leftArm, rightArm;
  private GameObject target;
  private PVector destination;
  private PVector start;
  private PVector offStart;
  private final float MAX_SPEED = 1;
  private BoundingBox boundingBox;
  
  public Boss(PVector position) {
    this.position = position;
    leftArm = new BossArm();
    leftArm.setPosition(new PVector(position.x - 100.0f, position.y));
    rightArm = new BossArm();
    rightArm.setPosition(new PVector(position.x + 100.0f, position.y));
    destination = new PVector();
    destination.x = position.x;
    destination.y = position.y;
    start = new PVector();
    start.x = position.x;
    start.y = position.y;
    offStart = new PVector(0.0f, 0.0f);
    boundingBox = new BoundingBox(this.position, 100, 110, new PVector(0, 0));
  }
  
  public void setTarget(GameObject target) {
    this.target = target;
    leftArm.setTarget(target);
    rightArm.setTarget(target); 
  }
  
  public BoundingBox getBoundingBox() {
    return boundingBox; 
  }
  
  public void setDestination(PVector destination) {
    this.destination = destination; 
  }
  
  public void setStart(PVector start) {
     this.start = start;
     offStart = PVector.sub(start, position);
     destination = offStart;
  }
  
  // will return which arm fired the shot
  public BossArm shoot() {
    
     PVector mousePos = new PVector(mouseX, mouseY);
     if(leftArm.getBoundingCircle().collidingWith(mousePos)) { 
       return(leftArm);
     } else if (rightArm.getBoundingCircle().collidingWith(mousePos)) {
       return(rightArm);
     }
     return null;
  }
  
  public void step() {
    PVector dir = PVector.sub(destination, PVector.add(position, offStart));
    if(dir.mag() > 3.0f) {
      dir.normalize();
      dir.mult(MAX_SPEED);
      moveRelative(dir);
      leftArm.moveRelative(dir);
      rightArm.moveRelative(dir);
    }
    leftArm.step();
    rightArm.step();
  }
  public boolean canShoot() {return false;}
  public void draw(boolean debug) {
    stroke(255);
    strokeWeight(3);
    fill(0);
    rect(position.x - 100, position.y - 40, 200, 40);
    rect(position.x - 30, position.y-20, 60, 30);
    strokeWeight(2);
    ellipse(position.x - 15, position.y - 5, 20, 20);
    ellipse(position.x + 15, position.y - 5, 20, 20);
    leftArm.draw(debug);
    rightArm.draw(debug); 
    
    
    PVector toTarget = new PVector(0, 1);
     if(target != null) {
       toTarget = PVector.sub(target.position, position);
     }
     toTarget.normalize();
     toTarget.mult(5);
     stroke(255, 0, 0);
     strokeWeight(3);
     ellipse(position.x - 15 + toTarget.x, position.y - 5 + toTarget.y, 2, 2);
     ellipse(position.x + 15 + toTarget.x, position.y - 5 + toTarget.y, 2, 2);
     strokeWeight(1);
    
    
    if(debug) {
      boundingBox.draw(debug); 
    }
  }
}
public class BossArm extends BossComponent {
  private float r = 60.0f;
  GameObject target;
  BoundingCircle boundingCircle;
  private int shotTimer;
  
  public BossArm() {
    target = null;
    position = new PVector();
    boundingCircle = new BoundingCircle(position, r);
    shotTimer = 30;
  }
  
  public BoundingCircle getBoundingCircle() {
    return boundingCircle; 
  }
  
  public void step() {
    boundingCircle.setPosition(position); 
    if(shotTimer < 30) {
      shotTimer++; 
    }
  }
  
  public boolean canShoot() {
    return(shotTimer >= 30);
  }
  
  public void shoot() {
    shotTimer = 0; 
  }
  
  public PVector toTarget() {
    PVector toTarg = new PVector();
    if(target != null) {
      toTarg = PVector.sub(target.position, position);
    }
    toTarg.normalize();
    return toTarg;
  }
  
  public void setTarget(GameObject target) {
    this.target = target; 
  }
  
   public void draw(boolean debug) {
     pushMatrix();
     translate(position.x, position.y);
     float b = r * cos(PI/6.0f);
     float a = r * sin(PI/6.0f);
    
     stroke(0);
     strokeWeight(2);
     fill(0);
    
     triangle(0, 0, r, 0, a, b);
     triangle(0, 0, a, b, -a, b);
     triangle(0, 0, -a, b, -r, 0);
     triangle(0, 0, -r, 0, -a, -b);
     triangle(0, 0, -a, -b, a, -b);
     triangle(0, 0, a, -b, r, 0);
    
     stroke(255);
     line(r, 0, a, b);
     line(a, b, -a, b);
     line(-a, b, -r, 0);
     line(-r, 0, -a, -b);
     line(-a, -b, a, -b);
     line(a, -b, r, 0);
    
     // draw gun
     strokeWeight(3);
     ellipse(0, 0, 30, 30);
    
     PVector toTarget = new PVector(0, 1);
     if(target != null) {
       toTarget = PVector.sub(target.position, position);
     }
     toTarget.normalize();
     toTarget.mult(35);
    
     line(0, 0, toTarget.x, toTarget.y);
     strokeWeight(1);
    
     popMatrix();  
     
     if(debug) {
       boundingCircle.draw(debug); 
     }
   }
}
public class BossComponent extends GameObject {
  public void step() {}
  public boolean canShoot() {return false;}
  public void draw(boolean debug) {
  
  
  }
}
public class BoundingBox extends GameObject {
  private float boxWidth;
  private float boxHeight;
  PVector offset;
  
  public BoundingBox(PVector position, float boxWidth, float boxHeight, PVector offset) {
    this.position = position;
    this.boxWidth = boxWidth;
    this.boxHeight = boxHeight;
    this.offset = offset;
  } 
 
  public boolean collidesWith(PVector other) {
    if(other.x >= position.x + offset.x - boxWidth/2 && other.x <= position.x + offset.x + boxWidth/2) {
      return(other.y >= position.y + offset.y - boxHeight/2 && other.y <= position.y + offset.y + boxHeight/2);
    } else {
      return false; 
    }
  }

  public void step() {}
  public void draw(boolean debug) {
    if(debug) {
      strokeWeight(1);
      stroke(255,255,0);
      noFill();
      rect(position.x + offset.x - boxWidth/2, position.y + offset.y - boxHeight/2, boxWidth, boxHeight);
    } 
  }
  public boolean canShoot() {
    return false; 
  }
}
public class BoundingCircle {
  private PVector position;
  private float radius;
  
  public BoundingCircle(PVector position, float radius) {
    this.position = position;
    this.radius = radius;
  } 
  
  public PVector getPosition() {
    return position; 
  }
  
  public float getRadius() {
    return radius; 
  }
  
  public boolean collidingWith(PVector other) {
    PVector distance = PVector.sub(position, other);
    return(distance.mag() < radius); 
  }
  
  public boolean collidingWith(BoundingCircle other) {
    PVector distance = PVector.sub(position, other.getPosition()); 
    return(distance.mag() < radius + other.getRadius());
  }
  
  public void setPosition(PVector position) {
    this.position = position; 
  }
  
  public void draw(boolean debug) {
    if(debug) {
      pushMatrix();
      stroke(255, 0, 255);
      noFill();
      ellipse(position.x, position.y, radius*2, radius*2);
      popMatrix();
    } 
  }
}
public class CollisionHandler {
  PlayerShip player;
  PlayerHorde horde;
  ArrayList asteroids;
  ArrayList shots;
 
  public CollisionHandler(PlayerShip player, PlayerHorde horde, 
      ArrayList asteroids,ArrayList shots) {
    this.player = player;
    this.horde = horde;
    this.asteroids = asteroids;
    this.shots = shots;
  }
 
  // TODO prettier collisions
  public void checkCollisions() {
    for(int shotIndex = 0; shotIndex < shots.size(); shotIndex++) {
      PlayerShot shot = (PlayerShot)shots.get(shotIndex);
      for(int asteroidIndex = 0; asteroidIndex < asteroids.size(); asteroidIndex++) {
        Asteroid asteroid = (Asteroid)asteroids.get(asteroidIndex);
        if(shot.collidingWith(asteroid)) {
          asteroids.remove(asteroid);
          shots.remove(shot);
          //asteroid = null;
          //shot = null;
          continue; 
        }
      }
    }
    for(int asteroidIndex = 0; asteroidIndex < asteroids.size(); asteroidIndex++) {
      Asteroid asteroid = (Asteroid)asteroids.get(asteroidIndex);
      if(asteroid.collidingWith(player)) {
        player.setPosition(new PVector(200, 500));
        horde.setPosition(new PVector(200, 100));
        asteroids.clear();
        shots.clear(); 
      }
    } 
  }
}
public abstract class GameObject {
  protected PVector position;
  protected BoundingCircle boundingCircle;

  
  public GameObject() {
    position = new PVector();
  } 
  
  public void setPosition(PVector position) {
    this.position = position; 
  }
  
  public void setPosition(float xpos, float ypos) {
    position.x = xpos;
    position.y = ypos; 
  }
  
  public PVector getPosition() {
    return position;
  }
  
  public void moveRelative(PVector direction) {
    position.add(direction);
  }
  
  public BoundingCircle getBoundingCircle() {
    return boundingCircle; 
  }
  
  public boolean collidingWith(GameObject other) {
    return (boundingCircle.collidingWith(other.getBoundingCircle())); 
  }
  
  public abstract void draw(boolean debug);
  public abstract void step();
  public abstract boolean canShoot();
}
public class GameObjectManager {
  private PlayerShip playerShip;
  private PlayerHorde playerHorde;
  private ArrayList playerObjects;
  private ArrayList hordeObjects;
  private boolean mouseHeld;
  
  private Boss testBoss;
  
  
  public GameObjectManager(PlayerShip playerShip, PlayerHorde playerHorder) {
    this.playerShip = playerShip;
    this.playerHorde = playerHorder;
    playerObjects = new ArrayList();
    hordeObjects = new ArrayList();
    mouseHeld = false;
    testBoss = new Boss(new PVector(250.0f, 100.0f));
    testBoss.setTarget(playerShip);
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
    
    
  }
  
  public void step() {
    playerShip.step();
    playerHorde.step();
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
    
//    if(mouseY < 150 && playerHorde.canSummon()) {
//      playerHorde.summon();
//      HexShooter hexShooter = new HexShooter();
//      hexShooter.setPosition(playerHorde.getPosition().x, playerHorde.getPosition().y);
//      hexShooter.setTarget(playerShip);
//      addHordeObject(hexShooter);
//    } 
  }
}
public class HexShooter extends GameObject {
  private float r;
  GameObject target;
  float rate;
  private int shotTimer;
  
  public HexShooter() {
    shotTimer = 60;
    r = 20.0f; 
    target = null;
    boundingCircle = new BoundingCircle(position, 20);
    rate = 1;
  }
  
  public void setTarget(GameObject target) {
    this.target = target; 
  }
  
  public void shoot() {
    shotTimer = 0; 
  }
  
  public boolean canShoot() {
    return (shotTimer == 60); 
  }
  
  public void step() {
    shotTimer += 1;
    if(shotTimer > 60) {
      shotTimer = 60; 
    }
    moveRelative(new PVector(0, rate));
    boundingCircle.setPosition(position); 
  }
  
  public PVector toTarget() {
    PVector toTarg = new PVector();
    if(target != null) {
      toTarg = PVector.sub(target.position, position);
    }
    toTarg.normalize();
    return toTarg;
  }
  
  public void draw(boolean debug) {
    pushMatrix();
    translate(position.x, position.y);
    float b = r * cos(PI/6.0f);
    float a = r * sin(PI/6.0f);
    
    stroke(0);
    fill(0);
    
    triangle(0, 0, r, 0, a, b);
    triangle(0, 0, a, b, -a, b);
    triangle(0, 0, -a, b, -r, 0);
    triangle(0, 0, -r, 0, -a, -b);
    triangle(0, 0, -a, -b, a, -b);
    triangle(0, 0, a, -b, r, 0);
    
    stroke(255);
    line(r, 0, a, b);
    line(a, b, -a, b);
    line(-a, b, -r, 0);
    line(-r, 0, -a, -b);
    line(-a, -b, a, -b);
    line(a, -b, r, 0);
    
    // draw gun
    strokeWeight(2);
    ellipse(0, 0, 10, 10);
    
    PVector toTarget = new PVector(0, 1);
    if(target != null) {
      toTarget = PVector.sub(target.position, position);
    }
    toTarget.normalize();
    toTarget.mult(13);
    
    line(0, 0, toTarget.x, toTarget.y);
    strokeWeight(1);
    
    popMatrix(); 
  }
}
public class HexShooterShot extends GameObject {
  private static final float SPEED = 3.0f;
  private PVector direction;
  
  public HexShooterShot(PVector direction) {
    this.direction = direction; 
    boundingCircle = new BoundingCircle(position, 5);
  }
  
  public void step() {
    PVector temp = new PVector();
    temp.x = direction.x;
    temp.y = direction.y;
    temp.normalize();
    temp.mult(SPEED);
    moveRelative(temp);
    boundingCircle.setPosition(position);
  }
  
  public void draw(boolean debug) {
    stroke(255, 0, 0);
    ellipse(position.x, position.y, 20, 20); 
    boundingCircle.draw(debug);
  } 
  
  public boolean canShoot() {
    return false; 
  }
}
public class PlayerHorde extends GameObject {
  private int summonTimer;
  
  public PlayerHorde() {
    summonTimer = 30; 
  }
  
  public void draw(boolean debug) {
    if(debug) {
      pushMatrix();
      stroke(255, 0, 255);
      noFill();
      ellipse(position.x, position.y, 10.0f, 10.0f);
      point(position.x, position.y);
      stroke(150, 0, 150);
      line(0, 200, 480, 200);
      popMatrix();
    } 
  }
  
  public boolean canSummon() {
    return (summonTimer == 30); 
  }
  
  public void summon() {
    summonTimer = 0; 
  }
  
  public void step(){
    summonTimer += 1;
    if(summonTimer > 30) {
      summonTimer = 30; 
    }
  }
  
  public boolean canShoot() {
    return false; 
  }
  
}
public class PlayerShip extends GameObject {
  public PVector destination;
  private int shotTimer;
  
  public PlayerShip(PVector position) {
    shotTimer = 30;
    this.position = position;
    destination = new PVector();
    
    PVector temp = new PVector(0.0f, 5.0f);
    boundingCircle = new BoundingCircle(PVector.add(temp, position), 25);
  }
  
  
  public void draw(boolean debug) {
    pushMatrix();
    PVector temp = new PVector(0.0f, 5.0f);
    boundingCircle.setPosition(PVector.add(temp, position));
    boundingCircle.draw(debug);
    fill(0);
    stroke(255);
    translate(position.x, position.y);
    triangle(-20.0f, 20.0f, 0.0f, -20.0f, 20.0f, 20.0f);
    popMatrix();
  }
  
  public boolean canShoot() {
    return (shotTimer == 30); 
  }
  
  public void shoot() {
     shotTimer = 0;
  }
  
  public void step() {
    shotTimer += 1;
    if(shotTimer > 30) {
      shotTimer = 30; 
    }
//    PVector toDest = PVector.sub(destination, position);
//    if(toDest.mag() > 3) {
//      toDest.normalize();
//      toDest.mult(3);
//      moveRelative(toDest);
//      
//    }
  }
}
public class PlayerShot extends GameObject {
  private int speed;
  
  public PlayerShot() {
     boundingCircle = new BoundingCircle(position, 5);
     boundingCircle.setPosition(position);
  }
  
  public void draw(boolean debug) {
    speed = 5;
    stroke(255);
    ellipse(position.x, position.y, 5, 5); 
    boundingCircle.draw(debug);
  }
  
  public void step() {
    position.y -= speed; 
    boundingCircle.setPosition(position);
  }
  public boolean canShoot() {
    return false; 
  }
}
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

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "InvaderInvasion" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
