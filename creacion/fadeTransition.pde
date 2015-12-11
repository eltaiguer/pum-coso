class FadeTransition implements Scene{

  int count;  
  int alfa;

  public FadeTransition(){}

  void closeScene(){}

  void initialScene(){
    noStroke();
    count = 0;
    alfa = 0;    
  }

  void drawScene(){
    if (alfa < 20){
    fill(0,0,0,alfa);
    rect(0,0,width,height);
    if (count == 5){
       alfa++;
       count = 0;
    }
      count++;    
    }
  }

  String getSceneName(){return "FadeTransition";};
}
