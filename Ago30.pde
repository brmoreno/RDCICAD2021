PImage imagen;
PImage imagenp;

class OsciladorIr{
  float inicio[];
  float tam[];
  float amp[];
  float min;
  float max;
  int n;
  //
  OsciladorIr(int n_){
    n = n_;
    inicio = new float[n];
    tam = new float [n];
    amp = new float [n];
    for(int i = 0 ; i<n; i++){
      inicio[i] = random(TWO_PI);
      amp[i] = random(-2,2);
      tam[i] = random(TWO_PI/20,TWO_PI);
    }
    
    min = 0;
    max = 0;
    for (int i = 0 ; i<n; i++){
      float valorCentro = inicio[i] + tam[i]/2;
      float val = valor(valorCentro);
      if (min < val){
        min = val;
      }
      
      if(max>val){
        max = val;
      }
    }
  }
  
  float valor(float v_){
    float v = v_%TWO_PI;
    float valor = 0;
    for (int i = 0 ; i< n ; i++){
      float puntoInicio = inicio[i];
      float puntoFinal = inicio[i] + tam[i];
      if(v>puntoInicio && v<puntoFinal){
        valor += sin(map(v,puntoInicio,puntoFinal, 0,PI))*amp[i]; 
      }
      if(puntoFinal>TWO_PI&& v<puntoFinal%TWO_PI){
        valor += sin(map(v,puntoInicio-TWO_PI,puntoFinal%TWO_PI, 0,PI))*amp[i];
      }
    }
    
    return valor;
  }
  
  float valor0255(float v_){
    return map(valor(map(v_,0,255,0,TWO_PI)),min,max,0,255);
  }
  
  float valor55(float v_){
    return map(valor(map(v_,0,255,0,TWO_PI)),min,max,-55,55);
  }
}


OsciladorIr rx;
OsciladorIr gx;
OsciladorIr bx;


void setup(){
  rx = new OsciladorIr(30);
  gx = new OsciladorIr(30);
  bx = new OsciladorIr(30);
  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);
  imagenp = imagen.copy();
  
  imagenp.loadPixels();
  for(int i = 0; i<imagenp.pixels.length;i++){
    
    int colorInicial = imagen.pixels[i];
    
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
    imagenp.pixels[i] = colorFinal;
  }
  imagenp.updatePixels();  
  noStroke();
  int tam = 10;
 
    for(int i = 0; i < imagen.width; i+= tam){
      for(int j = 0; j<imagen.height; j+= tam){
          
          color coriginal = eligeAleatorio(i,j,tam,imagen);
          color cpro = eligeAleatorio(i,j,tam,imagenp);
          color uno = coriginal;
          color dos = cpro;
          if (random(1)<0.5){
            uno = cpro;
            dos = coriginal;
          }
          fill(uno);
          rect(i,j,tam,tam);
          fill(dos);
          rect(i+tam/4,j+tam/4,tam/2,tam/2);
        
      }
    }
  
  saveFrame("foo"+hour()+minute()+second()+".jpg");
}



color eligeAleatorio(int i_, int j_, int tam_, PImage p){
  int x = constrain(i_+ceil(random(tam_)),0,p.width-1);
  int y = constrain(j_+ ceil(random(tam_)),0,p.height-1);
 color c = p.get(x,y);
 return c;
}

color colorPromedio(int i_, int j_, int tam_){
  int rojo = 0;
  int verde = 0;
  int azul = 0;
  int vi = 0;
  for(int i = i_; i< i_+tam_&& i<imagen.width; i++){
    for(int j = j_ ; j< j_+tam_ && j < imagen.height; j++){
      color colorInicial=imagen.get(i,j);
       rojo += (colorInicial>>16) & 0XFF;
       verde += (colorInicial>>8) & 0XFF;
       azul += colorInicial & 0XFF;
       vi++;
    }
  }
  
  int valorRojo = rojo/(vi);
  int valorVerde = verde/(vi);
  int valorAzul = azul/(vi);
  int valorAlpha = 255;
  color colorFinal = (valorAlpha<<24)|(valorRojo<<16)|(valorVerde<<8)|valorAzul;
  return colorFinal;
}
