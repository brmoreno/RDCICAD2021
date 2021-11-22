class ImagenConP extends Imagen{
  int px;
  int py;
  float r;
  float sc;
  float v;
  ImagenConP(String txt, int px_, int py_,float r_,float sc_,float v_){
    super(txt);
    px = px_;
    py = py_;
    r = r_;
    sc = sc_;
    v = v_;
  }
  
  void display(){
    super.display(px,py,r,sc,v);
  }
  
  
}

class Imagen {
  ArrayList <Ctr> ctrs;
  ArrayList <Linea> lineas;
  int xi;
  int yi;
  int w;
  int h;
  
  Imagen(String txt) {
    ctrs= new ArrayList <Ctr>() ;
    lineas = new ArrayList <Linea> ();
    int colcol = 0;
    int pospos = 0;
    String[] foo = loadStrings(txt);
    boolean linea = false;
    for (int i = 0; i< foo.length; i++) {
      if (i%2 == 0) {
        String[] partes = splitTokens(foo[i], " ");
        if (partes.length>1) {
          colcol = int(partes[1]);
          pospos = int(partes[0]);
        }
        if ( int(partes[0]) == 1) {
          linea = true;
        } else {
          linea = false;
        }
      } else {
        String[] partes = splitTokens(foo[i], "]");
        ArrayList <PVector> pos = new ArrayList <PVector>();
        for (int j = 0; j<partes.length; j++) {
          String[] arr = splitTokens(partes[j], "[, ");
          pos.add(new PVector(float(arr[0])+random(-2, 2), float(arr[1])+random(-2, 2)));
        }
        if (linea) {
          lineas.add(new Linea(pos));
        } else {
          ctrs.add(new Ctr(pos, pospos, colcol));
        }
      }
    }
    
    xi= ctrs.get(0).x;
    yi= ctrs.get(0).x;
    int maxx = ctrs.get(0).x;
    int maxy = ctrs.get(0).y;
    for(Ctr c:ctrs){
      if(c.x<xi){
        xi = c.x;
      }
      if(c.y<yi){
        yi=c.y;
      }
      if(c.x>maxx){
        maxx = c.x;
      }
      if(c.y>maxy){
        maxy = c.y;
      }
    }   
    for(Linea c:lineas){
      if(c.x<xi){
        xi = c.x;
      }
      if(c.y<yi){
        yi=c.y;
      }
      if(c.x>maxx){
        maxx = c.x;
      }
      if(c.y>maxy){
        maxy = c.y;
      }
    }   
    w = 1+maxx-xi;
    h = 1+maxy-yi;
  }
  
  void display(float x_, float y_, float r_, float s_, float v_){
    ArrayList <Ctr> copiactrs = new ArrayList <Ctr>();
    ArrayList <Linea> copialineas = new ArrayList <Linea>();    
    for(Ctr c:ctrs){
      copiactrs.add(new Ctr(c));
    }
    for(Linea l:lineas){
      copialineas.add(new Linea(l));
    }
    
    for(Ctr c: copiactrs){
      for(PVector p:c.pos){
        p.add(-w/2,-h/2).add(-xi,-yi);
        p.rotate(r_);
        p.mult(s_);
        p.add(x_,y_);
        p.add(random(-v_,v_),random(-v_,v_));
      }
        c.setXYWH();
        int centroX = c.x + c.w/2;
        int centroY = c.y + c.h/2;
        color colorCentro = fondo.get(centroX,centroY);
        fill(colorCentro);
        noStroke();
        if(random(1)<0.5){
        c.render();
        }
      //}
    
    }
    for(Linea l: copialineas){
      for(PVector p:l.pos){
        p.add(-w/2,-h/2).add(-xi,-yi);
        p.rotate(r_);
        p.mult(s_);
        p.add(x_,y_);
        p.add(random(-v_,v_),random(-v_,v_));
      }
      stroke(0);
      noFill();
      strokeWeight(1);
      l.render();
    }    
  }
}

