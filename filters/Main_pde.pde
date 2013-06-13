PrintWriter output;
int alt = 240;
int anch = 320;
int centerX = 410;
int centerY = 260;
int centerZ = 705-290;

void setup(){
  size(1240, 768);
  background(102);
  stroke(255,0,15);
  frame.setResizable(true);
  output = createWriter("newMap.txt");


  /*Filters filter0 = new Filters(320,240,"figura_4_front.txt",0,centerX,centerY, centerZ);
  Filters filter1 = new Filters(320,240,"figura_4_perfil_1.txt",1,centerX,centerY, centerZ);
  Filters filter2 = new Filters(320,240,"figura_4_perfil_2.txt",3,centerX,centerY, centerZ);
  Filters filter3 = new Filters(320,240,"figura_4_tras.txt",2,centerX,centerY, centerZ);*/
  
  Filters filter0 = new Filters(320,240,"figura_4_front.txt",0,centerX,centerY, centerZ);
  Filters filter1 = new Filters(320,240,"figura_4_perfil_1.txt",1,centerX,centerY, centerZ);
  Filters filter2 = new Filters(320,240,"figura_4_perfil_2.txt",3,centerX,centerY, centerZ);
  Filters filter3 = new Filters(320,240,"figura_4_tras.txt",2,centerX,centerY, centerZ);
  
  filter0.deleteSparePointsByDepth();
  filter1.deleteSparePointsByDepth();
  filter2.deleteSparePointsByDepth();
  filter3.deleteSparePointsByDepth();
  
  /*  int [][] mat = filter.getReducedMatrix();
  for (int i=0;i<alt;i++){
    for (int j=0;j<anch;j++){
      output.print(mat[i][j] + " ");
    }
    output.println("");
  }
  output.flush();
  output.close();*/
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
  
  int [][][][] filterVerteces = new int[4][][][];
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

  Figure figura = new Figure(filterVerteces, nb, nvert);
  
  
  figura.draw();
  
/*
  println("vertices");
  for(int k=0;k<filter0.nBorders;k++)
  {
    stroke(random(255),255,255);
    println("surface");
    for(int i=0;i<filter0.vertexesCount[k];i++)
    {
      point(filter0.vertexes[k][i][0],filter0.vertexes[k][i][1]);
      println(filter0.vertexes[k][i][0] + " " + filter0.vertexes[k][i][1]);
      if(i<filter0.vertexesCount[k]-1)
      {
        line(filter0.vertexes[k][i][0],filter0.vertexes[k][i][1],filter0.vertexes[k][i+1][0],filter0.vertexes[k][i+1][1]);

      }
      else
      {
         line(filter0.vertexes[k][i][0],filter0.vertexes[k][i][1],filter0.vertexes[k][0][0],filter0.vertexes[k][0][1]);
      }
    }
  }
   for(int k=0;k<filter1.nBorders;k++)
  {
    stroke(255,random(255),255);
    println("surface");
    for(int i=0;i<filter1.vertexesCount[k];i++)
    {
      point(filter1.vertexes[k][i][0],filter1.vertexes[k][i][1]);
      println(filter1.vertexes[k][i][0] + " " + filter1.vertexes[k][i][1]);
      if(i<filter1.vertexesCount[k]-1)
      {
        line(filter1.vertexes[k][i][0],filter1.vertexes[k][i][1],filter1.vertexes[k][i+1][0],filter1.vertexes[k][i+1][1]);

      }
      else
      {
         line(filter1.vertexes[k][i][0],filter1.vertexes[k][i][1],filter1.vertexes[k][0][0],filter1.vertexes[k][0][1]);
      }
    }
  }
    for(int k=0;k<filter2.nBorders;k++)
  {
    stroke(255,255,random(255));
    println("surface");
    for(int i=0;i<filter2.vertexesCount[k];i++)
    {
      point(filter2.vertexes[k][i][0],filter2.vertexes[k][i][1]);
      println(filter2.vertexes[k][i][0] + " " + filter2.vertexes[k][i][1]);
      if(i<filter2.vertexesCount[k]-1)
      {
        line(filter2.vertexes[k][i][0],filter2.vertexes[k][i][1],filter2.vertexes[k][i+1][0],filter2.vertexes[k][i+1][1]);

      }
      else
      {
         line(filter2.vertexes[k][i][0],filter2.vertexes[k][i][1],filter2.vertexes[k][0][0],filter2.vertexes[k][0][1]);
      }
    }
  }
    for(int k=0;k<filter3.nBorders;k++)
  {
    stroke(0,0,random(255));
    println("surface");
    for(int i=0;i<filter3.vertexesCount[k];i++)
    {
      point(filter3.vertexes[k][i][0],filter3.vertexes[k][i][1]);
      println(filter3.vertexes[k][i][0] + " " + filter3.vertexes[k][i][1]);
      if(i<filter3.vertexesCount[k]-1)
      {
        line(filter3.vertexes[k][i][0],filter3.vertexes[k][i][1],filter3.vertexes[k][i+1][0],filter3.vertexes[k][i+1][1]);

      }
      else
      {
         line(filter3.vertexes[k][i][0],filter3.vertexes[k][i][1],filter3.vertexes[k][0][0],filter3.vertexes[k][0][1]);
      }
    }
  }*/
}

//Aqui modificas a mano lo que hace que no funcione
void cheatingTool(Filters filter)
{
  filter.reducedData[0][171] = 0;
}

void matching(Filters front,Filters perfil_1,Filters perfil_2,Filters tras,int threshold)
{
  //for(int i=0;i<front.nBorders;i++)
}
