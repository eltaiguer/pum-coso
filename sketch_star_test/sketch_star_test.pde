PShape bot;
float size = 0;

void setup() {
  size(640, 360);
  bot = loadShape("star1.svg");
  background(#1161A5);
} 

void draw(){
}

void mouseReleased() {
  size = random(20, 70);
  shape(bot, mouseX, mouseY, size, size);
}




