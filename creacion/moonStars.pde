class MoonStars implements Scene{

 PImage moon, night;
 ArrayList<Star> stars;
 int moonx, moony, moonyTop, count;
 float scaling;
 boolean shrink;
 PShape star;

  public MoonStars(){}
  
  void closeScene(){}
  
  void initialScene(){
   moon = loadImage("luna.png");
   night = loadImage("noche.png");
   star = loadShape("estrella.svg");
   moonx = width/2;
   moony = height;
   moonyTop = height/3;
  /* shrink = true;
   scaling = 0.9;
   count = 10;*/
   stars = new ArrayList();
   background(0);
   star.scale(0.6);   
  }
  
  void drawScene(){
    
    if (moony > moonyTop){    
      imageMode(CORNERS);
      image(night,0,0);
      imageMode(CENTER);
      image(moon, moonx, moony);
    //if (moony > moonyTop){
      moony--;  
    }
    /*else{
      
      imageMode(CENTER);
      for(int i = 0; i < stars.size(); i++){
        Star star= stars.get(i);
        star.animate();
        //PShape starShape = stars[i].img;
        star.img.scale(star.scaling);
        shape(star.img, star.posx, star.posy);
        
      }*/
      
      /*star = loadShape("estrella.svg");
      imageMode(CENTER);
      star.scale(scaling);
      shape(star, 80, 90);    */  
      
      
    //}
  }

  String getSceneName(){return "MoonStars";};
  
  void addStar(int posx, int posy){
    imageMode(CENTER);
    shape(star, posx, posy); 
    
    
   /* println("pum");
    println(posx);
    println(posy);
    if (stars.size()<8){
      stars.add(new Star(posx, posy));*/
     //}
  }
}

/*class Star {
  int size;
  boolean shrink = true;
  
  public Star() {
    size = 10;
  }
  
  public void animate(){
    if (shrink){      
      if (size>10){
        
      }
    }
  }
}*/
