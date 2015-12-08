

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
  
  
/*  int  fluid_size_x = 150;
  int  fluid_size_y = 100;
  
  int  cell_size    = 7;
  int  window_size_x = fluid_size_x  * cell_size + (cell_size * 2);
  int  window_size_y = fluid_size_y  * cell_size + (cell_size * 2);*/
  
  
 
  
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
  
  int[] userList;
  
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
  
  
  //  size(1024, 768, JAVA2D); // for applet export
  //  if ( CPU_GPU == 0 ) size(window_size_x + gui_size_x, window_size_y, GLConstants.GLGRAPHICS);
  //  if ( CPU_GPU == 1 ) size(window_size_x + gui_size_x, window_size_y, JAVA2D);
  
  
    fluid = createFluidSolver(CPU_GPU);
  
    //iniciarGUI();
    frameRate(60);
  
    fluid.setTextureBackgroundColor(255, 255, 255);
  }
  
  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  public void drawScene() {
  
  
    background(0);
  
  
  
    // mouse influence
    // if ( mousePressed && !my_gui.cb_pause.Status().isActive())
    //   fluidInfluence(fluid);
  
  
  
  
  
    // emitters on corners
    float speed = .25f;
    int off = 10;
  //  if( my_gui.cb_emitter1.Status().isActive() ){
      setVel (fluid,               off,               10, 2, 2, speed, speed);   
      setDens(fluid,               off,               10, 2, 2, 23/255f, 153/255f, 204/255f);
  //  }
  //  if( my_gui.cb_emitter2.Status().isActive() ){
      setVel (fluid, window_size_x-off,               10, 2, 2, -speed, speed);
      setDens(fluid, window_size_x-off,               10, 2, 2, 23/255f, 153/255f, 204/255f);
  //  }
  //  if( my_gui.cb_emitter3.Status().isActive() ){
      setVel (fluid, window_size_x-off, window_size_y-10, 2, 2, -speed, -speed);
      setDens(fluid, window_size_x-off, window_size_y-10, 2, 2, 244/255f, 166/255f, 39/255f);
  //  }
  //  if( my_gui.cb_emitter4.Status().isActive() ){
      setVel (fluid,               off, window_size_y-10, 2, 2, speed, -speed);
      setDens(fluid,               off, window_size_y-10, 2, 2, 244/255f, 166/255f, 39/255f);
  //  }
  
  
  
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
  
    // simulate next step
  //  if( !my_gui.cb_pause.Status().isActive() ){
      fluid.update();
  //  }
  
    // visualize
    image(fluid.getDensityMap(), 0, 0);
  //println(frameRate);
  
    context.update();
  
    userList = context.getUsers();
    int userCount = userList.length;
  
    for(int i=0;i<userCount;i++)
    {
      if(context.isTrackingSkeleton(userList[i]))
      {
        stroke(userClr[ (userList[i] - 1) % userClr.length ] );
        drawSkeleton(userList[i]);
      }
    }
  
    if (userCount > 0){
      // Get right hand
      context.getJointPositionSkeleton(userList[userCount - 1], SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      context.convertRealWorldToProjective(rightHand, rightHand2d);
  
      context.getJointPositionSkeleton(userList[userCount - 1], SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
      context.convertRealWorldToProjective(leftHand, leftHand2d);
  
      context.getJointPositionSkeleton(userList[userCount - 1], SimpleOpenNI.SKEL_LEFT_SHOULDER, leftShoulder);
      context.convertRealWorldToProjective(leftShoulder, leftShoulder2d);
  
      fluidInfluence(fluid, rightHand2d, leftHand2d, leftShoulder2d);
    }
  
  }
  
  // draw the skeleton with the selected joints
  void drawSkeleton(int userId)
  {
    // to get the 3d joint data
    /*
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
    println(jointPos);
    */
  
    context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  
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
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
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

}
