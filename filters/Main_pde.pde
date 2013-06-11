PrintWriter output;
int alt = 240;
int anch = 320;
void setup(){
  size(1024, 1024);
  background(102);
  stroke(255,0,15);
  output = createWriter("newMap.txt");

  Filters filter = new Filters(anch,alt,"C:\\pol_lado1.txt",0,0,0,0);

  filter.deleteSparePointsByDepth();
    int [][] mat = filter.getReducedMatrix();
    for (int i=0;i<alt;i++){
    for (int j=0;j<anch;j++){
      output.print(mat[i][j] + " ");
    }
    output.println("");
  }
  output.flush();
  output.close();
  cheatingTool(filter);
  filter.getSortedBorders();

 

  filter.deleteUselessVertexes();
  filter.pixel2MM();
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

//Aqui modificas a mano lo que hace que no funcione
void cheatingTool(Filters filter)
{
  filter.reducedData[0][171] = 0;
}

void matching(float[][][] vertexesFront,float[][][] vertexesPerfil_1,float[][][] vertexesPerfil_2,float[][][] vertexesTras,Filters front,Filters perfil_1,Filters perfil_2,Filters tras,int threshold)
{
  singleMatching(vertexesFront,vertexesPerfil_1,front,perfil_1,threshold);
  singleMatching(vertexesFront,vertexesPerfil_2,front,perfil_2,threshold);
  singleMatching(vertexesFront,vertexesTras,front,tras,threshold);
  singleMatching(vertexesPerfil_1,vertexesPerfil_2,perfil_1,perfil_2,threshold);
  singleMatching(vertexesPerfil_1,vertexesTras,perfil_1,tras,threshold);
  singleMatching(vertexesPerfil_2,vertexesTras,perfil_2,tras,threshold);
}

void singleMatching(float[][][] vertexes_1,float[][][] vertexes_2,Filters f1,Filters f2,int threshold)
{
  int max1 = getMaxNumberOfPoints(f1);
  int max2 = getMaxNumberOfPoints(f2);
  int pairIndex_1 = 0;
  int pairIndex_2 = 0;
  int[][][] pairs = new int[f1.nBorders*f2.nBorders][max1*max2][4];
  for(int i=0;i<f1.nBorders;i++)
  {
    for(int j=0;j<f2.nBorders;j++)
    {
      for(int k=0;k<f1.numberOfPointsPerBorder[i];k++)
      {
        for(int m=0;m<f2.numberOfPointsPerBorder[j];m++)
        {
          if(isNotACheckedPair(pairs,i,j,k,m))
          {
            if(euclideanDistance(f1.vertexes[i][k],f2.vertexes[j][m]) < threshold)
            {
              vertexes_1[i][k][0] = mean(f1.vertexes[i][k][0],f2.vertexes[j][m][0]);
              vertexes_1[i][k][1] = mean(f1.vertexes[i][k][1],f2.vertexes[j][m][1]);
              vertexes_1[i][k][2] = mean(f1.vertexes[i][k][2],f2.vertexes[j][m][2]);
              
              vertexes_2[j][m][0] = mean(f1.vertexes[i][k][0],f2.vertexes[j][m][0]);
              vertexes_2[j][m][1] = mean(f1.vertexes[i][k][1],f2.vertexes[j][m][1]);
              vertexes_2[j][m][2] = mean(f1.vertexes[i][k][2],f2.vertexes[j][m][2]);
            }
            else
            {
              vertexes_1[i][k][0] = f1.vertexes[i][k][0];
              vertexes_1[i][k][1] = f1.vertexes[i][k][1];
              vertexes_1[i][k][2] = f1.vertexes[i][k][2];
              
              vertexes_2[j][m][0] = f2.vertexes[j][m][0];
              vertexes_2[j][m][1] = f2.vertexes[j][m][1];
              vertexes_2[j][m][2] = f2.vertexes[j][m][2];
            }
            pairs[pairIndex_1][pairIndex_2][0] = i;
            pairs[pairIndex_1][pairIndex_2][1] = j;
            pairs[pairIndex_1][pairIndex_2][2] = k;
            pairs[pairIndex_1][pairIndex_2][3] = m;
            pairIndex_2++;
          }
        }
      }
      pairIndex_1++;
    }
  }
}

int getMaxNumberOfPoints(Filters f)
{
  int max = 0;
  for(int i=0;i<f.nBorders;i++)
  {
    if(f.numberOfPointsPerBorder[i] > max) max = f.numberOfPointsPerBorder[i];
  }
  return max;
}

boolean isNotACheckedPair(int[][][] pairs,int i,int j,int k,int m)
{
  for(int p=0;p<pairs.length;p++)
  {
    for(int q=0;q<pairs[0].length;q++)
    {
      if((pairs[p][q][0] == i) && (pairs[p][q][1] == j) && (pairs[p][q][2] == k) && (pairs[p][q][3] == m)) return false;
    }
  }
  return true;
}

double euclideanDistance(int[] vec_1,int[] vec_2)
{
  return Math.sqrt((vec_1[0]*-vec_2[0])*(vec_1[0]*-vec_2[0]) + (vec_1[1]*-vec_2[1])*(vec_1[1]*-vec_2[1]) + (vec_1[2]*-vec_2[2])*(vec_1[2]*-vec_2[2]));
}

float mean(int p,int q)
{
  return (p+q)/2.;
}
