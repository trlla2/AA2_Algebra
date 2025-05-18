class Obstacle {
  int curve_estate = 1; 
  PVector position;
  float u;
  
  Interpolation_curve first_curve;
  Interpolation_curve second_curve;
  Interpolation_curve third_curve;
  Interpolation_curve forth_curve;
  
  Obstacle(){
     position = new PVector(); 

    
     PVector p[], q[], w[], k[]; // -> u
     p = new PVector[4];
     p[0] = new PVector(200,100); // P0
     p[1] = new PVector(350,300); // P1
     p[2] = new PVector(500,300); // P2
     p[3] = new PVector(650,100); // P3
      
     q = new PVector[4];
     q[0] = new PVector(650,100); //  P0 
     q[1] = new PVector(500,-50); //  P1
     q[2] = new PVector(350,-50); //  P2
     q[3] = new PVector(200,100); // P3
     
     w = new PVector[4];
     w[0] = new PVector(200,100); //  P0
     w[1] = new PVector(350,300); //  P1
     w[2] = new PVector(500,300); //  P2
     w[3] = new PVector(650,100); // P3
     
     k = new PVector[4];
     k[0] = new PVector(650,100); //  P0 
     k[1] = new PVector(500,-50); //  P1
     k[2] = new PVector(350,-50); //  P2
     k[3] = new PVector(200,100);
     
     
     // create the curves
    first_curve = new Interpolation_curve(p);
    second_curve = new Interpolation_curve(q);
    third_curve = new Interpolation_curve(w);
    forth_curve = new Interpolation_curve(k);
    
    // calculate cofs
    first_curve.calculate_coefs();
    second_curve.calculate_coefs();
    third_curve.calculate_coefs();
    forth_curve.calculate_coefs();
    
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
    else if(curve_estate == 3){// w(u)
      position.x = third_curve.coefs[0].x + third_curve.coefs[1].x * u +
        third_curve.coefs[2].x * u * u +
        third_curve.coefs[3].x * u * u * u;
      position.y = third_curve.coefs[0].y + third_curve.coefs[1].y * u +
        third_curve.coefs[2].y * u * u +
        third_curve.coefs[3].y * u * u * u;
    }
    else {// k(u)
      position.x = forth_curve.coefs[0].x + forth_curve.coefs[1].x * u +
        forth_curve.coefs[2].x * u * u +
        forth_curve.coefs[3].x * u * u * u;
      position.y = forth_curve.coefs[0].y + forth_curve.coefs[1].y * u +
        forth_curve.coefs[2].y * u * u +
        forth_curve.coefs[3].y * u * u * u;
    }
    
    u += 0.01;
    if(u >= 1){
      curve_estate ++;
      u = 0;
      if(curve_estate >= 5)// curvas{
        curve_estate = 1; // curva p
    }
  }
  
  // pintarlo
  void display(PGraphics buffer){
    fill(255,255,255);
    rectMode(CENTER);
    buffer.rect(position.x, position.y, 100, 100);
  }
}
