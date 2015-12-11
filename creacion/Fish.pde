/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/174099*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

/*----------------------------------
 
 Copyright by Diana Lange 2014
 Don't use without any permission. Creative Commons: Attribution Non-Commercial.
 
 Versions:
 08.09.2014: https://vimeo.com/102836577
 30.11.2014: https://vimeo.com/113223673
 
 mail: kontakt@diana-lange.de
 web: diana-lange.de
 facebook: https://www.facebook.com/DianaLangeDesign
 flickr: http://www.flickr.com/photos/dianalange/collections/
 tumblr: http://dianalange.tumblr.com/
 twitter: http://twitter.com/DianaOnTheRoad
 vimeo: https://vimeo.com/dianalange/videos
 
 -----------------------------------*/


// Colors for fish
color[] c2 = { 
  #EFF0EC, #398EAD, #B1CBCC, #D6AD99, #CD4F47, #188A8E, #51BBB2, #D2D7BE, #E8DBC5
};

// color for background
color[] c2_BG = {
  #2D4C60
};


ArrayList <Mover> bouncers;

ColorLib fishColors = new ColorLib(c2);
ColorLib backgroundColors = new ColorLib(c2_BG);


int bewegungsModus = 3; // 1 = NOISE // 2 = STEER // 4 = RADIAL
int displayMode = 0; // 0 = fish // 1 = skeleton // 2 = body

class Fishes implements Scene {

  
  public Fishes(){}
  
  String getSceneName(){return "Fishes";}
  
  void closeScene(){}
  
  void initialScene ()
  {
    smooth();
  
    bouncers = new ArrayList ();
  
    for (int i = 0; i < 60; i++)
    {
      Mover newMover = new Mover(fishColors);
      bouncers.add (newMover);
    }  
    
  }
  
  void drawScene () {
    background (backgroundColors.getColor());
  
    for (Mover m : bouncers) {
      m.update (bewegungsModus, displayMode, bouncers);
    }
  }
}


class ColorLib {
  color[] c;
  ArrayList <ColorComp> combinations = new ArrayList();
  ArrayList <Integer> ids = new ArrayList();

  int duoStart = 0;
  float percantageOfMonoColored = 20;

  ColorLib(color[] c) {
    this.c = c;

    setColorCombinations();
    setIDs();
  }

  Integer getRandomIndex () {
    Integer i = new Integer (0);
    float dice = random (100);
    if (dice < percantageOfMonoColored) i = ids.get ((int) random (1, duoStart));
    else i = ids.get ((int) random (duoStart, combinations.size()));
    return i;
  }

  color getColor () {
    return getColor(0);
  }

  color getColor(int id) {
    id = constrain (id, 0, ids.size()-1);
    return combinations.get(id).getColor() [0];
  }

  color[] getColorAtID(int id) {
    id = constrain (id, 0, ids.size()-1);

    return combinations.get(id).getColor();
  }

  void setIDs () {
    for (int i = 0; i < combinations.size (); i++) {
      ids.add (new Integer(i));
    }
  }

  void setColorCombinations () {


    // MONOCOLO
    for (color ct : c) {
      combinations.add(new  ColorComp (ct));
    }

    duoStart += combinations.size();

    // DUO 
    for (int i = 1; i < c.length; i++) {
      for (int j = i + 1; j < c.length; j++) {
        combinations.add(new ColorComp (c[i], c[j]));
      }
    }


    for (int i = c.length-1; i > 0; i--) {
      for (int j = i-1; j > 0; j--) {
        combinations.add(new ColorComp (c[i], c[j]));
      }
    }
  }
}

class ColorComp {
  color[] c = new color [2];

  ColorComp (color c) {
    this.c[0] = c;
    this.c[1] = c;
  }

  ColorComp (color c1, color c2) {
    c[0] = c1;
    c[1] = c2;
  }

  color[] getColor () {
    return c;
  }
}

class Fish
{
  float ellipseSize;
  float [] angles;

  PVector head;
  PVector tail;
  float bodyLength;
  float rVal;
  float speed;


  ColorLib c;
  Integer colorID;

