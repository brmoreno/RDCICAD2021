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
