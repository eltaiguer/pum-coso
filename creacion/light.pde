/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/167871*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//SPERICAL LIGHT made by LEE KUNHEE(39 lines, 35 lines without comments)

class Light implements Scene {

  float x, y, z, phi, theta;//For Vector value.
  float r=10;//initial light spread amount(focus)
  int i=1;//sphere sizecount
  boolean stop = false;

  public Light(){}

  void closeScene(){}

  String getSceneName(){return "Light";}

  void initialScene(){        
    background(0);    
  }

  void drawScene(){    
      if (!stop){
      println(i);
      strokeWeight(0.2+map(i, 0, 1000, 0, 20));//increase strokeWeight as frameCount goes up.
      translate(width/2, height/2, 0);//move (0,0,0) to the center of display
  
    
      //draw sunlight
      if (i<2000) {stroke(255, 255, 255, 5);}//MAKE SUNSET SCENE.      
      
      spread(360, 0);//MAKE SPERICAL LIGHT.
  
      i=i+2;//increase the light length.
  
      // if (i==4500)i=0;//initialize if sunset was done.
    }
  }

  void spread(int degree, float position) {
    //this function generates random line from (0,0,0)center to multiflied vector(ix,iy,iz)
    phi = radians(random(0, degree));
    theta = radians(random(0, degree));
    x = r * sin(phi) * cos(theta);
    y = r * sin(phi) * sin(theta);
    z = r * cos(phi);
    line(400+position, 300+0, 0, position+ i*x, i*y, i*z);
  }//END

}
