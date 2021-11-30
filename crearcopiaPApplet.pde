PImage imagen;
PImage fondo;

void setup() {
  background(255);
  size(750, 498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750, 498); 
  fondo = loadImage("IMG_0091.jpg");
  fondo.resize(750, 498); 
  for(int i = 0 ; i<width; i++){
    for(int j = 0; j<height; j++){
      color c = imagen.get(i,j);
      stroke(c);
      line(i,j,i+random(-50,50),j+random(-50,50));
    }
  }
  
  loadPixels();
  fondo.pixels = pixels;
  
  background(255);
  for(int i = 0; i<width; i+=20){
    for(int j = 0; j<width; j+= 20){
      fill(fondo.get(i,j));
      ellipse(i,j,15,15);
    }
  }  
}
