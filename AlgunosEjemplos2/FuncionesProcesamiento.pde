PImage imagen;
PImage imagenp;

void setup(){
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);
}

// Pasar pImage y parámetro del Posterizado
PImage edgeFind (PImage imagen_, int n_){
  PImage retorno = imagen_.copy();
  retorno.filter(POSTERIZE, n_);  
  for(int i = 0; i<retorno.pixels.length-width; i++){
    int colorPix = retorno.pixels[i];
    int siguiente = retorno.pixels[i+1];
    int abajo = retorno.pixels[i+width];
    if(colorPix != siguiente || colorPix != abajo){
      retorno.pixels[i] = 1;
    }
  }  
  return retorno;
}

PGraphics distorsionCopyPaste(PImage imagen_, int n_){
  PGraphics retorno = createGraphics(imagen.width, imagen.height);
  retorno.beginDraw();
  retorno.image(imagen_,0,0);
  for(int i = 0; i<n_; i++){
    int px = round(random(0,width-100));
    int py = round(random(0,height-100));
    int t = round(random(50,100));
    float escala = random(0.9,1.1);
    PImage recorte = imagen.get(px,py,t,t);
    PImage mask = recorte.copy();
    for(int j = 0; j<mask.pixels.length; j++){
      int qx = j%mask.width;
      int qy = j/mask.width;
      float distancia = dist(qx,qy,t/2,t/2);
      if(distancia<t/2){        
        mask.pixels[j] = color(map(distancia,0,t/2,255,0));
      }
      else{
        mask.pixels[j] = color(0);
      }
    }
    recorte.mask(mask);
    retorno.pushMatrix();
    retorno.translate(px+random(-20,20),py+random(-20,20));
    retorno.rotate(random(-0.2,0.2));
    retorno.image(recorte,0,0,t*escala,t*escala);   
    retorno.popMatrix();
  }
  retorno.endDraw();  
  return retorno;
}

PImage distorsionNodos(PImage imagen_, int n_){
  PImage retorno = imagen_.copy();
  float px [] = new float[n_];
  float py [] = new float[n_];
  float r [] = new float[n_];
  PVector v[] = new PVector[n_];
  
  for(int i = 0; i<n_; i++){
     px[i] = random(width);
     py[i] = random(height);
     r[i] = random(50,100);
     v[i] = PVector.random2D().mult(random(60,120));
  }
  
  for(int i = 0; i<imagen_.pixels.length; i++){
    int x = i%imagen_.width;
    int y = i/imagen_.width;
    PVector actualiza = new PVector(0,0);
    for(int j = 0; j<n_;j++){
      float distancia = dist(x,y,px[j],py[j]);
      if (distancia < r[j]){
        float intensidad = map(distancia,0,r[j],1,0);
        PVector agrega = v[j].copy().mult(intensidad);
        actualiza.add(agrega);
      }
    }
    retorno.pixels[i] = imagen_.get(x+round(actualiza.x),y+round(actualiza.y));
  }
  return retorno;
}
