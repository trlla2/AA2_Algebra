import processing.sound.*;

class Enemy {
  float x, y;
  float w = 50;
  float h = 100;
  int lives = 3;
  boolean alive = true;
  boolean wasHitThisAttack = false;
  boolean attacking = false;
  float speed = 1.5;
  float attackRange = 50;
  float knockbackDistance = 60;
  
  boolean knockbackActive = false;
  int knockbackFrames = 10;
  int knockbackCounter = 0;
  int knockbackDirection = 0; // -1 = izquierda, 1 = derecha
  
  PImage[] runFrames;
  PImage[] deathFrames;
  
  int currentFrame = 0;
  int frameDelay = 5;
  int frameCounter = 0;
  
  String state = "run";
  
  int scaleFactor = 6; // Igual que el del player

  boolean facingRight = true;

  SoundFile sDeath;

  PApplet app;

  Enemy(PApplet app, float x, float y) {
    this.app = app;
    runFrames   = loadSprites("run.png", 12);
    deathFrames = loadSprites("death.png", 11);

    this.x = x;
    this.y = y;
    sDeath = new SoundFile(app, "Derrota_Enemigo_Karateka.wav");
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


  void update(Player player) {
    // Permitir animación de muerte incluso si está muerto
    if (!alive) {
      // Solo permitir que avance la animación si aún no ha terminado
      if (state.equals("death") && currentFrame < deathFrames.length - 1) {
      // Permitir que se actualice currentFrame
      } else {
        return; // No hacer nada más
      }
    }


  
    // Si el jugador está muerto, detener toda lógica
    if (player.state.equals("death")) return;
  
    float enemyCenter = x + w / 2;
    float pw = player.getCurrentFrames()[player.currentFrame].width * player.scaleFactor;
    float playerCenter = player.x + pw / 2;
    float dx = playerCenter - enemyCenter;
  
    if (alive) {
      if ((dx >= 0 && dx < attackRange) || (dx < 0 && -dx < attackRange)) {
        attacking = true;
      } else {
        attacking = false;
    
        if (dx > 0) {
          x += speed;
          facingRight = true;
        } else if (dx < 0) {
          x -= speed;
          facingRight = false;
        }
      }
    } else {
      attacking = false; // ya está muerto, que no ataque
    }
    
    // Knockback
    if (knockbackActive) {
      x += knockbackDirection * (knockbackDistance / knockbackFrames);
      knockbackCounter++;
      if (knockbackCounter >= knockbackFrames) {
        knockbackActive = false;
      }
    }
  
    // Limitar movimiento
    if (x < 0) x = 0;
    if (x > width - w) x = width - w;
    
    // Estado
    if (alive) {
      state = "run";
    } else {
      state = "death";
    }
    
    // Animación
    frameCounter++;
    if (frameCounter >= frameDelay) {
      currentFrame++;
      frameCounter = 0;
    
      if (state.equals("death") && currentFrame >= deathFrames.length) {
        currentFrame = deathFrames.length - 1; // No se reinicia
      } else {
        currentFrame %= getCurrentFrames().length;
      }
    }

  }


  void display() {
    buffer.pushMatrix();

    int newW = getCurrentFrames()[currentFrame].width * scaleFactor;
    int newH = getCurrentFrames()[currentFrame].height * scaleFactor;

    if (facingRight) {
      buffer.translate(x, y);
    } else {
      buffer.translate(x + newW, y);
      buffer.scale(-1, 1);
    }

    PImage img = getCurrentFrames()[currentFrame];
    buffer.image(img, 0, 0, newW, newH);

    if (showHitboxes) {
      buffer.noFill();
      buffer.stroke(255, 0, 0);
      buffer.strokeWeight(2);
      buffer.rect(0, 0, newW, newH);
      buffer.noStroke();
    }

    buffer.popMatrix();
  }



  void receiveHit(Player player) {
    if (!alive) return;

    // Retroceso
    if (player.x < x) {
      x += knockbackDistance;
    } else {
      x -= knockbackDistance;
    }

    lives--;
    if (lives <= 0) {
      alive = false;
      state = "death";
      currentFrame = 0;
      frameCounter = 0;
      sDeath.play();
    }

  }

  boolean isHitBy(Player player) {
    if (!alive) return false;

    if (!player.state.equals("attack")) {
      wasHitThisAttack = false;
      return false;
    }

    if (wasHitThisAttack) return false;

    float pw = player.getCurrentFrames()[player.currentFrame].width * player.scaleFactor;
    float ph = player.getCurrentFrames()[player.currentFrame].height * player.scaleFactor;

    float px = player.x;
    float py = player.y;
    if (!player.facingRight) {
      px += pw / 2;
    }

    boolean hit = px + pw > x &&
                  px < x + w &&
                  py + ph > y &&
                  py < y + h;

    if (hit) {
      wasHitThisAttack = true;
      return true;
    }

    return false;
  }

  void resetEnemy(float newX, float newY) {
    x = newX;
    y = newY;
    lives = 3;
    alive = true;
    attacking = false;
    wasHitThisAttack = false;
  }
  
  PImage[] getCurrentFrames() {
    if (state.equals("death")) return deathFrames;
    return runFrames;
  }

}
