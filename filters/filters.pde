import java.lang.IndexOutOfBoundsException;
public class Filters {

  private int [] frameDimensions = new int[2];
  private String pathToRawFile ="";
  private int [][] rawData;
  private int [][] reducedData;
  private BufferedReader rawReader;
  private int maxDepth = 0;
  private int limitThres = 500;
  private int neighbourThres = 9;
  private int neighbourDepthThres = 50;


  Filters(int dimX, int dimY, String path) {
    frameDimensions[0] = dimX;
    frameDimensions[1] = dimY;
    pathToRawFile = path;
    rawData = new int[dimX][dimY];
    reducedData = new int[dimX][dimY];
    rawReader = createReader(path);
    readRawFile();
  }

  void readRawFile() {
    String line;
    String [] lineStringValues;

    for (int i=0;i<frameDimensions[0];i++) {
      try {
        line = rawReader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      lineStringValues = line.split(" ");
      for (int j=0;j<lineStringValues.length-1;j++) {
          rawData[i][j] = Integer.parseInt(lineStringValues[j]);
        if (rawData[i][j] > maxDepth) maxDepth = rawData[i][j];
      }
    }
  }
  
  int [][] getRawMatrix() {
    return rawData;
  }
  
  int [][] getReducedMatrix() {
    return reducedData;
  }
  
  /*Determina si el elemento x,y esta en el rango de profundidad de la profundidad pasada*/
  /*True para conservar el punto*/
  boolean inRange(int actualDepth, int x, int y) {
    return (((abs(rawData[x][y] - actualDepth)) < neighbourDepthThres));
  }
  /*Comprueba la cantidad de vecinos de un punto dentro del rango*/
  boolean checkNeighbours(int actualDepth, int x, int y) {
    int counter = 0;
    int oldNeighbourThres = neighbourThres;
    if ((x == 0)&&(y == 0)) {
      println("C1");
      neighbourThres = 3;
      for (int i=0;i<2;i++) {
        for (int j=0;j<2;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }
      
    }
    else if ((x == 0)&&(y == frameDimensions[1]-1)) {
      println("C2");
      neighbourThres = 3;
      for (int i=0;i<2;i++) {
        for (int j=-1;j<1;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }
    }
    else if ((x == frameDimensions[0]-1)&&(y == 0)) {
      println("C3");
      neighbourThres = 3;
      for (int i=-1;i<1;i++) {
        for (int j=0;j<2;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }

    }
    else if ((x == frameDimensions[0]-1)&&(y == frameDimensions[1]-1)) {
     println("C4");
      neighbourThres = 3;
      for (int i=-1;i<1;i++) {
        for (int j=-1;j<1;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }

    }
    else if (x == 0) {
      println("C5");
      neighbourThres = 9;
      
      for (int i=0;i<2;i++) {
        for (int j=-1;j<2;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      println("nbTH = "+neighbourThres+"counter = "+counter+"x = "+ x + " y = "+y);
      
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }
    }
    else if (y == 0) {
      println("C6");
      neighbourThres = 7;
      for (int i=-1;i<2;i++) {
        for (int j=0;j<2;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }

    }
    else if (x == frameDimensions[0]-1) {
      println("C7");
      neighbourThres = 7;
      for (int i=-1;i<1;i++) {
        for (int j=-1;j<2;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }

    }
    else if (y == frameDimensions[1]-1) {
      println("C8");
      neighbourThres = 7;
      for (int i=-1;i<2;i++) {
        for (int j=-1;j<1;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres){
         neighbourThres = oldNeighbourThres;
         return true;
      }

    }
    else {
      for (int i=-1;i<2;i++) {
        for (int j=-1;j<2;j++) {
          if (inRange(actualDepth, x+i, y+j)){ counter++;}
        }
      }
      if (counter < neighbourThres) return true;
    }
    return false;
  }

  int [][] deleteSparePointsByDepth() {
    int actualDepth = 0;
    int actualDepthSector = 0;
    for (int i=0;i<frameDimensions[0];i++) {
      for (int j=0;j<frameDimensions[1];j++) {
        actualDepth = rawData[i][j];
        if (actualDepth > (maxDepth - limitThres)) {
          reducedData[i][j] = 0;
        }
        else {
          if (!checkNeighbours(actualDepth, i, j)) reducedData[i][j] = 0;
          else reducedData[i][j] = actualDepth;
        }
      }
    }
    return null;
  }
  
  
  //@salida | sortedBorderPoints -> vector que contiene vectores de puntos ordenados para cada superficie (cada punto son dos cordeenadas, por eso 3dim)
  //@salida | nimberBorderPoints -> vector del numero de puntos del borde ordenados para cada superficie
  //@param | borderPoints -> puntos iniciales de cada superficie
  //@param | numero de superficies
  //@param | imagen simplificada con los bordes solamente
  void sortBorderSurfaces(int[][][] sortedBorderPoints,int[] numberBorderPoints,int[][] borderPoints,int nSurface,int[][] borderImage)
  {
    int[] dir = new int[2];;
    int[] actualPoint = new int[2];
    int[] nextPoint = new int[2];
    int[] nextDir = new int[2];
    int countPerSurface;

    //Para cada superficie
    for(int i=0;i<nSurface;i++)
    {
      countPerSurface = 1;
      //Obtener la direccion inicial y el punto actual
      getInitialDir(dir,borderPoints[i][0],borderPoints[i][1],borderImage);
      println("initial dir = " + dir[0] + " " + dir[1]);
      actualPoint[0] = borderPoints[i][0] + dir[0];
      actualPoint[1] = borderPoints[i][1] + dir[1];
      println("border Point = " + borderPoints[i][0] + " " +  borderPoints[i][1]);
      println("actual Point = " + actualPoint[0] + " " + actualPoint[1]);
      sortedBorderPoints[i][0][0] = actualPoint[0];
      sortedBorderPoints[i][0][1] = actualPoint[1];
      //Mientras el punto actual sea distinto del de partida (dado por borderPoints)
      while((actualPoint[0] != borderPoints[i][0]) || (actualPoint[1] != borderPoints[i][1]))
      {
        getActualPointAndNextDir(nextPoint,nextDir,actualPoint,dir,borderImage,borderImage[borderPoints[i][1]][borderPoints[i][0]]);
        actualPoint[0] = nextPoint[0];
        actualPoint[1] = nextPoint[1];
        dir[0] = nextDir[0];
        dir[1] = nextDir[1];
        println("actual Point = " + actualPoint[0] + " " + actualPoint[1]);
        println("actual Dir = " + dir[0] + " " + dir[1]);
        sortedBorderPoints[i][countPerSurface][0] = actualPoint[0];
        sortedBorderPoints[i][countPerSurface][1] = actualPoint[1];        
        countPerSurface++;
      }

      numberBorderPoints[i] = countPerSurface;
    }
  }



  void getInitialDir(int[] dir,int x,int y,int[][] borderImage)
  {
      if(borderImage[y + 1][x] == borderImage[y][x])
      {
        dir[0] = 0;
        dir[1] = 1;
      }
      if(borderImage[y][x + 1] == borderImage[y][x])
      {
        dir[0] = 1;
        dir[1] = 0;
      }
      if(borderImage[y + 1][x - 1] == borderImage[y][x])
      {
        dir[0] = -1;
        dir[1] = 1;
      }
      if(borderImage[y - 1][x + 1] == borderImage[y][x])
      {
        dir[0] = 1;
        dir[1] = -1;
      }
      if(borderImage[y - 1][x] == borderImage[y][x])
      {
        dir[0] = 0;
        dir[1] = -1;
      }
      if(borderImage[y][x - 1] == borderImage[y][x])
      {
        dir[0] = -1;
        dir[1] = 0;
      }
      if(borderImage[y + 1][x + 1] == borderImage[y][x])
      {
        dir[0] = 1;
        dir[1] = 1;
      }
      if(borderImage[y - 1][x - 1] == borderImage[y][x])
      {
        dir[0] = -1;
        dir[1] = -1;
      }
  }



  void getActualPointAndNextDir(int[] nextPoint,int[] nextDir,int[] actualPoint,int[] actualDir,int[][] image, int surfaceVal)
  {
    int[][] neighs = new int[8][2];
    int neighNumber;
    neighNumber = getNeighs(neighs,actualPoint,actualDir,image,surfaceVal);
    println("neighs");
    for(int i=0;i<neighNumber;i++)
    {
      print(neighs[i][0] + " " + neighs[i][1] + " ");
    }
    println(" ");
    getBetterNeigh(nextPoint,actualPoint,actualDir,neighs,neighNumber);
    getNextDir(nextDir,nextPoint,actualPoint);
  }



  int getNeighs(int[][] neighs,int[] point,int[] dir,int[][] image,int surfaceVal)
  {
    int[] startPoint = new int[2];
    int count = 0;
    startPoint[0] = point[0]-1;
    startPoint[1] = point[1]-1;
    println("Point = " + point[0] + " " + point[1]);
    println("start Point = " + startPoint[0] + " " + startPoint[1]);
    println("dir = " + dir[0] + " " + dir[1]);
    for(int i=0;i<3;i++)
    {
      for(int j=0;j<3;j++)
      {
        if(((i != 1) || (j != 1)) && ((i != 1 - dir[1]) || (j != 1 - dir[0])) && (image[startPoint[1]+i][startPoint[0]+j] == surfaceVal)) 
        {
          neighs[count][0] = startPoint[0]+j;
          neighs[count][1] = startPoint[1]+i;
          count++;
        }
      }
    }
    return count;
  }



  void getBetterNeigh(int[] nextPoint,int[] actualPoint,int[]actualDir,int[][] neighs,int neighNumber)
  {
    
    //Inicialmente el primer vecino (uno cualquiera)
    nextPoint[0] = neighs[0][0];
    nextPoint[1] = neighs[0][1];
    println("actual dir better = " + actualDir[0] + " " + actualDir[1]);
    for(int i=1;i<neighNumber;i++)
    {
      println("Point better = " + nextPoint[0] + " " + nextPoint[1]);
      if(isBetterNeigh(neighs[i],nextPoint,actualPoint,actualDir))
      {
        nextPoint[0] = neighs[i][0];
        nextPoint[1] = neighs[i][1];
      }
      println("Point better = " + nextPoint[0] + " " + nextPoint[1]);
    }
    
  }



  boolean isBetterNeigh(int[] n1,int[] n2,int[] actualPoint,int[] dir)
  {
    float h1 = evalNeigh(n1,actualPoint,dir);
    float h2 = evalNeigh(n2,actualPoint,dir);
    println("h1 = " + h1);
    println("h2 = " + h2);
    if(h1 < h2) return true;
    else return false;
  }



  float evalNeigh(int[] neigh,int[] actualPoint,int[] dir)
  {
    return sqrt((neigh[0]-(actualPoint[0]+dir[0]))*(neigh[0]-(actualPoint[0]+dir[0]))+(neigh[1]-(actualPoint[1]+dir[1]))*(neigh[1]-(actualPoint[1]+dir[1])));
  }



  void getNextDir(int[] nextDir,int[] nextPoint,int[] actualPoint)
  {
    println("actual Point get = " + actualPoint[0] + " " + actualPoint[1]);
    println("next Point get = " + nextPoint[0] + " " + nextPoint[1]);
    nextDir[0] = nextPoint[0] - actualPoint[0];
    nextDir[1] = nextPoint[1] - actualPoint[1];
  }
  
  
  //@Salida | vertexes -> los vertices indispensables para definir la superficie
  //@param | borderPoints -> los puntos del borde ordenados
  //@param | nSurface -> numero de superficies de la imagen
  //@param | numberBorderPoints ->
  void deleteUselessVertexes(int[][][] vertexes,int[][][] borderPoints,int nSurface,int[] numberBorderPoints)
  {
    int[] vertex = new int[2];
    for(int i=0;i<nSurface;i++)
    {
      vertex[0] = borderPoints[i][0][0]; 
      vertex[1] = borderPoints[i][0][1];
      for(int j=0;j<numberBorderPoints[i];j++)
      {
       // isLine(
      }
    }  
  }
  
  
}
