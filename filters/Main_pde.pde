PrintWriter output;

void setup(){
  size(320, 240);
  background(102);
  stroke(255,0,15);
  output = createWriter("/home/aridane/ULPGC/DGC/DGC_P2/newMap.txt");
  Filters filter = new Filters(320,240,"/home/aridane/ULPGC/DGC/DGC_P2/guit_front.txt");
  filter.deleteSparePointsByDepth();
    int [][] mat = filter.getReducedMatrix();
    for (int i=0;i<240;i++){
    for (int j=0;j<320;j++){
      output.print(mat[i][j] + " ");
    }
    output.println("");
  }
  output.flush();
  output.close();
  int[][][] sortedBorders = new int[20][240*320][2];
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
      println(vertexes[k][i][0] + " " + vertexes[k][i][1]);
      if(i<vertexesCount[k]-1)
      {
        line(vertexes[k][i][0],vertexes[k][i][1],vertexes[k][i+1][0],vertexes[k][i+1][1]);
      }
      else
      {
        line(vertexes[k][i][0],vertexes[k][i][1],vertexes[k][0][0],vertexes[k][0][1]);
      }
    }
  }
}
