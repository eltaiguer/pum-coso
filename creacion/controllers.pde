
public class ControlFrame extends PApplet {

  int w, h;
  ControlP5 cp5;
  Object parent;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

/////////////// Dia 1 Luz /////////////////////////////////

    cp5.addBang("bang1")
      .setPosition(180, 10)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

/////////////// Dia 2 Horizonte /////////////////////////////////

    cp5.addBang("bang2")
      .setPosition(180, 60)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Transicion Dia 3 /////////////////////////////////

    cp5.addBang("bang3")
      .setPosition(180, 110)
      .setSize(40, 20)
      .setLabel("Activar")
      ;    

  /////////////// Dia 3 Tierra /////////////////////////////////

    cp5.addBang("bang4")
      .setPosition(180, 160)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Transicion Dia 4 /////////////////////////////////

    cp5.addBang("bang5")
      .setPosition(180, 210)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Dia 4 Sol, luna y estrellas /////////////////////////////////

    cp5.addBang("bang6")
      .setPosition(180, 260)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Transicion Dia 5 /////////////////////////////////

    cp5.addBang("bang7")
      .setPosition(180, 310)
      .setSize(40, 20)
      .setLabel("Activar")
      ;

  /////////////// Dia 5 Peces y aves /////////////////////////////////

    cp5.addBang("bang8")
      .setPosition(180, 360)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
  
  /////////////// Transicion Dia 6 /////////////////////////////////

    cp5.addBang("bang9")
      .setPosition(180, 410)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
      
 /////////////// Dia 6 Mamiferos/////////////////////////////////

    cp5.addBang("bang10")
      .setPosition(180, 460)
      .setSize(40, 20)
      .setLabel("Activar")
      ;
 
  }

  void controlEvent(ControlEvent theEvent) {
    String n = theEvent.getName();

    // Dia 1 Luz
    if( n == "bang1") {
      manager.activate(0);
    }
    // Dia 2 Horizonte
    if( n == "bang2") {
      manager.activate(1);
    }
    // Escena 2 Espacio
    if( n == "bang3") {
      manager.activate(2);
    }

    // Transicion 2 Espacio-Cielo
    if( n == "bang4") {
      manager.activate(3);
    }
    // Escena 3 Cielo
    if( n == "bang5") {
      manager.activate(4);
    }
    // Transición 3 Cielo-Agua
    if( n == "bang6") {
      manager.activate(5);
    }
    // Escena 4 Agua
    if( n == "bang7") {
      manager.activate(6);
    }
    // Transicion 4 Agua-Cama
    if( n == "bang8") {
      manager.activate(7);
    }

    // Escena Cama final
    if( n == "bang7") {
      manager.activate(6);
    }
  }

  public void draw() {
    background(0);
    fill(255);
    text("Dia 1 - Luz",10,20);
    stroke(255,0,0);

    line(5,50,445,50);
    text("Dia 2 - Horizonte",10,70);

    line(5,100,445,100);
    text("Transicion - Dia 3",10,120);

    line(5,150,445,150);
    text("Dia 3 - Tierra y arboles",10,170);

    line(5,200,445,200);
    text("Transicion Dia 4",10,220);

    line(5,250,445,250);
    text("Dia 4 - Sol, luna y estrellas",10,270);

    line(5,300,445,300);
    text("Transicion Dia 5",10,320);

    line(5,350,445,350);
    text("Dia 5 - Peces y aves",10,370);
    
    line(5,400,445,400);
    text("Transicion Dia 6",10,420);
    
    line(5,450,445,450);
    text("Dia 6 - Animales y humanos",10,470);   
   
  }

  private ControlFrame() {
  }
  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }
  public ControlP5 control() {
    return cp5;
  }
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}
