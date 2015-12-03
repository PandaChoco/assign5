boolean goup,godown,goright,goleft=false;
PImage enemy,bullet;
int enemyCount = 8;
int type=0,score,cont,n=0;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
int xspeed=5,yspeed=5;
PImage bg1,bg2,end1,end2,fighter,hp,start1,start2,treasure;
int x,y,mx,my,i,j,t,t2 =0;
final int Game_start=1,Game_win=2,Game_lose=3,Game_run=4;
int gameState;
float life=0;
int randomY=0;
PImage []boom = new PImage[5];
int []boomX = new int[enemyCount];
int []boomY = new int[enemyCount];
boolean []boomis = new boolean[enemyCount];
boolean []boomcan = new boolean[enemyCount];
PFont f;
int []bulletX = new int[5];
int []bulletY = new int[5];
boolean []bulletis = new boolean[5];

void setup () {
	size(640, 480) ;
  life = 195*0.2;
  x=width-50;
  y=height/2-25;
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  enemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  bullet = loadImage("img/shoot.png");
  f = createFont("Arial",24);
  
  for (int i=1;i<=5;i++){   
    boom[i-1] = loadImage("img/flame"+i+".png");
  }
  
  mx=floor(random(600));
  my=floor(random(440));
  randomY=floor(random(0,height-60));
  addEnemy(0);
  gameState = Game_start;
  
}

void draw(){

  switch (gameState){
    case Game_start:
         image(start2,0,0);
         for (int i=0;i<5;i++){
           bulletY[i]=1000;
         }
         if (mouseX>200 & mouseX<455 & mouseY>375 & mouseY<415){
             image(start1,0,0);
             if(mousePressed){
               addEnemy(0);
               gameState = Game_run;}
         }
         break;
               
     case Game_run:
          image(bg1,t,0);
          image(bg2,t-640,0);
          image(bg1,t-1280,0);
          t++;
          t%=1280;
          t2+=5;
          
          fill(255,0,0);
          rect(10,0,life,20);
          
          image(hp,0,0);            //life          
          image(treasure,mx,my);
          image(fighter,x,y);
          textFont(f,16);           //print score
          textAlign(CENTER);
          fill(255);
          text("Score: "+score,50,height-30);
  
          for (int i = 0; i < enemyCount; i++) {      //draw enemy & boom
            if (enemyX[i] != -1 || enemyY[i] != -1) {
              image(enemy, enemyX[i], enemyY[i]);
              if (boomis[i]){
                image(boom[n],boomX[i],boomY[i]);
                cont++;
                if(cont==5){
                  cont=0;
                  n++;
                }
                if(n==5){
                  boomX[i]=1000;
                  boomY[i]=1000;
                  boomis[i]=false;
                  n=0;
                }
              }
              enemyX[i]+=5; 
            }
            if (t2>(width+fighter.width*5+150)){
              type++;
              type%=3;
              t2=0;
              addEnemy(type);
            }
            if (isHit(enemyX[i],enemyY[i],enemy.width,enemy.height,      // Hit by enemy
                x,y,fighter.width,fighter.height)){
                  life-=19.5*2;
                  if (life<=0){
                    gameState = Game_lose;
                  }
                  enemyX[i]=1000;
                  enemyY[i]=1000;
                  boomX[i]=x;
                  boomY[i]=y;
                  boomis[i]=true;
            }
            for (int j=0;j<5;j++){
            if(isHit(bulletX[j],bulletY[j],bullet.width,bullet.height,    //Hit by bullet
               enemyX[i],enemyY[i],enemy.width,enemy.height)){
                 boomX[i]=enemyX[i];
                 boomY[i]=enemyY[i];
                 enemyX[i]=1000;
                 enemyY[i]=1000;
                 boomis[i]=true;
                 bulletY[j]=1000;
                 scoreChange();
               }
            }
               
          }//end of for
          
        for(int i = 0; i < 5; i++){          //draw bullet
          if(!bulletis[i]){
            image(bullet,bulletX[i],bulletY[i]);
            int j=closestEnemy(bulletX[i],bulletY[i]);
            if(bulletX[i]<enemyX[i] || j== -1){
              bulletX[i]-=5;
            }else{
              bulletX[i]-=5;
              if(bulletY[i]>=enemyY[j]){
                bulletY[i]-=4;
              }else{bulletY[i]+=4;}
            }
          }
          if(bulletX[i]<-30){
            bulletis[i]=true;
            bulletY[i]=1000;
          }
          
        }
          
          // get treasure
          if (isHit(mx,my,treasure.width,treasure.height,
              x,y,fighter.width,fighter.height)){
            mx=floor(random(600));
            my=floor(random(440));
            life+=19.5;
               if (life >=195){
               life =195;
               }
          }
          

          
          if (goup){
            y-=yspeed;
          }
          if (godown){
            y+=yspeed;
          }
          if (goright){
            x+=xspeed;
          }
          if (goleft){
            x-=xspeed;
          }
          
          if (x<=0){
            x=0;
          }
          if (x>=width-50){
            x=width-50;
          }
          if (y<=0){
            y=0;
          }
          if (y>=height-50){
            y=height-50;
          }
          break;
     case Game_lose:
               image(end2,0,0);
               if ((mouseX>=208)&(mouseX<=433)&(mouseY>=310)&(mouseY<=345)){
                   image(end1,-0.5,0);
                   if (mousePressed){
                     life = 195*0.2;
                     x=width-50;
                     y=height/2-25;
                     type=0;
                     t2=0;
                     addEnemy(0);
                     for (int i=0;i<5;i++){
                       bulletY[i]=1000;
                     }
                     gameState=Game_run;
                   }
               }
               
               
   }
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type){	
	for (int i = 0; i < enemyCount; ++i) {
		enemyX[i] = -1;
		enemyY[i] = -1;
	}
	switch (type) {
		case 0:
			addStraightEnemy();
			break;
		case 1:
			addSlopeEnemy();
			break;
		case 2:
			addDiamondEnemy();
			break;
	}
}

