import processing.sound.*;
int wid = 1000;
int high = 700;

//Varibile timer
Timer t = new Timer();
boolean paused = false;
int defaultTimer = 30*60;
int timerTime = defaultTimer;
boolean finished = false;
boolean counted = false;

// Variabili bottoni
int l = 100;
// starX, startY, startWidth, startHeight, Text
int[] start = {wid/2-l*2-20 ,high-200,l*2,l};
String textStart = "Start";
String textRestart = "Restart";
int fillStart = #FFFFFF;
// starX, startY, startWidth, startHeight, Text
int[] stop = {wid/2+20,high-200,l*2,l};
String textStop = "Stop";
String textPause = "Resume";
int fillStop = #FFFFFF;

//Variabili per caselle di materie
int matLen = wid/2+50;
int matHi = 50;
int space = 20;
int spaceWords= 200;
int spaceChecks = 25;
int diameter = 10;
int[] Studio= {wid/2-matLen/2, space, matLen, matHi };
int[] Relax = {wid/2-matLen/2, space*2+matHi, matLen, matHi };
int[] Planning = {wid/2-matLen/2, space*3+matHi*2, matLen, matHi };
int fillStudio = #818181;
int fillStudioText = #FFFFFF;
int fillRelax = #818181;
int fillRelaxText = #FFFFFF;
int fillPlanning = #818181;
int fillPlanningText = #FFFFFF;
int[] fillCheck={#FFFFFF,#FFFFFF,#FFFFFF};

//Booleani per gestire io mouse
boolean overStart = false;
boolean overStop = false;
boolean overStudio = false;
boolean overRelax = false;
boolean overPlanning= false;

//Variabili Files
PFont TimerFont;
PFont mono;
SoundFile notif;

// Materie da checkare
String[] stingheMaterie = {"Studio", "Relax", "Planning"};
int[] checkMaterie = {0,0,0,0};
int[] timerMaterie = {60*60,10*60,30*60};
int[] checkMaxMaterie = {5,3,3};
boolean[] select = {false,false,false};

  

// Funzione principale
void setup(){

    size(1000,700);
    background(0,0,0);
    TimerFont= createFont("SevenSegment.ttf",100);
    mono = createFont("coolvetica.ttf",20);
     
    notif = new SoundFile(this, "definite.mp3");
    
    frameRate(30);
}//setup

//Funzione principale 
void draw(){
    // Background black
    background(0,0,0);
    
    //Controllo che il mouse non sia sopra le coose
    update();
    
    //Se ho completato timer conta
    conta();
    
    //ChangeColors
    changeUI();
    
    //Disegna i bottoni
    disegnaBottoni();
    
    //Disegna il timer
    drawTimer();
    
    //Disegna materie e check
    disegnaMaterie();
    
    //Disegna Check indipendenti
    disegnCheckIndipendenti();
    
    //textDebug
    //textDebug(Boolean.toString(finished));
    //Lines
    // drawHalfVerticalLine();
    //drawHalfHorizontalLine();
    
}//draw

/*  Funzione che aggiorna i Booleani che vengono usati per fare controlli
    successivi

    IOG overStart bool se il mouse e' sopra il tasto start
    IOG overStop bool se il mouse e' sopra il tasto stop
    IOG overStudio bool se il mouse e' sopra il riquadro di studio
    IOG overRelax bool se il mouse e' sopra il riquadro di Relax
    IOG overPlanning bool se il mouse e' sopra il riquadro di Planning
    IOG finished Bool che mi dice se il timer ha finito
    IOG counted Bool che mi dice se e' da contare 

*/
void update(){
  
  overStart = checkOver(start);
  overStop = checkOver(stop);
  overStudio = checkOver(Studio);
  overRelax = checkOver(Relax);
  overPlanning = checkOver(Planning);
  
  finished = t.isOver();
  counted = t.isCounted();
  
}

/*  Funzione che disegna i bottoni
    IG $paused bool variabile che mi dice se il timer e' in pausa
    IG $finished bool variabile che mi dice se il timer ha finito
    IG $start array di interi con le dimensioni del tasto di start
    IG $textStart Stringa con il testo da mettere dentro il bottone start
    IG $fillStart intero che dice il colore con cui deve essere colorato il
        bottone start 
    IG $stop array di interi con le dimensioni del tasto di stop
    IG $textStop Stringa con il testo da mettere dentro il bottone di stop
    IG $fillStop intero che dice il colore con cui deve essere colorato il
        bottone stop 
    
*/

void disegnaBottoni(){

    //Se non e' in pausa disegna i bottoni con funzione di stop e start
    if(!paused && !finished){
      
      drawButton(stop,textStop,fillStop);
      drawButton(start,textStart,fillStart);
    }
    else if(paused && !finished){
      // se in pausa sono i bottoni di pausa e restart
      drawButton(stop, textPause, fillStop);
      drawButton(start, textRestart,fillStart);
      
    }
    else{
      // se in pausa sono i bottoni di pausa e restart
      drawButton(stop, textStop, fillStop);
      drawButton(start, textRestart, fillStart);
      
    }
      

}

/*  Funzione che disegna le crocette dei timer indipendenti
    IG $checkMaterie[3] elemento che contiene il numero di timer,
      indipendenti dalle categorie, fatte


*/
void disegnCheckIndipendenti(){
  
  if (checkMaterie[3]>0){
     int rectW=spaceChecks*(checkMaterie[3]-1);
     
     int rectX=wid/2-rectW/2;
     int rectY=height-space-matHi;

     for(int i = 0; i<checkMaterie[3];i++){
       int x = rectX+i*spaceChecks;
       int y = rectY+matHi/2;
  
          crocetta(x,y,diameter,#FFFFFF);
    }//For
  }//if

}

/*  Funzione che disegna tutte le Categorie di timer messe
    
*/
void disegnaMaterie(){

  drawMateria( Studio,  stingheMaterie[0], checkMaterie[0],checkMaxMaterie[0], fillStudio, fillStudioText, fillCheck[0]);
  drawMateria( Relax,  stingheMaterie[1], checkMaterie[1],checkMaxMaterie[1], fillRelax, fillRelaxText, fillCheck[1]);
  drawMateria( Planning,  stingheMaterie[2], checkMaterie[2],checkMaxMaterie[2], fillPlanning, fillPlanningText, fillCheck[2]);

}


boolean checkOver(int[] butt){
  return overRect(butt[0],butt[1],butt[2],butt[3]);
}

void conta(){

  if(counted){
     
    for(int i = 0; i<3; i++){
      
      if (select[i])
        checkMaterie[i]++;
    
    }
    if (!select[0]&&!select[1]&&!select[2])
        checkMaterie[3]++;
        
    notif.play();
  }
  
  //Fare Emettere qualche suono
  //TODO:
  

}

void changeUI(){

  // Change dei colori dei bottoni
  if (overStart)
      fillStart=#818181;
  else
      fillStart=#FFFFFF;
      
  if (overStop)
      fillStop=#818181;
  else
      fillStop=#FFFFFF;
  //Change dei colori dei campi delle materie
  if ((overStudio || select[0])&&!select[1]&&!select[2]){
    fillStudio=#818181;
    fillStudioText=#000000;
    fillCheck[0]=#000000;
    
  }
  else{
    fillStudio=#000000;
    fillStudioText=#FFFFFF;
    fillCheck[0]=#FFFFFF;
  }
  
  if ((overRelax|| select[1])&&!select[0]&&!select[2]){
    fillRelax=#818181;
    fillRelaxText=#000000;
    fillCheck[1]=#000000;
  }
  else{
    fillRelax=#000000;
    fillRelaxText=#FFFFFF;
    fillCheck[1]=#FFFFFF;
  }
  if ((overPlanning|| select[2])&&!select[0]&&!select[1]){
    fillPlanning=#818181;
    fillPlanningText=#000000;
    fillCheck[2]=#000000;
  }
  else{
    fillPlanning=#000000;
    fillPlanningText=#FFFFFF;
    fillCheck[2]=#FFFFFF;
  }


}

// Controllo che il mouse sia sul bottone
boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}


//EVENTO pressione mouse
void mousePressed(){
  
  clickBottoni();
  clickMaterie();
  
}

void clickBottoni(){

  // se e' sopra start e non e' ne in pause ne ha finito
  if(overStart && !paused && !finished){
      t.start(timerTime);
  }
  //se e' sopra start e o e' nello stato di pausa o non e' nello stato di pausa
  // ma non ha finito allora resetta il timer
  else if(overStart && ((!paused && finished)||paused)){
    t.reset();
    paused = false;
  }
  // condizione di paisa 
  else if(overStop && !paused && !finished){
      
      t.pause();
      paused = true;
    
  }
  //Condizione per riprendere 
  else if(overStop && paused && !finished){
  
      t.resume();
      paused = false;
    
  }

}

void clickMaterie(){

  if(overStudio && !select[0]){
      select[0]=true;
      timerTime = timerMaterie[0];
  }
  else if (overRelax && !select[1]){
      select[1]=true;
      timerTime = timerMaterie[1];
  }
  else if(overPlanning && !select[2]){
      select[2]=true;
      timerTime = timerMaterie[2];
  
  }
  else if ( (overStudio && select[0])||
            (overRelax && select[1]) || 
            (overPlanning && select[2]) ){
      select[0]=false;
      select[1]=false;
      select[2]=false;
      timerTime = defaultTimer;
  }
  

}

//Discegna il timer
void drawTimer(){

  stroke(0);
  textFont(TimerFont);
  fill(#FFFFFF);
  textAlign(CENTER,CENTER);
  text(t.stringTimer(),width/2-10,height/2-10);
  
}

//Disegna il bottone
void drawButton(int[] butt, String Frase, int fillB){

  fill(fillB);
  stroke(0);
  rect(butt[0],butt[1],butt[2],butt[3]);
  fill(0);
  textFont(mono);
  textAlign(CENTER, CENTER);
  text(Frase, butt[0]+butt[2]/2, butt[1]+butt[3]/2);

}

void drawMateria(int[] mat, String Titolo, int check, int checkMax, int fillM, int fillText, int fillCheck){

  fill(fillM);
  stroke(0);
  rect(mat[0],mat[1],mat[2],mat[3]);
  fill(fillText);
  textFont(mono);
  textAlign(LEFT,CENTER);
  text(Titolo, mat[0]+10, mat[1]+mat[3]/2);
  
  drawChecks(mat, check, checkMax, fillCheck);


}

void drawChecks(int[] mat, int check, int checkMax, int fillCheck){
  int max = checkMax;
  fill(fillCheck);
  if (check>checkMax)
      max = check;
  for(int i = 0; i<max;i++){
      int x = mat[0]+spaceWords+i*spaceChecks;
      int y= mat[1]+matHi/2;
      
      if (i>=check)
        circle(x,y,diameter);
      else 
        crocetta(x,y,diameter,fillCheck);
  }
  

}

//Disegno di una crocetta 
void crocetta(int x, int y, int l, int fillCross){

    stroke(fillCross);
    strokeWeight(4);
    line(x-l,y+l,x+l,y-l);
    line(x+l,y+l,x-l,y-l);

}

/// INPUT KEYBOARD PER LA SCELTA DELLA MATERIA
//NOT THE WAY TO GO


// FUNZIONI UTILI PER IL DEBUG E NON PER IL PROGRAMMA
void drawHalfVerticalLine(){
  strokeWeight(1);
  stroke(#FFFFFF);
  line(width/2,0,width/2,height);
  
}

void drawHalfHorizontalLine(){
  strokeWeight(1);
  stroke(#FFFFFF);
  line(0,height/2,width,height/2);
  
}

void textDebug(String s){

  fill(#FF0000);
  textFont(mono);
  textAlign(LEFT,CENTER);
  text("Debug:"+ s, 10, height-20);

}
public class Timer {
    
    long startTime;
    long endTime;
    long stopTime;
    int timeEl;
    int milSecTimer;
    boolean running;
    boolean paused;
    boolean over;
    boolean started;
    boolean toCount;
    String divider = ":";
    


    Timer(){
      
        reset();
    }
    
    //input secondi
    void start(int sec){
      
        if(!running){
          startTime = millis();
          milSecTimer = secInMillisec(sec);
          endTime = startTime+secInMillisec(sec);
          running = true;
          paused = false;
          started = true;
        }
    }
    
    //Resetta tutto come se fosse spento
    void reset(){
        running = false;
        paused = false;
        startTime = 0; 
        endTime = 0;
        stopTime = 0;
        timeEl = 0;
        milSecTimer = 0;
        over = false;
        started = false;
        toCount = false;
    }
    
    //mette in pausa
    void pause(){
    
      running = false;
      paused  = true;
      stopTime = millis();
      timeEl = timeElapsed();
      
    }
    
    void resume(){
      
      running = true;
      paused = false;
      startTime = millis()-timeEl;
      endTime = startTime + milSecTimer;
      
    
    }
    
    boolean isOver(){
      
      return over;
      
    }
    
    //Ritorna false, tranne 1 volta quando viene chiamata e il timer e' finito
    boolean isCounted(){
       if(over&&!toCount){
          toCount=true;
          return true;
        }
       return false;
    }
    
    void checkisOver(){
      if (started && !paused)
        over = timeLeft()<=0;

    }
    
    private int secInMillisec(int sec){
        return sec*1000;
    }
    
    private int millInSec(int mill){
        return (mill/1000)%60;
    }
    
    private int millInMin(int mill){
        return (mill / (1000*60)) % 60;
    }

    int timeLeft(){
        if(running){
            return (int)(long)endTime - millis();
        }
        else{
            return 0;
        }
    }
    private int timeElapsed(){
    
      return (int)(long)(stopTime-startTime);
      
    }
  
    
    int second() {
        return millInSec(timeLeft());
    }
    int minute() {
        return millInMin(timeLeft());
    }
    int hour() {
        return (timeLeft() / (1000*60*60)) % 24;
    }
    
    
    
    String stringTimer(){
      checkisOver();  
      if (running && !over){
          // per visualizzare il tempo tipo 0:09
          if(t.second()<10)
              return t.minute()+divider +"0"+t.second();
          return t.minute()+divider+t.second();
      }
      else if ( paused ){
          int millSec = (int)(long)(endTime - stopTime);
          int min = millInMin(millSec);
          int sec = millInSec(millSec);
          if (sec<10){
              return min + divider+"0" + sec ;
          }
          return  min + divider + sec ;
      }
      else if(over){
         return "OVER";
      }
      return "0"+divider+"00";
          
      
    }

}
