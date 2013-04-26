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
}
