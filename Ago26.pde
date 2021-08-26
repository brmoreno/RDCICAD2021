PImage imagen;

void setup(){
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);
  loadPixels();
  for(int i = 0; i<pixels.length;i++){
    
    int colorInicial = imagen.pixels[i];
    
    int rojo = (colorInicial>>16) & 0XFF;
    int verde = (colorInicial>>8) & 0XFF;
    int azul = colorInicial & 0XFF;
    int alpha = (colorInicial>>24)& 0XFF;
    
    // Operamos los colores;
    
    
    
    //limitar el rango de color;
    rojo = constrain(rojo, 0,255);
    azul = constrain(azul, 0,255);
    verde = constrain(verde,0,255);
    alpha = constrain(alpha,0,255);

    //actualizar el color
    int colorFinal = (alpha<<24)|(rojo<<16)|(verde<<8)|azul;
    pixels[i] = colorFinal;
  }
  updatePixels(); 
}
