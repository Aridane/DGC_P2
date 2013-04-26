PrintWriter output;
void setup(){
  output = createWriter("newMap.txt");
  Filters filter = new Filters(60,80,"C:\\Users\\Aridane\\ULPGC\\5º\\2º Cuatrimestre\\DGC\\kin2.txt");
  filter.deleteSparePointsByDepth();
  int [][] mat = filter.getReducedMatrix();
  for (int i=0;i<60;i++){
    for (int j=0;j<80;j++){
      output.print(mat[i][j] + " ");
    }
    output.println("");
  }
  output.flush();
  output.close();
  println("........................");
}
