PImage imagen;
PImage imagenp;

void setup(){  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);  
  imagenp = imagenColoresAlt(imagen);
  background(255); 
  noStroke();
  int base = 20;
  noStroke();
  for(int i = 0; i<width; i+=base){
    for(int j = 0; j<height; j+= base){
      float ran = random(1);
      if (ran<0.33){
        fill(colorPromedio( i, j, base, base,imagenp));
        rect(i,j,base,base);
        fill(colorPromedio( i, j, base, base,imagen));
        rect(i+base*0.1,j+base*0.1,base*.8,base*.8);
      }
      else if (ran<0.66){
        fill(colorPromedio( i, j, base, base,imagen));
        rect(i,j,base,base);
        fill(colorPromedio( i, j, base, base,imagenp));
        rect(i+base*0.4,j+base*0.4,base*.2,base*.2);
      }
      else{
        fill(colorPromedio( i, j, base, base,imagen));
        rect(i,j,base,base);
        fill(colorPromedio( i, j, base, base,imagenp));
        rect(i+base*0.2,j+base*0.2,base*.6,base*.6);
        fill(colorPromedio( i, j, base, base,imagen));
        rect(i+base*0.3,j+base*0.3,base*.4,base*.4);
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

PImage imagenColoresAlt( PImage imagen_){
  OsciladorIr rx;
  OsciladorIr gx;
  OsciladorIr bx;
  rx = new OsciladorIr(30);
  gx = new OsciladorIr(30);
  bx = new OsciladorIr(30); 
  PImage imagenp_ = imagen_.copy(); 
  imagenp_.loadPixels();
  for(int i = 0; i<imagenp_.pixels.length;i++){
    int colorInicial = imagen_.pixels[i];
    int rojo = (colorInicial>>16) & 0XFF;
    int verde = (colorInicial>>8) & 0XFF;
    int azul = colorInicial & 0XFF;
    int alpha = (colorInicial>>24)& 0XFF;
    
    // Operamos los colores;
    int ri = round(rx.valor0255(rojo));
    int vi = round(gx.valor0255(verde));
    int az = round(bx.valor0255(azul));
    
    //limitar el rango de color;
    rojo = constrain(ri, 0,255);
    azul = constrain(az, 0,255);
    verde = constrain(vi,0,255);
    alpha = constrain(alpha,0,255);

    //actualizar el color
    int colorFinal = (alpha<<24)|(rojo<<16)|(verde<<8)|azul;
    imagenp_.pixels[i] = colorFinal;
  }
  
  imagenp_.updatePixels(); 
  return imagenp_;
}
