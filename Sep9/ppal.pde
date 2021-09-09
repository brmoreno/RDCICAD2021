PImage imagen;
PImage imagenp;
Trazo elTrazo;
ArrayList <Trazo> losTrazos;
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
  imagenp = imagenColoresAlt(imagen);
  
  noStroke();
  elTrazo = new Trazo(0,height/2,30);
  losTrazos = new ArrayList <Trazo>();
  for(int i = 0; i<1000; i++){
    losTrazos.add(new Trazo(random(width),random(height),random(5,20)));
  }
  background(255);
  
     for(Trazo t:losTrazos){
      for (int i = 0; i<200; i++){
       
      t.display();
      t.mover();
    }
  }   
}
