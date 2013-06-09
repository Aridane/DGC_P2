import java.lang.IndexOutOfBoundsException;
public class Filters {

  int alto;
  int ancho;
  //0 front, 1 right, 2 back, 3 left
  private int view;
  private int [] frameDimensions = new int[2];
  private String pathToRawFile ="";
  private int [][] rawData;
  private int [][] reducedData;
  
  //x,y,profundidad
  private int [][] initialBorderPoints;
  private int [] numberOfPointsPerBorder;
  private int nBorders = 0;
  private BufferedReader rawReader;
  private int maxDepth = 0;
  private int limitThres = 390;
  private int neighbourThres = 9;
  private int neighbourDepthThres = 45;
  PrintWriter debug= createWriter("debug.txt");

  int[][][] vertexes;
  int[] vertexesCount;
  int[][][] sortedBorderPoints;

  Filters(int dimX, int dimY, String path/*, int pview*/) {
    ancho = dimX;
    alto = dimY;
    frameDimensions[0] = dimX;
    frameDimensions[1] = dimY;
   // view = pview;
    pathToRawFile = path;
    rawData = new int[dimY][dimX];
    reducedData = new int[dimY][dimX];
    for (int i=0;i<dimY;i++) {
      for (int j=0;j<dimX;j++) reducedData[i][j] = 0;
    }
    rawReader = createReader(path);
    readRawFile();
    sortedBorderPoints = new int[20][2*alto+2*ancho][3];
  }

