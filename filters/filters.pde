public class Filters {
  
  private int [] frameDimensions = new int[2];
  private String pathToRawFile ="";
  private int [][] rawData;
  private BufferedReader rawReader;
  
  Filters(int dimX, int dimY, String path){
    frameDimensions[0] = dimX;
    frameDimensions[1] = dimY;
    pathToRawFile = path;
    rawData = new int[dimX][dimY];
    rawReader = createReader(path);
    readRawFile();
  }
  
  void readRawFile(){
    String line;
    String [] lineStringValues;
    
    for (int i=0;i<frameDimensions[0];i++) {
      try {
        line = rawReader.readLine();
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      lineStringValues = line.split(" ");
      for (int j=0;j<frameDimensions[1];j++) {
        rawData[i][j] = Integer.parseInt(lineStringValues[j]);
      }
    }
  }
  
  int [][] deleteSparePointsByDepth() {
    return null;
  }
}
