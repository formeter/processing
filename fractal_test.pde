//CONSTANTS   /////////////////////////////////////
final int STROKE_WEIGHT = 3;
final int STROKE_LENGTH = 6;
final int N_OF_WORD = 20;

final boolean PRINT = false;
final boolean MULTI_LINE_MODE = false;


//GLOBAL VARS  ////////////////////////////////////
Direction DIRECTION = new Direction();
Point ORIGIN = new Point(150, 200);

//CLASSES    //////////////////////////////////////
class Fibonacci_word {
  String word;
  int n;
  int len;
  
  Fibonacci_word (int n) {
    this.n = n;
    this.word = "";
    if (n > 0) {
      if (n == 1) {
        this.word = "0"; //word 1
      }
      else 
        if (n == 2) {
          this.word = "01"; //word 2
        }
        else {
            Fibonacci_word minus1 = new Fibonacci_word(n - 1);
            Fibonacci_word minus2 = new Fibonacci_word(n - 2);
            this.word = minus1.word + minus2.word;
          }
    }
    this.len = this.word.length();
    if (PRINT) {
      println("Fibonacci word:");
      println(this.n);
      println(this.len);
      println(this.word);
      println();
  }
  }
  
  int digit (int position) {
    return int(this.word.charAt(position)) - 48;
  }
  
  void convert_to_dense() {
    String dense_word = "";
    for (int i = 0; i < (this.len/2)*2; i += 2) {
      int dense_digit = 2*digit(i) + digit(i+1);
      dense_word = dense_word + str(dense_digit);
    }
    this.word = dense_word;
    this.len = this.word.length();
    if (PRINT){
      println("dense word:");
      println(this.word);
    }
  }
  
  void morphism_3digit(String d0, String d1, String d2) {
   String new_word = "";
   String new_digit = "";
   for (int i = 0; i < this.len; i += 1) {
     switch (digit(i)) {  
       case 0:
         new_digit = d0;
         break;
       case 1:
         new_digit = d1;
         break;
       case 2:
         new_digit = d2;
         break;
     }     
     new_word = new_word + new_digit;
   }
    this.word = new_word;
    this.len = this.word.length();
    if (PRINT){
      println("dense morphed word:");
      println(this.word);
    }
 }
}

 

class Point {
  int x;
  int y;

  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void set_coord (int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  Point prolong_via(int xp, int yp, float lambda) {
    int xN = int ( ( (1+lambda)*this.x - xp)/lambda );
    int yN = int ( ( (1+lambda)*this.y - yp)/lambda );
    return new Point(xN, yN);
  }
}
  
class Direction {
  int toX;
  int toY;
  int direction;
  
  Direction () {
    this.direction = 0;
    this.toX = 1;
    this.toY = 0;
  }
  
  void turn (int digit, int k) {
    if (digit == 1) {
      if (k % 2 == 0) {
        this.direction++;
        this.direction %= 4;
      } else {
        this.direction--;
        if (this.direction == -1) {
          this.direction = 3;
        } else {
          this.direction %= 4;
      }
      }
    }
    direction_to_XY();
  }
  
  void turn_dense (int digit) {
    if (digit == 1) {
        this.direction++;
        this.direction %= 4;
      } else { 
        if (digit == 2) {
          this.direction--;
          if (this.direction == -1)
            this.direction = 3; 
          else 
            this.direction %= 4;
          }
      }
    direction_to_XY();
  }
  
  void direction_to_XY() {
    switch(this.direction) {
      case 0:
        this.toX = 1;
        this.toY = 0;
        break;
      case 1:
        this.toX = 0;
        this.toY = 1;
        break;
      case 2:
        this.toX = -1;
        this.toY = 0;
        break;
      case 3:
        this.toX = 0;
        this.toY = -1;
        break;
    }
  }
}
  
class Segment {
  int k; //for position in the word
  int digit;
  color segment_color;
  Segment (int digit, int k, color segment_color) {
    this.digit = digit;
    this.k = k;
    this.segment_color = segment_color;
  }
  
  Point draw_segment(Point origin) { //returns next point (to use as a new origin)
    
    Point next = new Point (origin.x + STROKE_LENGTH * DIRECTION.toX, origin.y + STROKE_LENGTH * DIRECTION.toY);
    stroke(this.segment_color);
    line_function(origin.x, origin.y, next.x, next.y);
    //DIRECTION.turn(this.digit, this.k);
    DIRECTION.turn_dense(this.digit);
    next.set_coord(next.x, next.y);
    if (PRINT) println("k", this.k, "digit", this.digit, "dir", DIRECTION.direction, "toXY", DIRECTION.toX, DIRECTION.toY, "line", origin.x, origin.y, next.x, next.y);
    return next;
    
    //println(origin.x, origin.y, ORIGIN.x, ORIGIN.y);
  }
}


//for (int i=0; i<10; i++) {
//  Fibonacci_word fib_word = new Fibonacci_word(i);
//  println(fib_word.word);
//}

//DRAWING///////////////////////////////////////////////////////////////
void setup() {
  size(800, 800);
  //noLoop();
}

void draw_fractal(Fibonacci_word fib, Point origin, color base_color, int begin_color_k) {
  for (int k = 0; k < int(fib.len / 2.444); k++) { //for every digit of the word
    int digit = fib.digit(k);
    color segment_color = base_color + color( - (k + begin_color_k) % 30 , 0 , (k + begin_color_k) % 100, 100);
    Segment segment = new Segment (digit, k, segment_color);
    origin = segment.draw_segment(origin);
  }
  
}

void line_function(int x1, int y1, int x2, int y2) {
  if (!MULTI_LINE_MODE) line(x1, y1, x2, y2);
  else {
    stroke(STROKE_WEIGHT);
    line(x1, y1, x2, y2);
  
    Point point1 = new Point(x1,y1);
    Point point2 = point1.prolong_via(x2,y2,0.5);
    stroke(STROKE_WEIGHT/2);
    line(x1, y1, point2.x, point2.y);
    
  }
}

int K = 30;
int A = 0;
int X = 0;
float Time = 0;

void draw() {
  background(20);
  //strokeWeight(STROKE_WEIGHT+1);
  Fibonacci_word fib;
  
  ORIGIN.set_coord(102+X, 300+X/2);
  DIRECTION.direction = 0;
  strokeWeight(STROKE_WEIGHT+3);
  
  fib = new Fibonacci_word(N_OF_WORD);
  fib.convert_to_dense();
  fib.morphism_3digit("21","02","10");
  draw_fractal(fib, ORIGIN, color(0, 149, 149, 20), K);
  
  ORIGIN.set_coord(100, 300);
  DIRECTION.direction = 0;
  strokeWeight(STROKE_WEIGHT);
  
  fib = new Fibonacci_word(N_OF_WORD);
  fib.convert_to_dense();
  fib.morphism_3digit("21","02","10");
  draw_fractal(fib, ORIGIN, color(255, 149, 119, 70 - A), K/2);
  
  //ORIGIN.set_coord(123, 307);
  //DIRECTION.direction = 0;
  //strokeWeight(STROKE_WEIGHT);
  
  //fib = new Fibonacci_word(N_OF_WORD);
  //fib.convert_to_dense();
  //fib.morphism_3digit("21","02","10");
  //draw_fractal(fib, ORIGIN, color(255, 149, 149, 100 - A), K/2);
  
  Time += 0.001;
  
  K=K+20;
  A = int(sin(Time*20)*30);
  X = int(sin(Time*10)*8%4);
}
