branch[] branches;
int nTrees = 3; //the number of trees

float transparency = 150;
color leafColor = color(5,113,3,transparency);
color veinColor = color(5,113,3,transparency/2);
color branchColor = color(30);
//color skyColor = color(211,211,255);
color skyColor = color(42,138,201);


//branch controls

int nSegments;
float totalBranchLength;
float maxBranchThickness;
float minBranchThickness; 
float minSpawnDistance; //this controls how far the branch will grow before splitting
float branchSpawnOdds;   //the odds of a branch growing there
float branchSpawnOddsOfSecond; //odds of a second branch growing from the same node
float mindThetaSplit;
float maxdThetaSplit;
float maxdThetaWander;
float dBranchSize; //the new branch may change by 1.0+/- this amount

//leaf controls
float minLength; //leaf length
float maxLength; //leaf length
float minWidth;  //leaf width as a factor of length
float maxWidth;  //leaf width as a factor of length
float maxBranchSizeForLeaves;
float leafSpawnOdds;



boolean pauseWind = false;
boolean drawWind = false;
boolean drawVeins = false;
boolean blackLeaves = false;
boolean drawLeaves = true;


class TreesInWind implements Scene{
 

  public TreesInWind(){ }

  void closeScene(){}
  void initialScene(){
    
        
    smooth();
    noStroke();
    
    initializeTreeValues();
    
    windDirection = 0;
    windVelocity = 0;
    defineLeafOutline();
    defineVeins();
    
    
    
    generateBranches();
    
    redrawTrees();
    
    
  }

  void drawScene(){
    

    
    if(!pauseWind){
    updateWind();
    
    //move in the wind!
    for(int i = 0; i<nTrees; i++)
      branches[i].rotateDueToWind();
     
    redrawTrees();
    
    //draw the wind line
    if(drawWind)
      drawWindLine();
    }
    
  }
  
  void initializeTreeValues(){
    pauseWind = false;
    drawWind = false;
    drawVeins = false;
    blackLeaves = false;
    drawLeaves = true;
    //branch
    nSegments = 10;
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2; 
    minSpawnDistance = .2;
    branchSpawnOdds = .8; 
    branchSpawnOddsOfSecond = 0;
    mindThetaSplit = PI*.1;
    maxdThetaSplit = PI*.3;
    maxdThetaWander = PI/20;
    dBranchSize = .2;
    //leaves
    minLength = 10;
    maxLength = 30;
    minWidth = .4;
    maxWidth = .5;
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .7;
    generateBranches(); 
  }

  String getSceneName(){return "TreesInWind";};  

}


/*void mouseClicked(){
    generateBranches();
    windDirection = random(TWO_PI);
    redrawTrees();
  }
  
  void keyPressed(){
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
  }*/


void generateBranches(){
  println("generate");
  branches = new branch[nTrees];
  println("generate 2");
  for(int i = 0; i<nTrees; i++)
    branches[i] = new branch(-1,3*PI/2, totalBranchLength, maxBranchThickness);
}


class branch{
  float x, y, theta, startingThickness;
  float theta0;
  float[] thetas;
  int index = -1; //this tells what segment the branch has spawned at.
              // if it's -1, it's the root.
  float segmentLength;
  ArrayList myChildren;
  ArrayList myLeaves;
  
  //this one's to generate a parent branch!
  branch(int index0, float thetaI, float totalLength, 
             float startingThickness0){
    index = index0;
    myChildren = new ArrayList();
    myLeaves = new ArrayList();
    segmentLength = totalLength/nSegments;
    startingThickness = startingThickness0;
    
    theta0 = thetaI;
    thetas = new float[nSegments]; //r,theta
    thetas[0] = theta0;
    for(int i=1; i<nSegments; i++){
      thetas[i] = thetas[i-1]+random(-maxdThetaWander,maxdThetaWander);
    }
    
    //this'll spawn the baby branches!
    for(int i=1; i<nSegments; i++){
      if(startingThickness*(1-(float)i/nSegments)> minBranchThickness &&
         (float)i/nSegments > minSpawnDistance &&
          random(1) <= branchSpawnOdds){//add a baby!
            float dThetaSign = randomSign();
            myChildren.add(new branch(i, thetas[i]+dThetaSign*random(mindThetaSplit, maxdThetaSplit),
                                      totalLength*(1-(float)i/nSegments)*random(1-dBranchSize,1+dBranchSize),
//                                      totalLength*random(.3,.6),
                                      startingThickness*(1-(float)i/nSegments)));
            if(random(1)<=branchSpawnOddsOfSecond)
              myChildren.add(new branch(i, thetas[i]-dThetaSign*random(mindThetaSplit, maxdThetaSplit),
                                        totalLength*(1-(float)i/nSegments)*random(1-dBranchSize,1+dBranchSize),
  //                                      totalLength*random(.3,.6),
                                        startingThickness*(1-(float)i/nSegments)));
          }
    }
    
    //this'll add leaves!
    for(int i=1; i<nSegments; i++){
      if(startingThickness*(1-(float)i/nSegments)< maxBranchSizeForLeaves &&
         random(1)<leafSpawnOdds)
         myLeaves.add(new leaf(thetas[i],i));
    }
  }

