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

