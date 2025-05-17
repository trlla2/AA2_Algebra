


void setup(){
    size(1024,768);
    
     buffer = createGraphics(width, height); //initialize buffer
}

void draw(){
  
  buffer.beginDraw(); // start buffer (todo lo que se tenga de printar tiene que estar dentro del buffer)
  // todo lo que se tiene que printar se tiene que poner antes un buffer (buffer.rect(...))
  
  buffer.endDraw(); // fin del buffer
  ColorFilter(255, 255, 255); 
}
