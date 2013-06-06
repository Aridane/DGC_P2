PrintWriter output;
void setup(){
  size(80, 60);
  background(102);
  stroke(255,0,15);
  output = createWriter("newMap.txt");
  Filters filter = new Filters(60,80,"C:\\old_2.txt");
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

  filter.getSortedBorders();



  filter.deleteUselessVertexes();
  println("vertices");
  for(int k=0;k<filter.nBorders;k++)
  {
    println("surface");
    for(int i=0;i<filter.vertexesCount[k];i++)
    {
      point(filter.vertexes[k][i][0],filter.vertexes[k][i][1]);
      println(filter.vertexes[k][i][0] + " " + filter.vertexes[k][i][1]);
      if(i<filter.vertexesCount[k]-1)
      {
        line(filter.vertexes[k][i][0],filter.vertexes[k][i][1],filter.vertexes[k][i+1][0],filter.vertexes[k][i+1][1]);

      }
      else
      {
         line(filter.vertexes[k][i][0],filter.vertexes[k][i][1],filter.vertexes[k][0][0],filter.vertexes[k][0][1]);
      }
    }
  }
}