class Ctr {
  ArrayList <PVector> pos;
  color poster;
  color col;
  int x, y, w, h;
  Ctr(ArrayList<PVector> pos_, color post_, color col_) {
    pos = pos_;
    poster = post_;
    col = col_;
    x = round(pos.get(0).x);
    y = round(pos.get(0).y);
    int maxx = round(pos.get(0).x);
    int maxy = round(pos.get(0).y);
    for (PVector p : pos) {
      if (p.x<x) {
        x = round(p.x);
      }
      if (p.y<y) {
        y = round(p.y);
      }
      if (p.x>maxx) {
        maxx = round(p.x);
      }
      if (p.y>maxy) {
        maxy = round(p.y);
      }
    }
    w = 1+maxx-x;
    h = 1+maxy-y;
  }
  
  void setXYWH(){
    x = round(pos.get(0).x);
    y = round(pos.get(0).y);
    int maxx = round(pos.get(0).x);
    int maxy = round(pos.get(0).y);
    for (PVector p : pos) {
      if (p.x<x) {
        x = round(p.x);
      }
      if (p.y<y) {
        y = round(p.y);
      }
      if (p.x>maxx) {
        maxx = round(p.x);
      }
      if (p.y>maxy) {
        maxy = round(p.y);
      }
    }
    w = 1+maxx-x;
    h = 1+maxy-y;
  }
  
  Ctr(Ctr c){
    pos = new ArrayList <PVector>();
    for(PVector p:c.pos){
      pos.add(p.copy());
    }
    poster = c.poster;
    col = c.col;
    x = c.x;
    y = c.y;
    w = c.w;
    h = c.h;
  }

  void display(int n_) {
    fill(poster);
    if (n_ == 1) {
      fill(col);
    }
    noStroke();
    beginShape();
    vertex(pos.get(0).x, pos.get(0).y);
    for (int j = 0; j< pos.size(); j++) {
      int n [] = {j, j+1, j+2};
      if (j == pos.size()-2) {
        n[2] = 0;
      }
      if (j == pos.size()-1) {
        n[1] = 0;
        n[2] = 1;
      }
      PVector posn[] = new PVector[3];
      for (int k = 0; k<3; k++) {
        posn[k] = pos.get(n[k]);
      }
      PVector dostres = PVector.lerp(posn[1], posn[2], 0.5); 

      bezierVertex(posn[1].x, posn[1].y, posn[1].x, posn[1].y, dostres.x, dostres.y);
    }
    endShape();
  }
  
  void render() {
    beginShape();
    vertex(pos.get(0).x, pos.get(0).y);
    for (int j = 0; j< pos.size(); j++) {
      int n [] = {j, j+1, j+2};
      if (j == pos.size()-2) {
        n[2] = 0;
      }
      if (j == pos.size()-1) {
        n[1] = 0;
        n[2] = 1;
      }
      PVector posn[] = new PVector[3];
      for (int k = 0; k<3; k++) {
        posn[k] = pos.get(n[k]);
      }
      PVector dostres = PVector.lerp(posn[1], posn[2], 0.5); 

      bezierVertex(posn[1].x, posn[1].y, posn[1].x, posn[1].y, dostres.x, dostres.y);
    }
    endShape();
  }
  
