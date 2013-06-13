float [][] multiplyMatrix(float v[][], float R[][], int n1, int  m1, int m2) {
  // v x R
  float [][] M = new float[n1][m2];
  for (int i=0;i<n1;i++) {
    for (int j=0;j<m2;j++) {
      for (int k=0;k<m1;k++) {
        M[i][j] += v[i][k] * R[k][j];
      }
    }
  }
  return M;
}
class Figure{
  float [][][][] verteces;
  float[][][][] auxVerteces;
  float [][][][] tVerteces;

  int [] nBorders;
    
  int [][] nVerteces;
    
  float [] colour = new float[3];
  

  float [][] tMatrix = {
    {
      1, 0, 0, 0
    }
    , {
      0, 1, 0, 0
    }
    , {
      0, 0, 1, 0
    }
    , {
      0, 0, 0, 1
    }
  };

  PVector centroid;


  Figure(float [][][][] vert, int [] nb, int [][] nvert) {
    nVerteces = new int[4][];
    verteces = new float[4][][][];
    auxVerteces = new float[4][][][];
    tVerteces = new float[4][][][];
    nBorders = new int[4];
    for (int h=0;h<4;h++){
      nVerteces[h] = new int[nb[h]];
      verteces[h] = new float[nb[h]][][];
      auxVerteces[h] = new float[nb[h]][][];
      tVerteces[h] = new float[nb[h]][][];
      nBorders[h] = nb[h];
      for (int i=0;i<nb[h];i++){
        nVerteces[h][i] = nvert[h][i];
        verteces[h][i] = new float[nvert[h][i]][4];
        auxVerteces[h][i] = new float[nvert[h][i]][4];
        tVerteces[h][i] = new float[nvert[h][i]][4];
        for (int j=0;j<nvert[h][i];j++){
          verteces[h][i][j][0] = vert[h][i][j][0];
          tVerteces[h][i][j][0] = vert[h][i][j][0];
          
          verteces[h][i][j][1] = vert[h][i][j][1];
          tVerteces[h][i][j][1] = vert[h][i][j][1];
          
          verteces[h][i][j][2] = vert[h][i][j][2];
          tVerteces[h][i][j][2] = vert[h][i][j][2];

          verteces[h][i][j][3] = 1;
          tVerteces[h][i][j][3] = 1;
        }
      }
    }
  }
  int k = 400;
  void myLine(float [] v0, float [] v1) {
    float aux0X = v0[0], aux0Y = v0[1], aux1X = v1[0], aux1Y = v1[1];
        aux0X= aux0X-width/2.;
        aux0Y= aux0Y-height/2.;
        aux1X= aux1X-width/2.;
        aux1Y= aux1Y-height/2.;
    
        aux0X= aux0X/(1.-(v0[2]/k));
        aux0Y= aux0Y/(1.-(v0[2]/k));
        aux1X= aux1X/(1.-(v1[2]/k));
        aux1Y= aux1Y/(1.-(v1[2]/k));
        
        aux0X= aux0X+width/2.;
        aux0Y= aux0Y+height/2.;
        aux1X= aux1X+width/2.;
        aux1Y= aux1Y+height/2.;
    line(aux0X, aux0Y, aux1X, aux1Y);
  }
  //TODO Crear funcion miLinea, la cual aparte de dibujar la línea aplica la perspectiva.
  //buttonsPressed[6],buttonsPressed[7],buttonsPressed[8]
  void draw() {
    background(128,128,128);
    for (int h=0;h<4;h++){
      for (int i=0;i<nBorders[h];i++){
        for (int j=0;j<nVerteces[h][i];j++){
          //if (tVerteces[h][i][(j+1)%nVerteces[h][i]])
          myLine(tVerteces[h][i][j],tVerteces[h][i][(j+1)%nVerteces[h][i]]);
        }
      }
    }
  }


 void rotate(float angleX, float angleY, float iniRotX, float iniRotY) {
    float[][] Rx = {  
      {
        1, 0, 0, 0
      }
      , 
      {
        0, cos(angleX), sin(angleX), 0
      }
      , 
      {
        0, -sin(angleX), cos(angleX), 0
      }
      , 
      {
        0, 0, 0, 1
      }
    };
    float[][] Ry = {  
      {
        cos(angleY), 0, -sin(angleY), 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        sin(angleY), 0, cos(angleY), 0
      }
      , 
      {
        0, 0, 0, 1
      }
    };
    float [][] T = {
      {
        1, 0, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        -iniRotX, -iniRotY, 0, 1
      }
    };
    float [][] aux = multiplyMatrix(T, Rx, 4, 4, 4);
    aux = multiplyMatrix(aux, Ry, 4, 4, 4);
    T[3][0] = +iniRotX;
    T[3][1] = +iniRotY;
    aux = multiplyMatrix(aux, T, 4, 4, 4);
    tMatrix = multiplyMatrix(tMatrix, aux, 4, 4, 4);
    
    for (int i=0;i<4;i++) println(tMatrix[i][0]+" "+tMatrix[i][1]+" "+tMatrix[i][2]+" "+tMatrix[i][3]);
      
    for (int h=0;h<4;h++){
      for (int i=0;i<nBorders[h];i++){
        tVerteces[h][i] = multiplyMatrix(verteces[h][i], tMatrix, nVerteces[h][i], 4, 4);
      }
    }
    

  }


