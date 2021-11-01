class ContourColor{
  Contour c;
  color col;
  
  ContourColor( Contour c_, color col_){
    c = c_;
    col = col_;
  }
}

Comparator<ContourColor> VEC_CMP = new Comparator<ContourColor>() {
  int compare(final ContourColor a, final ContourColor b) {
    return
      Float.compare(a.c.area(), b.c.area());
  }
};


import gab.opencv.*;
import java.awt.*;
import java.util.Arrays;
import java.util.Comparator;

PImage imagen;
PImage poster;
PImage ppal;
PImage textura;
OpenCV opencv;
ArrayList <ContourColor> losContours;
void setup() {
  background(255);
  
  size(750, 498,P2D);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750, 498); 
  textura = loadImage("textura.jpg");
  textura.filter(GRAY);
  for(int i = 0; i<textura.pixels.length;i++){
    color c = textura.pixels[i];
    float b = blue(c);
    float fin = map(b,0,255,100,255);
    textura.pixels[i] = color(fin);
  }
  opencv = new OpenCV(this, imagen);
  losContours = new ArrayList <ContourColor>();
  poster = imagen.copy();
  poster.filter(POSTERIZE,5);
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
    opencv.dilate();
    opencv.erode();
    ArrayList <Contour> prov = opencv.findContours(true, true);
    for(Contour c: prov){
      if(c.area()>30){
        losContours.add(new ContourColor(c,valorCompara));
      }
    }
  }
  println(losContours.size());
  losContours.sort(VEC_CMP.reversed());
  textureMode(IMAGE);
  for (int i = 0; i<losContours.size(); i++ ) {
      losContours.get(i).c.setPolygonApproximationFactor(3);
      ArrayList <PVector> puntos;
      puntos = losContours.get(i).c.getPolygonApproximation().getPoints();
      Rectangle r = losContours.get(i).c.getBoundingBox();
      PGraphics mascara = createGraphics(r.width,r.height);
      PImage text = textura.get(0,0,r.width,r.height);
      mascara.beginDraw();
      mascara.background(0);
      mascara.fill(255);
      mascara.noStroke();
      mascara.beginShape();      
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
            mascara.vertex(pos[0].x-r.x, pos[0].y-r.y);
          }
          mascara.bezierVertex(pos[1].x-r.x, pos[1].y-r.y, pos[1].x-r.x, pos[1].y-r.y, dostres.x-r.x, dostres.y-r.y);
        }
      }
      mascara.endShape();
      mascara.endDraw();
      color col = losContours.get(i).col;
      float vr = red(col);
      float vg = green(col);
      float vb = blue(col);
      float ran = random(1);
      float var = random(-100,100);
      float vag = random(-100,100);
      float vab = random(-100,100);
      for(int k = 0 ; k<text.width;k++){
        for(int l = 0; l<text.height; l++){
          if(ran < 0.5){
            if(k%3 != 0){
              text.pixels[k+(l*text.width)]= col;
            }
            else{
              text.pixels[k+(l*text.width)]= color(vr-var,vg-vag,vb-vab);
            }
          }
          else{
            if(l%3 != 0){
              text.pixels[k+(l*text.width)]= col;
            }
            else{
              text.pixels[k+(l*text.width)]= color(vr-var,vg-vag,vb-vab);
            }
          }
          
        }
      }
      
      text.mask(mascara);
      image(text,r.x,r.y);
  }  
}

color colorPromedioContour(Contour c) {
  Rectangle r = c.getBoundingBox();
  int vr, vg, vb, cuantos;
  vr = vg = vb = cuantos = 0;
  for (int i = r.x; i<r.x+r.width; i++) {
    for (int j = r.y; j<r.y+r.height; j++) {
      if (c.containsPoint(i, j)) {
        vr += red(imagen.get(i, j));
        vg += green(imagen.get(i, j));
        vb += blue(imagen.get(i, j));
        cuantos++;
      }
    }
  }
  if (cuantos == 0) {
    cuantos = 1;
  }
  color col = color(vr/cuantos, vg/cuantos, vb/cuantos);     
  return col;
}
