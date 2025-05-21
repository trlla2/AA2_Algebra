// Fondo
PImage fondo;
int stage = 1;
int limitStage = 800;

Obstacle obstacle;

Player player;

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

void setup(){
    size(1024,768);
    fondo = loadImage("Fondo.png");
    noSmooth(); // Desactiva interpolación borrosa
    player = new Player();
    
    obstacle = new Obstacle();
    
    buffer = createGraphics(width, height); //initialize buffer
}

void draw(){
  buffer.beginDraw(); // start buffer (todo lo que se tenga de printar tiene que estar dentro del buffer)
  // todo lo que se tiene que printar se tiene que poner antes un buffer (buffer.rect(...))
  StageUpdate();
  
  if(player.x > limitStage){ // si llega al final del escenario
    println("ChangeStage");
    StageRestart();
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

void mousePressed() {
  if (mouseButton == LEFT) {
    player.attack();
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') player.moveLeft = false;
  if (key == 'd' || key == 'D') player.moveRight = false;
}
