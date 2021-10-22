import gab.opencv.*;
import java.awt.*;
PImage imagen;
OpenCV opencv;
ArrayList <Contour> losContours;
void setup(){
  background(255);
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498); 
  opencv = new OpenCV(this,imagen);
  for(int m = 0; m<5;m++){
  opencv.loadImage(imagen);
  opencv.inRange(m*50,m*50+50);
  //opencv.invert();
  //image(opencv.getOutput(),0,0);
  losContours = opencv.findContours(true,true);
  println(losContours.size());
  for(Contour c:losContours){
     c.setPolygonApproximationFactor(2);
     ArrayList <PVector> puntos;
     puntos = c.getPolygonApproximation().getPoints();
     Rectangle r = c.getBoundingBox();
     //int vr,vg,vb, cuantos;
     //vr = vg = vb = cuantos = 0;
     //for (int i = r.x;i<r.x+r.width;i++){
     //  for(int j = r.y; j<r.y+r.height;j++){
     //    if(c.containsPoint(i,j)){
     //      vr += red(imagen.get(i,j));
     //      vg += green(imagen.get(i,j));
     //      vb += blue(imagen.get(i,j));
     //      cuantos++;
     //    }
     //  }
     //}
     //if (cuantos == 0){
     //  cuantos = 1;
     //}
     //color col = color(vr/cuantos,vg/cuantos,vb/cuantos);
     
     fill(random(255),random(255),0);
     beginShape();
     for (int i = 0; i<puntos.size(); i++){
       PVector p = puntos.get(i);
       vertex(p.x,p.y);
     }
     endShape(CLOSE);
  } 
  }
  
  //saveFrame("foo.png");
}
