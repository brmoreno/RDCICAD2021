class ContourColor{
  Contour c;
  color col;
  PGraphics pg;
  
  ContourColor( Contour c_, color col_){
    c = c_;
    col = col_;
  }  
}
class Contour2{
  ArrayList <PVector> pos;
  color col;
  color prom;
  int x,y,w,h;
  PGraphics pg;
  boolean activo = true;
  boolean block = false;
  Contour2(ArrayList <PVector> pos_, color col_){
    pos = pos_;
    col = col_;
    x = round(pos.get(0).x);
    y = round(pos.get(0).y);
    int maxx = round(pos.get(0).x);
    int maxy = round(pos.get(0).y);
    for(PVector p:pos){
      if(p.x<x){
        x = round(p.x);
      }
      if(p.y<y){
        y = round(p.y);
      }
      if(p.x>maxx){
        maxx = round(p.x);
      }
      if(p.y>maxy){
        maxy = round(p.y);
      }
    }
    w = 1+maxx-x;
    h = 1+maxy-y;
    
    pg = createGraphics(w,h);
    pg.beginDraw();
    pg.noStroke();
    pg.fill(col);
    pg.beginShape();
    for (int j = 0; j< pos.size(); j++) {
        if (pos.size()>2) {
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
          if (j==0) {
            pg.vertex(posn[0].x-x, posn[0].y-y);
          }
          pg.bezierVertex(posn[1].x-x, posn[1].y-y, posn[1].x-x, posn[1].y-y, dostres.x-x, dostres.y-y);
        }
      }
    
    pg.endShape();
    pg.endDraw();
    int rojo = 0;
    int verde = 0;
    int azul =0;
    int n = 0;
    for(int i = 0; i<pg.width;i++){
      for(int j = 0; j<pg.height; j++){
        color c = pg.pixels[i+j*pg.width];
        if(c == col){
          color c2 = imagen.get(x+i,y+j);
          rojo += red(c2);
          verde += green(c2);
          azul += blue(c2);
          n++;
        }
      }
    }
    
    if (n==0){
      n=1;
    }
    prom = color(rojo/n,verde/n,azul/n);
  }
  
  void display(){
    if (activo){
    image(pg,x,y);
    }
  }
  
  void selected(){
    noStroke();
    fill(0,255,0);
    beginShape();
    for (int j = 0; j< pos.size(); j++) {
        if (pos.size()>2) {
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
          if (j==0) {
            vertex(posn[0].x, posn[0].y);
          }
          bezierVertex(posn[1].x, posn[1].y, posn[1].x, posn[1].y, dostres.x, dostres.y);
        }
      }
    endShape();
  }
}

Comparator<ContourColor> VEC_CMP = new Comparator<ContourColor>() {
  int compare(final ContourColor a, final ContourColor b) {
    return
      Float.compare(a.c.area(), b.c.area());
  }
};

class contourLinea{
  ArrayList <PVector> puntos;
  int x,y,w,h;
  boolean activo = true;
  boolean block = false;
  contourLinea(ArrayList <PVector> puntos_){
    puntos = puntos_;
    x = round(puntos.get(0).x);
    y = round(puntos.get(0).y);
    int maxx = round(puntos.get(0).x);
    int maxy = round(puntos.get(0).y);
    for(PVector p:puntos){
      if(p.x<x){
        x = round(p.x);
      }
      if(p.y<y){
        y = round(p.y);
      }
      if(p.x>maxx){
        maxx = round(p.x);
      }
      if(p.y>maxy){
        maxy = round(p.y);
      }
    }
    w = 1+maxx-x;
    h = 1+maxy-y;
  }
  
