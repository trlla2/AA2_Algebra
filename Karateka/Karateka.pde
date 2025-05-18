// Fondo
PImage fondo;

Player player;
void setup(){
    size(1024,768);
    fondo = loadImage("Fondo.png");
    noSmooth(); // Desactiva interpolación borrosa
    player = new Player();
    
     buffer = createGraphics(width, height); //initialize buffer
}

void draw(){
  
  player.update();
  
  
  buffer.beginDraw(); // start buffer (todo lo que se tenga de printar tiene que estar dentro del buffer)
  // todo lo que se tiene que printar se tiene que poner antes un buffer (buffer.rect(...))
  buffer.image(fondo, 0, 0, width, height); // Dibuja la imagen escalada como fondo
  player.display();
  
  buffer.endDraw(); // fin del buffer
  ColorFilter(255, 255, 255); 
}

void keyPressed() {
  if (key == 'a' || key == 'A') player.moveLeft = true;
  if (key == 'd' || key == 'D') player.moveRight = true;
  if (key == 'k' || key == 'K') player.die();
  if (key == ' ') player.jump();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    player.attack();
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') player.moveLeft = false;
  if (key == 'd' || key == 'D') player.moveRight = false;
}
