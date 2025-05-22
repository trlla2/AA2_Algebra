PImage fondo;
int stage = 1;
int limitStage = 800;

Obstacle obstacle;

Player player;
Enemy enemy;

void setup() {
  size(1024, 768);
  fondo = loadImage("Fondo.png");
  noSmooth(); // Desactiva suavizado para pixel art
  buffer = createGraphics(width, height);

  player = new Player();
  enemy = new Enemy(700, height - 320); // Ajusta posición según altura del suelo

void StageRestart(){
  player.x =  width - 800;
  player.y = height - 320;
}

void StageUpdate(){
  player.update();
  obstacle.update();
  
  buffer.image(fondo, 0, 0, width, height); // Dibuja la imagen escalada como fondo
  player.display();
  obstacle.display(buffer);
}

}

void draw() {
  buffer.beginDraw();

  // Dibuja fondo
  buffer.image(fondo, 0, 0, width, height);

  // Actualización y dibujo de jugador
  player.update();
  player.display();

  // Actualización y dibujo del enemigo con IA
  enemy.update(player);
  enemy.display();

  // Comprobar si golpea al enemigo
  if (enemy.isHitBy(player)) {
    enemy.receiveHit(player);
  }

  StageUpdate();
  
  if(player.x > limitStage){ // si llega al final del escenario
    println("ChangeStage");
    StageRestart();
    stage ++;
  }
  
  buffer.endDraw(); // fin del buffer
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
