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
  int[][][] sortedBorders = new int[20][4800][2];
  filter.getSortedBorders(sortedBorders);


  int[][][] vertexes = new int[filter.nBorders][filter.numberOfPointsPerBorder[0]][2];
  int[] vertexesCount = new int[filter.nBorders];
  filter.deleteUselessVertexes(vertexes,vertexesCount,sortedBorders,filter.nBorders,filter.numberOfPointsPerBorder);
  println("vertices");
  for(int k=0;k<filter.nBorders;k++)
  {
    println("surface");
    for(int i=0;i<vertexesCount[k];i++)
    {
      point(vertexes[k][i][0],vertexes[k][i][1]);
      println(vertexes[k][i][0] + " " + vertexes[k][i][1]);
      if(i<vertexesCount[k]-1)
      {
        //line(vertexes[k][i][0],vertexes[k][i][1],vertexes[k][i+1][0],vertexes[k][i+1][1]);

      }
      else
      {
        //line(vertexes[k][i][0],vertexes[k][i][1],vertexes[k][0][0],vertexes[k][0][1]);
      }
    }
  }
}
