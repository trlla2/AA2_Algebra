class Interpolation_curve{
  PVector[] ctrl_points;
  PVector[] coefs;
  
  
  // Constructor
  Interpolation_curve(PVector[] p){
    ctrl_points = new PVector[4];
    coefs = new PVector[4];
    
    // Initialize points
    for(int i=0;i<4;i++){
      ctrl_points[i]=new PVector(0.0,0.0);
      coefs[i]=new PVector(0.0,0.0);
      ctrl_points[i]=p[i];
    }
  }
  void calculate_coefs(){
    //C0 = P0;
    coefs[0].x = ctrl_points[0].x;
    coefs[0].y = ctrl_points[0].y;
    //C1 = -5.5P0+0P1+4.5P2+P3
    coefs[1].x = -5.5*ctrl_points[0].x + 9.0 * ctrl_points[1].x -4.5* ctrl_points[2].x + ctrl_points[3].x;
    coefs[1].y = -5.5*ctrl_points[0].y + 9.0 * ctrl_points[1].y -4.5* ctrl_points[2].y + ctrl_points[3].y;
    //C2 =  9P0 -22.5P1 + 18P2 -4.5P3
    coefs[2].x = 9*ctrl_points[0].x - 22.5*ctrl_points[1].x + 18*ctrl_points[2].x -4.5*ctrl_points[3].x;
    coefs[2].y = 9*ctrl_points[0].y - 22.5*ctrl_points[1].y + 18*ctrl_points[2].y -4.5*ctrl_points[3].y;
    //C3 = -4.5P0+ 13.5P1 -13.5P2 +4.5P3
    coefs[3].x = -4.5*ctrl_points[0].x + 13.5*ctrl_points[1].x - 13.5*ctrl_points[2].x + 4.5*ctrl_points[3].x;
    coefs[3].y = -4.5*ctrl_points[0].y + 13.5*ctrl_points[1].y - 13.5*ctrl_points[2].y + 4.5*ctrl_points[3].y;
  }
  
  
}
