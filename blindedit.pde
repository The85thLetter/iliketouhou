int test = 0;
double pi = 3.141592653;
int mode;
int menu;
int select;

int score;
int continues;
int lives;
double bombs;
double power;
int graze;
int points;

int startTime;
int pauseTime;
boolean paused;

int invincibilityTimer;
boolean hit;

boolean keyShift;
boolean keyZ;
boolean keyX;
boolean keyLeft;
boolean keyUp;
boolean keyRight;
boolean keyDown;
boolean keyEsc;
//class DataKey {
//  char dataKey;
//  int dataKeyCode;
//  DataKey (char dataKey, int dataKeyCode) {
//    this.dataKey=dataKey;
//    this.dataKeyCode=dataKeyCode;
//  }
//}
class Coord {
  int x;
  int y;
  Coord(int x, int y) {
    this.x=x;
    this.y=y;
  }
  Coord() {
    this.x=0;
    this.y=0;
  }
  double disP1() {
    return Math.sqrt(Math.pow((double)this.x-pPos.x,2)+Math.pow((double)this.y-pPos.y,2));
  }
  double disP2() {
    return 0.0;
  }
  Target homeP1(int s) {
    int dx = pPos.x-this.x;
    int dy = pPos.y-this.y;
    double d = this.disP1();
    Target dP = new Target((int)(dx*s/d),(int)(dy*s/d));
    return dP;
  }
  void fix () {
    if (x<5) {
      x=5;
    }
    if (y<5) {
      y=5;
    }
    if (x>745) {
      x=745;
    }
    if (y>945) {
      y=945;
    }
  }
}
class Target {
  int x;
  int y;
  Target(int x, int y) {
    this.x=x;
    this.y=y;
  }
}
class Item {
  //0-1 power, 2 full power, 3 point, 4 life, 5 bomb
  int type = 0;
  Coord pos;
  Boolean grazed = false;
  Boolean collected = false;
  Item (int px, int py) {
    pos = new Coord(px,py);
  }
  Item (int px, int py,boolean g) {
    pos = new Coord(px,py);
    grazed = g;
  }
  Item (int px, int py,int t) {
    pos = new Coord(px,py);
    type = t;
  }
  Item (int px, int py,int t,boolean g) {
    pos = new Coord(px,py);
    type = t;
    grazed = g;
  }
  void move() {
    if (collected) { 
      //temporary
      //v.x=100000;
    } else if (grazed) {
      //v = pos.homeP1(10);
    } else {
      pos.y += 5;
    }
    fill(255,0,0);
    rect(pos.x+20,pos.y+20,10,10);
  }
}
class Enemy {
  int type = 1;
  int hitbox = 5;
  Coord pos;
  Target v;
  int health = 0;
  void move() {
    if (type==1) {
      v = pos.homeP1(5);
    }
    pos.x += v.x;
    pos.y += v.y;
    fill(255,255,0);
    ellipse(pos.x+25,pos.y+25,20,20);
  }
  void testHitbox() {
    if (pos.disP1()<hitbox+5&& invincibilityTimer == 0) {
      hit=true;
    }
  }
}
class Bullet {
  //PImage look;
  int type = 0;
  int hitbox = 5;
  Coord pos;
  Target v;
  int group = 0;
  Boolean grazed = false;
  Bullet (String s) {
   // look = loadImage(s);
  }
  Bullet (int px, int py, double vx, double vy) {
    pos = new Coord(px,py);
    v = new Target((int)vx,(int)vy);
  }
  Bullet (int px, int py, int vx, int vy) {
    pos = new Coord(px,py);
    v = new Target(vx,vy);
  }
  Bullet (int px, int py, int vx, int vy, int t) {
    pos = new Coord(px,py);
    v = new Target(vx,vy);
    type = t;
  }
  Bullet (int px, int py, int vx, int vy, int t, int g) {
    pos = new Coord(px,py);
    v = new Target(vx,vy);
    type = t;
    group = g;
  }
  void move() {
    if (type==1) {
      v = pos.homeP1(5);
    }
    pos.x += v.x;
    pos.y += v.y;
    fill(255,0,0);
    rect(pos.x+20,pos.y+20,10,10);
  }
  void speed(double a) {
    v.x = (int)(v.x*a);
    v.y = (int)(v.y*a);
  }
  void testHitbox () {
    System.out.println(pos.disP1());
    if (pos.disP1()<hitbox+5&& invincibilityTimer == 0) {
      hit=true;
    } else if (pos.disP1()<hitbox+10&&!grazed) {
      //hitProtocool();
      graze++;
      score+=500;
      grazed=true;
    }
  }
}

Coord pPos;
Coord bPos = new Coord();
static ArrayList<Bullet> Bullets = new ArrayList<Bullet>(); 
static ArrayList<Item> Items = new ArrayList<Item>(); 
int spellTime = 0;
int spellRot = 0;
int spellLength = 0;