void addStraightEnemy(){
	float t = random(height - enemy.height);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h;
          boomis[i]=false;
	}
}
void addSlopeEnemy(){
	float t = random(height - enemy.height * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
          boomis[i]=false;
	}
}
void addDiamondEnemy(){
	float t = random( enemy.height * 3 ,height - enemy.height * 3);
	int h = int(t);
	int x_axis = 1;
	for (int i = 0; i < 8; ++i) {
            boomis[i]=false;
		if (i == 0 || i == 7) {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h;
			x_axis++;
		}
		else if (i == 1 || i == 5){
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 1 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 1 * 40;
			i++;
			x_axis++;
			
		}
		else {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 2 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 2 * 40;
			i++;
			x_axis++;
		}
	}
}

int closestEnemy(int x,int y){
  float distance = 1000;
  int mark=-1;
  for (int i=0;i<8;i++){
    if (enemyX[i]>-enemy.width || enemyX[i]<width){
      if (dist(x,y,enemyX[i],enemyY[i])<distance){
        distance = dist(x,y,enemyX[i],enemyY[i]);
        mark=i;
      }
    }
  }
  if (distance== 1000){
    return -1;
    }else {return mark;}
}
                           //byHit
boolean isHit(int ax,int ay,int aw,int ah,int bx,int by,int bw,int bh){
  if (bx>ax-aw && bx<=ax+bw && by>ay-ah && by<=ay+bh){
    return true;
  }else{
    return false;
  }
}
                             //score
void scoreChange(){
  score+=20;
}

void keyPressed(){
     if (key==CODED){
         if (keyCode == UP){
            goup=true;
         }else if (keyCode == DOWN){
                  godown=true;
               }
     
          if (keyCode == RIGHT){
             goright=true;
          }else if (keyCode == LEFT){
                    goleft=true;
                 }
     }
}
void keyReleased(){
     if (key==CODED){
         if (keyCode == UP){
            goup=false;
         }else if (keyCode == DOWN){
                  godown=false;
               }
     
         if (keyCode == RIGHT){
           goright=false;
         }else if (keyCode == LEFT){
                  goleft=false;
               }
     }
      if(key==' '){
        for(int i = 0; i < 5; i++){
        if(bulletis[i]){
          bulletX[i] = x;
          bulletY[i] = y + 12;
          bulletis[i] = false;
          break;
        }
       }
      }
}
