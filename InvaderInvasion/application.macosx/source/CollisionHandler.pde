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
