class Figure{
  float [][][] verteces;
  float [][][] tVerteces;

  int nBorders = 0;
    
  float [] nVerteces;
    
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


  Figure(int[][][] vert, int nb, int [] nvert) {
    nVerteces = new float[nb];
    verteces = new float[nb][][];
    for (int i=0;i<nb;i++){
      nVerteces[i] = nvert[i];
      verteces[i] = new float[nvert[i]][3];
      for (int j=0;j<nvert[i];j++){
        for (int k=0;k<3;k++) verteces[i][j][k] = vert[i][j][k];
      }
    }
    nBorders = nb;
  }
  //TODO Crear funcion miLinea, la cual aparte de dibujar la línea aplica la perspectiva.
  //buttonsPressed[6],buttonsPressed[7],buttonsPressed[8]
  void draw() {

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



