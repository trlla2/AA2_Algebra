PImage fondo;
int stage = 1;
color[] hpColor = new color[2];
int limitStage = 800;

Obstacle obstacle;

Player player;
Enemy enemy;

void setup() {
  size(1024, 768);
  fondo = loadImage("Fondo.png");
  noSmooth(); // Desactiva suavizado para pixel art
  buffer = createGraphics(width, height);
  obstacle = new Obstacle();
  player = new Player();
  enemy = new Enemy(700, height - 320); // Ajusta posición según altura del suelo
  
  // Set hp color
  hpColor[0] = color(255,0,0);
  hpColor[1] = color(255,255,0);
  hpColor[2] = color(255,255,255);

}
void StageRestart(){
  player.x =  width - 800;
  player.y = height - 320;
}

void StageUpdate(){
  // Update 
  // Actualización y dibujo de jugador
  player.update();
  // Actualización y dibujo del enemigo con IA
  enemy.update(player);
  // update 
  obstacle.update();
  
  // Comprobar si golpea al enemigo
  if (enemy.isHitBy(player)) {
    enemy.receiveHit(player);
  }

  if(player.x > limitStage){ // si llega al final del escenario
    println("ChangeStage");
    StageRestart();
    stage ++;
  }
  
  // Dibujar
  buffer.image(fondo, 0, 0, width, height);
  player.display();
  enemy.display();
  obstacle.display();
}


void draw() {
  buffer.beginDraw();

  StageUpdate();
  
  buffer.endDraw(); // fin del buffer
  
  ColorFilter(255, 255, 255);  // setear color filter al frame
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
