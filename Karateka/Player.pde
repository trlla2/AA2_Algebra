import processing.sound.*;

class Player {
  float x, y;
  float speed = 3;
  boolean moveLeft = false;
  boolean moveRight = false;
  boolean facingRight = true;

  PImage[] idleFrames;
  PImage[] runFrames;
  PImage[] attackFrames;
  PImage[] deathFrames;
  PImage[] jumpFrames;

  int currentFrame = 0;
  int frameDelay = 5;
  int frameCounter = 0;

  String state = "idle";

  boolean jumping = false;
  int jumpDuration = 90;
  int jumpCounter = 0;
  float jumpStartX, jumpStartY, jumpEndX, jumpEndY;
  float jumpControlX, jumpControlY;

  BezierQuadratic bezierX;
  BezierQuadratic bezierY;

  int scaleFactor = 6;
  
  int maxLives = 3;
  int lives = 3;
  int damageCooldown = 120;
  int damageCounter = 0;
  boolean damagedRecently = false;
  
  float knockbackDistance = 100;
  boolean knockbackActive = false;
  int knockbackFrames = 10;
  int knockbackCounter = 0;
  int knockbackDirection = 0; // -1 = izquierda, 1 = derecha

  // Sonidos
  SoundFile sAttackHit;
  SoundFile sAttackMiss;
  SoundFile sDeath;


  PApplet app;

  Player(PApplet app) {
    this.app = app;
    x = width - 800;
    y = height - 320;
  
    idleFrames   = loadSprites("idle.png", 3);
    runFrames    = loadSprites("run.png", 12);
    attackFrames = loadSprites("light-attack.png", 7);
    deathFrames  = loadSprites("death.png", 11);
    jumpFrames   = loadSprites("jump.png", 4);
  
    sAttackHit  = new SoundFile(app, "Ataque_Karateka.wav");
    sAttackMiss = new SoundFile(app, "Ataque_Fallido_Karateka.wav");
    sDeath      = new SoundFile(app, "Muerte_Karateka.wav");
  }


  PImage[] loadSprites(String file, int total) {
    PImage sheet = loadImage(file);
    int w = sheet.width / total;
    int h = sheet.height;
    PImage[] frames = new PImage[total];
    for (int i = 0; i < total; i++) {
      frames[i] = sheet.get(i * w, 0, w, h);
    }
    return frames;
  }
  
  void receiveDamageFromObstacle() {
    if (!damagedRecently && state != "death") {
      lives--;
      if (lives <= 0) {
        lives = 0;
        die();
      }
      damagedRecently = true;
    }
  }

  
  void receiveDamageFrom(Enemy enemy) {
    if (!damagedRecently && state != "death") {
      lives--;
      if (lives <= 0) {
        lives = 0;
        die();
      }
      damagedRecently = true;
  
      // Knockback según posición del enemigo
      if (enemy.x < x) {
        knockbackDirection = 1; // empuja hacia la derecha
      } else {
        knockbackDirection = -1; // empuja hacia la izquierda
      }
  
      knockbackActive = true;
      knockbackCounter = 0;
    }
  }


  void attack() {
    if (!state.equals("death") && !jumping && !state.equals("attack")) {
      state = "attack";
      currentFrame = 0;
      frameCounter = 0;
      sAttackMiss.play();
    }
  }



  void die() {
    if (!state.equals("death")) {
      state = "death";
      currentFrame = 0;
      frameCounter = 0;
      sDeath.play();
    }
  }


  void jump() {
    if (!jumping && !state.equals("death")) {
      state = "jump";
      jumping = true;
      jumpCounter = 0;
      currentFrame = 0;
      frameCounter = 0;

      jumpStartX = x;
      jumpStartY = y;
      jumpEndX = x + (facingRight ? 200 : -200);
      jumpEndY = y;
      jumpControlX = (jumpStartX + jumpEndX) / 2;
      jumpControlY = y - 150;

      bezierX = new BezierQuadratic(jumpStartX, jumpControlX, jumpEndX);
      bezierY = new BezierQuadratic(jumpStartY, jumpControlY, jumpEndY);
    }
  }

  void update() {
    if (state.equals("death")) {
      frameCounter++;
      if (frameCounter >= frameDelay && currentFrame < deathFrames.length - 1) {
        currentFrame++;
        frameCounter = 0;
      }
      return;
    }

    if (state.equals("attack")) {
      frameCounter++;
      if (frameCounter >= frameDelay) {
        currentFrame++;
        frameCounter = 0;
        if (currentFrame >= attackFrames.length) {
          currentFrame = 0;
          state = "idle";
        }
      }
      return;
    }

    if (state.equals("jump")) {
      frameCounter++;
      if (frameCounter >= frameDelay) {
        currentFrame = (currentFrame + 1) % jumpFrames.length;
        frameCounter = 0;
      }

      float t = jumpCounter / float(jumpDuration);
      x = bezierX.evaluate(t);
      y = bezierY.evaluate(t);

      jumpCounter++;
      if (jumpCounter >= jumpDuration) {
        jumping = false;
        state = "idle";
        y = jumpEndY;
      }

      currentFrame = constrain(currentFrame, 0, getCurrentFrames().length - 1);
      int spriteWidth = getCurrentFrames()[currentFrame].width * scaleFactor;
      x = constrain(x, 0, width - spriteWidth);
      return;
    }

    if (moveLeft) {
      x -= speed;
      facingRight = false;
      state = "run";
    } else if (moveRight) {
      x += speed;
      facingRight = true;
      state = "run";
    } else {
      state = "idle";
    }

    frameCounter++;
    if (frameCounter >= frameDelay) {
      currentFrame = (currentFrame + 1) % getCurrentFrames().length;
      frameCounter = 0;
    }

    currentFrame = constrain(currentFrame, 0, getCurrentFrames().length - 1);
    int spriteWidth = getCurrentFrames()[currentFrame].width * scaleFactor;
    x = constrain(x, 0, width - spriteWidth);
    
    if (damagedRecently) {
      damageCounter++;
      if (damageCounter >= damageCooldown) {
        damagedRecently = false;
        damageCounter = 0;
      }
    }
    if (knockbackActive) {
      x += knockbackDirection * (knockbackDistance / knockbackFrames);
      knockbackCounter++;
      if (knockbackCounter >= knockbackFrames) {
        knockbackActive = false;
      }
    }

  }

  void display() {
    PImage img = getCurrentFrames()[currentFrame];
    int newW = img.width * scaleFactor;
    int newH = img.height * scaleFactor;

    buffer.pushMatrix();

    if (!facingRight) {
      buffer.translate(x + newW, y);
      buffer.scale(-1, 1);
      buffer.image(img, 0, 0, newW, newH);
    } else {
      buffer.translate(x, y);
      buffer.image(img, 0, 0, newW, newH);
    }

    if (showHitboxes) {
      buffer.noFill();
      buffer.stroke(0, 255, 0);
      buffer.strokeWeight(2);
      buffer.rect(0, 0, newW, newH);
      buffer.noStroke();
    }

    buffer.popMatrix();
  }



  PImage[] getCurrentFrames() {
    switch (state) {
      case "run": return runFrames;
      case "attack": return attackFrames;
      case "death": return deathFrames;
      case "jump": return jumpFrames;
      default: return idleFrames;
    }
  }
}
