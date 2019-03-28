/*
   Assign 2 : Get Into Danger
   Update : 3.28.2019
*/

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState = GAME_START;

final int SPACE_X = 80, SPACE_Y = 80;

boolean downPressed, rightPressed, leftPressed;
boolean downMoving, rightMoving, leftMoving;
boolean move = false;

int groundhogSpaceX = 5, groundhogSpaceY = 0;
float groundhogX = SPACE_X*4, groundhogY = SPACE_Y;
float movingSpeed = 0, movingDistance = 0;
float soldierX = -SPACE_X, soldierY = floor(random(2,6))*SPACE_Y;
int cabbageX = floor(random(2,8))*SPACE_X, cabbageY = floor(random(2,6))*SPACE_Y;
int totalLife = 2;

PImage start, startButton, startButtonHovered;
PImage over, restartButton, restartButtonHovered;
PImage bg, soil, life, soldier, cabbage;
PImage groundhog, groundhogDown, groundhogLeft, groundhogRight;


void setup() {
  size(640, 480, P2D);

  start = loadImage("img/title.jpg");
  startButton = loadImage("img/startNormal.png");
  startButtonHovered = loadImage("img/startHovered.png");
  
  over = loadImage("img/gameover.jpg");
  restartButton = loadImage("img/restartNormal.png");
  restartButtonHovered = loadImage("img/restartHovered.png");
  
  bg = loadImage("img/bg.jpg");
  soil = loadImage("img/soil.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");
  
  groundhog = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  
}

void draw() {
  switch( gameState ){
    case GAME_START:
      image( start, 0, 0 );
      image( startButton, 248, 360 );
      if( mouseX>248 && mouseX<248+144 && mouseY>360 && mouseY<360+60){
        image( startButtonHovered, 248, 360 );
        if(mousePressed){
          gameState = GAME_RUN;
        }
      }
      break;


    case GAME_RUN:
      //background image
      image( bg, 0, 0 );
      image( soil, 0, SPACE_Y*2 );
      
      //grass drawing
      noStroke();
      fill( 124, 204, 25 );
      rect( 0, SPACE_Y*2-15, 640, 15);
      
      //sun drawing
      noStroke();
      fill( 255, 255, 0);
      ellipse( 640-50, 50, 120+10, 120+10 );
      fill( 253, 184, 19 );
      ellipse( 640-50, 50, 120, 120 );
      
      //cabbage eating
      if( cabbageX<groundhogX+80 && cabbageX+80>groundhogX
       && cabbageY<groundhogY+80 && cabbageY+80>groundhogY ){
        totalLife += 1;
        cabbageX = 640;
      }else{
        image( cabbage, cabbageX, cabbageY );
      }
      
      //soldier walking
      image( soldier, soldierX += 5, soldierY );
      soldierX = soldierX % (640+SPACE_X);
      if( soldierX<groundhogX+80 && soldierX+80>groundhogX
       && soldierY<groundhogY+80 && soldierY+80>groundhogY ){
        totalLife -= 1;
        downMoving = false;
        downPressed = false;
        rightMoving = false;
        rightPressed = false;
        leftMoving = false;
        leftPressed = false;
        groundhogSpaceX = 5;
        groundhogSpaceY = 0;
        groundhogX = SPACE_X*4;
        groundhogY = SPACE_Y; 
      }
      
      
      //groundhog image : image width 80px
      ///1.start or end
      if( groundhogSpaceY < 4 ){
        if( downPressed && !rightPressed && !leftPressed ){
          downMoving = true;
          rightMoving = false;
          leftMoving = false;
        }
      }else{
        downMoving =  false;
        groundhogSpaceY = 4;
      }
      if( groundhogSpaceX < 8 ){
        if( !downPressed && rightPressed && !leftPressed ){
          downMoving = false;
          rightMoving = true;
          leftMoving = false;
        }
      }else{
        rightMoving =  false;
        groundhogSpaceX = 8;
      }
      if( groundhogSpaceX > 1 ){
        if( !downPressed && !rightPressed && leftPressed ){
          downMoving = false;
          rightMoving = false;
          leftMoving = true;
        }
      }else{
        leftMoving =  false;
        groundhogSpaceX = 1;
      }
      
      ///2.moving
      if( downMoving ){
        movingSpeed = 80.0/15;
        movingDistance += movingSpeed;
        if( movingDistance >= 80  ){
          groundhogSpaceY += 1;
          movingDistance = 0;
          if( !downPressed ){
            movingSpeed = 0;
            move = false;
            groundhogY = (groundhogSpaceY+1)*SPACE_Y;
            downMoving = false;
          }
        }
        image( groundhogDown, groundhogX, groundhogY+=movingSpeed );
      }
      if( rightMoving ){
        leftPressed = false;
        movingSpeed = 80.0/15;
        movingDistance += movingSpeed;
        if( movingDistance >= 80  ){
          groundhogSpaceX += 1;
          movingDistance = 0;
          if( !rightPressed ){
            movingSpeed = 0;
            groundhogX = (groundhogSpaceX-1)*SPACE_X;
            rightMoving = false;
          }
        }
        image( groundhogRight, groundhogX+=movingSpeed, groundhogY );
      }
      if( leftMoving ){
        rightPressed = false;
        movingSpeed = 80.0/15;
        movingDistance += movingSpeed;
        if( movingDistance >= 80  ){
          groundhogSpaceX -= 1;
          movingDistance = 0;
          if( !leftPressed ){
            movingSpeed = 0;
            groundhogX = (groundhogSpaceX-1)*SPACE_X;
            leftMoving = false;
          }
        }
        image( groundhogLeft, groundhogX-=movingSpeed, groundhogY );
      }
      
      ///3.Stopped
      if( !downMoving && !rightMoving && !leftMoving ){
        image( groundhog, groundhogX, groundhogY );
      }
      
      //life image : image width 50px & space 20px
      if( totalLife == 0 ) gameState = GAME_OVER;
      if( totalLife >= 1 ) image( life, 10, 10 ); 
      if( totalLife >= 2 ) image( life, 10+(50+20), 10 );
      if( totalLife >= 3 ) image( life, 10+(50+20)*2, 10 );
      
      break;


    case GAME_OVER:
      image( over, 0, 0 );
      image( restartButton, 248, 360 );
      if( mouseX>248 && mouseX<248+144 && mouseY>360 && mouseY<360+60){
        image( restartButtonHovered, 248, 360 );
        if(mousePressed){
          gameState = GAME_RUN;
          
          //initializing
          groundhogSpaceX = 5;
          groundhogSpaceY = 0;
          groundhogX = SPACE_X*4;
          groundhogY = SPACE_Y;
          soldierX = -SPACE_X;
          soldierY = floor(random(2,6))*SPACE_Y;
          cabbageX = floor(random(2,8))*SPACE_X;
          cabbageY = floor(random(2,6))*SPACE_Y;
          totalLife = 2;
        }
      }
      break;
  }
}

//arrow key determining
void keyPressed(){
  switch(keyCode){
    case DOWN:
    downPressed = true;
    break;
    
    case RIGHT:
    rightPressed = true;
    break;
    
    case LEFT:
    leftPressed = true;
    break;
  }
}

void keyReleased(){
  switch(keyCode){    
    case DOWN:
    downPressed = false;
    break;
    
    case RIGHT:
    rightPressed = false;
    break;
    
    case LEFT:
    leftPressed = false;
    break;
  }
}
