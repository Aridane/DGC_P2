PrintWriter output;
PrintWriter output2;
float dragX, dragY;
float iniPressedX;
float iniPressedY;

float prevDragX;
float prevDragY;

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
  //loop();
  frame.setResizable(true);
  output = createWriter("newMap.txt");
  
  Filters filter0 = new Filters(320,240,"C:\\figura_3_front.txt",0,centerX,centerY, centerZ);
  Filters filter1 = new Filters(320,240,"C:\\figura_3_perfil_1.txt",1,centerX,centerY, centerZ);
  Filters filter2 = new Filters(320,240,"C:\\figura_3_perfil_2.txt",3,centerX,centerY, centerZ);
  Filters filter3 = new Filters(320,240,"C:\\figura_3_tras.txt",2,centerX,centerY, centerZ);
  
  filter0.deleteSparePointsByDepth();
  filter1.deleteSparePointsByDepth();
  filter2.deleteSparePointsByDepth();
  filter3.deleteSparePointsByDepth();
  
   int [][] mat = filter1.getReducedMatrix();
    for (int i=0;i<alt;i++){
    for (int j=0;j<anch;j++){
      output.print(mat[i][j] + " ");
    }
    output.println("");
  }
  output.flush();
  output.close();
  
  
 // cheatingTool(filter0);
  filter0.getSortedBorders();
  filter1.getSortedBorders();
  filter2.getSortedBorders();
  filter3.getSortedBorders();
  
  filter0.deleteUselessVertexes();
  filter1.deleteUselessVertexes();
/*  for(int i=0;i<filter1.nBorders;i++)
  {
    for(int j=0;j<filter1.numberOfPointsPerBorder[i];j++)
    {
      //println("superficie " + i + " punto " + j + " = " + filter1.vertexes[i][j][0] + " " + filter1.vertexes[i][j][1] + " " + filter1.vertexes[i][j][2]);
      println("superficie " + i + " punto " + j + " = " + filter1.sortedBorderPoints[i][j][0] + " " + filter1.sortedBorderPoints[i][j][1] + " " + filter1.sortedBorderPoints[i][j][2]);
    }
  }*/
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
  //figura.matching(200);
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


void mousePressed() {
  if (mouseButton == LEFT) {
    println("LEFT CLICK");
    prevDragX = mouseX;
    prevDragY = mouseY;
    iniPressedX = mouseX;
    iniPressedY = mouseY;
  }
}
void mouseDragged(){
  dragX = mouseX;
  dragY = mouseY;
  println("DRAG");
  figura.rotate((+prevDragY-dragY)*0.02,(-prevDragX+dragX)*0.02,iniPressedX, iniPressedY);
  
  prevDragX = mouseX;
  prevDragY = mouseY;
    
}

