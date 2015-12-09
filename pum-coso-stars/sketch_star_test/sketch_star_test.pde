PShape bot;
float size = 40;
boolean inc = true;

void setup() {
  size(640, 360);
  bot = loadShape("star1.svg");
  background(#1161A5);
} 

void draw(){
  
  background(#1161A5);
 
  shape(bot, mouseX, mouseY, size, size);
  if (inc && size<=45){
      size++;
  }
  if (size > 45){
    inc = false;
  }
  if (!inc && size>=40){
    size--;
  }
  if (size<40){
    inc = true;
  }
  println(size);
}

void mouseReleased() {
  size = random(20, 70);
  shape(bot, mouseX, mouseY, size, size);
}




