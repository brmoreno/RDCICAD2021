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
  size(410, 550);
  imagen = loadImage("gwl.jpg");
  //imagen.resize(750, 498); 
  //imagen.filter(GRAY);
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
      tercerPaso(7,1,1);
      paso++;
    break;
    case 3:
      cuartoPaso();
    break;
    case 4: 
      quintoPaso();
    break;
    case 5:
      sextoPaso();
    break;
    case 6:
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
        PrintWriter texto = createWriter("leibnitz"+hour()+minute()+second()+".txt");
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
