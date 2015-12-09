class Star {
  PShape s;
  float x, y;

  Star() {
    s = loadShape("star1.svg");
  }
  
  void display(float mousex, float mousey, float size) {
    shape(s,mousex, mousey, size, size);
  }
}
