import gab.opencv.*;
import java.awt.*;


PImage imagen;
OpenCV opencv;
ArrayList <Contour> losContours;

void setup() {
  background(255);
  size(750, 498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750, 498); 
  opencv = new OpenCV(this, imagen);
  losContours = new ArrayList <Contour>();  
  
  for(int i = 0; i< 180; i+= 5 ){
    opencv.loadImage(imagen);
    opencv.inRange(i,i+5);
    opencv.dilate();
    opencv.erode();
  ArrayList <Contour> prov = opencv.findContours(true, true);
    for(Contour c: prov){
      losContours.add(c);
    }  
  }
 
  for (int i = 0; i<losContours.size(); i++ ) {
      losContours.get(i).setPolygonApproximationFactor(random(1,5));
      ArrayList <PVector> puntos;
      
      puntos = losContours.get(i).getPolygonApproximation().getPoints();
      for(PVector p:puntos){
        p.add(random(-2,2),random(-2,2));
      }
      stroke(0);
      strokeWeight(random(0.2,1.5));
      noFill();
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
