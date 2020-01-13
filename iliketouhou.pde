int test = 0;

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
int pt; //playerType
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
  double x;
  double y;
  Coord() {
    this.x=0;
    this.y=0;
  }
  Coord(int x, int y) {
    this.x=x;
    this.y=y;
  }
  Coord(double x, double y) {
    this.x=x;
    this.y=y;
  }
  double disP1() {
    return Math.sqrt(Math.pow((double)this.x-pPos.x,2)+Math.pow((double)this.y-pPos.y,2));
  }
  double disP2() {
    return 0.0;
  }
  Target homeP1(int s) {
    double dx = pPos.x-this.x;
    double dy = pPos.y-this.y;
    double d = this.disP1();
    Target dP = new Target((dx*s/d),(dy*s/d));
    return dP;
  }
  void fix() {
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
  void transform(double x, double y, double r) {
    double dx = this.x - x;
    double dy = this.y - y;
    double d = Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2));
    float theta = tan((float)(dy/dx));
    if (dx<0&&dy<0) {
      theta += PI;
    }
    theta += r;
    this.x = d*sin(theta)+dx;
    this.y = d*cos(theta)+dy;
  }
}
class Target {
  double x;
  double y;
  Target(int x, int y) {
    this.x=x;
    this.y=y;
  }
  Target(double x, double y) {
    this.x=x;
    this.y=y;
  }
  void transform(double r) {
    double d = Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
    float theta = atan((float)(y/x));
    if (x<0&&y<0) {
      theta += PI;
    }
    theta += r;
    x = d*sin(theta);
    y = d*cos(theta);
  }
  float angleP1(double x, double y) {
    double dx = pPos.x-x;
    double dy = y-pPos.y;
    float theta = atan((float)(dy/dx));
    if (dx<0) {
      theta += PI;
    }
    return theta;
  }
  void transformTo(float theta) {
    double d = Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
    x = d*cos(theta);
    y = -d*sin(theta);
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
      Target v = pos.homeP1(10);
      pos.x += v.x;
      pos.y += v.y;
    } else {
      pos.y += 5;
    }
    fill(255,0,0);
    rect((int)pos.x+20,(int)pos.y+20,15,15);
  }
  boolean testHitbox() {
    if (pos.disP1()<10+10) {
      return true;
    } else if (!grazed&&pos.disP1()<15+10) {
      grazed = true;
    }
    return false;
  }
}

