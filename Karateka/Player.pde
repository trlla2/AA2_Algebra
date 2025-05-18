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

  // Variables de salto Bézier
  boolean jumping = false;
  int jumpDuration = 90;
  int jumpCounter = 0;
  float jumpStartX, jumpStartY, jumpEndX, jumpEndY;
  float jumpControlX, jumpControlY;
  
  int scaleFactor = 6;

  Player() {
    x = width - 800;
    y = height - 320;

    idleFrames   = loadSprites("idle.png", 3);
    runFrames    = loadSprites("run.png", 12);
    attackFrames = loadSprites("light-attack.png", 7);
    deathFrames  = loadSprites("death.png", 11);
    jumpFrames   = loadSprites("jump.png", 4);

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

  void attack() {
    if (!state.equals("death") && !jumping) {
      state = "attack";
      currentFrame = 0;
      frameCounter = 0;
    }
  }

  void die() {
    if (!state.equals("death")) {
      state = "death";
      currentFrame = 0;
      frameCounter = 0;
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
      x = bezierPoint(jumpStartX, jumpControlX, jumpControlX, jumpEndX, t);
      y = bezierPoint(jumpStartY, jumpControlY, jumpControlY, jumpEndY, t);

      jumpCounter++;
      if (jumpCounter >= jumpDuration) {
        jumping = false;
        state = "idle";
        y = jumpEndY;
      }
      currentFrame = constrain(currentFrame, 0, getCurrentFrames().length - 1);
      x = constrain(x, 0, width - getCurrentFrames()[currentFrame].width * scaleFactor);
      return;
    }

    // Movimiento lateral
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

    // Animación de idle/run
    frameCounter++;
    if (frameCounter >= frameDelay) {
      currentFrame = (currentFrame + 1) % getCurrentFrames().length;
      frameCounter = 0;
    }
    currentFrame = constrain(currentFrame, 0, getCurrentFrames().length - 1);
    x = constrain(x, 0, width - getCurrentFrames()[currentFrame].width * scaleFactor);
  }

  void display() {
  currentFrame = constrain(currentFrame, 0, getCurrentFrames().length - 1);
  PImage img = getCurrentFrames()[currentFrame];
  int newW = img.width * scaleFactor;
  int newH = img.height * scaleFactor;


  if (!facingRight) {
    pushMatrix();
    translate(x + newW / 2, y);
    scale(-1, 1);
    image(img, -newW / 2, 0, newW, newH);
    popMatrix();
  } else {
    image(img, x, y, newW, newH);
  }
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
