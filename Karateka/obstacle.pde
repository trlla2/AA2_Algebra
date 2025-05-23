class Obstacle {
  int curve_estate = 4; 
  boolean forward = false;
  PVector position;
  float u;
  PImage sprite;
  boolean isAlive = false;
  float angle = 0;   
  float limitAngle = 50;
  int rotationSpeed = 1;
  
  Interpolation_curve first_curve;
  Interpolation_curve second_curve;
  Interpolation_curve third_curve;
  Interpolation_curve fourth_curve;

  
  Obstacle(){
     position = new PVector(); 
     sprite = loadImage("Data/Ghost.png");
    
     PVector p[], q[], w[], k[];; // -> u
     p = new PVector[4];
     
     p[0] = new PVector(150, 448);  
     p[1] = new PVector(200, 548);  
     p[2] = new PVector(250, 548);  
     p[3] = new PVector(300, 448);  
    
     q = new PVector[4];
     
     q[0] = new PVector(300, 448); 
     q[1] = new PVector(350, 348);  
     q[2] = new PVector(400, 348);  
     q[3] = new PVector(450, 448);  
      
     w = new PVector[4];
     
     w[0] = new PVector(450, 448);  
     w[1] = new PVector(500, 548);  
     w[2] = new PVector(550, 548);  
     w[3] = new PVector(600, 448);  
     
     k = new PVector[4];
     
     k[0] = new PVector(600, 448);  
     k[1] = new PVector(700, 348);  
     k[2] = new PVector(750, 348);  
     k[3] = new PVector(800, 448);  
     
     
     // create the curves
    first_curve = new Interpolation_curve(p);
    second_curve = new Interpolation_curve(q);
    third_curve = new Interpolation_curve(w);
    fourth_curve = new Interpolation_curve(k);
    
    // calculate cofs
    first_curve.calculate_coefs();
    second_curve.calculate_coefs();
    third_curve.calculate_coefs();
    fourth_curve.calculate_coefs();
    
    
  }
  
  void update(){
    if(curve_estate == 1){ // p(u)
      position.x = first_curve.coefs[0].x + first_curve.coefs[1].x * u +
        first_curve.coefs[2].x * u * u +
        first_curve.coefs[3].x * u * u * u;
      position.y = first_curve.coefs[0].y + first_curve.coefs[1].y * u +
        first_curve.coefs[2].y * u * u +
        first_curve.coefs[3].y * u * u * u;
    }
    else if(curve_estate == 2){// q(u)
      position.x = second_curve.coefs[0].x + second_curve.coefs[1].x * u +
        second_curve.coefs[2].x * u * u +
        second_curve.coefs[3].x * u * u * u;
      position.y = second_curve.coefs[0].y + second_curve.coefs[1].y * u +
        second_curve.coefs[2].y * u * u +
        second_curve.coefs[3].y * u * u * u;
    }
    else if(curve_estate == 3){// q(u)
      position.x = third_curve.coefs[0].x + third_curve.coefs[1].x * u +
        third_curve.coefs[2].x * u * u +
        third_curve.coefs[3].x * u * u * u;
      position.y = second_curve.coefs[0].y + third_curve.coefs[1].y * u +
        third_curve.coefs[2].y * u * u +
        third_curve.coefs[3].y * u * u * u;
    }
    else if(curve_estate == 4){// q(u)
      position.x = fourth_curve.coefs[0].x + fourth_curve.coefs[1].x * u +
        fourth_curve.coefs[2].x * u * u +
        fourth_curve.coefs[3].x * u * u * u;
      position.y = fourth_curve.coefs[0].y + fourth_curve.coefs[1].y * u +
        fourth_curve.coefs[2].y * u * u +
        fourth_curve.coefs[3].y * u * u * u;
    }
    
    float uStep = forward ? 0.01 : -0.01;
    
    u += uStep;
    
    if(forward){
      if(u >= 1){
        if(curve_estate >= 4){
           forward = false;     // Cambiar dirección
           u = 1 - uStep;      // Mantener posición en el límite
        } else {
          curve_estate++;
          u = 0;
        }
      }
    } else {
      if(u <= 0){
        if(curve_estate <= 1){
          forward = true;      // Cambiar dirección
          u = -uStep;          // Mantener posición en el límite
        } else {
          curve_estate--;
          u = 1;
        }
      }
    }
    
    
    if(angle >= limitAngle ){
      rotationSpeed = -1;
    }
    else if(angle <= -limitAngle){
      rotationSpeed = 1;
    }
    
    angle += rotationSpeed;
  }
  
  // pintarlo
  void display() {
    if (isAlive) {
      buffer.pushMatrix(); 
      buffer.translate(position.x, position.y);
      buffer.rotate(radians(angle));
      buffer.imageMode(CENTER);
      buffer.image(sprite, 0, 0, 100, 100);
  
      // DEBUG: Dibujar hitbox
      buffer.noFill();
      buffer.stroke(0, 0, 255); // Azul para diferenciar
      buffer.strokeWeight(2);
      buffer.rectMode(CENTER);
      buffer.rect(0, 0, 100, 100);
      buffer.rectMode(CORNER); // Restaurar por si acaso
      buffer.noStroke();
  
      buffer.imageMode(CORNER);
      buffer.popMatrix(); 
    }
  }

  
  // reset variables
  void restart(){
    isAlive = true;
    curve_estate = 4; 
  }
  
}
