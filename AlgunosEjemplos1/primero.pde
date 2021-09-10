PImage imagen;
PImage conTresh;

void setup(){  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);  
  conTresh = imagen.copy();  
  background(255); 
  
  int base = 100;
  noStroke();
  for (float i = 1; i>0; i-= 0.1){
  conTresh = imagen.copy();
  conTresh.filter(THRESHOLD,i);
    for (int j = 0; j<width; j+= base*i){
      for (int k = 0; k<height; k+= base*i){
        if (conTresh.get(j,k) == color(0)){
          fill(colorPromedio(j, k, round(base*i), round(base*i)));
          rect(j,k,base*i,base*i);
        }
      }
    }
  }
  
  saveFrame("foo"+hour()+"_"+minute()+"_"+second()+".png");
}


color colorPromedio(int i_, int j_, int w_, int h_){
  int rojo = 0;
  int verde = 0;
  int azul = 0;
  int vi = 0;
  for(int i = i_>=0?i_:0; i< i_+w_&& i<imagen.width; i++){
    for(int j = j_>=0?j_:0 ; j< j_+h_ && j < imagen.height; j++){
      color colorInicial=imagen.get(i,j);
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
