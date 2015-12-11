class MoonStars implements Scene {

  PImage moon, night;
  ArrayList<Star> stars;
  int moonx, moony, moonyTop, count;
  float scaling;
  boolean shrink;
  PShape star;

  float a;
  float x;
  float y;
  float dx, dy, r;
  
  int felipe;


  public MoonStars() {
  }

  void closeScene() {
  }

  void initialScene() {
    moon = loadImage("luna.png");
    //moon.resize(410, 0);
    night = loadImage("noche.png");
    star = loadShape("estrella.svg");
    moonx = width/2;
    moony = height;
    moonyTop = height/3;
    stars = new ArrayList();
    background(0);
    star.scale(0.6);
    
    noStroke();
    smooth();
    
    felipe = 0;
  }

  void drawScene() {
    if (moony > moonyTop) {    
      
      imageMode(CORNERS);
      image(night, 0, 0);
      imageMode(CENTER);
      image(moon, moonx, moony);
      moony--;
    }
    else{
      
      if (felipe > 20){
      
      /*fill(0, 40);
      rect(0, 0, width, height);
      
      fill(255);*/
      r = random(20, 70);
      ellipseMode(CENTER);
      x = random(r, width-r);
      y = random(r, height-r);
      dx = map(noise(3.00+a), 0, 1, 0, 3);
      dy = map(noise(4.00+a), 0, 1, 0, 3);
      //ellipse(x + dx, y + dy, r, r);
      shape(star, x+dx, y+dy,r,r);
      
      a = a + 0.01;
      felipe = 0;
      image(moon, moonx, moony);
      }
      felipe++;
      
    }
    
    
  }


  String getSceneName() {
    return "MoonStars";
  };

  void addStar() {
    imageMode(CENTER);

    int xpos = moonx;

    while (xpos > moonx-5 && xpos < moonx+moon.width+5) {
      xpos=(int)random(0, width);
    }

    int ypos = moony;

    while (ypos > moony-5 && ypos < moony+moon.height+5) {
      ypos=(int)random(0, height);
    }
    shape(star, xpos, ypos);
  }
}

