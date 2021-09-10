PImage imagen;
PImage conTresh;

void setup(){  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);  
  conTresh = imagen.copy();  
  background(255); 
  
  int base = 50;
  noStroke();
  for (float i = 1; i>0; i-= 0.05){
  conTresh = imagen.copy();
  conTresh.filter(THRESHOLD,i);
    int l = 0;
    for (float j = -base*i; j<height; j+= base*i*0.5){
      l++;
      float offset = l%2==1? -base*i*0.5:0; 
      for (float k = -base*i - offset; k<width - offset; k+= base*i){
        if (conTresh.get(round(k),round(j)) == color(0)){
          fill(colorPromedio(round(k),round(j), round(base*i), round(base*i)));
          circuloide(k+base*i*0.5,j+base*i*0.5,base*i);
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


void circuloide(float x, float y, float t){
  float foo[] = new float[4];
  for(int i= 0 ; i <4; i++){
    foo[i] = random(t/2,t);
  }
  for(int i = 0; i<4; i++){
    int a = i%2==0?i:(i+1)%4;
    int b = i%2==0?(i+1)%4:i;
    arc(x,y,foo[a],foo[b],HALF_PI*i,HALF_PI*(i+1));
  }
}
