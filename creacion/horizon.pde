

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/31335*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//------------------------------------------------------------------------------
//
// author: thomas diewald
// date: 27.07.2011
//
// basic fluid examples with gui controlls
//
// interaction: see GUI on right side of application
//
//------------------------------------------------------------------------------

class Horizon implements Scene { 

  //------------------------------------------------------------------------------
  //------------------------------------------------------------------------------
  int  CPU_GPU        = 1; // 0 is GPU, 1 is CPU;
  //------------------------------------------------------------------------------
  //------------------------------------------------------------------------------
  
  
  Fluid2D fluid;
 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  
  PVector com = new PVector();
  PVector com2d = new PVector();
  
  PVector rightHand = new PVector();
  PVector rightHand2d = new PVector();
  
  PVector leftHand = new PVector();
  PVector leftHand2d = new PVector();
  
  PVector leftShoulder = new PVector();
  PVector leftShoulder2d = new PVector();
  
  
  color[]       userClr = new color[]{ color(255,0,0),
                                       color(0,255,0),
                                       color(0,0,255),
                                       color(255,255,0),
                                       color(255,0,255),
                                       color(0,255,255)
                                     };
  
  
  
  public Horizon(){}

  void closeScene(){}

  String getSceneName(){return "Horizon";}

  
  void initialScene() {
    background(255,255,255);
    
    println(window_size_x);
    println(window_size_y);
 

   /* if(context.isInit() == false)
    {
       println("Can't init SimpleOpenNI, maybe the camera is not connected!");
       exit();
       return;
    }*/
  
    // enable depthMap generation
    context.enableDepth();
  
    // enable skeleton generation for all joints
    context.enableUser();

    fluid = createFluidSolver(CPU_GPU);

    frameRate(60);
  
    fluid.setTextureBackgroundColor(255, 255, 255);
  }
  
  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void drawScene() {  
  
    background(0);
  
    // emitters on corners
    float speed = .25f;
    int off = 10;
  
    setVel (fluid,               off,              7, 2, 2, speed, speed);   
    setDens(fluid,               off,               7, 2, 2, 23/255f, 153/255f, 204/255f);

    setVel (fluid, window_size_x-off,               10, 2, 2, -speed, speed);
    setDens(fluid, window_size_x-off,               10, 2, 2, 23/255f, 153/255f, 204/255f);

    setVel (fluid, window_size_x-off, window_size_y-10, 2, 2, -speed, -speed);
    setDens(fluid, window_size_x-off, window_size_y-10, 2, 2, 244/255f, 166/255f, 39/255f);

    setVel (fluid,               off, window_size_y-10, 2, 2, speed, -speed);
    setDens(fluid,               off, window_size_y-10, 2, 2, 244/255f, 166/255f, 39/255f);
  
    // fluid parameters
    fluid.setParam_Timestep          (       27 *.005 );
    fluid.setParam_Iterations        ( (int) 6 );
    fluid.setParam_IterationsDiffuse ( (int) 5 );
    fluid.setParam_Viscosity         (       0 * .0000005 );
    fluid.setParam_Diffusion         (       0 * .00000005 );
    fluid.setParam_Vorticity         (       20 * .1  );
  
  
    fluid.processViscosity   ( (0 > 1) );
    fluid.processDiffusion   ( (6 > 1) );
    fluid.processVorticity   ( (20 > 1) );
  
  
    // smooth output
    fluid.smoothDensityMap(true);
    fluid.update();
 
  
    // visualize
    image(fluid.getDensityMap(), 0, 0);
 
    context.update();
  
    int[] userList = context.getUsers();
    int userCount = userList.length;
  
    for(int i=0;i<userCount;i++)
    {
      if(context.isTrackingSkeleton(userList[i]))
      {
        stroke(userClr[ (userList[i]) % userClr.length ] );
        drawSkeleton(userList[i]);
        
        // Get right hand
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
        context.convertRealWorldToProjective(rightHand, rightHand2d);
    
        context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
        context.convertRealWorldToProjective(leftHand, leftHand2d);
    
        fluidInfluence(fluid, rightHand2d, leftHand2d);
      }
    }  
  } 
}