  void display(){
    if (activo){
      if(puntos.size()<=2){
        PVector a = puntos.get(0);
        PVector b = puntos.get(1);
        stroke(0);
        strokeWeight(1);
        line(a.x,a.y,b.x,b.y);
      }
      else {
        PVector u = puntos.get(0);
        PVector v = puntos.get(1);
        stroke(0);
        strokeWeight(1);
        line(u.x,u.y,v.x,v.y);
        u = puntos.get(puntos.size()-1);
        v = puntos.get(puntos.size()-2);
        line(u.x,u.y,v.x,v.y);
        for (int i = 0; i<puntos.size()-2;i++){   
          PVector a = puntos.get(i);
          PVector b = puntos.get(i+1);
          PVector c = puntos.get(i+2);
          PVector ancla1 = PVector.lerp(a,b,0.5);
          PVector ancla2 = PVector.lerp(b,c,0.5);
          stroke(0);
          strokeWeight(1);
          bezier(ancla1.x,ancla1.y,b.x,b.y,b.x,b.y,ancla2.x,ancla2.y);
        }
      }
    }
  }
  
  void over(){
    for (int i = 0; i<puntos.size()-1;i++){
      PVector a = puntos.get(i);
      PVector b = puntos.get(i+1);
      strokeWeight(2);
      stroke(255,0,0);
      line(a.x,a.y,b.x,b.y);
      ellipse(a.x,a.y,2,2);
      ellipse(b.x,b.y,2,2);
    }
  }
}

import gab.opencv.*;
import java.awt.*;
import java.util.Arrays;
import java.util.Comparator;

PImage imagen;
PImage imagen2;
PImage poster;
PGraphics corte;
PGraphics corte2;
PImage primerC;
OpenCV opencv;
ArrayList <ContourColor> losContours;
ArrayList<Contour2> cts;
ArrayList <Contour> lims;
ArrayList <Contour2> undos;
ArrayList <contourLinea> lins;
ArrayList <contourLinea> dostres;
boolean flagIncluye = false;
void setup() {
  background(255,0,0);
  size(750, 498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750, 498); 
  imagen2 = imagen.copy();
  opencv = new OpenCV(this, imagen);
  corte = createGraphics(width,height);
  losContours = new ArrayList <ContourColor>();
  cts = new ArrayList <Contour2>();
  undos = new ArrayList <Contour2>();
  primerC = imagen.copy();
  lins = new ArrayList <contourLinea>() ;
  dostres = new ArrayList <contourLinea>() ;
}

int paso = 0;


void draw(){
  background(255);
  switch(paso){
    case 0:
      primerPaso();
    break;
    case 1:
      segundoPaso();
    break;
    case 2:
      tercerPaso(4,2,1);
    break;
    case 3:
      tercerPaso(7,1,1);
    break;
    case 4:
      cuartoPaso();
    break;
    case 5: 
      quintoPaso();
    break;
    case 6:
      sextoPaso();
    break;
    case 7:
      septimoPaso();
    break;
  }
}

void primerPaso(){
  image(imagen,0,0);
  image(corte,0,0);
  corte.beginDraw();
  corte.noStroke();
  corte.fill(255);
  if(mousePressed){
    corte.ellipse(mouseX,mouseY,10,10);
  }
  corte.endDraw();
  if (keyPressed){
    if(key == 'z'){
      corte.beginDraw();
      corte.rect(0,0,width,height);
      corte.endDraw();
    }
    if(key == 'x'){
      flagIncluye = true;
    }
    paso++;
  }
}

void segundoPaso(){
  if (!flagIncluye){
  PImage imagenCorta = corte.get();
    opencv.loadImage(imagenCorta);
    ArrayList <Contour> contours = opencv.findContours();
    corte2 = createGraphics(width,height);
    corte2.beginDraw();
    for (Contour c: contours){
      corte2.fill(0);
      corte2.noStroke();
      ArrayList <PVector> pos = c.getPoints();
      corte2.beginShape();
      for(PVector p:pos){
        corte2.vertex(p.x,p.y);
      }
      corte2.endShape();
    }
    corte2.endDraw(); 
    
    for(int i = 0; i<imagen2.pixels.length;i++){
      if(corte2.pixels[i]== color(0)){
        imagen2.pixels[i] = imagen.pixels[i];
      }
      else{
        imagen2.pixels[i] = 0;
      }
    }
    corte2.save("foo.png");
    }
    else{
      PImage preCorte = loadImage("foo.png");
      corte2 = createGraphics(width,height);
      corte2.beginDraw();
      corte2.image(preCorte,0,0);
      corte2.endDraw();
      for(int i = 0; i<imagen2.pixels.length;i++){
      if(preCorte.pixels[i]== color(0)){
        imagen2.pixels[i] = imagen.pixels[i];
      }
      else{
        imagen2.pixels[i] = 0;
      }
    }
      
    }
    paso++; 
    
}

