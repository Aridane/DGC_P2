/*class Figure implements Drawable {
  float [][] verteces = new float[10000][];
  float [][] tVerteces = new float[10000][];
  float [][] pVerteces;
  
  float limitMinX = MAX_FLOAT;
  float limitMinY = MAX_FLOAT;
  float limitMaxX = 0;
  float limitMaxY = 0;
  
  int type = 1;

  int [][] triangles;

  float [][] triangleCentroids;
  float [][] tTriangleCentroids;

  float [] colour = new float[3];

  float [][] normals;
  float [][] tNormals;
  float [][] vertexNormals;
  float [][] tVertexNormals;
  

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

  int nTriangles = 0;

  boolean revolution = false;
  
  boolean lightFlag = false;

  int nSteps = 20;

  boolean closed = false;

  int nVerteces = 0;

  Figure(boolean revolutionFlag, boolean light) {
    revolution = revolutionFlag;
    lightFlag = light;
    if (lightFlag){
      colour[0] = 255;
      colour[1] = 255;
      colour[2] = 255;
    }
    else {
      colour[0] = (float)random(250);
      colour[1] = (float)random(250);
      colour[2] = (float)random(250);
    }
  }

  boolean closed() {
    return closed;
  }

  int type() {
    return type;
  }

  int triangles() {
    return nTriangles;
  }

  void setVertex(int n, float x, float y, float z) {
    verteces[n][0] = x;
    verteces[n][1] = y;
    verteces[n][2] = z; 
    verteces[n][3] = 1;
  }

  void setverteces(float [][] v) {
    int i = 0;
    for (i=0;i<nVerteces;i++) {
      verteces[i][0] = v[i][0];
      verteces[i][1] = v[i][1];
      verteces[i][2] = v[i][2]; 
      verteces[i][3] = 1;
    }
  }

  void addVertex(float x, float y, float z) {
    verteces[nVerteces] = new float[4];
    verteces[nVerteces][0] = x;
    verteces[nVerteces][1] = y;
    verteces[nVerteces][2] = z;
    verteces[nVerteces][3] = 1;

    tVerteces[nVerteces] = new float[4];
    tVerteces[nVerteces][0] = x;
    tVerteces[nVerteces][1] = y;
    tVerteces[nVerteces][2] = z;
    tVerteces[nVerteces][3] = 1;

    nVerteces = nVerteces + 1;
  }

  void closeFigure() {
    float x = 0, y = 0, z = 0;
    if (!revolution) {
      for (int i=0;i<nVerteces;i++) {
        x = x + tVerteces[i][0];
        y = y + tVerteces[i][1];
        z = z + tVerteces[i][2];
      }
      nSteps = 0;
    }
    else {
      float angle = 360;
      x = tVerteces[0][0];
      y = tVerteces[0][1];
      z = tVerteces[0][2];
      for (int i=1; i<nSteps;i++) {
        for (int k=0;k<nVerteces;k++) {
          verteces[k][0] = verteces[k][0] - width/2;
          verteces[k][1] = verteces[k][1] - height/2;
        }

        rotateY(((TWO_PI)/nSteps), 0, 0, null, 0);       

        for (int k=0;k<nVerteces;k++) {
          verteces[k][0] = verteces[k][0] + width/2;
          verteces[k][1] = verteces[k][1] + height/2;
          tVerteces[k][0] = tVerteces[k][0] + width/2;
          tVerteces[k][1] = tVerteces[k][1] + height/2;
        }


        for (int j=0;j<nVerteces;j++) {
        // println(" i = " + i + " nVerteces = " + nVerteces);
          verteces[i*nVerteces+j] = new float[4];

          verteces[i*nVerteces+j][0] = tVerteces[j][0];
          verteces[i*nVerteces+j][1] = tVerteces[j][1];
          verteces[i*nVerteces+j][2] = tVerteces[j][2];
          verteces[i*nVerteces+j][3] = tVerteces[j][3];
          x = x + tVerteces[j][0];
          y = y + tVerteces[j][1];
          z = z + tVerteces[j][2];
        }
      }
      nVerteces = nVerteces * nSteps;
     // println(" nVerteces = " + nVerteces);
      tVerteces = new float[nVerteces][4];
      for (int i=0;i<nVerteces;i++) {
        tVerteces[i][0] = verteces[i][0];
        tVerteces[i][1] = verteces[i][1];
        tVerteces[i][2] = verteces[i][2];
        tVerteces[i][3] = verteces[i][3];
      }
    }
    for (int i=0;i<4;i++) {
      for (int j=0;j<4;j++) {
        if (i == j) tMatrix[i][j] = 1;
        else tMatrix[i][j] = 0;
      }
    }
    centroid = new PVector(x/nVerteces, y/nVerteces, z/nVerteces);

    if (!revolution){
      closed = true;
      return;
    }
    nTriangles = nSteps*2*((nVerteces/nSteps)-1);
    triangles = new int[nTriangles][3];
    triangleCentroids = new float[nTriangles][4];
    normals = new float[nTriangles][4];

    tTriangleCentroids = new float[nTriangles][4];
    tNormals = new float[nTriangles][4];

    int triangleIndex = 0;
    int aux = 0;
    float tX = 0, tY = 0, tZ = 0;
    for (int j = 0;j<nSteps;j++) {
      for (int k=0;k<((nVerteces/nSteps)-1);k++) {
        aux = k + j*(nVerteces/nSteps);

        //Cálculo de Vertices
        triangles[triangleIndex][0] = aux;
        triangles[triangleIndex][1] = (aux + (nVerteces/nSteps))% nVerteces;
        triangles[triangleIndex][2] = triangles[triangleIndex][1] + 1;

        //Cálculo del centroide
        tX = tX + verteces[aux][0];
        tX = tX + verteces[triangles[triangleIndex][1]][0];
        tX = tX + verteces[triangles[triangleIndex][2]][0];
        tX = tX/3.;

        tY = tY + verteces[aux][1];
        tY = tY + verteces[triangles[triangleIndex][1]][1];
        tY = tY + verteces[triangles[triangleIndex][2]][1];
        tY = tY/3.;

        tZ = tZ + verteces[aux][2];
        tZ = tZ + verteces[triangles[triangleIndex][1]][2];
        tZ = tZ + verteces[triangles[triangleIndex][2]][2];        
        tZ = tZ/3.;

        triangleCentroids[triangleIndex][0] = tX;
        triangleCentroids[triangleIndex][1] = tY;
        triangleCentroids[triangleIndex][2] = tZ;
        triangleCentroids[triangleIndex][3] = 1;

        tTriangleCentroids[triangleIndex][0] = tX;
        tTriangleCentroids[triangleIndex][1] = tY;
        tTriangleCentroids[triangleIndex][2] = tZ;
        tTriangleCentroids[triangleIndex][3] = 1;


        println("CENTROIDE " + tX + " " + tY + " " + tZ);

        tX = 0;
        tY = 0;
        tZ = 0;

        //Cálculo de la normal
        float [] v43 = new float[3];
        float [] v40 = new float[3];
       // println("VECTOR 43-> " + triangles[triangleIndex][1] + " - " + triangles[triangleIndex][2]);
        v43[0] = verteces[triangles[triangleIndex][1]][0] - verteces[triangles[triangleIndex][2]][0];
        v43[1] = verteces[triangles[triangleIndex][1]][1] - verteces[triangles[triangleIndex][2]][1];
        v43[2] = verteces[triangles[triangleIndex][1]][2] - verteces[triangles[triangleIndex][2]][2];

        //println("VECTOR 40 -> " + triangles[triangleIndex][0] + " -  " + triangles[triangleIndex][2]);
        v40[0] = verteces[triangles[triangleIndex][0]][0] - verteces[triangles[triangleIndex][2]][0];
        v40[1] = verteces[triangles[triangleIndex][0]][1] - verteces[triangles[triangleIndex][2]][1];
        v40[2] = verteces[triangles[triangleIndex][0]][2] - verteces[triangles[triangleIndex][2]][2];
        //println("NORMAL v40 " + v40[0] + " " + v40[1] + " " + v40[2]);
        //println("NORMAL v43 " + v43[0] + " " + v43[1] + " " + v43[2]);

        normals[triangleIndex][0] = (v40[1] * v43[2]) - (v40[2] * v43[1]);
        normals[triangleIndex][1] = (v40[2] * v43[0]) - (v40[0] * v43[2]);
        normals[triangleIndex][2] = (v40[0] * v43[1]) - (v40[1] * v43[0]);
        //println("NORMAL ORIGINAL 0 -> " + normals[triangleIndex][0] + " " + normals[triangleIndex][1] + " " + normals[triangleIndex][2]);
        float module = sqrt( normals[triangleIndex][0]* normals[triangleIndex][0] +  
          normals[triangleIndex][1]* normals[triangleIndex][1] + 
          normals[triangleIndex][2]* normals[triangleIndex][2]); 
          

        normals[triangleIndex][0] = normals[triangleIndex][0]/module + triangleCentroids[triangleIndex][0];
        normals[triangleIndex][1] = normals[triangleIndex][1]/module + triangleCentroids[triangleIndex][1];
        normals[triangleIndex][2] = normals[triangleIndex][2]/module + triangleCentroids[triangleIndex][2];

        normals[triangleIndex][3] = 1;

        tNormals[triangleIndex][0] = normals[triangleIndex][0];
        tNormals[triangleIndex][1] = normals[triangleIndex][1];
        tNormals[triangleIndex][2] = normals[triangleIndex][2];
        tNormals[triangleIndex][3] = 1;


        triangleIndex = triangleIndex + 1;
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////        
        triangles[triangleIndex][0] = aux;
        triangles[triangleIndex][1] = ((aux + (nVerteces/nSteps))% nVerteces) + 1;
        triangles[triangleIndex][2] = aux+1;       

        //Cálculo del centroide
        tX = tX + verteces[triangles[triangleIndex][0]][0];
        tX = tX + verteces[triangles[triangleIndex][1]][0];
        tX = tX + verteces[triangles[triangleIndex][2]][0];
        tX = tX/3.;

        tY = tY + verteces[triangles[triangleIndex][0]][1];
        tY = tY + verteces[triangles[triangleIndex][1]][1];
        tY = tY + verteces[triangles[triangleIndex][2]][1];
        tY = tY/3.;

        tZ = tZ + verteces[triangles[triangleIndex][0]][2];
        tZ = tZ + verteces[triangles[triangleIndex][1]][2];
        tZ = tZ + verteces[triangles[triangleIndex][2]][2];        
        tZ = tZ/3.;

        triangleCentroids[triangleIndex][0] = tX;
        triangleCentroids[triangleIndex][1] = tY;
        triangleCentroids[triangleIndex][2] = tZ;
        triangleCentroids[triangleIndex][3] = 1;

        tTriangleCentroids[triangleIndex][0] = tX;
        tTriangleCentroids[triangleIndex][1] = tY;
        tTriangleCentroids[triangleIndex][2] = tZ;
        tTriangleCentroids[triangleIndex][3] = 1;
        //println("CENTROIDE " + tX + " " + tY + " " + tZ);

        tX = 0;
        tY = 0;
        tZ = 0;   

        //Cálculo de la normal
        float [] v41 = new float[3];
        v41[0] = verteces[triangles[triangleIndex][2]][0] - verteces[triangles[triangleIndex][1]][0];
        v41[1] = verteces[triangles[triangleIndex][2]][1] - verteces[triangles[triangleIndex][1]][1];
        v41[2] = verteces[triangles[triangleIndex][2]][2] - verteces[triangles[triangleIndex][1]][2];

        //println("VECTOR 41 -> " + triangles[triangleIndex][2] + " -  " + triangles[triangleIndex][1]);
        normals[triangleIndex][0] = (v41[1] * v40[2]) - (v41[2] * v40[1]);
        normals[triangleIndex][1] = (v41[2] * v40[0]) - (v41[0] * v40[2]);
        normals[triangleIndex][2] = (v41[0] * v40[1]) - (v41[1] * v40[0]);

        module = sqrt( normals[triangleIndex][0]* normals[triangleIndex][0] +  
          normals[triangleIndex][1]* normals[triangleIndex][1] + 
          normals[triangleIndex][2]* normals[triangleIndex][2]); 
          

        normals[triangleIndex][0] = 10*normals[triangleIndex][0]/module + triangleCentroids[triangleIndex][0];
        normals[triangleIndex][1] = 10*normals[triangleIndex][1]/module + triangleCentroids[triangleIndex][1];
        normals[triangleIndex][2] = 10*normals[triangleIndex][2]/module + triangleCentroids[triangleIndex][2];

        normals[triangleIndex][3] = 1;

        tNormals[triangleIndex][0] = normals[triangleIndex][0];
        tNormals[triangleIndex][1] = normals[triangleIndex][1];
        tNormals[triangleIndex][2] = normals[triangleIndex][2];
        tNormals[triangleIndex][3] = 1;
       // println("NORMAL ORIGINAL " + normals[triangleIndex][0] + " " + normals[triangleIndex][1] + " " + normals[triangleIndex][2]);

        triangleIndex = triangleIndex + 1;
      }
    }
    //normalizeNormals();
    getSquareLimits(false);
    calculateVertexNormals();
    closed = true;
    pVerteces = new float[nVerteces][3];
    applyPerspective(k);
  }
//Funcion para obtener el cuadrado final.
  void getSquareLimits(boolean pers){
    float x,y;
    limitMinX = MAX_FLOAT;
    limitMinY = MAX_FLOAT;
    limitMaxX = 0;
    limitMaxY = 0;
    for (int i=0;i<nVerteces;i++){  
      if (!pers)x = tVerteces[i][0];
      else x = pVerteces[i][0];
      if (!pers)y = tVerteces[i][1];
      else y = pVerteces[i][1];
      if (x < limitMinX) limitMinX = x;
      if (x > limitMaxX) limitMaxX = x;
      if (y < limitMinY) limitMinY = y;
      if (y > limitMaxY) limitMaxY = y;
    }
    //println("----------------> MinX  "+limitMinX + " MaxX " + limitMaxX + " ");
    //println("----------------> MinY  "+limitMinY + " MaxY " + limitMaxY + " ");
  }
  
  void applyPerspective(float k){
    int i;
    for (i=0;i<nVerteces;i++) {
      pVerteces[i][0] = tVerteces[i][0] - width/2.;
      pVerteces[i][1] = tVerteces[i][1] - height/2.;
      pVerteces[i][2] = tVerteces[i][2];
    }

    for (i=0;i<nVerteces;i++) {
      pVerteces[i][0] = pVerteces[i][0]/(1.-(pVerteces[i][2]/k));
      pVerteces[i][1] = pVerteces[i][1]/(1.-(pVerteces[i][2]/k));
      pVerteces[i][2] = pVerteces[i][2]/(1-(pVerteces[i][2]/k));
    }

    for (i=0;i<nVerteces;i++) {
      pVerteces[i][0] = pVerteces[i][0] + width/2.;
      pVerteces[i][1] = pVerteces[i][1] + height/2.;
    }
    getSquareLimits(true);
  }
  PVector getCentroid() {
    return centroid;
  }

  void updateCentroid() {
    float x = 0, y = 0, z = 0;
    for (int j=0;j<nVerteces;j++) {
      x = x + tVerteces[j][0];
      y = y + tVerteces[j][1];
      z = z + tVerteces[j][2];
    }
    centroid = new PVector(x/nVerteces, y/nVerteces, z/nVerteces);
  }
  
  void calculateVertexNormals(){
    vertexNormals = new float[nVerteces][4];
    tVertexNormals = new float[nVerteces][4];
    int [] marcador = new int[nVerteces];
    int [] neighbourCount = new int[nVerteces];
    for (int i=0;i<nVerteces;i++){
     neighbourCount[i] = 0;
     marcador[i] = 0;
      for (int j=0;j<4;j++){
        vertexNormals[i][j] = 0;
      }
    }
    for (int triangle=0;triangle<nTriangles;triangle++){
      for (int vertex=0;vertex<3;vertex++){
        if(triangles[triangle][vertex] % (nVerteces/nSteps) == 0){
          if((vertex == 0)&&(marcador[triangles[triangle][vertex]] == 0)){
            vertexNormals[triangles[triangle][vertex]][0] = vertexNormals[triangles[triangle][vertex]][0] + normals[triangle][0] -triangleCentroids[triangle][0];
            vertexNormals[triangles[triangle][vertex]][1] = vertexNormals[triangles[triangle][vertex]][1] + normals[triangle][1] -triangleCentroids[triangle][1];
            vertexNormals[triangles[triangle][vertex]][2] = vertexNormals[triangles[triangle][vertex]][2] + normals[triangle][2] -triangleCentroids[triangle][2];
            marcador[triangles[triangle][vertex]] = 1;
            neighbourCount[triangles[triangle][vertex]] = neighbourCount[triangles[triangle][vertex]] + 1;
          }
          else if (vertex != 0) {
            vertexNormals[triangles[triangle][vertex]][0] = vertexNormals[triangles[triangle][vertex]][0] + normals[triangle][0] -triangleCentroids[triangle][0];
            vertexNormals[triangles[triangle][vertex]][1] = vertexNormals[triangles[triangle][vertex]][1] + normals[triangle][1] -triangleCentroids[triangle][1];
            vertexNormals[triangles[triangle][vertex]][2] = vertexNormals[triangles[triangle][vertex]][2] + normals[triangle][2] -triangleCentroids[triangle][2];
            neighbourCount[triangles[triangle][vertex]] = neighbourCount[triangles[triangle][vertex]] + 1;
          }

        }
        else if(triangles[triangle][vertex] % (nVerteces/nSteps) == ((nVerteces/nSteps)-1)){
          if(vertex == 2){
            vertexNormals[triangles[triangle][vertex]][0] = vertexNormals[triangles[triangle][vertex]][0] + normals[triangle][0] -triangleCentroids[triangle][0];
            vertexNormals[triangles[triangle][vertex]][1] = vertexNormals[triangles[triangle][vertex]][1] + normals[triangle][1] -triangleCentroids[triangle][1];
            vertexNormals[triangles[triangle][vertex]][2] = vertexNormals[triangles[triangle][vertex]][2] + normals[triangle][2] -triangleCentroids[triangle][2];
            neighbourCount[triangles[triangle][vertex]] = neighbourCount[triangles[triangle][vertex]] + 1;
          }
        }
        else{
          vertexNormals[triangles[triangle][vertex]][0] = vertexNormals[triangles[triangle][vertex]][0] + normals[triangle][0] -triangleCentroids[triangle][0];
          vertexNormals[triangles[triangle][vertex]][1] = vertexNormals[triangles[triangle][vertex]][1] + normals[triangle][1] -triangleCentroids[triangle][1];
          vertexNormals[triangles[triangle][vertex]][2] = vertexNormals[triangles[triangle][vertex]][2] + normals[triangle][2] -triangleCentroids[triangle][2];
          neighbourCount[triangles[triangle][vertex]] = neighbourCount[triangles[triangle][vertex]] + 1;
        }
      }
    }
    for (int i=0;i<nVerteces;i++){
      vertexNormals[i][0] = vertexNormals[i][0]/(float)neighbourCount[i];
      vertexNormals[i][1] = vertexNormals[i][1]/(float)neighbourCount[i];
      vertexNormals[i][2] = vertexNormals[i][2]/(float)neighbourCount[i];

      float module = sqrt( vertexNormals[i][0]* vertexNormals[i][0] +  
          vertexNormals[i][1]* vertexNormals[i][1] + 
          vertexNormals[i][2]* vertexNormals[i][2]); 
      
      vertexNormals[i][0] = vertexNormals[i][0]/module;// + verteces[i][0];
      vertexNormals[i][1] = vertexNormals[i][1]/module;// + verteces[i][1];
      vertexNormals[i][2] = vertexNormals[i][2]/module;// + verteces[i][2];
      
      vertexNormals[i][0] = vertexNormals[i][0] + verteces[i][0];
      vertexNormals[i][1] = vertexNormals[i][1] + verteces[i][1];
      vertexNormals[i][2] = vertexNormals[i][2] + verteces[i][2];
      
      vertexNormals[i][3] = 1;
      
      tVertexNormals[i][0] = vertexNormals[i][0];
      tVertexNormals[i][1] = vertexNormals[i][1];
      tVertexNormals[i][2] = vertexNormals[i][2];
      tVertexNormals[i][3] = vertexNormals[i][3];
    }
  }

  //TODO Crear funcion miLinea, la cual aparte de dibujar la línea aplica la perspectiva.
  //buttonsPressed[6],buttonsPressed[7],buttonsPressed[8]
  void draw(float k, boolean [] options) {

    int i = 0;
    float z = 0, a = 0;
    stroke(colour[0], colour[1], colour[2]);
    if (!closed)for (i=0;i<nVerteces-1;i++) myLine(tVerteces[i], tVerteces[(i+1)], options);

    if (closed && !revolution) {
      myLine(tVerteces[nVerteces-1], tVerteces[0], options);
      for (i=0;i<nVerteces-1;i++) myLine(tVerteces[i], tVerteces[(i+1)], options);
    }
    if (closed && revolution) {
      for (i=0;i<(nVerteces/nSteps);i++) {
        for (int j=0;j<nSteps;j++) {
          myLine(tVerteces[(j*(nVerteces/nSteps))+i], tVerteces[((j+1)%nSteps)*(nVerteces/nSteps)+i], options);  
          if (i < ((nVerteces/nSteps)-1)) {
            myLine(tVerteces[i+j*(nVerteces/nSteps)], tVerteces[i+j*(nVerteces/nSteps)+1], options);
          }
        }
      }
      if (options[6]) {
        for (int l=0;l<nTriangles;l=l+2) {
          myLine(tVerteces[triangles[l][2]], tVerteces[triangles[l][0]], options);
        }
      }
      if (options[7]) {
        for (int l=0;l<nTriangles;l++) {
          //Línea desde el centroide al centroide + vector
          if (tTriangleCentroids[l][2] < tNormals[l][2]) stroke(255, 0, 0);
          else stroke(0, 0, 255);
          myLine(tTriangleCentroids[l], tNormals[l], options);
        }
        for (int l=0;l<nVerteces;l++){
          if (tVerteces[l][2] < tVertexNormals[l][2]) stroke(255, 0, 0);
          else stroke(0, 0, 255);
          myLine(tVerteces[l], tVertexNormals[l], options);
        }
      }
    }
    stroke(0);
  }
  void translate (float x, float y, float z, boolean [] options, float k) {
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

  }
}*/