  void readRawFile() {
    String line;
    String [] lineStringValues;

    for (int i=0;i<frameDimensions[1];i++) {
      try {
        line = rawReader.readLine();
      } 
      catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      lineStringValues = line.split(" ");
      println("Y = "+i+"Split Length"+lineStringValues.length);
      for (int j=0;j<frameDimensions[0];j++) {
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


  boolean inRangeInReduced(int actualDepth, int x, int y)
  {
    return (((abs(reducedData[x][y] - actualDepth)) < neighbourDepthThres));
  }

  /*Comprueba la cantidad de vecinos de un punto dentro del rango*/
  /*Si un piunto tiene un numero de vecinos menor que el limite establecido se devuelve true*/
  boolean checkNeighbours(int actualDepth, int i, int j) {
    int counter = 0;
    int oldNeighbourThres = neighbourThres;
    if ((i == 0)&&(j == 0)) {
      //println("C1");
      neighbourThres = 5;
      for (int ic=0;ic<2;ic++) {
        for (int jc=0;jc<2;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else if ((i == 0)&&(j == frameDimensions[0]-1)) {
      //println("C2");
      neighbourThres = 5;
      for (int ic=0;ic<2;ic++) {
        for (int jc=-1;jc<1;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else if ((i == frameDimensions[1]-1)&&(j == 0)) {
//println("C3");
      neighbourThres = 5;
      for (int ic=-1;ic<1;ic++) {
        for (int jc=0;jc<2;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else if ((i == frameDimensions[1]-1)&&(j == frameDimensions[0]-1)) {
//println("C4");
      neighbourThres = 5;
      for (int ic=-1;ic<1;ic++) {
        for (int jc=-1;jc<1;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else if (i == 0) {
//println("C5");
      neighbourThres = 7;

      for (int ic=0;ic<2;ic++) {
        for (int jc=-1;jc<2;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      //println("nbTH = "+neighbourThres+"counter = "+counter+"i = "+ i + " j = "+j);

      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else if (j == 0) {
      //println("C6");
      neighbourThres = 7;
      for (int ic=-1;ic<2;ic++) {
        for (int jc=0;jc<2;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else if (i == frameDimensions[1]-1) {
      //println("C7");
      neighbourThres = 7;
      for (int ic=-1;ic<1;ic++) {
        for (int jc=-1;jc<2;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else if (j == frameDimensions[0]-1) {
      //println("C8");
      neighbourThres = 7;
      for (int ic=-1;ic<2;ic++) {
        for (int jc=-1;jc<1;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) {
        neighbourThres = oldNeighbourThres;
        return true;
      }
      return false;
    }
    else {
      for (int ic=-1;ic<2;ic++) {
        for (int jc=-1;jc<2;jc++) {
          if (inRange(actualDepth, i+ic, j+jc)) { 
            counter++;
          }
        }
      }
      if (counter < neighbourThres) return true;
    }
    return false;
  }

  int [][] deleteSparePointsByDepth() {
    int actualDepth = 0;
    int actualDepthSector = 0;
    for (int i=0;i<frameDimensions[1];i++) {
      for (int j=0;j<frameDimensions[0];j++) {
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


  //Lo modifique para que directamente obtuviera los bordes ordenados de todas las superficies
  void getSortedBorders()
  {
    //Recorremos la matriz reducida, cuando encontramos un elemento !=0 obtenemos el borde al que pertenece y almacenamos ese borde.
    //recorremos el resto de puntos hasta que encontramos uno que no pertenece a un borde recorrido y lo usamos como nuevo punto inicial.
    initialBorderPoints = new int[20][2];
    int actualDepth = 0;
    numberOfPointsPerBorder = new int [20];
    int [] nPoints = new int[1];
    for (int i=0;i<frameDimensions[0];i++)
    {
      for (int j=0;j<frameDimensions[1];j++)
      {
        actualDepth = reducedData[j][i];
        int [] point = {i,j};
        if ((actualDepth != 0) && (!isPartOf(point, sortedBorderPoints,actualDepth)))
        {
          try
          {
            println("depth = " + actualDepth);
            println("point = " + point[0] + " " + point[1]);
            initialBorderPoints[nBorders] = point;
          
            if(sortBorder(point,actualDepth)) nBorders++;
          }
          catch (ArrayIndexOutOfBoundsException e)
          {
          }
        }
      }
    }
    vertexes = new int[nBorders][2*alto+2*ancho][3];
    vertexesCount = new int[nBorders];
//println("nBorders = "+ nBorders +" nPoints Border 1 = "+ numberOfPointsPerBorder[0]);
  }


  boolean isPartOf(int [] point, int [][][] pointList, int depthVal) {
    for (int i=0;i<nBorders;i++) {
      for (int j=0;j<numberOfPointsPerBorder[i];j++) {
        if (isNeighAndInRange(pointList[i][j], point, depthVal)) return true;
      }
    }
    return false;
  }

  boolean isNeighAndInRange(int[] p1, int[] p2, int depthVal)
  {
    int[] startPoint = new int[2];
    startPoint[0] = p2[0]-1;
    startPoint[1] = p2[1]-1;
    for (int i=0;i<3;i++)
    {
      for (int j=0;j<3;j++)
      {
        if ((startPoint[0]+j >= 0) && (startPoint[1]+i >= 0) && (startPoint[0]+j < reducedData[0].length) && (startPoint[1]+i < reducedData.length) && (p1[0] == startPoint[0]+j) && (p1[1] == startPoint[1]+i) && inRangeInReduced(depthVal, startPoint[1]+i, startPoint[0]+j)) return true;
      }
    }
    return false;
  }

  //@salida | sortedBorderPoints -> vector de puntos del borde ordenados
  //@return | numero de puntos del borde
  //@param | initialBorderPoint -> punto inicial
  //@param | depthValue -> valor de profundidad del punto inicial
  boolean sortBorder(int[] initialBorderPoint,int depthValue)
  {
    int[] dir = new int[2];;
    int[] actualPoint = new int[2];
    int[] nextPoint = new int[2];
    int[] nextDir = new int[2];
    numberOfPointsPerBorder[nBorders] = 1;

    //Obtener la direccion inicial y el punto actual
    if(!getInitialDir(dir,initialBorderPoint[0],initialBorderPoint[1],depthValue)) return false;
    //println("initial dir = " + dir[0] + " " + dir[1]);
    actualPoint[0] = initialBorderPoint[0] + dir[0];
    actualPoint[1] = initialBorderPoint[1] + dir[1];
    //println("border Point = " + initialBorderPoint[0] + " " + initialBorderPoint[1]);
    //println("actual Point = " + actualPoint[0] + " " + actualPoint[1]);
    sortedBorderPoints[nBorders][0][0] = actualPoint[0];
    sortedBorderPoints[nBorders][0][1] = actualPoint[1];
    //Mientras el punto actual sea distinto del de partida (dado por borderPoints)
    while((actualPoint[0] != initialBorderPoint[0]) || (actualPoint[1] != initialBorderPoint[1]))
    {
      getActualPointAndNextDir(nextPoint,nextDir,actualPoint,dir,depthValue);

      
      actualPoint[0] = nextPoint[0];
      actualPoint[1] = nextPoint[1];
      dir[0] = nextDir[0];
      dir[1] = nextDir[1];
/*      if((actualPoint[0] == 35) && (actualPoint[1] == 0))
      {*/
  //      println("initial Point = " + initialBorderPoint[0] + " " + initialBorderPoint[1]);
        /*println("actual Point = " + actualPoint[0] + " " + actualPoint[1]);
        println("actual Dir = " + dir[0] + " " + dir[1]);
        println("next Point = " + nextPoint[0] + " " + nextPoint[1]);
        println("next Dir = " + nextDir[0] + " " + nextDir[1]);*/
     // }
      sortedBorderPoints[nBorders][numberOfPointsPerBorder[nBorders]][0] = actualPoint[0];
      sortedBorderPoints[nBorders][numberOfPointsPerBorder[nBorders]][1] = actualPoint[1];
      numberOfPointsPerBorder[nBorders]++;
    }
    return true;
  }



  boolean getInitialDir(int[] dir,int x,int y,int depthVal)
  {
      //println("xy " + x + " " + y);
      if((y+1 >= 0) && (x >= 0) && (y+1 < reducedData.length) && (x < reducedData[0].length) && (inRange(depthVal,y+1,x)))
      {
        dir[0] = 0;
        dir[1] = 1;
        return true;
      }
      if((y >= 0) && (x+1 >= 0) && (y < reducedData.length) && (x+1 < reducedData[0].length) && (inRange(depthVal,y,x+1)))
      {
        dir[0] = 1;
        dir[1] = 0;
        return true;
      }
      if((y+1 >= 0) && (x-1 >= 0) && (y+1 < reducedData.length) && (x-1 < reducedData[0].length) && (inRange(depthVal,y+1,x-1)))
      {
        dir[0] = -1;
        dir[1] = 1;
        return true;
      }
      if((y-1 >= 0) && (x+1 >= 0) && (y-1 < reducedData.length) && (x+1 < reducedData[0].length) && (inRange(depthVal,y-1,x+1)))
      {
        dir[0] = 1;
        dir[1] = -1;
        return true;
      }
      if((y-1 >= 0) && (x >= 0) && (y-1 < reducedData.length) && (x < reducedData[0].length) && (inRange(depthVal,y-1,x)))
      {
        dir[0] = 0;
        dir[1] = -1;
        return true;
      }
      if((y >= 0) && (x-1 >= 0) && (y < reducedData.length) && (x-1 < reducedData[0].length) && (inRange(depthVal,y,x-1)))
      {
        dir[0] = -1;
        dir[1] = 0;
        return true;
      }
      if((y+1 >= 0) && (x+1 >= 0) && (y+1 < reducedData.length) && (x+1 < reducedData[0].length) && (inRange(depthVal,y+1,x+1)))
      {
        dir[0] = 1;
        dir[1] = 1;
        return true;
      }
      if((y-1 >= 0) && (x-1 >= 0) && (y-1 < reducedData.length) && (x-1 < reducedData[0].length) && (inRange(depthVal,y-1,x-1)))
      {
        dir[0] = -1;
        dir[1] = -1;
        return true;
      }
      println("IHOIHIUHOIHIU");
      return false;
  }



  void getActualPointAndNextDir(int[] nextPoint,int[] nextDir,int[] actualPoint,int[] actualDir, int depthVal)
  {
    int[][] neighs = new int[8][2];
    int neighNumber;
    neighNumber = getNeighs(neighs,actualPoint,actualDir,depthVal);
    if((actualPoint[0] == 0) && (actualPoint[1] == 36))
    {
      for(int i=0;i<neighNumber;i++)
      {
        //System.out.println("neigh = " + neighs[i][0] + " " + neighs[i][1]);
      }
    }
    if((actualPoint[0] == 108) && (actualPoint[1] == 220))
    {
      println("neighs");
      for(int i=0;i<neighNumber;i++)
      {
        print(neighs[i][0] + " " + neighs[i][1] + " ");
      }
      println(" ");
    }

    getBetterNeigh(nextPoint,actualPoint,actualDir,neighs,neighNumber);
    getNextDir(nextDir,nextPoint,actualPoint);
  }



  int getNeighs(int[][] neighs,int[] point,int[] dir,int depthVal)
  {
    int[] startPoint = new int[2];
    int count = 0;
    startPoint[0] = point[0]-1;
    startPoint[1] = point[1]-1;
  /*  if((point[0] == 108)&&(point[1] == 220))
    {
    println("Point = " + point[0] + " " + point[1]);
    println("start Point = " + startPoint[0] + " " + startPoint[1]);
    println("dir = " + dir[0] + " " + dir[1]);
    println("depthval " + depthVal);
    }*/
     
    for(int i=0;i<3;i++)
    {
      for(int j=0;j<3;j++)
      {
          if((point[0] == 108)&&(point[1] == 220))
          {
             /*println("coorde = " + (startPoint[0]+j) + " " + (startPoint[1]+i));
             println("diff = "+(abs(reducedData[startPoint[1]+i][startPoint[0]+j] - depthVal)));*/
             //if(!inRangeInReduced(depthVal,startPoint[1]+i,startPoint[0]+j)) println("no esta en rango");
          }
        if((!isSorted(startPoint[0]+j,startPoint[1]+i)) && (startPoint[1]+i >= 0) && (startPoint[0]+j >= 0) && (startPoint[1]+i < reducedData.length) && (startPoint[0]+j < reducedData[0].length) && ((i != 1) || (j != 1)) && ((i != 1 - dir[1]) || (j != 1 - dir[0])) && (inRangeInReduced(depthVal,startPoint[1]+i,startPoint[0]+j)))
        {
        /*  if((point[0] == 108)&&(point[1] == 220))
          {
                println("coorde = " + (startPoint[0]+j) + " " + (startPoint[1]+i));
                println("INRANGE?? = " + reducedData[startPoint[1]+i][startPoint[0]+j]);
                println("entro");
          }*/
          neighs[count][0] = startPoint[0]+j;
          neighs[count][1] = startPoint[1]+i;
          count++;
        }
      }
    }
    return count;
  }

  boolean isSorted(int pointColumn,int pointRow)
  {
    for(int i=0;i<numberOfPointsPerBorder[nBorders];i++)
    {
      if((pointColumn == sortedBorderPoints[nBorders][i][0]) && (pointRow== sortedBorderPoints[nBorders][i][1])) return true;
    }
    return false;
  }

  void getBetterNeigh(int[] nextPoint,int[] actualPoint,int[]actualDir,int[][] neighs,int neighNumber)
  {
    
    //Inicialmente el primer vecino (uno cualquiera)
    nextPoint[0] = neighs[0][0];
    nextPoint[1] = neighs[0][1];
    //println("actual dir better = " + actualDir[0] + " " + actualDir[1]);
    for(int i=1;i<neighNumber;i++)
    {
      //println("Point better = " + nextPoint[0] + " " + nextPoint[1]);
      if(isBetterNeigh(neighs[i],nextPoint,actualPoint,actualDir))
      {
        nextPoint[0] = neighs[i][0];
        nextPoint[1] = neighs[i][1];
      }
      //println("Point better = " + nextPoint[0] + " " + nextPoint[1]);
    }
    
  }



  boolean isBetterNeigh(int[] n1,int[] n2,int[] actualPoint,int[] dir)
  {
    float h1 = evalNeigh(n1,actualPoint,dir);
    float h2 = evalNeigh(n2,actualPoint,dir);
   /* println("h1 = " + h1);
println("h2 = " + h2);*/
    if(h1 <= h2) return true;
    else return false;
  }



  float evalNeigh(int[] neigh,int[] actualPoint,int[] dir)
  {
    return sqrt((neigh[0]-(actualPoint[0]+dir[0]))*(neigh[0]-(actualPoint[0]+dir[0]))+(neigh[1]-(actualPoint[1]+dir[1]))*(neigh[1]-(actualPoint[1]+dir[1])));
  }



  void getNextDir(int[] nextDir,int[] nextPoint,int[] actualPoint)
  {
    /*println("actual Point get = " + actualPoint[0] + " " + actualPoint[1]);
println("next Point get = " + nextPoint[0] + " " + nextPoint[1]);*/
    nextDir[0] = nextPoint[0] - actualPoint[0];
    nextDir[1] = nextPoint[1] - actualPoint[1];
  }
  
  
  //@Salida | vertexes -> los vertices indispensables para definir la superficie
  //@param | borderPoints -> los puntos del borde ordenados
  //@param | nSurface -> numero de superficies de la imagen
  //@param | numberBorderPoints ->
  void deleteUselessVertexes()
  {
    int[] initialVertex = new int[2];
    int[] actualVertex = new int[2];
    int initialIndex;
    int j ;
    for(int i=0;i<nBorders;i++)
    {
      vertexesCount[i] = 1;
      initialIndex = 0;
      initialVertex[0] = sortedBorderPoints[i][0][0];
      initialVertex[1] = sortedBorderPoints[i][0][1];
      vertexes[i][0][0] = initialVertex[0];
      vertexes[i][0][1] = initialVertex[1];
      actualVertex[0] = sortedBorderPoints[i][1][0];
      actualVertex[1] = sortedBorderPoints[i][1][1];
      j = 2;
      while(j<numberOfPointsPerBorder[i]+1)
      {

        if(!isLine(initialVertex,actualVertex,initialIndex,sortedBorderPoints[i]))
        {
          //println("NO LINEA");
          initialVertex[0] = sortedBorderPoints[i][j-2][0];
          initialVertex[1] = sortedBorderPoints[i][j-2][1];
          initialIndex = j-2;
          vertexes[i][vertexesCount[i]][0] = sortedBorderPoints[i][j-2][0];
          vertexes[i][vertexesCount[i]][1] = sortedBorderPoints[i][j-2][1];
          vertexesCount[i]++;
        }
        else
        {
          if(j < numberOfPointsPerBorder[i])
          {
            actualVertex[0] = sortedBorderPoints[i][j][0];
            actualVertex[1] = sortedBorderPoints[i][j][1];
          }
          j++;
        }
      }
      vertexes[i][vertexesCount[i]][0] = sortedBorderPoints[i][numberOfPointsPerBorder[i]-1][0];
      vertexes[i][vertexesCount[i]][1] = sortedBorderPoints[i][numberOfPointsPerBorder[i]-1][1];
      vertexesCount[i]++;
    }
  }
  
  
  boolean isLine(int[] iniVertex,int[] endVertex,int initialIndex,int[][] borderPoints)
  {
    /*println("iniVertex = " + iniVertex[0] + " " + iniVertex[1]);
println("endVertex = " + endVertex[0] + " " + endVertex[1]);
println("tam line points = " + (int)(Math.floor(sqrt((iniVertex[0]-endVertex[0])*(iniVertex[0]-endVertex[0])+(iniVertex[1]-endVertex[1])*(iniVertex[1]-endVertex[1])))+1));*/
    int[][] linePoints = new int[(int)Math.floor(sqrt((iniVertex[0]-endVertex[0])*(iniVertex[0]-endVertex[0])+(iniVertex[1]-endVertex[1])*(iniVertex[1]-endVertex[1])))+1][2];
    int[] which = new int[1];
    int numberPoints = getPointsBresenham(iniVertex[0],iniVertex[1],endVertex[0],endVertex[1],linePoints,0,which);
    /*println("line points");
for(int i=0;i<numberPoints;i++)
{
println("line " + linePoints[i][0] + " " + linePoints[i][1]);
println("border " + borderPoints[initialIndex+i][0] + " " + borderPoints[initialIndex+i][1]);
}*/
    if(which[0] == 0)
    {
      for(int i=0;i<numberPoints;i++)
      {
        if((borderPoints[initialIndex+i][0] != linePoints[i][0]) || (borderPoints[initialIndex+i][1] != linePoints[i][1])) return false;
      }
      return true;
    }
    else
    {
      for(int i=0;i<numberPoints;i++)
      {
        if((borderPoints[initialIndex+i][0] != linePoints[numberPoints-1-i][0]) || (borderPoints[initialIndex+i][1] != linePoints[numberPoints-1-i][1])) return false;
      }
      return true;
    }
  }
  
  int getPointsBresenham (int x0,int y0,int x1,int y1,int[][] linePoints,int numberPoints,int[] which)
  {
    int R = 0;
    int A;
    int B;
    int p;
    int xk;
    int yk;
    int i;
    int number;
    int Count = 0;
    if ((x0 != x1) || (y0 != y1))
    {
      if ((abs(y1-y0)>=abs(x1-x0)))
      {
        if (y1 < y0)
        {
          number = getPointsBresenham (x1,y1,x0,y0,linePoints,numberPoints,which);
          which[0] = 1;
          return number;
        }
        else
        {
          //println("numberPoints = " + numberPoints);
          linePoints[numberPoints][0] = x0;
          linePoints[numberPoints][1] = y0;
          numberPoints++;
          if (x1 > x0) R=1;
          if (x1 < x0) R=-1;
          A=2*abs((x1-x0));
          B=A-2*abs(y1-y0);
          p=A-abs(y1-y0);
          xk=x0;
          for (yk=y0; yk<y1; yk++)
          {
            if (p<=0)
            {
              linePoints[numberPoints][0] = xk;
              linePoints[numberPoints][1] = yk+1;
              numberPoints++;
              p=p+A;
            }
            else
            {
              linePoints[numberPoints][0] = xk+R;
              linePoints[numberPoints][1] = yk+1;
              numberPoints++;
              p=p+B;
              xk=xk+R;
            }
          }
          which[0] = 0;
          return numberPoints;
        }
      }
      else
      {
        if (x1 < x0)
        {
          number = getPointsBresenham(x1,y1,x0,y0,linePoints,numberPoints,which);
          which[0] = 1;
          return number;
        }
        else
        {
          //println("numberPoints = " + numberPoints);
          linePoints[numberPoints][0] = x0;
          linePoints[numberPoints][1] = y0;
          numberPoints++;
          if (y1 > y0) R=1;
          if (y1 < y0) R=-1;
          A=2*abs((y1-y0));
          B=A-2*(x1-x0);
          p=A-(x1-x0);
          yk=y0;
          for (xk=x0; xk<x1; xk++)
          {
            //println("x1 = " + x1 + " xk = " + xk);
            if (p<=0)
            {
              linePoints[numberPoints][0] = xk+1;
              linePoints[numberPoints][1] = yk;
              numberPoints++;
              p=p+A;
            }
            else
            {
              //println("number points interior = " + numberPoints);
              linePoints[numberPoints][0] = xk+1;
              linePoints[numberPoints][1] = yk+R;
              numberPoints++;
              p=p+B;
              yk=yk+R;
            }
          }
          which[0] = 0;
          return numberPoints;
        }
      }
    }
    return 0;
  }



/*//Todos los puntos se convierten a un sistema de referencia con respecto al centroide del objeto
void changeVertexReferenceSystem(int [] centroid) {
  for (int k=0;k<nBorders;k++) {
    for (int i=0;i<vertexesCount[k];i++) {
    //Para el borde "k" y el vertice "i"
    
    }
  }
}*/
}

