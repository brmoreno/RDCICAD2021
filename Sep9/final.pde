PImage imagen;
PImage imagenp;
PImage conTresh;
Trazo elTrazo;
ArrayList <Trazo> losTrazos;



void setup(){
  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);
  imagenp = imagenColoresAlt(imagen);
  
  conTresh = imagen.copy();
  
  
  noStroke();
  elTrazo = new Trazo(0,height/2,30);
  losTrazos = new ArrayList <Trazo>();
  for(int i = 0; i<3000; i++){
    losTrazos.add(new Trazo(random(width),random(height),random(5,20)));
  }
  
  background(255); 
  for (float j = 1; j>0; j-= 0.25 ){
    conTresh = imagen.copy();
    conTresh.filter(THRESHOLD,j);
    for(Trazo t:losTrazos){
      for (int i = 0; i<100; i++){         
          t.display();
          t.mover();
      }
    } 
  }
  saveFrame("foo"+hour()+"_"+minute()+"_"+second()+".png");
}


void dibujaProgresivo1(int i_, int j_, int w_, int h_){
  int r = round(random(-50,50));
  int g = round(random(-50,50));
  int b = round(random(-50,50));
  for(int k = 0; k<w_;k+=1){
          color coriginal = colorPromedio(i_,j_,w_-k,h_);
          int rojo = (coriginal>>16) & 0XFF;
          int verde = (coriginal>>8) & 0XFF;
          int azul = coriginal & 0XFF;
          rojo +=r;
          verde += g;
          azul += b;
          fill(rojo,verde,azul);
          rect(i_,j_,w_-k,h_);
  }  
}

void dibujaProgresivo2(int i_, int j_, int w_, int h_){
  int r = round(random(-50,50));
  int g = round(random(-50,50));
  int b = round(random(-50,50));
  for(int k = 0; k<w_;k+=1){
          color coriginal = colorPromedio(i_+k,j_,w_-k,h_);
          fill(coriginal);
          rect(i_+k,j_,w_-k,h_);
  }  
}

void dibujaProgresivo3(int i_, int j_, int w_, int h_){
  int r = round(random(-30,30));
  int g = round(random(-30,30));
  int b = round(random(-30,30));
  for(int k = 0; k<w_;k+=1){
          color coriginal = colorPromedio(i_,j_,w_,h_-k);
          int rojo = (coriginal>>16) & 0XFF;
          int verde = (coriginal>>8) & 0XFF;
          int azul = coriginal & 0XFF;
          rojo +=r;
          verde += g;
          azul += b;
          fill(rojo,verde,azul);
          rect(i_,j_,w_,h_-k);
  }  
}
void dibujaProgresivo4(int i_, int j_, int w_, int h_){
  for(int k = 0; k<w_;k+=1){
          color coriginal = colorPromedio(i_,j_+k,w_,h_-k);
          fill(coriginal);
          rect(i_,j_+k,w_,h_-k);
  }  
}

color eligeAleatorio(int i_, int j_, int tam_, PImage p){
  int x = constrain(i_+ceil(random(tam_)),0,p.width-1);
  int y = constrain(j_+ ceil(random(tam_)),0,p.height-1);
 color c = p.get(x,y);
 return c;
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