void startGame() {
  mode=1;
  lives=3;
  continues=2;
  paused=false;
  startTime=frameCount;
  hit=false;
  bPos.x = 375;
  bPos.y = 100;
  pPos.x = 375;
  pPos.y = 875;
  invincibilityTimer = 120;
}
void hitProtocool() {
  lives--;
  if (lives<0) {
    mode=0;
    Bullets.clear();
  } else{
    pPos.x = 375;
    pPos.y = 875;
    invincibilityTimer=120;
  }
  hit=false;
}
void runSpellCard (int id) {
  //identify spell card
  if (id==1) {
    spellLength = 1;
    if (spellTime%spellLength==0) {
      Bullets.add(new Bullet(bPos.x,bPos.y,Math.cos(pi*spellRot/100)*10,Math.sin(pi*spellRot/100)*10));
      Bullets.add(new Bullet(bPos.x,bPos.y,Math.cos(pi*(spellRot+50)/100)*10,Math.sin(pi*(spellRot+50)/100)*10));
      Bullets.add(new Bullet(bPos.x,bPos.y,Math.cos(pi*(spellRot+100)/100)*10,Math.sin(pi*(spellRot+100)/100)*10));
      Bullets.add(new Bullet(bPos.x,bPos.y,Math.cos(pi*(spellRot+150)/100)*10,Math.sin(pi*(spellRot+150)/100)*10));
      Bullets.add(new Bullet(bPos.x+40,bPos.y-9,Math.cos(pi*-(spellRot+21)/100)*10,Math.sin(pi*-(spellRot+21)/100)*10));
      Bullets.add(new Bullet(bPos.x+40,bPos.y-9,Math.cos(pi*(-(spellRot+21)+50)/100)*10,Math.sin(pi*(-(spellRot+21)+50)/100)*10));
      Bullets.add(new Bullet(bPos.x+40,bPos.y-9,Math.cos(pi*(-(spellRot+21)+100)/100)*10,Math.sin(pi*(-(spellRot+21)+100)/100)*10));
      Bullets.add(new Bullet(bPos.x+40,bPos.y-9,Math.cos(pi*(-(spellRot+21)+150)/100)*10,Math.sin(pi*(-(spellRot+21)+150)/100)*10));
    }
    System.out.println(spellRot);
    spellRot=(spellRot+7)%200;
  } else if (id==2) {
    spellLength = 5*60;
    int rand = (int)Math.random()*15;
    if (spellTime%spellLength==0) {
      for (int i=0;i<360;i+=15) {
        Bullets.add(new Bullet(bPos.x,bPos.y,Math.cos((i+rand)*pi/180)*5,Math.sin((i+rand)*pi/180)*5));
      }
    } else if (spellTime%spellLength==spellLength*5/100) {
      for (int i=0;i<360;i+=15) {
        Bullets.add(new Bullet(bPos.x,bPos.y,Math.cos((i+rand)*pi/180)*5,Math.sin((i+rand)*pi/180)*5));
      }
    } else if (spellTime%spellLength==spellLength*10/100) {
      for (int i=0;i<360;i+=15) {
        Bullets.add(new Bullet(bPos.x,bPos.y,Math.cos((i+rand)*pi/180)*5,Math.sin((i+rand)*pi/180)*5));
      }
    }
  } else (id==3) {
    int start = bPos.x
    int x = 0;
    Bullets.add(new Bullet(bPos.x, bPos.y, 1, 1, 0, 5));
    Bullets.add(new Bullet(bPos.x, bPos.y, 1, 1, 1, 5));
    for(Bullet b: Bullets){
      x = b.pos.x - start;
      int x = b.pos.x - start;
      if(b.group = 5){
         b.v.y = -(x/Math.sqrt(1-Math.pow(x,2)));
      }
    }
  }
  spellTime++;
}

