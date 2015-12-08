PImage [] images;
  
  int race = 0;
  boolean draw = false;
  
  int cant = 2;

class Animals implements Scene {
  
  public Animals(){}

  void closeScene(){}

  String getSceneName(){return "Animals";}

  void initialScene(){ 
    images = new PImage[cant];
  }

  void drawScene(){
    if (draw){
      background(255);
      for (int i = 0; i< cant; i++){               
        image(images[i],i*width/cant, height - images[i].height);
      }
      draw = false;
    }
  }  
  
}

void keyPressed(){
  
  if (keyCode == ' '){
    race++;    
  }
  
  for (int i=0; i<cant; i++){    
    switch(race) {
      case 0:
        images[i] = loadImage("leon-papel.png");
        break;
      case 1:
        images[i] = loadImage("elefante-papel.png");
        break;
      case 2:
        images[i] = loadImage("canguro-papel.png");
        break;
      case 3:
        images[i] = loadImage("mono-papel.png");
        break;
    }
    
  }
  draw = true;
}
