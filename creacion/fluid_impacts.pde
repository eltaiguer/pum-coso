

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*public void keyPressed() {
  if( online && key == ESC) key = 0;
}*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// createFluidSolver();
//
Fluid2D createFluidSolver(int type) {
  Fluid2D fluid_tmp = null;

  if ( type == 0) fluid_tmp = new Fluid2D_GPU(this, fluid_size_x, fluid_size_y);
  if ( type == 1) fluid_tmp = new Fluid2D_CPU(this, fluid_size_x, fluid_size_y);

  fluid_tmp.setParam_Timestep  ( 0.10f );
  fluid_tmp.setParam_Iterations( 8 );
  fluid_tmp.setParam_IterationsDiffuse(1);
  fluid_tmp.setParam_Viscosity ( 0.00000000f );
  fluid_tmp.setParam_Diffusion ( 0.000001f );
  fluid_tmp.setParam_Vorticity ( 2.0f );
  fluid_tmp.processDensityMap  ( true );
  fluid_tmp.processDiffusion   ( true );
  fluid_tmp.processViscosity   ( true );
  fluid_tmp.processVorticity   ( true );
  fluid_tmp.setObjectsColor    (1, 1, 1, 1);

  output_densityMap    = createImage(window_size_x, window_size_y, RGB);
  fluid_tmp.setDensityMap(output_densityMap);
  return fluid_tmp;
}




/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fluidInfluence();
//
public void fluidInfluence( Fluid2D fluid2d, PVector rightHand2d, PVector leftHand2d) {
  
    int rightHandXMap = int(map(rightHand2d.x, 0, kWidth, 0, width));
    int rightHandYMap = int(map(rightHand2d.y, 0, kHeight, 0, height));

    int leftHandXMap = int(map(leftHand2d.x, 0, kWidth, 0, width));
    int leftHandYMap = int(map(leftHand2d.y, 0, kHeight, 0, height));
  
       
    int size = 2;
    int xpos = (int)(rightHandXMap/(float)cell_size) + size/2;
    int ypos = (int)(rightHandYMap/(float)cell_size) + size/2;

    int xposLeft = (int)(leftHandXMap/(float)cell_size) + size/2;
    int yposLeft = (int)(leftHandYMap/(float)cell_size) + size/2;
    println("ypos: " + ypos);
    if ((ypos<=60 && ypos >= 20) || (yposLeft<=60 && yposLeft >= 20)) {
     
      addObject(fluid2d, xpos, 40, 5, 1, 0);
      addObject(fluid2d, xposLeft, 40, 5, 1, 0);
      
    }
    
    
}

public void mouseInfluence(Fluid2D fluid2d){
  println(mouseX);
    
     int ypos = (int)(mouseY/(float)cell_size) - 1;
      if (ypos<=60 && ypos >= 20){
        
        int xpos = (int)(mouseX/(float)cell_size) - 1;      
        println("ypos: " + ypos);
        println("xpos: " + xpos);
        addObject(fluid2d, xpos, 40, 2, 2, 0);
      }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// setDens();
//
void setDens(Fluid2D fluid2d, int x, int y, int sizex, int sizey, float r, float g, float b) {
  for (int y1 = 0; y1 < sizey; y1++) {
    for (int x1 = 0; x1 < sizex; x1++) {
      int xpos = (int)(x/(float)cell_size) + x1 - sizex/2;
      int ypos = (int)(y/(float)cell_size) + y1 - sizey/2;
      fluid2d.addDensity(0, xpos, ypos, r);
      fluid2d.addDensity(1, xpos, ypos, g);
      fluid2d.addDensity(2, xpos, ypos, b);
    }
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// setVel();
//
void setVel(Fluid2D fluid2d, int x, int y, int sizex, int sizey, float velx, float vely) {
  for (int y1 = 0; y1 < sizey; y1++) {
    for (int x1 = 0; x1 < sizex; x1++) {
      int xpos = (int)((x/(float)cell_size)) + x1 - sizex/2;
      int ypos = (int)((y/(float)cell_size)) + y1 - sizey/2;
      fluid2d.addVelocity(xpos, ypos, velx, vely);
    }
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// addObject();
//
public void addObject(Fluid2D fluid2d, int posx, int posy, int sizex, int sizey, int mode) {
  int offset = 0;
  int xlow = posx;
  int xhig = posx + sizex;
  int ylow = posy;
  int yhig = posy;

  for (int x = xlow-offset ; x < xhig+offset ; x++) {
    for (int y = ylow-offset ; y <= yhig+offset ; y++) {
      if ( x < 0 || x >= fluid2d.getSizeXTotal() || y < 0 )//|| y >= fluid2d.getSizeYTotal() )
        continue;
      if ( mode == 0) fluid2d.addObject(x, y);
      if ( mode == 1) fluid2d.removeObject(x, y);
    }
  }
}
