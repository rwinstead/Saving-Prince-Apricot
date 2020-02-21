//USE ARROW KEYS (LEFT, RIGHT) TO MOVE. UP ARROW IS JUMP. MOUSE CLICK TO INTERACT WITH ENVIRONMENT.




character protag;

import ddf.minim.*; 
AudioPlayer keysound;
AudioPlayer victorysound;
AudioPlayer getkey;
AudioPlayer splash;
AudioPlayer spike;
Minim minim;

PImage level_1; // Background art of level one
PImage level_2; // Background art of level two
PImage level_3; // Background art of level three
PImage level_1b; // Background art of level 1 (with door open)
PImage idle; // Image of character when idle
PImage Key;

int walkRmax = 8;
int walkRindex;
PImage[] walkR = new PImage [walkRmax];

int walkLmax = 8;
int walkLindex;
PImage[] walkL = new PImage [walkLmax];

int jumpMax = 3;
int jumpIndex;
PImage[] jump = new PImage [jumpMax];

boolean hasKey;
float ground;
int frameTime;
int startFrametime;
int level;
int spawn2;
PFont script;
PFont dialog;
PFont death;

boolean doorOpen;


void setup()
{
  size(1200, 712);
  protag = new character();
  level_1 = loadImage("Level1_bkg_a.png");
  level_2 = loadImage("Level2_bkg_a.png");
  level_3 = loadImage("Level3_bkg.png");
  level_1b = loadImage("Level1_bkg_b.png");
  Key = loadImage("key.png");

  idle = loadImage("idle.png");
  

  ground = 520;

  // SPAWN POINT
  protag.x = 300;
  protag.y = ground; 

  //ARRAY OF WALK RIGHT

  walkR[0] = loadImage("Walk_R-01.png");
  walkR[1] = loadImage("Walk_R-09.png");
  walkR[2] = loadImage("Walk_R-03.png");
  walkR[3] = loadImage("Walk_R-04.png");
  walkR[4] = loadImage("Walk_R-05.png");
  walkR[5] = loadImage("Walk_R-06.png");
  walkR[6] = loadImage("Walk_R-07.png");
  walkR[7] = loadImage("Walk_R-08.png");



  //ARRAY OF WALK LEFT

  walkL[0] = loadImage("Walk_L-01.png");
  walkL[1] = loadImage("Walk_L-09.png");
  walkL[2] = loadImage("Walk_L-03.png");
  walkL[3] = loadImage("Walk_L-04.png");
  walkL[4] = loadImage("Walk_L-05.png");
  walkL[5] = loadImage("Walk_L-06.png");
  walkL[6] = loadImage("Walk_L-07.png");
  walkL[7] = loadImage("Walk_L-08.png");


  //ARRAY OF JUMP

  jump[0] = loadImage("jumping-01.png");
  jump[1] = loadImage("jumping-02.png");
  jump[2] = loadImage("jumping-02.png");

  //SLOWING DOWN ANIMATION VIA TIME

  frameTime = 75;
  startFrametime = 0;

  spawn2 =100;

  //FONTS
  script = createFont ("bean.ttf", 50);
  dialog = createFont ("cutivemono.ttf", 22);
  death = createFont ("death.ttf", 32);

  //SOUND
  minim = new Minim(this);
  keysound = minim.loadFile("keyTurn.mp3");
  victorysound = minim.loadFile("winSound.mp3");
  getkey = minim.loadFile("getkey.mp3");
  splash = minim.loadFile("splash.mp3");
  spike = minim.loadFile("spike.mp3");
} // End void setup



void draw() //*********************************************
{
  switch(level)
  {
  case 0:
    titleScreen();
    break;
  case 1: 
    level1();
    break;
  case 2:
    level2();
    break;
  case 3: 
    level3();
    break;
  case 4:
    level4();
    break;
  case 5:
    deathScreen();
    break;
  case 6:
    victoryScreen();
    break;
  }
  if (level != 0 && level < 5)
  {
    protag.display();
  }
  //println(mouseX, mouseY);
  
  ////Arduino to Processing code here
  

  
} //END VOID DRAW


void keyPressed() {
  if (keyCode == RIGHT) {
    protag.moveRight = true;
  }
  if (keyCode == LEFT) {
    protag.moveLeft = true;
  }
  if (keyCode == UP) {
    protag.moveUp = true;
  }
  //if (key == 'e') 
  //{
  //  level = 4;
  //  protag.x=width;
  //  ground=462;
  //}
}




void keyReleased() {
  if (keyCode == RIGHT) {
    protag.moveRight = false;
    protag.noidle = false;
  }

  if (keyCode == LEFT) {
    protag.moveLeft = false;
    protag.noidle = false;
  }
  if (keyCode == UP) {
    protag.moveUp = false;
  }
}

//Platform section






class character 
{

  float x, y;
  float x_speed;
  float y_speed;
  boolean moveLeft, moveRight, moveUp, noidle;
  boolean midair = false;



