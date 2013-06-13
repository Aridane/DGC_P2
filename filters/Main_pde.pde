PrintWriter output;
int alt = 240;
int anch = 320;
int centerX = 410;
int centerY = 260;
int centerZ = 705-290;
Figure figura = null;

void setup(){
  size(1024, 512);
  background(102);
  stroke(255,0,15);
  frame.setResizable(true);
  output = createWriter("newMap.txt");
  
  Filters filter0 = new Filters(320,240,"C:\\figura_4_front.txt",0,centerX,centerY, centerZ);
  Filters filter1 = new Filters(320,240,"C:\\figura_4_perfil_1.txt",1,centerX,centerY, centerZ);
  Filters filter2 = new Filters(320,240,"C:\\figura_4_perfil_2.txt",3,centerX,centerY, centerZ);
  Filters filter3 = new Filters(320,240,"C:\\figura_4_tras.txt",2,centerX,centerY, centerZ);
  
  filter0.deleteSparePointsByDepth();
  filter1.deleteSparePointsByDepth();
  filter2.deleteSparePointsByDepth();
  filter3.deleteSparePointsByDepth();
  
  cheatingTool(filter0);
  filter0.getSortedBorders();
  filter1.getSortedBorders();
  filter2.getSortedBorders();
  filter3.getSortedBorders();
  
  filter0.deleteUselessVertexes();
  filter1.deleteUselessVertexes();
  filter2.deleteUselessVertexes();
  filter3.deleteUselessVertexes();
  
  filter0.pixel2MM();
  filter1.pixel2MM();
  filter2.pixel2MM();
  filter3.pixel2MM();
  
  filter0.changeVertexReferenceSystem();
  filter1.changeVertexReferenceSystem();
  filter2.changeVertexReferenceSystem();
  filter3.changeVertexReferenceSystem();
  
  float [][][][] filterVerteces = new float[4][][][];
  int [] nb = {filter0.nBorders, filter1.nBorders,filter2.nBorders,filter3.nBorders};
  int [][] nvert = new int[4][];
  filterVerteces[0] = filter0.getVerteces();
  nvert[0] = filter0.vertexesCount;
  filterVerteces[1] = filter1.getVerteces();
  nvert[1] = filter1.vertexesCount;
  filterVerteces[2] = filter2.getVerteces();
  nvert[2] = filter2.vertexesCount;
  filterVerteces[3] = filter3.getVerteces();
  nvert[3] = filter3.vertexesCount;

  figura = new Figure(filterVerteces, nb, nvert);
    
  figura.draw();
}

void draw(){
  if (figura != null) figura.draw();
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


double euclideanDistance(float[] vec_1,float[] vec_2)
{
  return Math.sqrt((vec_1[0]*-vec_2[0])*(vec_1[0]*-vec_2[0]) + (vec_1[1]*-vec_2[1])*(vec_1[1]*-vec_2[1]) + (vec_1[2]*-vec_2[2])*(vec_1[2]*-vec_2[2]));
}

float mean(float p,float q)
{
  return (p+q)/2;
}
