import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class skyAndLeaves extends PApplet {

float transparency = 150;
int leafColor = color(5,113,3,transparency);
int veinColor = color(5,113,3,transparency/2);
int branchColor = color(30);
int skyColor = color(211,211,255);

int width = 900;
int height = 500;

//branch controls
int nTrees = 1; //the number of trees
int nSegments = 15;
float totalBranchLength = 400;
float maxBranchThickness = 10;
float minBranchThickness = 2; 
float minSpawnDistance = .2f; //this controls how far the branch will grow before splitting
float branchSpawnOdds = .8f;   //the odds of a branch growing there
float mindThetaSplit = PI*.1f;
float maxdThetaSplit = PI*.3f;
float maxdThetaWander = PI/20;


//leaf controls
float minLength = 10; //leaf length
float maxLength = 30; //leaf length
float minWidth = .4f;  //leaf width as a factor of length
float maxWidth = .5f;  //leaf width as a factor of length
float maxBranchSizeForLeaves = 4;
float leafSpawnOdds = .7f;

branch[] branches;

boolean pauseWind = false;
boolean drawWind = false;
boolean drawVeins = false;
boolean blackLeaves = false;

//int width = 1680;
//int height = 1050;

public void setup(){
  size(width, height);
  frameRate(30);
  smooth();
  noStroke();

  
  windDirection = 0;
  windVelocity = 0;
  defineLeafOutline();
  defineVeins();
  
  generateBranches();
}


public void draw(){
  background(skyColor);
  
  if(!pauseWind)
    updateWind();

  //draw branches
  stroke(branchColor);
  for(int i = 0; i<nTrees; i++)
    branches[i].drawBranch(new float[]{(1+i)*(width/(1+nTrees)), height});

  noStroke();
  if(blackLeaves)
    fill(0,0,0,transparency);
  else
    fill(leafColor);
  //draw leaves
  for(int i = 0; i<nTrees; i++)
    branches[i].drawLeaves(new float[]{(1+i)*(width/(1+nTrees)), height});
  
  //move in the wind!
  for(int i = 0; i<nTrees; i++)
    branches[i].rotateDueToWind();
  
  //draw the wind line
  if(drawWind){
    stroke(0);
    int dx= 100;
    int dy = 100;
    line(dx,dy,dx+50*windVelocity*cos(windDirection),dy+50*windVelocity*sin(windDirection));
    noStroke();
    fill(0);
    ellipse(dx,dy,3,3);
  }
}
public void mouseClicked(){
  generateBranches();
  windDirection = random(TWO_PI);
  
}

public void keyTyped(){
  if(key == 'm')
    drawWind = !drawWind;
  if(key== 'n')
    drawVeins = !drawVeins;
  if(key=='c')
    blackLeaves = !blackLeaves;
    
  if(key == 'p'){
    pauseWind = !pauseWind;
    if(pauseWind)
      windVelocity = 0;
  }

  if(key == '='){
    if(transparency<240){
      transparency +=10;
      leafColor = color(5,113,3,transparency);
    }
    println("transparency: "+transparency);
  }
  if(key == '-'){
    if(transparency>0){
      transparency -=10;
      leafColor = color(5,113,3,transparency);
    }
    println("transparency: "+transparency);
  }
  
  //more/less wiggly
  if(key=='q'){
    if(maxdThetaWander==0)
      maxdThetaWander = .01f;
    maxdThetaWander = maxdThetaWander*1.2f;
    generateBranches();
  }
  if(key=='a'){
    maxdThetaWander = maxdThetaWander/1.2f;
    generateBranches();
  }
  
  //more/less branches
  if(key=='w'){
    if(branchSpawnOdds<1)
      branchSpawnOdds += .1f;
    generateBranches();
  }
  if(key=='s'){
    if(branchSpawnOdds>0)
      branchSpawnOdds -= .1f;
    generateBranches();    
  }

  
  //fatter/thinner branches
  if(key=='e'){
    maxBranchThickness = maxBranchThickness*1.2f;
    maxBranchSizeForLeaves = maxBranchSizeForLeaves*1.2f;
    minBranchThickness = minBranchThickness*1.2f;
    generateBranches();
  }
  if(key=='d'){
    maxBranchThickness = maxBranchThickness/1.2f;
    maxBranchSizeForLeaves = maxBranchSizeForLeaves/1.2f;
    minBranchThickness = minBranchThickness/1.2f;
    generateBranches();
  }

  //more/less leaves
  if(key=='r'){
    if(leafSpawnOdds<1)
      leafSpawnOdds += .1f;
    generateBranches();
  }
  if(key=='f'){
    if(leafSpawnOdds>0)
      leafSpawnOdds -= .1f;
    generateBranches();    
  }
  
  //bigger/smaller leaves
  if(key=='t'){
    minLength = minLength*1.2f; //leaf length
    maxLength = maxLength*1.2f; //leaf length
    generateBranches();
  }
  if(key=='g'){
    minLength = minLength/1.2f; //leaf length
    maxLength = maxLength/1.2f; //leaf length
    generateBranches();
  }
  
  if(key =='['){
    if(nLeafPoints > 6){
      nLeafPoints-=2;
      defineLeafOutline();
      defineVeins();
      println("nLeafPoints: "+nLeafPoints);
    }
  }
  if(key ==']'){
    nLeafPoints+=2;
    defineLeafOutline();
    defineVeins();
    println("nLeafPoints: "+nLeafPoints);
  }
  
  //reset
  if(key =='z'){
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2; 
    minSpawnDistance = .2f;
    branchSpawnOdds = .8f; 
    mindThetaSplit = PI*.1f;
    maxdThetaSplit = PI*.3f;
    maxdThetaWander = PI/20;
    minLength = 10; //leaf length
    maxLength = 30; //leaf length
    minWidth = .4f;  //leaf width as a factor of length
    maxWidth = .5f;  //leaf width as a factor of length
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .7f;
    generateBranches();
  }

  //hand-picked tree types!
  if(key =='1'){
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2; 
    minSpawnDistance = .2f;
    branchSpawnOdds = .8f; 
    mindThetaSplit = PI/2;
    maxdThetaSplit = PI/2;
    maxdThetaWander = 0;
    minLength = 10; //leaf length
    maxLength = 30; //leaf length
    minWidth = .4f;  //leaf width as a factor of length
    maxWidth = .5f;  //leaf width as a factor of length
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .7f;
    generateBranches();
  }
  if(key =='2'){
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2; 
    minSpawnDistance = .2f;
    branchSpawnOdds = .8f; 
    mindThetaSplit = PI/3;
    maxdThetaSplit = PI/3;
    maxdThetaWander = 0;
    minLength = 10; //leaf length
    maxLength = 30; //leaf length
    minWidth = .4f;  //leaf width as a factor of length
    maxWidth = .5f;  //leaf width as a factor of length
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .7f;
    generateBranches();
  }
  if(key =='3'){
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2; 
    minSpawnDistance = .2f;
    branchSpawnOdds = .8f; 
    mindThetaSplit = PI/4;
    maxdThetaSplit = PI/4;
    maxdThetaWander = 0;
    minLength = 10; //leaf length
    maxLength = 30; //leaf length
    minWidth = .4f;  //leaf width as a factor of length
    maxWidth = .5f;  //leaf width as a factor of length
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .7f;
    generateBranches();
  }
  if(key =='4'){
    totalBranchLength = 400;
    maxBranchThickness = 10;
    maxBranchSizeForLeaves = 4;
    minBranchThickness = 2; 
    minSpawnDistance = .1f;
    branchSpawnOdds = .3f; 
    mindThetaSplit = 0;
    maxdThetaSplit = PI/4;
    maxdThetaWander = PI/4;
    minLength = 10; //leaf length
    maxLength = 30; //leaf length
    minWidth = .4f;  //leaf width as a factor of length
    maxWidth = .5f;  //leaf width as a factor of length
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .7f;
    generateBranches();
  }
  
  if(key =='5'){
    totalBranchLength = 400;
    maxBranchThickness = 40;
    minBranchThickness = 2; 
    minSpawnDistance = .5f;
    branchSpawnOdds = .3f; 
    mindThetaSplit = 0;
    maxdThetaSplit = PI/2;
    maxdThetaWander = PI/4;
    minLength = 10; //leaf length
    maxLength = 30; //leaf length
    minWidth = .4f;  //leaf width as a factor of length
    maxWidth = .5f;  //leaf width as a factor of length
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .4f;
    generateBranches();
  }
  
  if(key =='6'){
    totalBranchLength = 400;
    maxBranchThickness = 5;
    minBranchThickness = 2; 
    minSpawnDistance = .1f;
    branchSpawnOdds = .2f; 
    mindThetaSplit = 0;
    maxdThetaSplit = .3f;
    maxdThetaWander = PI/30;
    minLength = 30; //leaf length
    maxLength = 60; //leaf length
    minWidth = .1f;  //leaf width as a factor of length
    maxWidth = .2f;  //leaf width as a factor of length
    maxBranchSizeForLeaves = 4;
    leafSpawnOdds = .7f;
    generateBranches();
  }
  
  if(key =='7'){
    totalBranchLength = 400;
    maxBranchThickness = 5;
    maxBranchSizeForLeaves = 1;
    minBranchThickness = .5f; 
    minSpawnDistance = .7f;
    branchSpawnOdds = 1; 
    mindThetaSplit = 0;
    maxdThetaSplit = PI/6;
    maxdThetaWander = PI/30;
    minLength = 30; //leaf length
    maxLength = 60; //leaf length
    minWidth = .3f;  //leaf width as a factor of length
    maxWidth = .5f;  //leaf width as a factor of length
    leafSpawnOdds = 1;
    generateBranches();
  }
  
}

public void generateBranches(){
  branches = new branch[nTrees];
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
      thetas[i] = thetas[i-1]+randomSign()*random(maxdThetaWander);
    }
    
    //this'll spawn the baby branches!
    for(int i=1; i<nSegments; i++){
      if(startingThickness*(1-(float)i/nSegments)> minBranchThickness &&
         (float)i/nSegments > minSpawnDistance &&
          random(1)<branchSpawnOdds){//add a baby!
            myChildren.add(new branch(i, thetas[i]+randomSign()*random(mindThetaSplit, maxdThetaSplit),
                                      totalLength*(1-(float)i/nSegments),
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
  public float[] getCoordsOf(int n){
    float x2 = x;
    float y2 = y;
    for(int i=0; i<n; i++){
      x2 += segmentLength*cos(thetas[i]);
      y2 += segmentLength*sin(thetas[i]);
    }
    return new float[]{x2,y2};
  }
  
  public void rotate(float dTheta){
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
  
  public void rotateDueToWind(){
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
  
  public void drawBranch(float[] coords){
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
  
  public void drawLeaves(float[] coords){
    for(int i=0; i<myLeaves.size(); i++)
      ((leaf)myLeaves.get(i)).draw(getCoordsOf(((leaf)myLeaves.get(i)).index));
    //draw children's leaves
    for(int i=0; i<myChildren.size(); i++)
      ((branch)myChildren.get(i)).drawLeaves(coords);
  }
}


public int randomSign(){ //returns +1 or -1
  float num = random(-1,1);
  if(num==0)
    return -1;
  else
    return (int)(num/abs(num));
}
int nLeafPoints = 8;
float[] xOutline;
float[] yOutline;
public void defineLeafOutline(){
  xOutline = new float[nLeafPoints];
  yOutline = new float[nLeafPoints];
  for(int i=0; i<=nLeafPoints/2;i++){
    xOutline[i] = 2*i/(float)(nLeafPoints);
    yOutline[i] = (-pow((xOutline[i]-.5f),2)+.25f)*2;
    
    if(i>0 && i<=nLeafPoints/2){
      xOutline[nLeafPoints-i] = xOutline[i];
      yOutline[nLeafPoints-i] = -yOutline[i];
    }
  }
}

float[] xVeins;
float[] yVeins;
public void defineVeins(){
  xVeins = new float[8];
  yVeins = new float[8];
  xVeins[0] = .2f;
  xVeins[1] = .25f;
  xVeins[2] = .4f;
  xVeins[3] = .47f;
  xVeins[4] = .6f;
  xVeins[5] = .65f;
  xVeins[6] = .8f;
  xVeins[7] = .85f;
  
  yVeins[0] = 0;
  yVeins[1] = .3f;
  yVeins[2] = 0;
  yVeins[3] = .45f;
  yVeins[4] = 0;
  yVeins[5] = .35f;
  yVeins[6] = 0;
  yVeins[7] = .2f;
}


float tempx;
float tempy;
//leafWidth is a fraction of leafLength
public void drawLeaf(float x, float y, float leafLength, float leafWidth, float direction){
  beginShape();
  for(int i=0; i<xOutline.length;i++){
    tempx = xOutline[i]*cos(direction)*leafLength-yOutline[i]*sin(direction)*leafWidth*leafLength;
    tempy = xOutline[i]*sin(direction)*leafLength+yOutline[i]*cos(direction)*leafWidth*leafLength;
    vertex(x+tempx,y+tempy);
  }
  endShape(CLOSE);
}


float vx1,vx2,vy1,vy2;
public void drawVeins(float x, float y, float leafLength, float leafWidth, float direction){
//  strokeWeight(leafLength/40);
  strokeWeight(1);
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

  public void moveFromWind(){
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
  
  public void rotate(float deltaTheta){
    dTheta+=deltaTheta;
  }

  public void draw(float x, float y){
//    line(x,y,x+myLength*cos(theta0+dTheta),y+myLength*sin(theta0+dTheta));
    drawLeaf(x, y, myLength, myWidth, theta0+dTheta);
    if(drawVeins)
      drawVeins(x, y, myLength, myWidth, theta0+dTheta);
  }

  
  public void draw(float[] coord){
    draw(coord[0],coord[1]);
  }
}

float windDirection;
float windVelocity;
float velIncrement = 0.04f;
float velOff = 0;
public void updateWind(){
  velOff+= velIncrement;
  windDirection = (windDirection+random(-1,-1)*.001f+TWO_PI)%TWO_PI;
  windVelocity = 2*noise(velOff)-1;
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "skyAndLeaves" });
  }
}