void tercerPaso( int pv_, int n1, int n2){
  poster = imagen2.copy();
  poster.filter(POSTERIZE,pv_);
  IntList losColores = new IntList();;
  for(int i = 0 ; i<poster.pixels.length; i++){
    int ColorPix = poster.pixels[i];
    if(!losColores.hasValue(ColorPix)){
      losColores.append(ColorPix);
    }
  }
  PImage analisis = poster.copy();
  for(int i = 0; i<losColores.size(); i++){
    color valorCompara = losColores.get(i);
    for(int j = 0; j<poster.pixels.length; j++){
      if(poster.pixels[j] == valorCompara){
        analisis.pixels[j] = color(255);
      }
      else{
        analisis.pixels[j] = color(0);        
      }
    }
    opencv.loadImage(analisis);
    for(int k = 0; k<n1; k++){
    opencv.dilate();
    }
    for(int k = 0; k<n2; k++){
    opencv.erode();
    }
    ArrayList <Contour> prov = opencv.findContours(true, true);
    for(Contour c: prov){
      ArrayList <PVector> pos = c.getPoints();
      float inOut = 0;
      for(PVector p:pos){
        color elColor = corte2.get(round(p.x),round(p.y));
        if(elColor == color(0)){
          inOut++;
        }
      }
      if(inOut/pos.size()>0.6){
        losContours.add(new ContourColor(c,valorCompara));
      }
    }
  }
  losContours.sort(VEC_CMP);
  paso++;
}

void cuartoPaso(){
  for (int i = 0; i<losContours.size(); i++ ) {
      losContours.get(i).c.setPolygonApproximationFactor(2);
      ArrayList <PVector> puntos;
      puntos = losContours.get(i).c.getPolygonApproximation().getPoints();
      for(int j = puntos.size()-1;j>=0;j--){
        color col = corte2.get(round(puntos.get(j).x),round(puntos.get(j).y));
        if(col != color(0)){
          puntos.remove(j);
        }
      }
      if (puntos.size()>2){
      cts.add(new Contour2(puntos,losContours.get(i).col));  
      }
  } 
    paso++;
}

void quintoPaso(){
  for(int i = cts.size()-1;i>=0; i--){
      Contour2 c = cts.get(i);
      c.display();
      if(mouseX>c.x&&mouseX<c.x+c.w&&mouseY>c.y&&mouseY<c.y+c.h){
        color col = c.pg.get(mouseX-c.x,mouseY-c.y);
        if(col != 0 && c.activo == true){
          c.selected();
          if(mousePressed && c.block == false){
            c.activo=false;
            undos.add(c);
          }
          if (keyPressed && key == 'b'){
            c.block = true;
            keyPressed = false;
          }
        }
      }
    }
    if(keyPressed && key=='q'){
      paso++;
      loadPixels();
      primerC.pixels=pixels;
      keyPressed = false;
    }
    if (keyPressed && key=='z'&& undos.size()>0){
      undos.get(undos.size()-1).activo = true;
      undos.remove(undos.size()-1);
      keyPressed = false;
    }
    if (keyPressed && key=='u'){
      for (Contour2 c: cts){
        c.block = false;
      }
      keyPressed = false;
    }
}