  void display()
  {


    if (!noidle)
    {
      image(idle, x, y);
    }

    x_speed = 0;
    if (moveRight)
    {
      noidle = true;
      if (millis() > startFrametime + frameTime) 
      {
        walkRindex++;

        startFrametime = millis();
        moveLeft= false;
      }


      if (walkRindex >= 7)
      {
        walkRindex = 1;
      }
      if (!midair)
      {
        image(walkR [walkRindex], protag.x, protag.y);
      }
      x_speed += 4;
    }

    if (moveLeft) {
      if (millis() > startFrametime + frameTime) 
      {
        walkLindex++;

        startFrametime = millis();
        moveRight=false;
      }
      if (!midair)
      {
        image(walkL [walkLindex], protag.x, protag.y);
      }
      if (walkLindex >= 7)
      {
        walkLindex = 1;
      }
      x_speed -= 4;
      noidle = true;
    }



    x += x_speed;

    if (midair)
    {

      walkRindex=8;
      if (jumpIndex< 2)
      {
        jumpIndex++;
      }

      image(jump [jumpIndex], protag.x, protag.y);

      if (jumpIndex >= 1)
      {
        jumpIndex = 2;
      }

      noidle = true;
    }
    //println(x, y);

    if (!midair && moveUp) {
      midair = true;
      y_speed = -16;
    }
    y += y_speed;
    y_speed += 1.0;

    if (y>= ground) {
      y= ground;
      midair = false;
      y_speed= 0;
    }
    if (y==ground && x_speed ==0)
    {
      noidle=false;
    }
  }
}



