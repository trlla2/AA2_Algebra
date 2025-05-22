PImage fondo;
int stage = 1;
int limitStage = 800;
boolean levelStarting = true;
PFont font;
import processing.sound.*;
SoundFile sStageStart;

Obstacle obstacle;

Player player;
Enemy enemy;

void setup() {
  size(1024, 768);
  fondo = loadImage("Fondo.png");
  noSmooth(); // Desactiva suavizado para pixel art
  buffer = createGraphics(width, height);
  obstacle = new Obstacle();
  player = new Player(this);
  enemy = new Enemy(this, 700, height - 320);
  sStageStart = new SoundFile(this, "Inicio_Karateka.wav");
  sStageStart.play(); // Sonar al empezar el primer nivel
  font = createFont("font.TTF", 128);
}
void StageRestart() {
  player.x = width - 800;
  player.y = height - 320;

  sStageStart.play();
  levelStarting = true; // Bloquea movimiento
  enemy.resetEnemy(700, height - 320);
}



void StageUpdate(){
  // Update 
  player.update();
  enemy.update(player);
  // update 
  obstacle.update();
  
  // Comprobar si golpea al enemigo
  if (enemy.isHitBy(player)) {
    player.sAttackHit.play(); // Sobrescribe sonido de impacto
    enemy.receiveHit(player);
  }


  // DETECCIÓN DE COLISIÓN ENEMIGO → JUGADOR
  if (enemy.alive) {
    float pw = player.getCurrentFrames()[player.currentFrame].width * player.scaleFactor;
    float ph = player.getCurrentFrames()[player.currentFrame].height * player.scaleFactor;

    float ew = enemy.w;
    float eh = enemy.h;

    float px = player.x;
    float py = player.y;
    float ex = enemy.x;
    float ey = enemy.y;

    boolean touching = px + pw > ex &&
                       px < ex + ew &&
                       py + ph > ey &&
                       py < ey + eh;

    if (touching) {
      player.receiveDamage();
    }
  }

  // Cambio de fase
  if (player.x > limitStage) {
    println("ChangeStage");
    StageRestart();
    stage++;
  }

  // Dibujo
  buffer.image(fondo, 0, 0, width, height);
  player.display();
  enemy.display();
  obstacle.display();
}



void draw() {
  buffer.beginDraw();

  // Si el nivel está empezando, espera a que termine el sonido
  if (!levelStarting) {
    StageUpdate();
  } else {
    buffer.image(fondo, 0, 0, width, height);
    
    
    buffer.textFont(font);
    buffer.textAlign(CENTER);
    buffer.textSize(80);
    buffer.fill(255);
    buffer.text("Preparate", width/2, height/2);
    
    // Si la música ya no suena, desbloquear
    if (!sStageStart.isPlaying()) {
      levelStarting = false;
    }
  }
  
  buffer.endDraw();
  ColorFilter(255, 255, 255);

}


void keyPressed() {
  if (key == 'a' || key == 'A') player.moveLeft = true;
  if (key == 'd' || key == 'D') player.moveRight = true;
  if (key == 'k' || key == 'K') player.die();
  if (key == ' ') player.jump();
}

void keyReleased() {
  if (key == 'a' || key == 'A') player.moveLeft = false;
  if (key == 'd' || key == 'D') player.moveRight = false;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    player.attack();
  }
}
