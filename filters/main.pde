

void setup()
{
  int[][] image = {{0, 0, 0, 0, 0, 0, 0, 0},
                   {0, 0, 1, 1, 1, 1, 0, 0},
                   {0, 0, 1, 0, 0, 1, 0, 0},
                   {0, 0, 1, 0, 0, 1, 0, 0},
                   {0, 1, 0, 0, 1, 1, 0, 0},
                   {0, 0, 1, 1, 0, 0, 0, 0},
                   {0, 0, 0, 0, 0, 0, 0, 0}};
                   
  int[][] borderPoint = {{2, 2}};
  int[][][] res = new int[1][42][2];
  int[] numberRes = new int[1];
  Filters filter = new Filters(8,7,"path");
  filter.sortBorderSurfaces(res,numberRes,borderPoint,1,image);
  println("number " + numberRes[0]);
  for(int i=0;i<numberRes[0];i++)
  {
    println(res[0][i][0] + " " + res[0][i][1]);
  }
}
