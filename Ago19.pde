class Particula{
  //Atributos;
  float x,y;
  float r;
  float dx,dy;
  color col;
  float fr,dr, ddr;
  
    
  //Constructor;
  Particula(){
    x = random(width);
    y = random(height);
    r = round(random(60,120));
    dx = random(-1,1);
    dy = random(-1,1);
    col = color(random(80),random(80),random(80));
    dr += random(0,0.005);
    fr = r;
    ddr = random(TWO_PI);
  }

  //Métodos;  
  void mover(){
    x += dx; 
    y += dy;
    if(x<-r){
      x = width +r;
    }
    if(x>width+r){
      x= -r;
    }
    if(y<-r){
      y = height +r;
    }
    if(y>height+r){
      y= -r;
    }
  }
  
  void display(){
    ddr += dr;
    r = fr*sin(ddr);
    int hastaX = floor(x+r)<width? floor(x+r):width;
    int hastaY = floor(y+r)<height? floor(y+r):height;
    for(int i = floor(x-r)>0?floor(x-r):0; i< hastaX; i++){
      for(int j = floor(y-r)>0?floor(y-r):0; j< hastaY; j++){
        float distancia = dist(x,y,i,j);
        if(distancia<r){
          float inten = map(distancia,0,r,1,0);
          float rojo = red(pixels[i+j*width]);
          float verde = green(pixels[i+j*width]);
          float azul = blue(pixels[i+j*width]);
          rojo += red(col)*inten;
          verde += green(col)*inten;
          azul += blue(col)*inten;
          pixels[i+j*width] = color(rojo,verde,azul);
        }
      }
    }
  }
}

ArrayList <Particula> particulas;

void setup(){
  size(400,400);
  particulas = new ArrayList <Particula>();
  for (int i = 0; i<200; i++){
    particulas.add(new Particula());
  } 
}

void draw(){
  loadPixels();
  for(int i = 0; i<pixels.length; i++){
    pixels[i] = color(0);
  }
  
  for(Particula p:particulas){
    p.mover();
    p.display();
  }
  updatePixels();
}
