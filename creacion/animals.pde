  PImage [] images;
  
  int race = 0;
  boolean draw = false;
  PImage image, image2;
  
  int cant = 2;

class Animals implements Scene {
  
  
  PImage background;
  
  public Animals(){}

  void closeScene(){}

  String getSceneName(){return "Animals";}

  void initialScene(){ 
    noStroke();
    //noSmooth();
    images = new PImage[cant];
    background = loadImage("pajaros-cielo.png");
  }

  void drawScene(){
    //if (draw){
      
      imageMode(CORNER); 
       image(background,0,0);     
      if (race==0){
        image = loadImage("leon-1.png");
        image2 = loadImage("leon-2.png");
        image(image, 0, height - image.height);
        image(image2, width - image2.width, height - image.height);        
      }
      
      if (race==1){
        image = loadImage("mono-1.png");
        image.resize(408,0);
        image2 = loadImage("mono-2.png");
        image2.resize(408,0);
        image(image, 0, height - image.height);
        image(image2, width - image2.width, height - image.height);        
      }
      
      if (race==2){
        image = loadImage("elefante.png");
        image(image, 0, 0);                
      }
      
      if (race==3){
        image = loadImage("canguro-1.png");
        image2 = loadImage("canguro-2.png");
        image(image, 0, height - image.height);
        image(image2, width - image2.width, height - image.height);        
      }  
      
      //for (int i = 0; i< cant; i++){               
      //image(images[i],i*width/cant, height - images[i].height);
      //}
  //    draw = false;
  //  }
  }

  public void changeRace(){
    
    race = (race+1) % 4;
    println("race " + race);
  }  
  
}

/*void keyPressed(){
  
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
}*/