  void renderPG(){
    setXYWH();
    PGraphics pg = createGraphics(w,h);
    pg.beginDraw();
    pg.background(0);
    pg.fill(255);
    pg.beginShape();
    pg.vertex(pos.get(0).x-x, pos.get(0).y-y);
    for (int j = 0; j< pos.size(); j++) {
      int n [] = {j, j+1, j+2};
      if (j == pos.size()-2) {
        n[2] = 0;
      }
      if (j == pos.size()-1) {
        n[1] = 0;
        n[2] = 1;
      }
      PVector posn[] = new PVector[3];
      for (int k = 0; k<3; k++) {
        posn[k] = pos.get(n[k]);
      }
      PVector dostres = PVector.lerp(posn[1], posn[2], 0.5); 

      pg.bezierVertex(posn[1].x-x, posn[1].y-y, posn[1].x-x, posn[1].y-y, dostres.x-x, dostres.y-y);
    }
    pg.endShape();
    pg.endDraw();
    
    PImage fondo = texturas.get(floor(random(texturas.size()))).get(round(random(200)),round(random(200)),w,h);
    for(int i = 0; i<fondo.pixels.length;i++){
      int colorInicial = fondo.pixels[i];
      float rojo =map(red(colorInicial),0,255,0,127)*red(col)/255;
      float verde = map(green(colorInicial), 0,255,100,250)*green(col)/255;
      float azul = map(blue(colorInicial),0,255,0,127)*blue(col)/255;
      fondo.pixels[i] = color(rojo,verde,azul);
    }
    fondo.mask(pg);
    image(fondo,x,y);
  }  
}

class Linea {
  ArrayList <PVector> pos;
  int x, y, w, h;
  
  Linea(ArrayList<PVector> pos_) {
    pos = pos_;
    x = round(pos.get(0).x);
    y = round(pos.get(0).y);
    int maxx = round(pos.get(0).x);
    int maxy = round(pos.get(0).y);
    for (PVector p : pos) {
      if (p.x<x) {
        x = round(p.x);
      }
      if (p.y<y) {
        y = round(p.y);
      }
      if (p.x>maxx) {
        maxx = round(p.x);
      }
      if (p.y>maxy) {
        maxy = round(p.y);
      }
    }
    w = 1+maxx-x;
    h = 1+maxy-y;
  }
  
  Linea(Linea l){
    pos = new ArrayList <PVector>();
    for(PVector p:l.pos){
      pos.add(p.copy());
    }
    x = l.x;
    y = l.y;
    w = l.w;
    h = l.h;
  }
  void display() {
    beginShape();
    for (int j = 0; j<pos.size()-2; j++) {          
      PVector a = pos.get(j);
      PVector b = pos.get(j+1);
      PVector c = pos.get(j+2);
      PVector ancla1 = PVector.lerp(a, b, 0.5);
      PVector ancla2 = PVector.lerp(b, c, 0.5);
      if(random(1)<0){
        bezier(ancla1.x, ancla1.y, b.x, b.y, b.x, b.y, ancla2.x, ancla2.y);
      }
      if (j==0) {
        line(a.x, a.y, ancla1.x, ancla1.y);
      }
      if (j == pos.size()-3) {
        line(ancla2.x, ancla2.y, pos.get(pos.size()-1).x, pos.get(pos.size()-1).y);
      }
    }
    endShape();
  }
  
  void render() {
    beginShape();
    for (int j = 0; j<pos.size()-2; j++) {          
      PVector a = pos.get(j);
      PVector b = pos.get(j+1);
      PVector c = pos.get(j+2);
      PVector ancla1 = PVector.lerp(a, b, 0.5);
      PVector ancla2 = PVector.lerp(b, c, 0.5);
      //if(random(1)<0.75){
      bezier(ancla1.x, ancla1.y, b.x, b.y, b.x, b.y, ancla2.x, ancla2.y);
      //}
      if (j==0) {
        line(a.x, a.y, ancla1.x, ancla1.y);
      }
      if (j == pos.size()-3) {
        line(ancla2.x, ancla2.y, pos.get(pos.size()-1).x, pos.get(pos.size()-1).y);
      }
    }
    endShape();
  } 
}

Imagen foo;
OsciladorIr ro ;
  OsciladorIr ve;
  OsciladorIr az;
ArrayList <PImage> texturas;
PImage fondo;
void setup() {
  fondo = loadImage("gwl.jpg");
  size(800, 800);
  background(255);
  foo = new Imagen("leibnitz162428.txt");
  fondo.resize(800,800); 
  for(int i = 0; i<500; i++){
    
      foo.display(random(width),random(height),random(TWO_PI),random(0.2,0.5),0);

  }
  
}
