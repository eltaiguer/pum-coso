class SkyTransition implements Scene{

  int c;
  int count;
  int size;
  boolean down = true;
  public SkyTransition(boolean down){
    this.down = down;
  }

  void closeScene(){}
  void initialScene(){
    noStroke();
    c=0;
    count=0;
    if (down){
      size = 0;
    }
    else{
      size = height;
    }
  }

  void drawScene(){
    count++;
    fill(42,138,201,c);
    
    if (down){
      rect(0, 0,width,size);
      size=size+5;
      
    }
    else{
      rect(0, size,width,height);
      size = size-5;
    }
    
    

    if (count==5){
       c++;
       count=0;
    }
    
    
  }

  String getSceneName(){return "SkyTransition";};
}
