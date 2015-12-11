/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/330*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/*
Sky Composition
December 18, 2007 - howard winston
http://www.howardwinston.com
email: info@howardwinston.com
create a cloud filled sky based on the sensation of looking up and watching the sky
clouds will slowly take form and change
mouse click to build a new sky and cloud formation
*/

// set sizes, counts, arrays, etc.
int w = 900;
int h = 450;
int halfW = w/2; // use for max x coordinate
int halfH = h/2; // use for max y coordinate
// color info
color skyColorSun = color(60, 135, 245);
color cloudColor = color(220, 250, 255);
// cloud info
float cloudSize = .01; 
int cloudAlpha = 4;
int numOfClouds = 18;
int cloudMovement = 16; // range of movement for cloud within its location
int cloudSharpness = 160; // number of pixels to adjust edges
// arrays to hold cloud point and position info - this is lousy OO design!
int numOfPts = 9;
int cloudBase [][][] = new int [numOfClouds][numOfPts][2]; // base coordinates
int cloudTranslate [][] = new int [numOfClouds][2]; // translate offset for each cloud
PImage sun;
int count = 1;
int trans=0;

class SunCreation implements Scene {
  
  public SunCreation(){}
  
  void closeScene(){}
  
  void initialScene () {
    buildCloudBases();
    buildTranslateArray();
    smooth();
    background(skyColorSun);
    sun = loadImage("sol.png");
  }
  
  void drawScene () {
    if (count<=7000){
      for (int i = 0; i < numOfClouds; i++) {
        cloud(i);
        count++;
      }
    }
  }
  
  public void sunTransition(){
    tint(255, trans);  // Apply transparency without changing color
    image(sun, 50, 0);
    trans++; 
  }  
  
  String getSceneName(){return "SunCreation";};

}


void buildCloudBases () {
  for (int i = 0; i < numOfClouds; i++) {
    // north point
    cloudBase [i][0][0] = halfW;
    cloudBase [i][0][1] = (int) random((0 + cloudSharpness),(halfH));
    // northeast point
    cloudBase [i][1][0] = (int) random((halfW), (w - cloudSharpness));
    cloudBase [i][1][1] = (int) random((0 + cloudSharpness), (halfH));
    // east point
    cloudBase [i][2][0] = (int) random((halfW), (w - cloudSharpness)); 
    cloudBase [i][2][1] = halfH;
    // southeast point
    cloudBase [i][3][0] = (int) random((halfW), (w - cloudSharpness));
    cloudBase [i][3][1] = (int) random((halfH), (h - cloudSharpness));
    // south point
    cloudBase [i][4][0] = halfW;
    cloudBase [i][4][1] = (int) random((halfH), (h - cloudSharpness));
    // southwest point
    cloudBase [i][5][0] = (int) random((0 + cloudSharpness), (halfW));
    cloudBase [i][5][1] = (int) random((halfH), (h - cloudSharpness));
    // west point
    cloudBase [i][6][0] = (int) random((0 + cloudSharpness), (halfW));
    cloudBase [i][6][1] = halfH;
    // northwest point
    cloudBase [i][7][0] = (int) random((0 + cloudSharpness), (halfW));
    cloudBase [i][7][1] = (int) random((0 + cloudSharpness), (halfH));
    // close point
    cloudBase [i][8][0] = halfW;
    cloudBase [i][8][1] = (int) random((0 + cloudSharpness),(halfH));    
  }
  // now reduce by cloud size
  for (int i = 0; i < numOfClouds; i++) {
    for (int j = 0; j < numOfPts; j++) {
      cloudBase [i][j][0] = (int) (cloudBase [i][j][0] * cloudSize);
      cloudBase [i][j][1] = (int) (cloudBase [i][j][1] * cloudSize);
    }   
  }
}

void buildTranslateArray () {
  for (int i = 0; i < numOfClouds; i++) {
    cloudTranslate [i][0] = (int) random(0, w);
    cloudTranslate [i][1] = (int) random(0, h);    
  }
}


void cloud (int cloudNum) {
  // clouds will appear or disappear based on random control
  if ((int) random(0, 2) == 0) {
      fill(skyColorSun, cloudAlpha);
  } else {
    fill(cloudColor, cloudAlpha);
  }
  noStroke();
  smooth();
  pushMatrix();
  if (cloudTranslate [cloudNum][0] > w) {
    cloudTranslate [cloudNum][0] = 0 - cloudSharpness;
  }
  if (cloudTranslate [cloudNum][1] > h) {
    cloudTranslate [cloudNum][1] = 0 - cloudSharpness;
  }
  translate(
    cloudTranslate [cloudNum][0] += (int) random(-cloudMovement, cloudMovement),
    cloudTranslate [cloudNum][1] += (int) random(-cloudMovement, cloudMovement));
  beginShape();
  for (int i = 0; i < numOfPts; i++) {
    curveVertex(
      random(cloudBase [cloudNum][i][0] - cloudSharpness, cloudBase [cloudNum][i][0] + cloudSharpness),
      random(cloudBase [cloudNum][i][1] - cloudSharpness, cloudBase [cloudNum][i][1] + cloudSharpness));
  }
  endShape();
  popMatrix();
}



//void mousePressed() { 
//  tint(255, trans);  // Apply transparency without changing color
//  image(sun, 50, 0);
//  trans++;  
//}



