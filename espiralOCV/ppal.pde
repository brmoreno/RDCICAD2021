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
      if(c.x+c.w>maxx){
        maxx = c.x +c.w;
      }
      if(c.y+c.h>maxy){
        maxy = c.y +c.h;
      }
    }   
    for(Linea c:lineas){
      if(c.x<xi){
        xi = c.x;
      }
      if(c.y<yi){
        yi=c.y;
      }
      if(c.x+c.w>maxx){
        maxx = c.x +c.w;
      }
      if(c.y+c.h>maxy){
        maxy = c.y + c.h;
      }
    }   
    w = 1+maxx-xi;
    h = 1+maxy-yi;
  }
  
  void display(float x_, float y_, float r_, float s_, float v_){
    ArrayList <Ctr> copiactrs = new ArrayList <Ctr>();
       
    for(Ctr c:ctrs){
      copiactrs.add(new Ctr(c));
    }
    
    
    for(Ctr c: copiactrs){
      for(PVector p:c.pos){
        p.add(-w/2,-h/2).add(-xi,-yi);
        p.rotate(r_);
        p.mult(s_);
        p.add(x_,y_);
        p.add(random(-v_,v_),random(-v_,v_));
      }
      
      //c.redux(0.75);
      c.escala(random(0.8,1.2));
      //noStroke();
      //fill(c.col);
      //if(random(1)<0.55){
        c.render();
      //}
    
    }
    for(int i = 0; i<1; i++){
    ArrayList <Linea> copialineas = new ArrayList <Linea>(); 
    for(Linea l:lineas){
      copialineas.add(new Linea(l));
    }
    for(Linea l: copialineas){
      for(PVector p:l.pos){
        p.add(-w/2,-h/2).add(-xi,-yi);
        p.rotate(r_);
        p.mult(s_);
        p.add(x_,y_);
        p.add(random(-v_,v_),random(-v_,v_));
      }
      if(random(1)<0.60){
        l.render();
      }
    }
    }
  }
}

class Ctr{
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
    if(pos.size()>0){
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
  
  void escala(float v_){
    setXYWH();
    PVector centro = new PVector(x+w*.5,y+w*0.5);
    for (PVector p:pos){
      p.lerp(centro,1-v_);
    }
  }
  
  void redux(float v_){
    for (int i = pos.size()-1;i>=0; i--){
      if(random(1)>v_){
        pos.remove(i);
      }
    }
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
    if(pos.size()>2){
    pg.beginDraw();
    pg.beginShape();
    pg.noStroke();
    pg.fill(col);
    pg.vertex(pos.get(0).x, pos.get(0).y);
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

      pg.bezierVertex(posn[1].x, posn[1].y, posn[1].x, posn[1].y, dostres.x, dostres.y);
    }
    pg.endShape();
    pg.endDraw();
  }
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
    noFill();
    stroke(0);
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
    setXYWH();
    pg.beginDraw();
    pg.beginShape();
    for (int j = 0; j<pos.size()-2; j++) {          
      PVector a = pos.get(j);
      PVector b = pos.get(j+1);
      PVector c = pos.get(j+2);
      PVector ancla1 = PVector.lerp(a, b, 0.5);
      PVector ancla2 = PVector.lerp(b, c, 0.5);
      pg.strokeWeight(1);
      pg.noFill();

      pg.stroke(0);
      //if(random(1)<0.75){
      pg.bezier(ancla1.x, ancla1.y, b.x, b.y, b.x, b.y, ancla2.x, ancla2.y);
      //}
      if (j==0) {
        pg.line(a.x, a.y, ancla1.x, ancla1.y);
      }
      if (j == pos.size()-3) {
        pg.line(ancla2.x, ancla2.y, pos.get(pos.size()-1).x, pos.get(pos.size()-1).y);
      }
    }
    pg.endShape();
    pg.endDraw();
  } 
  
  void setXYWH(){
    if(pos.size()>0){
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
  }
  
}
Imagen una;
PGraphics pg;
  float r1 = 1;//random(TWO_PI);
  float r2 = 0.02;//random(0.2);;
  float r3 = 0;
  float r4 = 255;
  float g1 = 1;//random(TWO_PI);
  float g2 = 0.02;//random(0.2);;
  float g3 = 0;
  float g4 = 255;
  float b1 = 1;//random(TWO_PI);
  float b2 = 0.02;//random(0.2);
  float b3 = 0;
  float b4 = 255;
  PGraphics textura;
  PImage fuente;
void setup(){
  size(800,800);
  background(255);
  String texto = "ed.txt";
  una = new Imagen(texto);
  pg = createGraphics(width,height);
  pg.beginDraw();
  pg.background(255);
  pg.endDraw();
  float v_ = 0.5;
  for(int i = 0 ; i <40; i++){
    float x = width/2+sin(i*v_)*(400-i*8);
    float y= height/2+cos(i*v_)*(400-i*8);
  una.display(x,y,PI-i*v_,0.5,0);
  }
  background(255);
 
  pg.save(texto +"_"+ hour()+minute()+second()+ ".png");
  image(pg,0,0);
}