class PBullet {
  int type = 0;
  Coord pos;
  Target v;
  int hitbox;
  PBullet (int type, Coord pos){
    this.type = type;
    this.pos = pos;
    this.v = new Target(0, -30);
    this.hitbox = 5;
  }
  void move(){
    pos.x += v.x;
    pos.y += v.y;
    fill(#FA12B9);
    rect((int)pos.x + 25, (int)pos.y + 25, 2, 5);
    if(type == -1){
      
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
  Bullet (double px, double py, double vx, double vy) {
    pos = new Coord(px,py);
    v = new Target(vx,vy);
  }
  Bullet (double px, double py, int vx, int vy) {
    pos = new Coord(px,py);
    v = new Target(vx,vy);
  }
  Bullet (double px, double py, int vx, int vy, int t) {
    pos = new Coord(px,py);
    v = new Target(vx,vy);
    type = t;
  }
  Bullet (double px, double py, int vx, int vy, int t, int g) {
    pos = new Coord(px,py);
    v = new Target(vx,vy);
    type = t;
    group = g;
  }
  Bullet (double px, double py, Target v) {
    pos = new Coord(px,py);
    this.v = v;
  }
  void move() {
    if (type==1) {
      v = pos.homeP1(10);
    }
    pos.x += v.x;
    pos.y += v.y;
    fill(255,0,0);
    ellipse((int)pos.x+25,(int)pos.y+25,20,20);
  }
  void speed(double a) {
    v.x = (int)(v.x*a);
    v.y = (int)(v.y*a);
  }
  void testHitbox () {
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
class Enemy {
  int type = 0;
  int hitbox = 5;
  Coord pos;
  Target v;
  int health = 30;
  int spellTime = 0;
  int spellRotation = 0;
  Enemy (double x, double y, double vx, double vy, int t) {
    pos = new Coord(x, y);
    v = new Target(vx, vy);
    type = t;
  }
  void move() {
    if (type==1) {
      v = pos.homeP1(5);
    }
    pos.x += v.x;
    pos.y += v.y;
    fill(255,0,255);
    ellipse((int)pos.x+25,(int)pos.y+25,20,20);
  }
  void testHitbox() {
    if (pos.disP1()<hitbox+5&& invincibilityTimer == 0) {
      hit=true;
    }
  }
  boolean didIDie(){
    for(int i = 0; i < PBullets.size(); i++){
      if(Math.sqrt(Math.pow((double)PBullets.get(i).pos.x-this.pos.x,2)+Math.pow((double)PBullets.get(i).pos.y-this.pos.y,2)) <= hitbox + PBullets.get(i).hitbox){
        //System.out.println("I've been hit!");
        health--;
        if (health<=0) {
          Items.add(new Item((int)pos.x,(int)pos.y));
          return true;
        }
        PBullets.remove(PBullets.get(i));
        i--;
      }
    }
    return false;
  }
  void testHealth() {
    if (health<=0) {
      
    }
  }
}


Coord pPos;
Coord bPos = new Coord();
static ArrayList<PBullet> PBullets = new ArrayList<PBullet>();
static ArrayList<Bullet> Bullets = new ArrayList<Bullet>(); 
static ArrayList<Item> Items = new ArrayList<Item>(); 
static ArrayList<Enemy> Enemies = new ArrayList<Enemy>(); 
int spellTime = 0;
int spellRot = 0;
int spellLength = 0;
//jason
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
  Enemies.add(new Enemy(162.5,100.0,0,1,2));
  Enemies.add(new Enemy(537.5,100.0,0,1,2));
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
void runSpellCard (double px, double py, int id, int t, int r) {
  //int r is in degrees
  //identify spell card
  if (id==0) {
    spellLength = 5*60;
    if (t%spellLength==0) {
      for (int i=0;i<360;i+=60) {
        Bullets.add(new Bullet(px,py,Math.cos(i*PI/180)*5,Math.sin((i)*PI/180)*5));
      }
    }
  } else if (id==2) {
    spellLength = 5*60;
    if (t%spellLength%5 == 0 && t%spellLength < 60) {
      Target temp = new Target(0,5);
      System.out.println(degrees(temp.angleP1(px,py)));
      temp.transformTo(temp.angleP1(px,py));
      Bullets.add(new Bullet(px,py,temp));
    }
  } else if (id==1001) {
    spellLength = 8;
    if (t%spellLength==0) {
      Bullets.add(new Bullet(px,py,Math.cos(radians(r))*2,Math.sin(radians(r))*2));
      Bullets.add(new Bullet(px,py,Math.cos(radians(r+90))*2,Math.sin(radians(r+90))*2));
      Bullets.add(new Bullet(px,py,Math.cos(radians(r+180))*2,Math.sin(radians(r+180))*2));
      Bullets.add(new Bullet(px,py,Math.cos(radians(r+270))*2,Math.sin(radians(r+270))*2));
      //Bullets.add(new Bullet(px,py,Math.cos(pi*-(spellRot+21)/100)*2,Math.sin(pi*-(spellRot+21)/100)*2));
      //Bullets.add(new Bullet(px,py,Math.cos(pi*(-(spellRot+21)+50)/100)*2,Math.sin(pi*(-(spellRot+21)+50)/100)*2));
      //Bullets.add(new Bullet(px,py,Math.cos(pi*(-(spellRot+21)+100)/100)*2,Math.sin(pi*(-(spellRot+21)+100)/100)*2));
      //Bullets.add(new Bullet(px,py,Math.cos(pi*(-(spellRot+21)+150)/100)*2,Math.sin(pi*(-(spellRot+21)+150)/100)*2));
    }
    spellRot=(r+1)%360;
  } else if (id==1002) {
    spellLength = 5*60;
    int rand = (int)Math.random()*15;
    if (t%spellLength==0) {
      for (int i=0;i<360;i+=15) {
        Bullets.add(new Bullet(px,py,Math.cos(radians(i+rand))*5,Math.sin(radians(i+rand))*5));
      }
    } else if (spellTime%spellLength==spellLength*5/100) {
      for (int i=0;i<360;i+=15) {
        Bullets.add(new Bullet(px,py,Math.cos(radians(i+rand))*5,Math.sin(radians(i+rand))*5));
      }
    } else if (spellTime%spellLength==spellLength*10/100) {
      for (int i=0;i<360;i+=15) {
        Bullets.add(new Bullet(px,py,Math.cos(radians(i+rand))*5,Math.sin(radians(i+rand))*5));
      }
    }
  } else if (id==1003) {
    spellLength = 1*60;
    if (t%spellLength==0) {
      double start = py;
      double y = 0;
      Bullets.add(new Bullet(px, py, 0, 0, 0, 5));
      for(Bullet b: Bullets){
        y = py - start;
        if(b.group == 5){
          //b.v.y = (int)(-(x/Math.sqrt(1-Math.pow(x,2))));
          //b.pos.y = (Math.sqrt(10-Math.pow(x,2)))+100;
          b.v.x = (Math.cos(radians((float)y)));
        }
      }
    }
  } else if (id==1004) {
    spellLength = 1;
    if (t%spellLength==0) {
      Bullets.add(new Bullet(px, py, 0, 0, 1, 5));
    }
  }
  spellTime=t+1;
}  

void keyPressed() {
  switch (key) {
    case ESC:
    key = 0;
    break;
  }
  if (keyCode==16) {
    keyShift=true;
  }
  if (keyCode==90) {
    keyZ=true;
  }
  if (keyCode==88) {
    keyX=true;
  }
  if (keyCode==37) {
    keyLeft=true;
  }
  if (keyCode==38) {
    keyUp=true;
  }
  if (keyCode==39) {
    keyRight=true;
  }
  if (keyCode==40) {
    keyDown=true;
  }
  if (keyCode==27) {
    keyEsc=true;
  }
  //System.out.println(keyCode);
}
void keyReleased() {
  if (keyCode==16) {
    keyShift=false;
  }
  if (keyCode==90) {
    keyZ=false;
  }
  if (keyCode==88) {
    keyX=false;
  }
  if (keyCode==37) {
    keyLeft=false;
  }
  if (keyCode==38) {
    keyUp=false;
  }
  if (keyCode==39) {
    keyRight=false;
  }
  if (keyCode==40) {
    keyDown=false;
  }
  if (keyCode==27) {
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
          if (select==7) {
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
          select=7;
        } if (select>7) {
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
     
      if (select==1) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Da Pi Gu",600-textWidth("Da Pi Gu")/2,300);
      //santosh
      
      if (select==2) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Samalaingik",600-textWidth("Samalaingik")/2,400);
      //aaron
     
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
     
      if (select==5) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Algebra II Lord",600-textWidth("Algebra II Lord")/2,700);
      //jason

      if (select==6) { 
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Hiru",600-textWidth("Hiru")/2,800);
    
      if (select==7) {
        fill(#ffffff);
      } else {
        fill(#8a8a8a);
      }
      text("Back",600-textWidth("Back")/2,900);
    }
  } else if (mode==1) {
    //jasonisaleech
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
      for (int i = 0; i < Bullets.size(); i++) {
        Bullets.get(i).move();
        Bullets.get(i).testHitbox();
        
        if (Bullets.get(i).pos.x > 750 || Bullets.get(i).pos.x < 0 || Bullets.get(i).pos.y > 950 || Bullets.get(i).pos.y < 0) {
          Bullets.remove(Bullets.get(i));
          i--;
        }
      }
      
      for (int i = 0; i < Enemies.size(); i++) {
        Enemies.get(i).move();
        runSpellCard(Enemies.get(i).pos.x,Enemies.get(i).pos.y,Enemies.get(i).type,Enemies.get(i).spellTime,Enemies.get(i).spellRotation);
        Enemies.get(i).spellTime=spellTime;
        Enemies.get(i).spellRotation=spellRot;
        //System.out.println(spellTime);
        Enemies.get(i).testHitbox();
        if (Enemies.get(i).didIDie()) {
          Enemies.remove(Enemies.get(i));
          i--;
        } else if (Enemies.get(i).pos.x > 750 || Enemies.get(i).pos.y > 950) {
          Enemies.remove(Enemies.get(i));
          i--;
        }
      }
      
      for (int i = 0; i < PBullets.size(); i++) {
        PBullets.get(i).move();
        if (PBullets.get(i).pos.x > 750 || PBullets.get(i).pos.x < 0 || PBullets.get(i).pos.y > 950 || PBullets.get(i).pos.y < 0) {
          PBullets.remove(PBullets.get(i));
        }
      }
      
      for (int i = 0; i < Items.size(); i++) {
        Items.get(i).move();
        if (Items.get(i).testHitbox()) {
          if (Items.get(i).type==0) {
            power+=.1;
          }
          Items.remove(Items.get(i));
          i--;
        } else if (Items.get(i).pos.x > 750 || Items.get(i).pos.x < 0 || Items.get(i).pos.y > 950 || Items.get(i).pos.y < 0) {
          Items.remove(Items.get(i));
          i--;
        }
      }
      
      if (hit) {
        hitProtocool();
      } 
      if (keyPressed) {
        int move = 10;
        if (keyZ){
          if (pt == 0) {
            Coord add = new Coord(pPos.x-10, pPos.y);
            PBullets.add(new PBullet(0,add));
            add = new Coord(pPos.x+10, pPos.y);
            PBullets.add(new PBullet(0,add));
          }
          
        }
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
      ellipse((int)bPos.x+25,(int)bPos.y+25,30,30);
      fill(0,0,255);
      if (invincibilityTimer>0) {
        fill(255,255,0);
      }
      ellipse((int)pPos.x+25,(int)pPos.y+25,30,30);
      if (keyShift) {
        fill(255,0,0);
        ellipse((int)pPos.x+25,(int)pPos.y+25,10,10);
      }
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