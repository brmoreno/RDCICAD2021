PImage imagen;


void setup(){  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);  
  background(255); 
  noStroke();
  int base = 100;
  noStroke();
  for(int i = 0; i<width; i+=base){
    int offset = (i/base)%2==1? -base/2:0;
    for(int j = 0 +offset; j<height; j+= base){
      int ran = ceil(random(1,6));
      for(int k = 0; k<ran; k++){
        for(int l = 0; l<ran; l++){
          fill(colorPromedio(i+k*base/ran, j+l*base/ran, base/ran, base/ran,imagen));
          rect(i+k*base*1f/ran, j+l*base*1f/ran, base*1f/ran, base*1f/ran);
        }
      }
      
    }
  }
  
  saveFrame("foo"+hour()+"_"+minute()+"_"+second()+".png");
}



color colorPromedio(int i_, int j_, int w_, int h_, PImage imagen_){
  int rojo = 0;
  int verde = 0;
  int azul = 0;
  int vi = 0;
  for(int i = i_>=0?i_:0; i< i_+w_&& i<imagen_.width; i++){
    for(int j = j_>=0?j_:0 ; j< j_+h_ && j < imagen_.height; j++){
      color colorInicial=imagen_.get(i,j);
       rojo += (colorInicial>>16) & 0XFF;
       verde += (colorInicial>>8) & 0XFF;
       azul += colorInicial & 0XFF;
       vi++;
    }
  }
  if (vi == 0){
    vi =1;
  }
  int valorRojo = rojo/(vi);
  int valorVerde = verde/(vi);
  int valorAzul = azul/(vi);
  int valorAlpha = 255;
  color colorFinal = (valorAlpha<<24)|(valorRojo<<16)|(valorVerde<<8)|valorAzul;
  return colorFinal;
}

color eligeAleatorio(int i_, int j_, int tam_, PImage p){
  int x = constrain(i_+ceil(random(tam_)),0,p.width-1);
  int y = constrain(j_+ ceil(random(tam_)),0,p.height-1);
 color c = p.get(x,y);
 return c;
}
