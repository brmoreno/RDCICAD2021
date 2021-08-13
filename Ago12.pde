float x[] = new float [200];
float y[] = new float [200];
int w[] = new int [200];
int h[] = new int [200];
float dx[] = new float [200];
float dy[] = new float [200];
color cols[] = new color[200];

void setup(){
  size(400,400);
  loadPixels();
  for(int i = 0; i<pixels.length; i++){
    pixels[i] = color(255);
    }
  updatePixels(); 
  for(int i = 0; i<200; i++){
    x[i] = random(width);
    y[i] = random(height);
    w[i] = round(random(20,100));
    h[i] = round(random(20,100));
    dx[i] = random(-1,1);
    dy[i] = random(-1,1);
    cols[i] = color(random(80),random(80),random(80));
  }
}

void draw(){
  loadPixels();  
  for(int i = 0; i<pixels.length; i++){
    pixels[i] = color(0);
    }
  
  for(int i = 0; i<200; i++){
    x[i]+=dx[i];
    y[i]+=dy[i];
    if(x[i]<-w[i]){
      x[i] = width;
    }
    if(x[i]>width){
      x[i]= -w[i];
    }
    if(y[i]<-h[i]){
      y[i] = height;
    }
    if(y[i]>height+h[i]){
      y[i]= -h[i];
    }
    //rect(x[i],y[i],w[i],h[i]);
    int hastaX = floor(x[i])+w[i]<width? floor(x[i])+w[i]:width;
    int hastaY = floor(y[i])+ h[i]<height? floor(y[i])+ h[i]:height;
    for(int j = floor(x[i])>0? floor(x[i]):0; j<hastaX; j++){
      for(int k = floor(y[i])>0?floor(y[i]):0; k<hastaY; k++){
        float rojo = red(pixels[j+k*width]);
        float verde = green(pixels[j+k*width]);
        float azul = blue(pixels[j+k*width]);
        rojo += red(cols[i]);
        verde += green(cols[i]);
        azul += blue(cols[i]);
        pixels[j+k*width] = color(rojo,verde,azul);
      }
    }
  }  
 updatePixels();   
}