  Fish (float x, float y, ColorLib c)
  {
    float dice = random (100);
    bodyLength = dice < 60 ? random (30, 50): random (50, 100);
    rVal = 0;

    angles = new float [(int)map (bodyLength, 30, 100, 5, 20)];
    angles [0] = 0;

    head = new PVector (x, y);
    tail = head.get();

    for (int i = 1; i < angles.length; i++)
    {
      angles [i] = 0;
    }
    speed = 1;

    this.c = c;
    colorID = c.getRandomIndex(); 
    ellipseSize = bodyLength / 4;
  }


  float getSize ()
  {
    return ellipseSize;
  }

  PVector getHead ()
  {
    return head.get();
  }

  PVector getTail ()
  {
    return tail.get();
  }

  void setHead (PVector pos)
  {
    PVector tempLocation = head.get();
    head = pos.get();


    angles [angles.length-1] = atan2 ( tempLocation.y-head.y, tempLocation.x- head.x);

    updateBody ();
  }

  void setSpeed (float speed) {
    this.speed = speed;
  }

  void resetBody ()
  {
  }

  // HELPERS ---------------

  void updateBody ()
  {
    for (int i = 0; i < angles.length-1; i++)
    {
      angles [i] = angles [i+1];

      angles [i]  += (cos ((bodyLength+frameCount/ ( map (bodyLength, 30, 100, 5, 3) / constrain (speed, 3, 7))+i)*TWO_PI / angles.length)*map (bodyLength, 30, 100, 0.1, 0.07));
    }
  }

  // DISPLAY --------------------

  void display () {
    displayFish();
  }

