//A RECURSIVE BACKTRACKER MAZE ALGORITHM

int cellSize=30;
int cellsX;
int cellsY;
Cell[][] cells;
CellCoord currentCell;
ArrayList<CellCoord> backtracker;

//VISITED CELL COLOR
float currH, currB;
float nextH, nextB;
//CELL COLOR
float currH1, currB1;
float nextH1, nextB1;
float easing = 0.01;
int lastChange = 0;
PShader fragment;

void setup(){
  
  fullScreen(P3D);
  colorMode(HSB, 100);
  fragment=loadShader("FX.glsl");
  fragment.set("u_resolution", float(width), float(height));
  currH=random(100);
  currB=random(100);
  currH1=random(100);
  currB1=random(100);
  pickNextColor();

  //SIZE
  cellsX = width/cellSize;
  cellsY = height/cellSize;

  backtracker = new ArrayList<CellCoord>();
  
  //STARTING POINT
  currentCell=new CellCoord(int(random(cellsX)), int(random(cellsY)));
  
  //INIT MAZE ARRAY
  cells=new Cell[cellsX][cellsY];
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {
      Cell cell = new Cell(new CellCoord(i,j));
      cells[i][j] = cell;
    }
  }
  
  //Generates a full maze
  /*cells[currentCell.x][currentCell.y].visit();
  while(backtracker.size()>0){
    cells[currentCell.x][currentCell.y].visit();
  }*/

}

void draw(){
  //Starts drawing a maze
  cells[currentCell.x][currentCell.y].visit();
  
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {
      cells[i][j].drawCell();
    }
  }
  
   filter(fragment);
}

void restart(){
  for (int i = 0; i < cellsX; i++) {
    for (int j = 0; j < cellsY; j++) {
      cells[i][j].visited=false;
      cells[i][j].walls[0]=true;
      cells[i][j].walls[1]=true;
      cells[i][j].walls[2]=true;
      cells[i][j].walls[3]=true;
    }
  }
  currH=random(100);
  currB=random(100);
  currH1=random(100);
  currB1=random(100);
}  

class Cell {
  
  PVector position;
  CellCoord coord;
  
  color visitColor = color(currH, currB, 100);
  
  //WALLS ARRAY POSITION
  //       ___0___
  //      |       |
  //    2 |       |3
  //      |_______|
  //          1
  
  boolean[] walls={true,true,true,true};
  
  boolean visited=false;
  
  Cell(CellCoord c){
    position = new PVector(c.x*cellSize, c.y*cellSize);
    coord = c;
  }
  
  void visit(){
    visited=true;
    lastChange++;
    if (lastChange>100){
      pickNextColor();
      lastChange=0;
    }
    updateCurrColor();
    visitColor = color(currH, currB, 100);
    CellCoord n=nextCell();
//OPEN NEXT CELL'S GATE
    if(n!=null){
      if(coord.x-n.x==0){
//OPEN NORTH 0
        if (coord.y-n.y>0){
          cells[n.x][n.y].walls[1]=false;
          walls[0]=false;
//OPEN SOUTH 1
        }else{
          cells[n.x][n.y].walls[0]=false;
          walls[1]=false;
        }
      }else{
//OPEN WEST 2
        if (coord.x-n.x>0) {
          cells[n.x][n.y].walls[3]=false;
          walls[2]=false;
//OPEN EAST 3
        }else{
          cells[n.x][n.y].walls[2]=false;
          walls[3]=false;
        }        
      }
      backtracker.add(currentCell);
      currentCell = n;
//IF THERE ISN'T ANY NEIGHBOR
    }else{
      if(backtracker.size()>0){
        int i=backtracker.size()-1;
        currentCell = backtracker.get(i);
        backtracker.remove(i);
      }else{
        restart();
      }
    }
  }
  
  CellCoord nextCell(){
    ArrayList<CellCoord> cc = new ArrayList<CellCoord>();
    if (coord.y>0){
        if(!cells[coord.x][coord.y-1].visited){
          cc.add(new CellCoord(coord.x,coord.y-1));
        }
    }
    if (coord.y<cellsY-1){
        if(!cells[coord.x][coord.y+1].visited){
          cc.add(new CellCoord(coord.x,coord.y+1));
        }
    }
    if (coord.x>0){
        if(!cells[coord.x-1][coord.y].visited){
          cc.add(new CellCoord(coord.x-1,coord.y));
        }
    }    
    if (coord.x<cellsX-1){
        if(!cells[coord.x+1][coord.y].visited){
          cc.add(new CellCoord(coord.x+1,coord.y));
        }
    }
    if (cc.size()>0){
      int rnd=floor(random(cc.size()));
      return cc.get(rnd);
    }else{
      return null;
    }
  }
  
  void drawWalls(){
    stroke(0);
    if (walls[0]){
      line(position.x,position.y,position.x+cellSize, position.y);
    }
    if (walls[1]){
      line(position.x,position.y+cellSize,position.x+cellSize, position.y+cellSize);
    }
    if (walls[2]){
      line(position.x,position.y,position.x, position.y+cellSize);
    }
    if (walls[3]){
      line(position.x+cellSize,position.y,position.x+cellSize, position.y+cellSize);
    }
  }
  
  void drawCell(){
    noStroke();
    if(visited){
      fill(visitColor);
    }else{
      fill(currH1,currB1,75);
    }
    rect(position.x,position.y,cellSize, cellSize);
    drawWalls();
  }
}

//A 2D INT VECTOR USED TO STORE CELLS LOCATIONS
class CellCoord{
  int x;
  int y;
  
  CellCoord(int X, int Y){
    x=X;
    y=Y;
  }
}

void pickNextColor() {
  nextH = random(100);
  nextB = random(50);
  nextH1 = random(100);
  nextB1 = random(50);
}

void updateCurrColor() {
  // Easing between current and next colors
  currH += easing * (nextH - currH);
  currB += easing * (nextB - currB);
}
