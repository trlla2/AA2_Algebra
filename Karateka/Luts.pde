
class Lut{
  PGraphics buffer;
  
  
  void ColorFilter(int r, int g, int b){
     // Obtener y procesar el buffer
     PImage frame = buffer.get();// cargar todo lo del buffer como si furea una imagen 
     frame.loadPixels();
     
    for(int i = 0; i< frame.width; i++){
      for(int j= 0; j < frame.height; j++){
        int index = i + j * frame.width; // passar array 2d a 1d cause imagenes son arrays 1d
        
        color ImgCol = frame.pixels[index]; 
        
        color temp;
        

        
        // para cambiar el color primero quiero saber cuanto color quiero (RGB/255) =  =  1 si quiero todo 0 si no quiero nada
        // ahora solo falta multiplicarlo con el color de la imagen rgb(image)*(RGB/255) = 255
        temp = color(red(ImgCol)*(r/255), green(ImgCol)*(g/255), blue(ImgCol)*(b/255)); // cambial color
        frame.pixels[index] = temp;
        
        frame.updatePixels();
      }
    }
    
    image(frame, 0, 0);
  }
}
