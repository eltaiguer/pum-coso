

class PumCoso implements Scene {
 
 PImage image;
  
  public PumCoso(){}

  void closeScene(){}

  String getSceneName(){return "PumCoso";}

  void initialScene(){ 
    image=loadImage("pum-coso.png");    
  }

  void drawScene(){
    imageMode(CORNER);
    image(image,0,0);
  }    
  
}
