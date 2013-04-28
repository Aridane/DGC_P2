PrintWriter output;
void setup(){
  size(80, 60);
  background(102);
  stroke(255,0,15);
  output = createWriter("newMap.txt");
  //Filters filter = new Filters(60,80,"C:\\kin.txt");
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
  filter.initialBorderPoints();
  println("........................");

  println("........................");
  /*
  int[][] borderPoint = {{21, 59}};
  int[][][] res = new int[1][4800][2];
  int[] numberRes = new int[1];
  filter.sortBorderSurfaces(res,numberRes,borderPoint,1,mat);
  println("number " + numberRes[0]);
  for(int i=0;i<numberRes[0];i++)
  {
    println(res[0][i][0] + " " + res[0][i][1]);
  }
  int[][][] vertexes = new int[1][numberRes[0]][2];
  int[] vertexesCount = new int[1];
  filter.deleteUselessVertexes(vertexes,vertexesCount,res,1,numberRes);
  println("vertices");
  for(int i=0;i<vertexesCount[0];i++)
  {
    println(vertexes[0][i][0] + " " + vertexes[0][i][1]);
    if(i<vertexesCount[0]-1)
    {
      line(vertexes[0][i][0],vertexes[0][i][1],vertexes[0][i+1][0],vertexes[0][i+1][1]);
    }
    else
    {
      line(vertexes[0][i][0],vertexes[0][i][1],vertexes[0][0][0],vertexes[0][0][1]);
    }
  }
  */
}