  /*void translate (float x, float y, float z, boolean [] options, float k) {
    //Traslación 
    float [][] T = {
      {
        1, 0, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        x, y, z, 1
      }
    };

    tMatrix = multiplyMatrix(tMatrix, T, 4, 4, 4);
    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);
    
    if((closed)&&(options[8])) applyPerspective(k);
    else if(closed)getSquareLimits(false);
    if(!revolution) return;
    
    tTriangleCentroids = multiplyMatrix(triangleCentroids, tMatrix, nTriangles, 4, 4);
    tNormals = multiplyMatrix(normals, tMatrix, nTriangles, 4, 4);
    tVertexNormals = multiplyMatrix(vertexNormals, tMatrix, nVerteces, 4, 4);

    updateCentroid();
    //normalizeNormals();

    if((closed)&&(options[8])) applyPerspective(k);
    else if(closed)getSquareLimits(false);
  }

  void rotateX(float angle0, float iniRotX, float iniRotY, boolean [] options, float k) {
    float angle = angle0;
    float[][] Rx = {  
      {
        1, 0, 0, 0
      }
      , 
      {
        0, cos(angle), sin(angle), 0
      }
      , 
      {
        0, -sin(angle), cos(angle), 0
      }
      , 
      {
        0, 0, 0, 1
      }
    };
    float [][] T = {
      {
        1, 0, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        -iniRotX, -iniRotY, 0, 1
      }
    };
    float [][] aux = multiplyMatrix(T, Rx, 4, 4, 4);
    T[3][0] = +iniRotX;
    T[3][1] = +iniRotY;
    aux = multiplyMatrix(aux, T, 4, 4, 4);
    tMatrix = multiplyMatrix(tMatrix, aux, 4, 4, 4);

    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);
    if((closed)&&(options[8])) applyPerspective(k);
    else if(closed)getSquareLimits(false);
    if(!revolution) return;
    
    tTriangleCentroids = multiplyMatrix(triangleCentroids, tMatrix, nTriangles, 4, 4);
    tNormals = multiplyMatrix(normals, tMatrix, nTriangles, 4, 4);
    tVertexNormals = multiplyMatrix(vertexNormals, tMatrix, nVerteces, 4, 4);

    //normalizeNormals();
    updateCentroid();

  }

  void rotateY(float angle0, float iniRotX, float iniRotY, boolean [] options, float k) {
    float angle = angle0;
    float[][] Ry = {  
      {
        cos(angle), 0, -sin(angle), 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        sin(angle), 0, cos(angle), 0
      }
      , 
      {
        0, 0, 0, 1
      }
    };
    float [][] T = {
      {
        1, 0, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        -iniRotX, -iniRotY, 0, 1
      }
    };
    float [][] aux = multiplyMatrix(T, Ry, 4, 4, 4);
    T[3][0] = +iniRotX;
    T[3][1] = +iniRotY;
    aux = multiplyMatrix(aux, T, 4, 4, 4);


    tMatrix = multiplyMatrix(tMatrix, aux, 4, 4, 4);
    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);
    
    if((closed)&&(options[8])) applyPerspective(k);
    else if(closed)getSquareLimits(false);
    if(!revolution) return;
    
    tTriangleCentroids = multiplyMatrix(triangleCentroids, tMatrix, nTriangles, 4, 4);
    tNormals = multiplyMatrix(normals, tMatrix, nTriangles, 4, 4);
    if(closed) tVertexNormals = multiplyMatrix(vertexNormals, tMatrix, nVerteces, 4, 4);
    updateCentroid();
    //normalizeNormals();
  }


  void scale(float angle0, float angle1, float iniRotX, float iniRotY, boolean [] options, float k) {
    float angle = angle0;
    float[][] Rx = {  
      {
        angle0, 0, 0, 0
      }
      , 
      {
        0, angle1, 0, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        0, 0, 0, 1
      }
    };
    float [][] T = {
      {
        1, 0, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        -centroid.x, -centroid.y, 0, 1
      }
    };
    float [][] aux = multiplyMatrix(T, Rx, 4, 4, 4);
    T[3][0] = +centroid.x;
    T[3][1] = +centroid.y;
    aux = multiplyMatrix(aux, T, 4, 4, 4);
    tMatrix = multiplyMatrix(tMatrix, aux, 4, 4, 4);

    tVerteces = multiplyMatrix(verteces, tMatrix, nVerteces, 4, 4);
    if((closed)&&(options[8])) applyPerspective(k);
    else if(closed)getSquareLimits(false);
    if(!revolution) return;
    
    tTriangleCentroids = multiplyMatrix(triangleCentroids, tMatrix, nTriangles, 4, 4);
    tNormals = multiplyMatrix(normals, tMatrix, nTriangles, 4, 4);
    tVertexNormals = multiplyMatrix(vertexNormals, tMatrix, nVerteces, 4, 4);

    //normalizeNormals();
    updateCentroid();

  }*/


void matching(float altitude,float threshold)
{
  singleMatching(0,1,altitude,threshold);
  singleMatching(0,3,altitude,threshold);
  singleMatching(0,2,altitude,threshold);
  singleMatching(1,3,altitude,threshold);
  singleMatching(1,2,altitude,threshold);
  singleMatching(3,2,altitude,threshold);
  for(int i=0;i<4;i++)
  {
    for(int j=0;j<verteces[i].length;j++)
    {
      for(int k=0;k<verteces[i][j].length;k++)
      {
        for(int m=0;m<verteces[i][j][k].length;m++)
        {
          verteces[i][j][k][m] = auxVerteces[i][j][k][m];
          tVerteces[i][j][k][m] = auxVerteces[i][j][k][m];
        }
      }
    }
  }
}



void singleMatching(int index_1,int index_2,float altitude,float threshold)
{
  int max1 = getMaxNumberOfPoints(index_1);
  int max2 = getMaxNumberOfPoints(index_2);
  int pairIndex_1 = 0;
  int pairIndex_2 = 0;
  int[][][] pairs = new int[2*nBorders[index_1]*nBorders[index_2]+max2][2*max1*max2][4];
  for(int i=0;i<nBorders[index_1];i++)
  {
    for(int j=0;j<nBorders[index_2];j++)
    {
      for(int k=0;k<nVerteces[index_1][i];k++)
      {
        for(int m=0;m<nVerteces[index_2][j];m++)
        {
          //if(isNotACheckedPair(pairs,i,j,k,m))
          //{
            println("distancia = " + euclideanDistance(verteces[index_1][i][k],verteces[index_2][j][m]));
            if(altitudeRange(verteces[index_1][i][k][1],verteces[index_2][j][m][1],altitude) && euclideanDistance(verteces[index_1][i][k],verteces[index_2][j][m]) < threshold)
            {
              println("CAMBIO");
              auxVerteces[index_1][i][k][0] = mean(verteces[index_1][i][k][0],verteces[index_2][j][m][0]);
              auxVerteces[index_1][i][k][1] = mean(verteces[index_1][i][k][1],verteces[index_2][j][m][1]);
              auxVerteces[index_1][i][k][2] = mean(verteces[index_1][i][k][2],verteces[index_2][j][m][2]);
              
              auxVerteces[index_2][j][m][0] = mean(verteces[index_1][i][k][0],verteces[index_2][j][m][0]);
              auxVerteces[index_2][j][m][1] = mean(verteces[index_1][i][k][1],verteces[index_2][j][m][1]);
              auxVerteces[index_2][j][m][2] = mean(verteces[index_1][i][k][2],verteces[index_2][j][m][2]);
            }
            else
            {
              //println("i = " + i + " j = " + j + "k = " + k + " m = " + m); 
              auxVerteces[index_1][i][k][0] = verteces[index_1][i][k][0];
              auxVerteces[index_1][i][k][1] = verteces[index_1][i][k][1];
              auxVerteces[index_1][i][k][2] = verteces[index_1][i][k][2];
              
              
              /*
             println("LEEENGTH = " +   verteces[index_2][j].length); 
     println("LEEENGTH = " +   vertexes_2[j].length);           
     println("cual = " + index_1 + " " + index_2);*/
              auxVerteces[index_2][j][m][0] = verteces[index_2][j][m][0];
              auxVerteces[index_2][j][m][1] = verteces[index_2][j][m][1];
              auxVerteces[index_2][j][m][2] = verteces[index_2][j][m][2];
            //}
     /*       pairs[pairIndex_1][pairIndex_2][0] = i;
            pairs[pairIndex_1][pairIndex_2][1] = j;
            pairs[pairIndex_1][pairIndex_2][2] = k;
            pairs[pairIndex_1][pairIndex_2][3] = m;
            pairIndex_2++;*/
          }
        }
      }
      //pairIndex_1++;
    }
  }
}


boolean altitudeRange(float n1,float n2,float altitude)
{
  if(abs(n1-n2) <= altitude) return true;
  else return false;
}

int getMaxNumberOfPoints(int index)
{
  int max = 0;
  for(int i=0;i<nBorders[index];i++)
  {
    if(nVerteces[index][i] > max) max = nVerteces[index][i];
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
  return Math.sqrt((vec_1[0]-vec_2[0])*(vec_1[0]-vec_2[0]) + (vec_1[1]-vec_2[1])*(vec_1[1]-vec_2[1]) + (vec_1[2]-vec_2[2])*(vec_1[2]-vec_2[2]));
}

float mean(float p,float q)
{
  return (p+q)/2;
}

}



