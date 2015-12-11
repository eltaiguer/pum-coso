class Mover
{
  PVector direction;

  float speed;
  float SPEED;

  float noiseScale;
  float noiseStrength;
  float forceStrength;

  Fish f;

  Mover (ColorLib c) {
    setRandomValues (c);
  }

  // SET ---------------------------

  void setRandomValues (ColorLib c)
  {
    float dice = random (100);
    if (dice < 25)  f = new Fish (random (width), random (-400, -80), c);
    else if (dice < 50)  f = new Fish (random (width), random (width + 80, width + 400), c);
    else if (dice < 75)  f = new Fish (random (-400, -80), random(height), c);
    else f = new Fish (random (width+400, width+80), random(height), c);


    float angle = random (TWO_PI);
    direction = new PVector (cos (angle), sin (angle));

    speed = random (4, 7);
    SPEED = speed;
    noiseScale = 80;
    noiseStrength = 1;
    forceStrength = random (0.1, 0.18);
  }

  void setFishSize (float s)
  {
    f.ellipseSize = s;
  }

  // GET --------------------------------

  float getSize ()
  {
    return f.getSize();
  }

  PVector getLocation ()
  {
    return f.getHead();
  }

  // GENEREL ------------------------------

  void update ()
  {
    update (0, 0, new ArrayList <Mover>());
  }

  void update (int mode, int display, ArrayList <Mover> boids)
  {

    if (mode == 0) // noise
    {
      speed = speed * 0.9 + SPEED * 0.1;
      addNoise ();
      seperate(boids);
      move();
      checkEdges ();
    } else if (mode == 1) // seek
    {
      speed = speed * 0.9 + SPEED * 0.1;
      for(int i=0;i<userList.length;i++)
      {      
        if(context.getCoM(userList[i],com))
        {
          context.convertRealWorldToProjective(com,com2d);
         /* int rightHandXMap = int(map(com2d.x, 0, 640, 0, 600));
      int rightHandYMap = int(map(com2d.y, 0, 480, 0, 600));*/
       seek (com2d.x, com2d.y);
        }
       
      }
      seperate(bouncers);
      move();
    } else // radial
    {
      speed = speed * 0.9 + SPEED * 0.1;
      addRadial ();
      seperate(boids);
      move();
      checkEdges();
    } 

    f.setSpeed(speed);
    display(display);
  }

  // seperatate --------------

  void seperate (ArrayList <Mover> boids)
  {
    PVector location = f.getHead();

    PVector other;
    float otherSize ;

    PVector seperationSum = new PVector (0, 0);
    float seperationCount = 0;

    float speedSum = 0;

    //speed = speed * 0.9 + SPEED * 0.1;

    for (int i = 0; i < boids.size (); i++)
    {
      other = boids.get(i).f.getHead();
      otherSize = boids.get(i).f.getSize();

      float distance = PVector.dist (other, location);


      if (distance > 0 && distance < (f.getSize()+otherSize)) // seperate bei collision
      {
        float angle = atan2 (location.y-other.y, location.x-other.x);

        seperationSum.add (cos (angle), sin (angle), 0);
        seperationCount++;
      }

      if (seperationCount > 10) break;
    }

    // seperation: renne nicht in andere hinein

    float angle = direction.heading2D();


    if (seperationCount > 0)
    {
      seperationSum.div (seperationCount);
      seperation (seperationSum, 1+forceStrength);

      float val = abs (angle-direction.heading2D());
      speed *= 1+val*0.2;

      speed = constrain (speed, 0, SPEED * 1.5);
    }
  }
 

  void seperation (PVector force, float strength)
  {
    force.limit (strength*forceStrength);

    direction.add (force);
    direction.normalize();

    //  speed *= 1.1;
    //  speed = constrain (speed, 0, SPEED * 1.5);
  }


  // HOW TO MOVE ----------------------------

  void seek (float x, float y)
  {
    seek (x, y, 1);
  }

  void seek (float x, float y, float strength)
  {
    PVector location = f.getHead();

    float angle = atan2 (y-location.y, x -location.x);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength * strength);

    direction.add (force);
    direction.normalize();
  }

  void addRadial ()
  {

    float angleChange = direction.heading2D();

    PVector location = f.getHead();

    float m = noise ((float)frameCount / (2*80)) * 1.2;
    m = constrain (m, 0, 1);
    m = map (m, 0, 1.2, - 1, 1);
    if (m < 0 && m > -0.2) m =-0.2;
    else if (m >= 0 && m < 0.2) m = 0.2;

    float maxDistance = m * dist (0, 0, width/2, height/2);
    float distance = dist (location.x, location.y, width/2, height/2);

    float angle = map (distance, 0, maxDistance, 0, TWO_PI);

    PVector force = new PVector (cos (angle), sin (angle));
    force.mult (forceStrength);

    direction.add (force);
    direction.normalize();

    float val = abs (angleChange-direction.heading2D());
    speed *= 1+val*0.15;

    speed = constrain (speed, 0, SPEED * 1.2);
  }

  void addNoise ()
  {
    PVector location = f.getHead();

    float noiseValue = noise (location.x /noiseScale, location.y / noiseScale, frameCount / noiseScale);
    noiseValue*= TWO_PI * noiseStrength;

    float angle = direction.heading2D();

    PVector force = new PVector (cos (noiseValue), sin (noiseValue));

    force.mult (forceStrength);
    direction.add (force);
    direction.normalize();

    float val = abs (angle-direction.heading2D());
    speed *= 1+val*0.2;

    speed = constrain (speed, 0, SPEED * 1.5);
  }

  // MOVE -----------------------------------------

  void move ()
  {
    PVector location = f.getHead();

    PVector velocity = direction.get();
    velocity.mult (speed);
    location.add (velocity);

    f.setHead (location);
    f.speed = map (speed, speed, SPEED*1.5, 0.8, 1.5);
    f.speed = constrain (f.speed, 0.8, 1.5);
  }

  // CHECK --------------------------------------------------------

  void checkEdges ()
  {
    PVector location = f.getHead();
    float diameter = f.bodyLength * 1.3;

    if (location.x < -diameter )
    {
      location.x = width+diameter;
      f.setHead (location);
    } else if (location.x > width+diameter)
    {
      location.x = -diameter;
      f.setHead (location);
    }

    if (location.y < -diameter)
    {
      location.y = height+diameter;
      f.setHead (location);
    } else if (location.y > height+diameter)
    {
      location.y = -diameter;
      f.setHead (location);
    }
  }

  // DISPLAY ---------------------------------------------------------------

  void display (int mode)
  {

    if (mode == 0) f.display();
    else if (mode == 1) f.displaySkeleton();
    else f.displayBody();
  }
}

