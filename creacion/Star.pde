class Star {
  PShape img;
  int posx, posy, count;
  float scaling;
  boolean shrink;
  
  public Star(int posx, int posy){
    
    img = loadShape("estrella.svg");
    shrink = true;
    this.posx = posx;
    this.posy = posy;
    count = 0;
    scaling = 1.0;
  }
  
  public void animate(){
    if (shrink){
        if (scaling > 0.9){
          if (count == 0){          
            scaling = scaling - 0.03;
            count = 8;           
          }
          else{
            count--;
          }
        }
        else{
          shrink = false;
          count = 8;         
        }
      }
      else{      
        if (scaling < 1.0){      
        if (count == 0){    
          scaling = scaling + 0.025;
          count = 8;
        }
        else{
            count--;
          }
        }
        else{
          shrink = true;    
          count = 8;      
        }
      }
  }
}
