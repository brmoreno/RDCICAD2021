PImage imagen;
PImage imagenp;
ArrayList <Trazo> losTrazos;

void setup(){  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);  
  
  imagenp = imagen.copy();
  imagenp.filter(POSTERIZE,3);
  IntList colores = new IntList();
  imagenp.loadPixels();
  for (int i = 0; i<imagenp.pixels.length;i++){
    int colorPix = imagenp.pixels[i];
    if(!colores.hasValue(colorPix)){
      colores.append(colorPix);
    }
  }
  colores.shuffle();
  
  background(255); 
  losTrazos = new ArrayList<Trazo>();
  IntList posiciones = new IntList();
  int k = 0;
  for(int l = 0; l<colores.size(); l++){
    for(int i = 15; i<width; i+=15 ){
      for(int j = 15; j<height; j+=15 ){
        losTrazos.add(new Trazo(i+random(0),j+random(0),random(15,15),colores.get(l)));
        posiciones.append(k);
        k++;
      }
    }
  
  posiciones.shuffle();
  
    for (int i = 0; i<losTrazos.size();i++){
      for(int j = 0; j<20;j++){
      losTrazos.get(posiciones.get(i)).display();
      }
    }

  }
  
  //saveFrame("foo"+hour()+"_"+minute()+"_"+second()+".png");
}

class Trazo{ 
  PVector pos;
  float a;
  float t;
  color colorActual;
  color referencia;
  float da;
  float alfa;
  Trazo(float x_, float y_, float t_, color re_){
   pos = new PVector(x_,y_);
   a = random(TWO_PI);
   t = t_;
   PVector fin = PVector.fromAngle(a).mult(t).add(pos);
   PVector inicio = PVector.fromAngle(a).mult(t*.80).add(pos);
   colorActual = CPromedioLineal(inicio,fin);
   referencia = re_;
   da = 2f/t;
  }
  
  void display(){
    PVector fin = PVector.fromAngle(a).mult(t).add(pos);
    PVector inicio = PVector.fromAngle(a).mult(t*.80).add(pos);
    color pAct = CPromedioLineal(inicio,fin);
    colorActual = lerpColor(colorActual,pAct,0.1);
    stroke(colorActual,alfa);
    strokeWeight(4);
    line(inicio.x,inicio.y,fin.x,fin.y);
    a+=da;
  }
  
  color CPromedioLineal(PVector de_, PVector a_){
    float r,g,b,sumaAlfa;
    r=g=b=sumaAlfa=0;
    float dist = de_.dist(a_);
    for(float i = 0; i<1; i+= 1f/dist){
      PVector posInt = PVector.lerp(de_,a_,i);
      color c = imagen.get(round(posInt.x),round(posInt.y));
      color refe = imagenp.get(round(posInt.x),round(posInt.y));
      r+= red(c);
      g+= green(c);
      b+= blue(c);
      if(refe == referencia){
        sumaAlfa++;
      }
    }
    alfa = 0;
    if (sumaAlfa>dist/2f){
      alfa = 255*((sumaAlfa-(dist/2f))/(dist/2f));
    }    
    return(color(r/dist,g/dist,b/dist));
  }  
}