  //gives the location of the nth node
  float[] getCoordsOf(int n){
    float x2 = x;
    float y2 = y;
    for(int i=0; i<n; i++){
      x2 += segmentLength*cos(thetas[i]);
      y2 += segmentLength*sin(thetas[i]);
    }
    return new float[]{x2,y2};
  }
  
  void rotate(float dTheta){
    //rotate myself
    for(int i=0; i<nSegments; i++)
      thetas[i]+=dTheta;
    //rotate my leaves
    for(int i=0; i<myLeaves.size(); i++)
      ((leaf)myLeaves.get(i)).rotate(dTheta);
    //rotate my children
    for(int i=0; i<myChildren.size(); i++)
      ((branch)myChildren.get(i)).rotate(dTheta);
  }
  
  void rotateDueToWind(){
    float dThetaWind = (thetas[0]-windDirection);
    float dThetaBranch = (thetas[0]-theta0);
    
    if(dThetaWind>PI)
      dThetaWind = -(TWO_PI-dThetaWind);
    else if(dThetaWind<-PI)
      dThetaWind = TWO_PI+dThetaWind;

    if(dThetaBranch>PI)
      dThetaBranch = -(TWO_PI-dThetaBranch);
    else if(dThetaBranch<-PI)
      dThetaBranch = TWO_PI+dThetaBranch;
    
    float forceOfBranch = -(thetas[0]-theta0)*startingThickness/maxBranchThickness;
    float forceOfWind = -windVelocity*sin(dThetaWind)/10;
    //this moves the branch
    rotate((forceOfBranch+forceOfWind)/20);

    //this moves the leaves!
    for(int i=0; i<myLeaves.size(); i++)
      ((leaf)myLeaves.get(i)).moveFromWind();

    //this'll rotate the children
    for(int i=0; i<myChildren.size(); i++)
      ((branch)myChildren.get(i)).rotateDueToWind();
  }
  
  void drawBranch(float[] coords){
    x = coords[0];
    y = coords[1];
    float x1 = x;
    float y1 = y;
    float x2,y2;
    for(int i=0; i<nSegments; i++){
      x2 = x1+segmentLength*cos(thetas[i]);
      y2 = y1+segmentLength*sin(thetas[i]);
      strokeWeight(startingThickness*(1-(float)i/nSegments));
      line(x1,y1,x2,y2);
      x1 = x2;
      y1 = y2;
    }
    //draw children
    for(int i=0; i<myChildren.size(); i++)
      ((branch)myChildren.get(i)).drawBranch(getCoordsOf(((branch)myChildren.get(i)).index));
  }
  
  void drawLeaves(float[] coords){
    for(int i=0; i<myLeaves.size(); i++)
      ((leaf)myLeaves.get(i)).draw(getCoordsOf(((leaf)myLeaves.get(i)).index));
    //draw children's leaves
    for(int i=0; i<myChildren.size(); i++)
      ((branch)myChildren.get(i)).drawLeaves(coords);
  }
}


int randomSign(){ //returns +1 or -1
  float num = random(-1,1);
  if(num==0)
    return -1;
  else
    return (int)(num/abs(num));
}


int nLeafPoints = 8;
float[] xOutline;
float[] yOutline;
void defineLeafOutline(){
  xOutline = new float[nLeafPoints];
  yOutline = new float[nLeafPoints];
  for(int i=0; i<=nLeafPoints/2;i++){
    xOutline[i] = 2*i/(float)(nLeafPoints);
    yOutline[i] = (-pow((xOutline[i]-.5),2)+.25)*2;
    
    if(i>0 && i<=nLeafPoints/2){
      xOutline[nLeafPoints-i] = xOutline[i];
      yOutline[nLeafPoints-i] = -yOutline[i];
    }
  }
}

float[] xVeins;
float[] yVeins;
void defineVeins(){
  xVeins = new float[8];
  yVeins = new float[8];
  xVeins[0] = .2;
  xVeins[1] = .25;
  xVeins[2] = .4;
  xVeins[3] = .47;
  xVeins[4] = .6;
  xVeins[5] = .65;
  xVeins[6] = .8;
  xVeins[7] = .85;
  
  yVeins[0] = 0;
  yVeins[1] = .3;
  yVeins[2] = 0;
  yVeins[3] = .45;
  yVeins[4] = 0;
  yVeins[5] = .35;
  yVeins[6] = 0;
  yVeins[7] = .2;
}


