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
  opencv.findCannyEdges(187,64);
  ArrayList <Contour> losCs = opencv.findContours();
  noFill();
  stroke(0);
  for(Contour c:losCs){
    c.setPolygonApproximationFactor(3);
    ArrayList <PVector> puntos = c.getPolygonApproximation().getPoints();    
    for (int j = 0; j< puntos.size()-1; j++) {
      PVector actual = puntos.get(j);
      PVector siguiente = puntos.get(j+1);
      float distancia = PVector.dist(actual,siguiente);
      float npasos = distancia/1;
      float tasaCambio = 1f/npasos;
      for (float i = 0; i<=1; i+=tasaCambio){
        PVector pos = PVector.lerp(actual,siguiente,i);
        
        stroke(imagen.get(round(pos.x),round(pos.y)));
        line(pos.x,pos.y,pos.x+random(-5,5),pos.y+random(-5,5));
      }
      
      }
     
  }
}