void keyPressed() {
  switch (key) {
    case ESC:
    key = 0;
    break;
  }
  if (keyCode==16) {
    keyShift=true;
  } else if (keyCode==90) {
    keyZ=true;
  } else if (keyCode==88) {
    keyX=true;
  } else if (keyCode==37) {
    keyLeft=true;
  } else if (keyCode==38) {
    keyUp=true;
  } else if (keyCode==39) {
    keyRight=true;
  } else if (keyCode==40) {
    keyDown=true;
  } else if (keyCode==27) {
    keyEsc=true;
  }
  System.out.println(keyCode);
}
void keyReleased() {
  if (keyCode==16) {
    keyShift=false;
  } else if (keyCode==90) {
    keyZ=false;
  } else if (keyCode==88) {
    keyX=false;
  } else if (keyCode==37) {
    keyLeft=false;
  } else if (keyCode==38) {
    keyUp=false;
  } else if (keyCode==39) {
    keyRight=false;
  } else if (keyCode==40) {
    keyDown=false;
  } else if (keyCode==27) {
    keyEsc=false;
  }
}
int slowRate = 1;
void setup() {
  size(1200,1000);
  mode = 0;
  menu = 0;
  select = 0;
  hit = false;
  textSize(50);
  //active board is 750x950
  pPos = new Coord(375,875);
}
void draw() {
  background(0);
  //System.out.println(frameRate);
  //\/ code to slow down game by a factor of slowRate, change slowRate\/
  if (test%slowRate==0) {
  
  if (mode==0) {
    textSize(50);
    //if (keyPressed) {
    //  for (int i=0;i<PressedKeys.size();i++) {
    //    char pressedKey = PressedKeys.get(i).dataKey;
    //    int pressedKeyCode = PressedKeys.get(i).dataKeyCode;
    //    System.out.print("|"+pressedKey+","+pressedKeyCode);
    //}
    if (keyPressed) {
      if (keyZ) {
        if (menu==0) {
          if (select==0) {
            menu=1;
            select=0;
            delay(200);
          }
          if (select==3) {
            exit();
          }
        } else if (menu==1) {
          if (select==0) {
            startGame();
          }
          if (select==4) {
            menu=0;
            select=0;
            delay(200);
          }
        } 
      }
      if (keyUp) {
          select--;
          delay(100);
      }
      if (keyDown) {
        select++;
        delay(100);
      }
      if (menu==0) {
        if (select<0) {
          select=3;
        } if (select>3) {
          select=0;
        }
      } else if (menu==1) {
        if (select<0) {
          select=4;
        } if (select>4) {
          select=0;
        }
      }
    }
    if (menu==0) {
      if (select==0) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Play",600-textWidth("Play")/2,200);
      if (select==1) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Practice",600-textWidth("Practice")/2,300);
      if (select==2) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Options",600-textWidth("Options")/2,400);
      if (select==3) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Exit",600-textWidth("Exit")/2,500);
    } else if (menu==1) {
      //character
      fill(#ffffff);
      text("Character",600-textWidth("Character")/2,100);
      //boston
      if (select==0) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Bostonia",600-textWidth("Bostonia")/2,200);
      //michael
      text("Boston",600-textWidth("Boston")/2,200);
      if (select==1) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Da Pi Gu",600-textWidth("Da Pi Gu")/2,300);
      //santosh
      text("Michael",600-textWidth("Michael")/2,300);
      if (select==2) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Samalaingik",600-textWidth("Samalaingik")/2,400);
      //aaron
      text("Santosh",600-textWidth("Santosh")/2,400);
      if (select==3) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Noraa",600-textWidth("Noraa")/2,500);
      //sultan
      if (select==4) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Sultana",600-textWidth("Sultana")/2,600);
      //william
      text("Sultan",600-textWidth("Sultan")/2,600);
      if (select==5) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Algebra II Lord",600-textWidth("Algebra II Lord")/2,700);
      //jason
      text("William",600-textWidth("William")/2,700);
      if (select==6) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Hiru",600-textWidth("Hiru")/2,800);
      text("Jason",600-textWidth("Jason")/2,800);
      if (select==6) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Back",600-textWidth("Back")/2,900);
    }
  } else if (mode==1) {
    //active board is 750x950
    fill(0,255,0);
    rect(25,25,750,950);
    int currentTime = frameCount-startTime;
    //currenttime/60 to get time in seconds
    //if (currentTime)
    if (!paused) {
      if (invincibilityTimer>0) {
        invincibilityTimer--;
      } 
      //for (int i=0;i<Bullets.size();i++) {
      //  Bullets.get(i).move();
      //  Bullets.get(i).testHitbox();
      //  if (Bullets.get(i).pos.x > 750 || Bullets.get(i).pos.y > 950) {
      //    Bullets.remove(i);
      //  }
      //}
      runSpellCard(2);
      for (int i = 0; i < Bullets.size(); i++) {
        Bullets.get(i).move();
        Bullets.get(i).testHitbox();
        
        if (Bullets.get(i).pos.x > 750 || Bullets.get(i).pos.y > 950) {
          Bullets.remove(Bullets.get(i));
        }
        
      }
      if (hit) {
        hitProtocool();
      } 
      if (keyPressed) {
        int move = 10;
        if (keyShift) {
          move=5;
        }
        if (keyLeft) {
          pPos.x-=move;
        }
        if (keyRight) {
          pPos.x+=move;
        }
        if (keyUp) {
          pPos.y-=move;
        }
        if (keyDown) {
          pPos.y+=move;
        }
        if (keyEsc) {
          paused=true;
          pauseTime = frameCount;
          delay(200);
        }
      }
      pPos.fix();
      fill(255);
      textSize(50);
      text("Normal",800,100);
      text("Score: "+score,800,200);
      text("Player: "+lives,800,300);
      text("Bombs: "+bombs,800,400);
      text("Power: "+power,800,500);
      text("Graze: "+graze,800,600);
      text("Point: "+points,800,700);
      fill(0,255,255);
      ellipse(bPos.x+25,bPos.y+25,10,10);
      fill(0,0,255);
      if (invincibilityTimer>0) {
        fill(255,255,0);
      }
      ellipse(pPos.x+25,pPos.y+25,10,10);
    } else {
      fill(255);
      textSize(100);
      text("Paused",600-textWidth("Paused")/2,500);
      if (keyEsc) {
        paused=false;
        startTime = startTime+frameCount-pauseTime;
        delay(200);
      }
    }
  }
  fill(255);
  textSize(20);
  test++;
  text(test,5,20);
  }
}