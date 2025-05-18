PImage fondo;

Player player;
Enemy enemy;

void setup() {
  size(1024, 768);
  fondo = loadImage("Fondo.png");
  noSmooth(); // Desactiva suavizado para pixel art
  buffer = createGraphics(width, height);

  player = new Player();
  enemy = new Enemy(700, height - 320); // Ajusta posición según altura del suelo
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


  buffer.endDraw();

  // Pintar buffer en pantalla
  image(buffer, 0, 0);
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
