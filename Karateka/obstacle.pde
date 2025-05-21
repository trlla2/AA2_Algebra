class Obstacle {
  int curve_estate = 1; 
  PVector position;
  float u;
  PImage sprite;
  
  Interpolation_curve first_curve;
  Interpolation_curve second_curve;
  
  
  Obstacle(){
     position = new PVector(); 
     sprite = loadImage("Data/Ghost.png");
    
     PVector p[], q[]; // -> u
     p = new PVector[4];
     p[0] = new PVector(200,100); // P0
     p[1] = new PVector(350,300); // P1
     p[2] = new PVector(500,300); // P2
     p[3] = new PVector(650,100); // P3
      
     q = new PVector[4];
     q[0] = new PVector(650,100); //  P0 
     q[1] = new PVector(500,300); //  P1
     q[2] = new PVector(350,300); //  P2
     q[3] = new PVector(200,100); // P3
     
     
     
     
     // create the curves
    first_curve = new Interpolation_curve(p);
    second_curve = new Interpolation_curve(q);
    
    
    // calculate cofs
    first_curve.calculate_coefs();
    second_curve.calculate_coefs();
    
    
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
    
    
    u += 0.01;
    if(u >= 1){
      curve_estate ++;
      u = 0;
      if(curve_estate > 2)// curvas{
        curve_estate = 1; // curva p
    }
  }
  
  // pintarlo
  void display(PGraphics buffer){
    imageMode(CENTER); 
    buffer.image(sprite, position.x, position.y, 100, 100);
    imageMode(CORNER); // reset image mode
  }
}
