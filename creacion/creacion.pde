import SimpleOpenNI.*;

import controlP5.*;
import java.awt.Frame;

// horizon imports

import diewald_fluid.Fluid2D;
import diewald_fluid.Fluid2D_CPU;
import diewald_fluid.Fluid2D_GPU;


int  fluid_size_x = 150;
int  fluid_size_y = 110;
  
int  cell_size    = 7;
int  window_size_x = fluid_size_x  * cell_size + (cell_size * 2);
int  window_size_y = fluid_size_y  * cell_size + (cell_size * 2);
  
int  CPU_GPU        = 1;
PImage output_densityMap;

ControlFrame cf;
SceneManager manager;
boolean stopDraw = false;
SimpleOpenNI  context;

void setup(){
  size(800, 600, P3D);
  cf = addControlFrame("Controladores", 450, 700);
  manager = new SceneManager();
  context = new SimpleOpenNI(this);
}

void draw(){
  if (!stopDraw) manager.actualScene.drawScene();
}