  void displayFish() {
    stroke (c.getColor(0));
    noFill();

    PVector startPos = head.get();
    PVector endPos = startPos.get();
    float steps = bodyLength / angles.length;
    float angle = 0;

    color ct;
    float sw, s;

    int flossenID = round (angles.length-1-angles.length*0.1);

    for (int i = angles.length-1; i >= 0; i--)
    {


      stroke (c.getColor(0));
      noFill();

      endPos.x = startPos.x + cos (angles [i])*steps;
      endPos.y = startPos.y + sin (angles [i])*steps;  

      strokeWeight (1);

      if (i == 0) {  // endflosse 
        endPos.x = startPos.x + cos (angles [i])*bodyLength*0.25;
        endPos.y = startPos.y + sin (angles [i])*bodyLength*0.25;

        line (startPos.x, startPos.y, endPos.x, endPos.y);

        float controlOneX = lerp (startPos.x, endPos.x, 0.5) + cos (angles [i] + PI/2) * PVector.dist (startPos, endPos) *0.2;
        float controlOneY = lerp (startPos.y, endPos.y, 0.5) + sin (angles [i] + PI/2) * PVector.dist (startPos, endPos) *0.2;

        float controlTwoX = lerp (startPos.x, endPos.x, 0.5) + cos (angles [i] - PI/2) * PVector.dist (startPos, endPos) *0.2;
        float controlTwoY = lerp (startPos.y, endPos.y, 0.5) + sin (angles [i] - PI/2) * PVector.dist (startPos, endPos) *0.2;

        noFill();
        beginShape();
        curveVertex (startPos.x, startPos.y);
        curveVertex (startPos.x, startPos.y);
        curveVertex (controlOneX, controlOneY);
        curveVertex (endPos.x, endPos.y);
        curveVertex (endPos.x, endPos.y);
        curveVertex (controlTwoX, controlTwoY);
        curveVertex (startPos.x, startPos.y);
        curveVertex (startPos.x, startPos.y);
        endShape (CLOSE);
      }

      s = pow (i, 2);
      s = map (s, 0, pow (angles.length-1, 2), 1, ellipseSize-1);

      if (i >=  angles.length-1) { // Eyes
        strokeWeight (ellipseSize*0.4);

        point (startPos.x + cos (angles [i]+PI*0.65)*s/2, startPos.y + sin (angles [i]+PI*0.65)*s/2);
        point (startPos.x + cos (angles [i]-PI*0.65)*s/2, startPos.y + sin (angles [i]-PI*0.65)*s/2);


        strokeWeight (1);
      }

      if (i == flossenID) {
        float flossenWinkel = 0.10;

        float startOneX = startPos.x + cos (angles [i]+PI/2)*s/2;
        float startOneY = startPos.y + sin (angles [i]+PI/2)*s/2;

        float endFlosseOneX = startOneX + cos (angles [i]+PI*flossenWinkel)*bodyLength*0.3;
        float endFlosseOneY = startOneY + sin (angles [i]+PI*flossenWinkel)*bodyLength*0.3;

        float controlOne_1X = lerp (startOneX, endFlosseOneX, 0.8) + cos (angles [i]+PI*flossenWinkel+PI/2) * bodyLength*0.05;
        float controlOne_1Y = lerp (startOneY, endFlosseOneY, 0.8) + sin (angles [i]+PI*flossenWinkel+PI/2) * bodyLength*0.05;

        float controlOne_2X = lerp (startOneX, endFlosseOneX, 0.8) + cos (angles [i]+PI*flossenWinkel-PI/2) * bodyLength*0.05;
        float controlOne_2Y = lerp (startOneY, endFlosseOneY, 0.8) + sin (angles [i]+PI*flossenWinkel-PI/2) * bodyLength*0.05;

        float startTwoX = startPos.x + cos (angles [i]-PI/2)*s/2;
        float startTwoY = startPos.y + sin (angles [i]-PI/2)*s/2;

        float endFlosseTwoX = startTwoX + cos (angles [i]-PI*flossenWinkel)*bodyLength*0.3;
        float endFlosseTwoY = startTwoY + sin (angles [i]-PI*flossenWinkel)*bodyLength*0.3;

        float controlTwo_1X = lerp (startTwoX, endFlosseTwoX, 0.8) + cos (angles [i]-PI*flossenWinkel+PI/2) * bodyLength*0.05;
        float controlTwo_1Y = lerp (startTwoY, endFlosseTwoY, 0.8) + sin (angles [i]-PI*flossenWinkel+PI/2) * bodyLength*0.05;

        float controlTwo_2X = lerp (startTwoX, endFlosseTwoX, 0.8) + cos (angles [i]-PI*flossenWinkel-PI/2) * bodyLength*0.05;
        float controlTwo_2Y = lerp (startTwoY, endFlosseTwoY, 0.8) + sin (angles [i]-PI*flossenWinkel-PI/2) * bodyLength*0.05;

        line (startOneX, startOneY, endFlosseOneX, endFlosseOneY );
        line (startTwoX, startTwoY, endFlosseTwoX, endFlosseTwoY );


        noFill();
        beginShape();
        curveVertex (startOneX, startOneY);
        curveVertex (startOneX, startOneY);
        curveVertex (controlOne_1X, controlOne_1Y);
        curveVertex (endFlosseOneX, endFlosseOneY);
        curveVertex (controlOne_2X, controlOne_2Y);
        curveVertex (startOneX, startOneY);
        curveVertex (startOneX, startOneY);
        endShape (CLOSE);

        beginShape();
        curveVertex (startTwoX, startTwoY);
        curveVertex (startTwoX, startTwoY);
        curveVertex (controlTwo_1X, controlTwo_1Y);
        curveVertex (endFlosseTwoX, endFlosseTwoY);
        curveVertex (controlTwo_2X, controlTwo_2Y);
        curveVertex (startTwoX, startTwoY);
        curveVertex (startTwoX, startTwoY);
        endShape (CLOSE);
      }


      // BODY 

      ct = lerpColor (c.getColorAtID(colorID) [0], c.getColorAtID(colorID) [1], map (i, 0, angles.length, 1, 0 ) );
      s = pow (i, 2);
      s = map (s, 0, pow (angles.length-1, 2), 1, ellipseSize-1);

      stroke (ct);
      strokeWeight (abs (s));
      line (startPos.x, startPos.y, endPos.x, endPos.y);

      startPos = endPos.get();
    }

    tail.x = startPos.x + cos (angles [0])*steps;
    tail.y = startPos.y + cos (angles [0])*steps;
  }