void titleScreen()
{
  background(0);
  String a = "Dear Bario,";
  String b = "If you are reading this, Kowser has captured me. I beg of you: travel up to the bridge in the east, grab the key to Kowser's castle, and rescue me. You are my only hope, dear sweet.";
  String c = " - Prince Apricot";
  String d = "**Click to continue**";
  fill(255);
  textFont(script);
  text(a, 200, 100, 500, 500);
  text(b, 200, 200, 900, 500); 
  text(c, 600, 500, 500, 500);
  textFont(dialog); 
  fill(#FF3939);
  textSize(24);
  text(d, 25, 670, 500, 500);

  if (mousePressed)
  {
    level = level+1;
  }
}



void level1() //********************************************************

{
  //maintheme.play();
  image(level_1, 0, 0);
  //PLATFORM 1
  if (protag.x>767 && protag.x <991 && protag.y<430 && protag.y >337)
  {
    ground =424;
  } 

  if ((protag.x< 767 || protag.x >991) && protag.y<473 && protag.y>380)
  {
    ground =520;
  }

  //PLATFORM 2
  if (protag.x>590 && protag.x <760 && protag.y<380 && protag.y >230)
  {
    ground= 350;
  } 

  if ((protag.x<590 || protag.x >760) && protag.y==350)
  {
    ground= 520;
  } 

  //PLATFORM 3
  if (protag.x>822 && protag.x <918 && protag.y<260 && protag.y >185)
  {
    ground= 254;
  } 

  if ((protag.x<820 || protag.x >918) && (protag.y<256) && (protag.y >240))
  {
    ground= 520;
  } 

  //PLATFORM 4

  if ((protag.x>970 && protag.x <=width) && (protag.y<190) && (protag.y >100))
  {
    ground=194 ;
  } 

  if ((protag.x<970) && (protag.y<195) && (protag.y >100))
  {
    ground=520 ;
  }

  if (protag.x>width && protag.y<200)
  { 

    level=level+1;
    protag.x=5;
    ground=185;
  }

  String a = "Quest: Go to the bridge";
  textFont(dialog);
  textSize(20);
  fill(255);
  text(a, 15, 15, 400, 400);
}

void level2() //********************************************************
{
  image(level_2, 0, 0);
  if (!hasKey)
  {
    String a = "Quest: Get the key";
    textFont(dialog);
    textSize(20);
    fill(255);
    text(a, 15, 15, 400, 400);
    image(Key, 1100, 300);
  }

  if (hasKey)
  {
    String b = "Quest: Return to Kowser's Castle";
    textFont(dialog);
    textSize(20);
    fill(255);
    text(b, 15, 15, 400, 400);
  }

  if (protag.x>1092 && protag.x <1154 && protag.y == 202)
  {
    hasKey = true;
    getkey.play();
  }


  if (protag.x<0 && protag.y<500)
  { 
    protag.x=width;
    protag.y=ground;
    if (!hasKey)
    {
      level = level-1;
    }

    if (hasKey)
    {
      level = level+1;
    }
  }

  //DEATH CONDITION
  if (protag.y >640)
  {
    level = 5;
    splash.play();
  }

  //PLATFORM 1

  if (protag.x>0 && protag.x<183 && protag.y<266)
  {
    ground =185;
  }

  if (protag.x>183 && protag.x<272 && protag.y<196 && protag.y>52)
  {
    ground=height;
  }

  //PLATFORM 2

  if (protag.x>272 && protag.x<376 && protag.y<230)
  {
    ground = 151;
  }

  if (protag.x>376 && protag.x<480 && protag.y<187)
  {
    ground = height;
  }

  //PLATFORM 3

  if (protag.x >480 && protag.x< 648 && protag.y<250)
  {
    ground =125;
  }

  if (protag.x>648 && protag.x<728 && protag.y<260)
  {
    ground = height;
  }

  //PLATFORM 4

  if (protag.x>728 && protag.x<859 && protag.y<300)
  {
    ground = 189;
  }

  if (protag.x >859 && protag.x<960 && protag.y<311)
  {
    ground = height;
  }

  //PLATFORM 5

  if (protag.x >960 && protag.y<350)
  {
    ground = 202;
  }
} //END LEVEL 2


//LEVEL 3 (Same as level 1, door opens)

void level3()
{
  image(level_1, 0, 0);

  String a = "Quest: Use key on door";
  textFont(dialog);
  textSize(20);
  fill(255);
  text(a, 15, 15, 400, 400);


  //PLATFORM 1

  if (protag.x>767 && protag.x <991 && protag.y<430 && protag.y >337)
  {
    ground =424;
  } 

  if ((protag.x< 767 || protag.x >991) && protag.y<473 && protag.y>380)
  {
    ground =520;
  }

  //PLATFORM 2
  if (protag.x>590 && protag.x <760 && protag.y<380 && protag.y >230)
  {
    ground= 350;
  } 

  if ((protag.x<590 || protag.x >760) && protag.y==350)
  {
    ground= 520;
  } 

  //PLATFORM 3
  if (protag.x>822 && protag.x <918 && protag.y<260 && protag.y >185)
  {
    ground= 254;
  } 

  if ((protag.x<820 || protag.x >918) && (protag.y<256) && (protag.y >240))
  {
    ground= 520;
  } 

  //PLATFORM 4

  if ((protag.x>970 && protag.x <=width) && (protag.y<190) && (protag.y >100))
  {
    ground=194 ;
  } 

  if ((protag.x<970) && (protag.y<195) && (protag.y >100))
  {
    ground=520 ;
  }

  if (protag.x>width && protag.y<200)
  { 

    level=level-1;
    protag.x=5;
    ground=185;
  }

  if (hasKey && protag.x> 87 && protag.x<220)
  {
    String k = "Click to use key";
    textFont(dialog);
    fill(0);
    textSize(15);
    text(k, 210, 489, 500, 500);
  }

  if (mousePressed)
  {
    if (doorOpen)
    {
      level=level+1;
      protag.x =1080;
      ground=462;
      keysound.play();
    }

    if (hasKey && protag.x> 87 && protag.x<220)
    {
      doorOpen=true;
    }
  }


  if (doorOpen)
  {
    image(level_1b, 0, 0);
  }
}

void level4() //CASTLE
{
  image(level_3, 0, 0);

  String a = "Quest: Save the Prince!";
  textFont(dialog);
  textSize(20);
  fill(0);
  text(a, 15, 15, 400, 400);

  if (protag.x<800 && protag.x>756 && protag.y>420)
  {
    level = 5;
    spike.play();
  }

  if (protag.x<565 && protag.x>510 && protag.y>420)
  {
    level = 5;
    spike.play();
  }

  if (protag.x<150 && protag.y>435)
  {
    level = 6;
  }
}

void deathScreen()
{
  background(0);
  String a = "You died!";
  String b = "Press R to retry. Prince Apricot is depending on you!";
  textFont(death); 
  fill(#FF3939);
  textSize(38);
  text(a, (width/2)-175, (height/2)-100, 500, 500);
  fill(255);
  textFont(dialog);
  text(b, (width/2)-175, (height/2), 500, 500);
  getkey.pause();
  getkey.rewind();
  keysound.pause();
  keysound.rewind();



  if (key == 'r')
  {
    level=1;
    hasKey=false;
    protag.x=300;
    ground=520;
    doorOpen=false;
    splash.pause();
    splash.rewind();
    spike.pause();
    spike.rewind();
  }
  if (key == 'R')
  {
    {
      level=1;
      hasKey=false;
      protag.x=300;
      ground=520;
      doorOpen=false;
      splash.pause();
      splash.rewind();
      spike.pause();
      spike.rewind();
    }
  }
}

void victoryScreen()
{
  victorysound.play();
  String a = "Congratulations!";
  String b = "You saved Prince Apricot from Kowser! Well done.";
  background(0);
  textFont(death);
  fill(#FCD845);
  textSize(40);
  text(a, (width/2)-270, (height/2)-100, 600, 500);
  textFont(dialog);
  fill(255);
  text(b, (width/2)-270, (height/2), 500, 500);
}
