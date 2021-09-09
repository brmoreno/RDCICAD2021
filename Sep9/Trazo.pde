class Trazo{ 
  float x,y,dx,dy,t;
  float tInicial;
  OsciladorIr dt;
  float contador;
  PVector dire;
  OsciladorIr ddire;
  float contaddire;
  float deDondeTomacolor;
  float rojo,verde,azul;
  color colorActual;
  float contadortrazo;
  
  Trazo(float x_, float y_, float t_ ){
    x = x_;
    y = y_;
    t = t_;
    dx = random(-1,1);
    dy = random(-1,1);
    dt = new OsciladorIr(6);
    tInicial= t_;
    dire = new PVector(2,0);
    ddire = new OsciladorIr(8);
    deDondeTomacolor = random(1);
    rojo = random(-20,20);
    verde = random(-20,20);
    azul = random(-20,20);
    colorActual = imagen.get(round(x),round(y));
  }
  
  void display(){
    noStroke();
    colorProgresivo();
    noStroke();
    stroke(red(colorActual)+rojo,green(colorActual)+verde,blue(colorActual)+azul);
    strokeWeight(3);
    contador += 0.01;
    //PVector tam = new PVector(1,0).mult(t);
    //tam.rotate(contador);    
    //line(x,y,x+tam.x,y+tam.y);
    t = map(dt.valor(contador),dt.min,dt.max,0,tInicial);
    line(x,y,x+t,y+t);
  }
  
  void colorProgresivo(){
    int x_ = round(x);
    int y_ = round(y);
    color c = imagen.get(x_,y_);
    colorActual = lerpColor(colorActual,c,0.02);
  }
  
  color colorPromedioRadial(PImage p_){
    color promedio = 0;
    int rojo = 0;
    int verde = 0;
    int azul = 0;
    int vi = 0;
    int x_ = round(x);
    int y_ = round(y);
    int r = round(t/2);
    for(int i = x_-r>=0?x_-r:0;  i< x_+r&& i<p_.width;  i++){
      for(int j = y_-r>=0?y_-r:0 ; j< y_+r && j < p_.height; j++){
        float distancia = dist(i,j,x,y);
        if(distancia < r){
          color colorInicial=p_.get(i,j);
           rojo += (colorInicial>>16) & 0XFF;
           verde += (colorInicial>>8) & 0XFF;
           azul += colorInicial & 0XFF;
           vi++;
        }
      }
    }
    if (vi == 0){
      vi =1;
    }
    int valorRojo = rojo/(vi);
    int valorVerde = verde/(vi);
    int valorAzul = azul/(vi);
    int valorAlpha = 255;
    promedio = (valorAlpha<<24)|(valorRojo<<16)|(valorVerde<<8)|valorAzul;
    return promedio;
  }
  
  void mover(){
    contaddire += 0.01;
    float angulo = map(ddire.valor(contaddire),ddire.min,ddire.max,-TWO_PI,TWO_PI);
    dire = PVector.fromAngle(angulo);
    x += dire.x;
    y += dire.y;
  }  
}
