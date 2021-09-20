PImage imagen;
PImage imagenp;
ArrayList <Espiral> espirales;

void setup(){  
  size(750,498);
  imagen = loadImage("IMG_0091.jpg");
  imagen.resize(750,498);  
  
  imagenp = imagen.copy();
  imagenp.filter(POSTERIZE,2);
  IntList colores = new IntList();
  imagenp.loadPixels();
  for (int i = 0; i<imagenp.pixels.length;i++){
    int colorPix = imagenp.pixels[i];
    if(!colores.hasValue(colorPix)){
      colores.append(colorPix);
    }
  }
  //colores.shuffle();
  
  background(255);
  for(int k = 0; k<colores.size();k++){
  espirales = new ArrayList<Espiral>();
  for(int i = 0; i<width; i+=200){
    for(int j = 0; j< height; j+= 200){
      espirales.add(new Espiral(i,j,200,200,3,colores.get(k)));
    }
  }
  
  for(Espiral e:espirales){
    e.display();
  }
  }
  
  //saveFrame("foo"+hour()+"_"+minute()+"_"+second()+".png");
}

class Espiral{
  float ti;
  float t;
  float a;
  PVector pos;
  float da;
  float paso;
  float dtt;
  float dt;
  float x,y,w,h;
  float tmax;
  color actual;
  color referencia;
  float alfa;
  int contador;
  int limite;
  Espiral(float x_, float y_,float w_,float h_,float t_, color ref_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    pos = new PVector(random(x_,x_+w_),random(y_,y_+h_));
    t = ti = 1;
    a = random(TWO_PI);
    paso = 1;
    da = paso/t;
    dtt = t_;
    float mx = pos.x>x+w/2? x: x+w;
    float my = pos.y>y+h/2? y: y+h;
    tmax = dist(pos.x,pos.y,mx,my);
    PVector fin = PVector.fromAngle(a).mult(t).add(pos);
    actual = imagen.get(round(fin.x),round(fin.y));
    referencia = ref_;   
    alfa = 255;
    limite = round(random(5,15));
  }
  
  void display(){
    while(t<tmax){
      PVector fin = PVector.fromAngle(a).mult(t).add(pos);
      noStroke();
      color sobre = imagen.get(round(fin.x),round(fin.y));
      actual = lerpColor(actual,sobre,0.1);
      da = paso/t;
      a+= da;
      dt = dtt/((TWO_PI*t)/paso);
      t+=dt;
      if (fin.x>x&& fin.x <x+w && fin.y>y && fin.y<y+h){
        color colact = imagenp.get(round(fin.x),round(fin.y));
        if(colact == referencia){
          alfa += 30;
        }
        else{
          alfa-= 30;
        }
        alfa = constrain(alfa,0,255);
        fill(actual,alfa);
        contador++;
        if (contador <limite){
          ellipse(fin.x,fin.y,1.5,1.5);
        }
        if (contador >limite){
          contador = 0;
          limite = round(random(5,20));
        }        
      }
    }
  }
}
