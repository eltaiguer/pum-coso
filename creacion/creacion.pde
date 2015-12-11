import SimpleOpenNI.*;

import controlP5.*;
import java.awt.Frame;

// horizon imports

import diewald_fluid.Fluid2D;
import diewald_fluid.Fluid2D_CPU;
import diewald_fluid.Fluid2D_GPU;


int kWidth  = 640;
int kHeight = 480;

int  fluid_size_x = 150;
int  fluid_size_y = 110;
  
int  cell_size    = 7;

int  window_size_x = 940;
int  window_size_y = 700;
  
int  CPU_GPU        = 1;
PImage output_densityMap;

ControlFrame cf;
SceneManager manager;
boolean stopDraw = false;
SimpleOpenNI  context;

void setup(){
  size(800, 600, P2D);
  cf = addControlFrame("Controladores", 450, 700);
  manager = new SceneManager(); 
  context = new SimpleOpenNI(this); 
}

void draw(){
  if (!stopDraw) manager.actualScene.drawScene();
}

void onNewUser(SimpleOpenNI curContext, int userId)
  {
    println("onNewUser - userId: " + userId);
    println("\tstart tracking skeleton");
  
    curContext.startTrackingSkeleton(userId);
  }
  
  void onLostUser(SimpleOpenNI curContext, int userId)
  {
    println("onLostUser - userId: " + userId);
  }
  
  // draw the skeleton with the selected joints
  void drawSkeleton(int userId)
  {
      
    /*context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);*/
  }
  
  void mouseClicked(){
    Scene current = manager.actualScene;
    String name = current.getSceneName();
    if ( name == "TreesInWind"){    
      generateBranches();
      windDirection = random(TWO_PI);
      redrawTrees();
    }
    println("name " + name);
    if (name == "MoonStars"){
      println("sabe");
      ((MoonStars)current).addStar();
    }
  }
  
  void keyPressed(){
    Scene current = manager.actualScene;
    String name = current.getSceneName();
    if (key == CODED) {
      if (keyCode == LEFT) {
        windDirection = 0;
        windVelocity = -4;
      } else if (keyCode == RIGHT) {
        windDirection = TWO_PI;
        windVelocity = 4;
      }
      else if (keyCode == UP) {
        windDirection = 0;
        windVelocity = 0;
      }     
     // redrawTrees();
    }
    else if (keyCode == ' '){
        if (name == "Animals"){
          println("sabe");
          ((Animals)current).changeRace();
        }
        
        if (name == "SunCreation"){
          ((SunCreation)current).sunTransition();
        }
       
        if (name == "MoonStars"){
          println("sabe");
          ((MoonStars)current).addStar();
        }
    }         
      
  }
  
  

