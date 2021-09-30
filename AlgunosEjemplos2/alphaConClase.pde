PImage imagen;
ArrayList <Trazo> losTrazos;

void setup() {  
  size(750, 498);
  imagen = loadImage("macaw.png");
  imagen.resize(750, 498);  
  background(255);   
  
  losTrazos = new ArrayList<Trazo>();
  IntList posiciones = new IntList();
  int k = 0;
  for (int i = 5; i<width; i+=5 ) {
    for (int j = 5; j<height; j+=5 ) {
      losTrazos.add(new Trazo(i+random(0), j+random(0), random(10, 40)));
      posiciones.append(k);
      k++;
    }
  }
  posiciones.shuffle();

  for (int i = 0; i<losTrazos.size(); i++) {
    for (int j = 0; j<20; j++) {
      losTrazos.get(posiciones.get(i)).display();
    }
  }
}

class Trazo { 
  PVector pos;
  float a;
  float t;
  color colorActual;
  float da;
  float alfa;
  Trazo(float x_, float y_, float t_) {
    pos = new PVector(x_, y_);
    a = random(TWO_PI);
    t = t_;
    PVector fin = PVector.fromAngle(a).mult(t).add(pos);
    PVector inicio = PVector.fromAngle(a).mult(t*.50).add(pos);
    colorActual = CPromedioLineal(inicio, fin);
    da = 2f/t;
  }

  void display() {
    PVector fin = PVector.fromAngle(a).mult(t).add(pos);
    PVector inicio = PVector.fromAngle(a).mult(t*.80).add(pos);
    color pAct = CPromedioLineal(inicio, fin);
    colorActual = lerpColor(colorActual, pAct, 0.1);
    stroke(colorActual);
    strokeWeight(4);
    line(inicio.x, inicio.y, fin.x, fin.y);
    a+=da;
  }

  color CPromedioLineal(PVector de_, PVector a_) {
    float r, g, b, alfa;
    r=g=b=alfa=0;
    float dist = de_.dist(a_);
    int num = 0; 
    for (float i = 0; i<1; i+= 1f/dist) {
      PVector posInt = PVector.lerp(de_, a_, i);
      color c = 0;
      c = imagen.get(round(posInt.x), round(posInt.y));

      if (alpha(c)==255) {
        r+= red(c);
        g+= green(c);
        b+= blue(c); 
        num++;
        alfa+=alpha(c);
      } 
      else if (alpha(c) == 0) {
        r+= 255;
        g+=255;
        b+=255;
        alfa+= alpha(c);
        num++;
      } 
      else {
        alfa+= alpha(c);
        num++;
      }
    }    
    return(color(r/num, g/num, b/num, alfa/num));
  }
}
