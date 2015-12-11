 

class Birds implements Scene {
 
 PImage image;
  
  public Birds(){}

  void closeScene(){}

  String getSceneName(){return "Birds";}

  void initialScene(){ 
    image=loadImage("pajaros-cielo.png");    
  }

  void drawScene(){
    imageMode(CORNER);
    image(image,0,0);
  }    
  
}