  void displayBody ()
  {
    PVector startPos = head.get();
    PVector endPos = startPos.get();
    float steps = bodyLength / angles.length;
    float angle = 0;

    float s;
    color ct;

    noStroke();
    for (int i = angles.length-1; i > 0; i--)
    {
      endPos.x = startPos.x + cos (angles [i])*steps;
      endPos.y = startPos.y + sin (angles [i])*steps;  

      ct = lerpColor (c.getColorAtID(colorID) [0], c.getColorAtID(colorID) [1], map (i, 0, angles.length, 1, 0 ) );
      s = pow (i, 2);
      s = map (s, 0, pow (angles.length-1, 2), 1, ellipseSize-1);


      stroke (ct);
      strokeWeight (abs (s));
      line (startPos.x, startPos.y, endPos.x, endPos.y);

      startPos = endPos.get();
    }

    tail.x = startPos.x + cos (angles [0])*steps;
    tail.y = startPos.y + cos (angles [0])*steps;
  }

  void displaySkeleton ()
  {
    stroke (255);
    noFill();

    PVector startPos = head.get();
    PVector endPos = startPos.get();
    float steps = bodyLength / angles.length;
    float angle = 0;

    strokeWeight (ellipseSize);
    point (head.x, head.y);

    int flossenID = round (angles.length-1-angles.length*0.1);
    float s;

    for (int i = angles.length-1; i >= 0; i--)
    {
      endPos.x = startPos.x + cos (angles [i])*steps;
      endPos.y = startPos.y + sin (angles [i])*steps;  

      strokeWeight (1);

      if (i != 0) //  spinal
      {
        line (startPos.x, startPos.y, endPos.x, endPos.y);
      } else // endflosse
      {
        endPos.x = startPos.x + cos (angles [i])*bodyLength*0.25;
        endPos.y = startPos.y + sin (angles [i])*bodyLength*0.25;

        line (startPos.x, startPos.y, endPos.x, endPos.y);

        float controlOneX = lerp (startPos.x, endPos.x, 0.5) + cos (angles [i] + PI/2) * PVector.dist (startPos, endPos) *0.2;
        float controlOneY = lerp (startPos.y, endPos.y, 0.5) + sin (angles [i] + PI/2) * PVector.dist (startPos, endPos) *0.2;

        float controlTwoX = lerp (startPos.x, endPos.x, 0.5) + cos (angles [i] - PI/2) * PVector.dist (startPos, endPos) *0.2;
        float controlTwoY = lerp (startPos.y, endPos.y, 0.5) + sin (angles [i] - PI/2) * PVector.dist (startPos, endPos) *0.2;

        noFill();
        beginShape();
        curveVertex (startPos.x, startPos.y);
        curveVertex (startPos.x, startPos.y);
        curveVertex (controlOneX, controlOneY);
        curveVertex (endPos.x, endPos.y);
        curveVertex (endPos.x, endPos.y);
        curveVertex (controlTwoX, controlTwoY);
        curveVertex (startPos.x, startPos.y);
        curveVertex (startPos.x, startPos.y);
        endShape (CLOSE);
      }

      s = pow (i, 2);
      s = map (s, 0, pow (angles.length-1, 2), 1, ellipseSize-1);

      if (i <  angles.length-1) // Rippen
      {

        line (startPos.x, startPos.y, startPos.x + cos (angles [i]+PI/2)*s/2, startPos.y + sin (angles [i]+PI/2)*s/2);
        line (startPos.x, startPos.y, startPos.x + cos (angles [i]-PI/2)*s/2, startPos.y + sin (angles [i]-PI/2)*s/2);
      } else {  // Augen 
        strokeWeight (ellipseSize*0.4);

        point (startPos.x + cos (angles [i]+PI*0.65)*s/2, startPos.y + sin (angles [i]+PI*0.65)*s/2);
        point (startPos.x + cos (angles [i]-PI*0.65)*s/2, startPos.y + sin (angles [i]-PI*0.65)*s/2);

        strokeWeight (1);
      }

      if (i == flossenID)
      {
        float flossenWinkel = 0.10;

        float startOneX = startPos.x + cos (angles [i]+PI/2)*s/2;
        float startOneY = startPos.y + sin (angles [i]+PI/2)*s/2;

        float endFlosseOneX = startOneX + cos (angles [i]+PI*flossenWinkel)*bodyLength*0.3;
        float endFlosseOneY = startOneY + sin (angles [i]+PI*flossenWinkel)*bodyLength*0.3;

        float controlOne_1X = lerp (startOneX, endFlosseOneX, 0.8) + cos (angles [i]+PI*flossenWinkel+PI/2) * bodyLength*0.05;
        float controlOne_1Y = lerp (startOneY, endFlosseOneY, 0.8) + sin (angles [i]+PI*flossenWinkel+PI/2) * bodyLength*0.05;

        float controlOne_2X = lerp (startOneX, endFlosseOneX, 0.8) + cos (angles [i]+PI*flossenWinkel-PI/2) * bodyLength*0.05;
        float controlOne_2Y = lerp (startOneY, endFlosseOneY, 0.8) + sin (angles [i]+PI*flossenWinkel-PI/2) * bodyLength*0.05;

        float startTwoX = startPos.x + cos (angles [i]-PI/2)*s/2;
        float startTwoY = startPos.y + sin (angles [i]-PI/2)*s/2;

        float endFlosseTwoX = startTwoX + cos (angles [i]-PI*flossenWinkel)*bodyLength*0.3;
        float endFlosseTwoY = startTwoY + sin (angles [i]-PI*flossenWinkel)*bodyLength*0.3;

        float controlTwo_1X = lerp (startTwoX, endFlosseTwoX, 0.8) + cos (angles [i]-PI*flossenWinkel+PI/2) * bodyLength*0.05;
        float controlTwo_1Y = lerp (startTwoY, endFlosseTwoY, 0.8) + sin (angles [i]-PI*flossenWinkel+PI/2) * bodyLength*0.05;

        float controlTwo_2X = lerp (startTwoX, endFlosseTwoX, 0.8) + cos (angles [i]-PI*flossenWinkel-PI/2) * bodyLength*0.05;
        float controlTwo_2Y = lerp (startTwoY, endFlosseTwoY, 0.8) + sin (angles [i]-PI*flossenWinkel-PI/2) * bodyLength*0.05;

        line (startOneX, startOneY, endFlosseOneX, endFlosseOneY );
        line (startTwoX, startTwoY, endFlosseTwoX, endFlosseTwoY );

        noFill();
        beginShape();
        curveVertex (startOneX, startOneY);
        curveVertex (startOneX, startOneY);
        curveVertex (controlOne_1X, controlOne_1Y);
        curveVertex (endFlosseOneX, endFlosseOneY);
        curveVertex (controlOne_2X, controlOne_2Y);
        curveVertex (startOneX, startOneY);
        curveVertex (startOneX, startOneY);
        endShape (CLOSE);

        beginShape();
        curveVertex (startTwoX, startTwoY);
        curveVertex (startTwoX, startTwoY);
        curveVertex (controlTwo_1X, controlTwo_1Y);
        curveVertex (endFlosseTwoX, endFlosseTwoY);
        curveVertex (controlTwo_2X, controlTwo_2Y);
        curveVertex (startTwoX, startTwoY);
        curveVertex (startTwoX, startTwoY);
        endShape (CLOSE);
      }


      if (i != 0)
      {
        strokeWeight (4);
        point (endPos.x, endPos.y);
      }

      startPos = endPos.get();
    }

    tail.x = startPos.x + cos (angles [0])*steps;
    tail.y = startPos.y + cos (angles [0])*steps;
  }
}

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
      seek (mouseX, mouseY);
      
       
      
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


/*void displayMode()
{
  if (key == '+') displayMode = (displayMode + 1) > 2 ? 0 : ++displayMode;
  if (key == ' ') bewegungsModus = (bewegungsModus + 1) > 2 ? 0 : ++bewegungsModus;

}


void dis ()
{
  bewegungsModus = (bewegungsModus + 1) > 2 ? 0 : ++bewegungsModus;
}*/


