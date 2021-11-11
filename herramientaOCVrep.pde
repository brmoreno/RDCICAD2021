size(750, 498);
background(255);
String[] foo = loadStrings("foo.txt");
int col = 0;
boolean linea = false;
for (int i = 0; i< foo.length;i++){
  if (i%2 == 0){
     String[] partes = splitTokens(foo[i]," ");
     if(partes.length>1){
     col = int(partes[1]);
     }
     if ( int(partes[0]) == 1){
       linea = true;
     }
     else{
       linea = false;
     }
  }
  else{
    String[] partes = splitTokens(foo[i],"[]");
    if (linea == false){
      fill(col);
      noStroke();
      beginShape();
      for(int j = 0; j<partes.length; j++){
        float[] nums = float(split(partes[j],','));
        vertex(nums[0],nums[1]);
      }
      endShape();
    }
    else{
      noFill();
      stroke(0);
      beginShape();
      for(int j = 0; j<partes.length; j++){
        float[] nums = float(split(partes[j],','));
        vertex(nums[0]+random(-1,1),nums[1]+random(-1,1));
      }
      endShape();
    }
  }
}
