PImage imagen;
ArrayList <Trazo> losTrazos;

void setup(){  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);  
 
  background(255); 
  losTrazos = new ArrayList<Trazo>();
  IntList posiciones = new IntList();
  int k = 0;
  for(int i = 30; i<width; i+=30 ){
    for(int j = 30; j<height; j+=30 ){
      losTrazos.add(new Trazo(i,j,random(20,50)));
      posiciones.append(k);
      k++;
    }
  }
  posiciones.shuffle();
  
    for (int i = 0; i<losTrazos.size();i++){
      for(int j = 0; j<80;j++){
      losTrazos.get(posiciones.get(i)).display();
      }
    }

  losTrazos = new ArrayList<Trazo>();
  posiciones = new IntList();
  k = 0;
  for(int i = 15; i<width; i+=15 ){
    for(int j = 15; j<height; j+=15 ){
      losTrazos.add(new Trazo(i+random(-5,5),j+random(-5,5),random(1,5)));
      posiciones.append(k);
      k++;
    }
  }
  posiciones.shuffle();
  
    for (int i = 0; i<losTrazos.size();i++){
      for(int j = 0; j<100;j++){
      losTrazos.get(posiciones.get(i)).display();
      }
    }
  saveFrame("foo"+hour()+"_"+minute()+"_"+second()+".png");
}

class Trazo{ 
  PVector pos;
  float a;
  float t;
  color colorActual;
  Trazo(float x_, float y_, float t_ ){
   pos = new PVector(x_,y_);
   a = random(TWO_PI);
   t = t_;
   PVector fin = PVector.fromAngle(a).mult(t).add(pos);
   colorActual = CPromedioLineal(fin);
  }
  
  void display(){
    PVector fin = PVector.fromAngle(a).mult(t).add(pos);
    color pAct = CPromedioLineal(fin);
    colorActual = lerpColor(colorActual,pAct,0.1);
    stroke(colorActual);
    strokeWeight(3);
    line(pos.x,pos.y,fin.x,fin.y);
    a+=0.05;
  }
  
  color CPromedioLineal(PVector a_){
    float r,g,b;
    r=g=b=0;
    for(float i = 0; i<1; i+= 1f/t){
      PVector posInt = PVector.lerp(pos,a_,i);
      color c = imagen.get(round(posInt.x),round(posInt.y));
      r+= red(c);
      g+= green(c);
      b+= blue(c);
    }   
    return(color(r/t,g/t,b/t));
  }  
}
