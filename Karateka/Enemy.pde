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
  float knockbackDistance = 130;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update(Player player) {
    if (!alive) return;

    float enemyCenter = x + w / 2;
    float pw = player.getCurrentFrames()[player.currentFrame].width * player.scaleFactor;
    float playerCenter = player.x + pw / 2;

    float dx = playerCenter - enemyCenter;

    // Knockback puede hacer que el enemigo salga ligeramente de pantalla, limitar:
    if ((dx >= 0 && dx < attackRange) || (dx < 0 && -dx < attackRange)) {
      attacking = true;
    } else {
      attacking = false;

      // Movimiento hacia el jugador
      if (dx > 0) {
        x += speed;
      } else if (dx < 0) {
        x -= speed;
      }
    }

    // Mantener dentro del borde de pantalla
    if (x < 0) x = 0;
    if (x > width - w) x = width - w;
  }

  void display() {
    if (!alive) return;
    if (attacking) {
      buffer.fill(255, 0, 0);
    } else {
      buffer.fill(255);
    }
    buffer.noStroke();
    buffer.rect(x, y, w, h);
  }

  void receiveHit(Player player) {
    if (!alive) return;

    // Retroceso (knockback)
    if (player.x < x) {
      x += knockbackDistance;
    } else {
      x -= knockbackDistance;
    }

    lives--;
    if (lives <= 0) {
      alive = false;
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
}
