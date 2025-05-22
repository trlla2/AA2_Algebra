PImage fondo;
int stage = 1;
color[] hpColor = new color[3];
int limitStage = 800;
boolean levelStarting = true;
boolean endLevel = false;
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
  
  // Set hp color
  hpColor[0] = color(255,50,255);
  hpColor[1] = color(255,255,0);
  hpColor[2] = color(255,255,255);

  player = new Player(this);
  enemy = new Enemy(this, 700, height - 320);
  sStageStart = new SoundFile(this, "Inicio_Karateka.wav");
  sStageStart.play(); // Sonar al empezar el primer nivel
  font = createFont("font.TTF", 128);
}
void StageRestart() {
  player.x = width - 800;
  player.y = height - 320;
  
  
  if(stage > 5){ // spawn el fantasma y el enemigo
      obstacle.restart();
      enemy.resetEnemy(700, height - 320);

  }
  else if(stage % 2 == 0){ // par spawnea el enemigo
      enemy.resetEnemy(700, height - 320);
  }
  else{ // impar spawnea el fantasma
      obstacle.restart();
  }

  sStageStart.play();
  levelStarting = true; // Bloquea movimiento
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
    
     // Score text
    buffer.textFont(font);
    buffer.textAlign(CENTER);
    buffer.textSize(30);
    buffer.fill(255);
    buffer.text("Score: " + stage, width*0.5, height*0.1); 
  } else {
    buffer.image(fondo, 0, 0, width, height);
    
    
    buffer.textFont(font);
    buffer.textAlign(CENTER);
    buffer.textSize(80);
    buffer.fill(255);
    buffer.text("Preparate", width*0.5, height*0.5);
    
    // Si la música ya no suena, desbloquear
    if (!sStageStart.isPlaying()) {
      levelStarting = false;
    }
  }
  
  if(player.lives <= 0 && !player.sDeath.isPlaying()){ // end text
    buffer.textFont(font);
    buffer.textAlign(CENTER);
    buffer.textSize(80);
    buffer.fill(255);
    buffer.text("The End", width*0.5, height*0.5);
  }
  
  
  
  buffer.endDraw(); // fin del buffer
  if(player.lives > 0){
    int colorR = (int)red(hpColor[player.lives -1]);
    int colorG = (int)green(hpColor[player.lives -1]);
    int colorB = (int)blue(hpColor[player.lives -1]);
    
    ColorFilter(colorR , colorG, colorB);
  }
  else{
    ColorFilter(255, 255, 255);  // setear color filter al frame
  }
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
