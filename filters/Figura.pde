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
    tVerteces = new float[4][][][];
    nBorders = new int[4];
    for (int h=0;h<4;h++){
      nVerteces[h] = new int[nb[h]];
      verteces[h] = new float[nb[h]][][];
      tVerteces[h] = new float[nb[h]][][];
      nBorders[h] = nb[h];
      for (int i=0;i<nb[h];i++){
        nVerteces[h][i] = nvert[h][i];
        verteces[h][i] = new float[nvert[h][i]][4];
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
      
    
    println("PREV CHANGE");
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
}