void sextoPaso(){
  background(255,0,0);
    image(primerC,0,0);
    opencv.loadImage(imagen);
    opencv.findCannyEdges(mouseX,mouseY);
    lims = opencv.findContours();
    for(Contour c:lims){
      stroke(0);
      noFill();
      Rectangle r = c.getBoundingBox();
      int px = r.x+r.width/2;
      int py = r.y+r.height/2;
      if(corte2.get(px,py)==color(0) ||corte2.get(r.x,r.y)==color(0) ||corte2.get(r.x+r.width,r.y+r.height)==color(0)||corte2.get(r.x,r.y+r.height)==color(0)||corte2.get(r.x+r.width,r.y)==color(0)){
        c.setPolygonApproximationFactor(3);
      ArrayList <PVector> puntos;
      puntos = c.getPolygonApproximation().getPoints();
      beginShape();
      for (int j = 0; j< puntos.size(); j++) {
        if (puntos.size()>2) {
          int n [] = {j, j+1, j+2};
          if (j == puntos.size()-2) {
            n[2] = 0;
          }
          if (j == puntos.size()-1) {
            n[1] = 0;
            n[2] = 1;
          }
          PVector pos[] = new PVector[3];
          for (int k = 0; k<3; k++) {
            pos[k] = puntos.get(n[k]);
          }
          PVector dostres = PVector.lerp(pos[1], pos[2], 0.5); 
          if (j==0) {
            vertex(pos[0].x, pos[0].y);
          }
          bezierVertex(pos[1].x, pos[1].y, pos[1].x, pos[1].y, dostres.x, dostres.y);
        }
      }
      endShape();
      }
    }
    
    if(keyPressed){
      for(Contour c:lims){
        Rectangle r = c.getBoundingBox();
        int px = r.x+r.width/2;
        int py = r.y+r.height/2;
        if(corte2.get(px,py)==color(0) ||corte2.get(r.x,r.y)==color(0) ||corte2.get(r.x+r.width,r.y+r.height)==color(0)||corte2.get(r.x,r.y+r.height)==color(0)||corte2.get(r.x+r.width,r.y)==color(0)){
          c.setPolygonApproximationFactor(3);
          ArrayList <PVector> puntos;
          puntos = c.getPolygonApproximation().getPoints();
          
          for(int i=puntos.size()-1;i>=0;i--){
            PVector pos = puntos.get(i);
            color cl = corte2.get(round(pos.x),round(pos.y)); 
            if(cl== 0){
              puntos.remove(i);
            }
          }
          
          if(puntos.size()>2){
            ArrayList <PVector>repuntos = new ArrayList<PVector>();
            for(int i = 0; i<puntos.size()-1;i++){
              PVector uno = puntos.get(i);
              PVector dos = puntos.get(i+1);
              PVector medio = PVector.lerp(uno,dos,0.5);
              color pm = corte2.get(round(medio.x),round(medio.y));
              if(pm == color (0)){
                repuntos.add(uno);
              }
              else{
                if(repuntos.size()>2){
                  repuntos.add(uno);
                  lins.add(new contourLinea(repuntos));
                }
                repuntos = new ArrayList<PVector>();
              }
            }
            if(repuntos.size()>2){
              lins.add(new contourLinea(repuntos));
            }
          }
        }      
      }
    paso++;
  }
}

void septimoPaso(){
  background(0,255,0);
      image(primerC,0,0);
      for(contourLinea cl:lins){
        cl.display();
        if(mouseX>cl.x&&mouseX<cl.x+cl.w&&mouseY>cl.y&&mouseY<cl.y+cl.h){
          for(PVector p:cl.puntos){
            float distancia = dist(mouseX,mouseY,p.x,p.y);
            if(distancia <10 && cl.activo == true){
              cl.over();
              if(mousePressed & cl.block == false){
                cl.activo = false;
                dostres.add(cl);
              }
              if(keyPressed && key =='b'){
                cl.block = true;
                keyPressed = false;
              }
            }
          }
        }
      }
      if(keyPressed && key == 'z' && dostres.size()>0){
        dostres.get(dostres.size()-1).activo = true;
        dostres.remove(dostres.size()-1);
        keyPressed = false;
      }
      
      if(keyPressed && key == 'u'){
        for(contourLinea cl:lins){
          cl.block = false;
        }
        keyPressed = false;
      }
      
      if(keyPressed && key == 'q'){
        PrintWriter texto = createWriter("foo.txt");
        for(int i = cts.size()-1; i>= 0; i--){
          Contour2 c = cts.get(i);
          if (c.activo){
          texto.println(c.col + " " +c.prom);
          texto.println(c.pos);
          }
        }
        for(int i = lins.size()-1;i>=0;i--){
          contourLinea l = lins.get(i);
          if(l.activo){
            texto.println(1);
            texto.println(l.puntos);
          }
        }
        texto.flush();
        texto.close();
        exit();
      }
}