float tempx;
float tempy;
//leafWidth is a fraction of leafLength
void drawLeaf(float x, float y, float leafLength, float leafWidth, float direction){
  beginShape();
  for(int i=0; i<xOutline.length;i++){
    tempx = xOutline[i]*cos(direction)*leafLength-yOutline[i]*sin(direction)*leafWidth*leafLength;
    tempy = xOutline[i]*sin(direction)*leafLength+yOutline[i]*cos(direction)*leafWidth*leafLength;
    vertex(x+tempx,y+tempy);
  }
  endShape(CLOSE);
}


float vx1,vx2,vy1,vy2;
void drawVeins(float x, float y, float leafLength, float leafWidth, float direction){
//  strokeWeight(leafLength/40);
  strokeWeight(1);
  if(blackLeaves)
    stroke(0,0,0,transparency);
  else
    stroke(leafColor);

  line(x,y,x+cos(direction)*leafLength,y+sin(direction)*leafLength);
  for(int i=0; i<4; i++){
    vx1 = xVeins[i*2]*cos(direction)*leafLength-yVeins[i*2]*sin(direction)*leafWidth*leafLength;
    vx2 = xVeins[i*2+1]*cos(direction)*leafLength-yVeins[i*2+1]*sin(direction)*leafWidth*leafLength;
    vy1 = xVeins[i*2]*sin(direction)*leafLength+yVeins[i*2]*cos(direction)*leafWidth*leafLength;
    vy2 = xVeins[i*2+1]*sin(direction)*leafLength+yVeins[i*2+1]*cos(direction)*leafWidth*leafLength;
    line(x+vx1,y+vy1,x+vx2,y+vy2);
    vx1 = xVeins[i*2]*cos(direction)*leafLength+yVeins[i*2]*sin(direction)*leafWidth*leafLength;
    vx2 = xVeins[i*2+1]*cos(direction)*leafLength+yVeins[i*2+1]*sin(direction)*leafWidth*leafLength;
    vy1 = xVeins[i*2]*sin(direction)*leafLength-yVeins[i*2]*cos(direction)*leafWidth*leafLength;
    vy2 = xVeins[i*2+1]*sin(direction)*leafLength-yVeins[i*2+1]*cos(direction)*leafWidth*leafLength;
    line(x+vx1,y+vy1,x+vx2,y+vy2);
  }
}

class leaf{
  float theta0,dTheta,myWidth,myLength;
  int index;
  leaf(float thetaBranch, int index0){
    theta0 = thetaBranch+randomSign()*random(PI/6,PI/3);
    dTheta = 0;
    myWidth = random(minWidth,maxWidth);
    myLength = random(minLength,maxLength);
    index = index0;
  }

  void moveFromWind(){
    float dThetaWind = (((theta0+dTheta)-windDirection)%TWO_PI);
    if(dThetaWind>PI)
      dThetaWind = -(TWO_PI-dThetaWind);
    else if(dThetaWind<-PI)
      dThetaWind = TWO_PI+dThetaWind;

    theta0 = (theta0+TWO_PI)%TWO_PI;

    float forceOfLeaf = -(dTheta)/PI;
    float forceOfWind = -windVelocity*sin(dThetaWind);

    dTheta += (forceOfLeaf+forceOfWind)/15;
  }
  
  void rotate(float deltaTheta){
    dTheta+=deltaTheta;
  }

  void draw(float x, float y){
//    line(x,y,x+myLength*cos(theta0+dTheta),y+myLength*sin(theta0+dTheta));
    drawLeaf(x, y, myLength, myWidth, theta0+dTheta);
    if(drawVeins)
      drawVeins(x, y, myLength, myWidth, theta0+dTheta);
  }

  
  void draw(float[] coord){
    draw(coord[0],coord[1]);
  }
}

void redrawTrees(){
  background(skyColor);
  drawBranches();
  if(drawLeaves)
    drawLeaves();
}

void drawBranches(){
    stroke(branchColor);
    for(int i = 0; i<nTrees; i++)
      branches[i].drawBranch(new float[]{(1+i)*(width/(1+nTrees)), height});
  }
  
void drawLeaves(){
  noStroke();
  if(blackLeaves)
    fill(0,0,0,transparency);
  else
    fill(leafColor);
  //draw leaves
  for(int i = 0; i<nTrees; i++)
    branches[i].drawLeaves(new float[]{(1+i)*(width/(1+nTrees)), height});
}
  
  void drawWindLine(){
    stroke(0);
    int dx= 100;
    int dy = 100;
    line(dx,dy,dx+50*windVelocity*cos(windDirection),dy+50*windVelocity*sin(windDirection));
    noStroke();
    fill(0);
    ellipse(dx,dy,3,3);
  }



