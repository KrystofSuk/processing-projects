int amount = 10;
float mag = 300;
float rnd = .2;
float xC = random(0.1, 4);
float yC = random(0.1, 4);
float zC = random(0.1, 4);
float xDC = random(0.1, 4);
float yDC = random(0.1, 4);
float zDC = random(0.1, 4);
float cC = random(0.1,5);
boolean run = true;
boolean end = false;
float step = .4;
float clr = 0;
float r = 240, g = 240, b = 240;

float pX, pY;
void setup() {
    size(800,1000, P2D);
    imageMode(CENTER);
    background(#101010);
    fill(190,30,45);
    rect(width/2 - 586/2, height/2-810/2, 586, 810);
    fill(0);
    strokeCap(ROUND);
    
    frameRate(60);
    smooth(8);
    xC = random(0.1, 4);
    yC = random(0.1, 4);
    zC = random(0.1, 4);
    xDC = random(0.1, 4);
    yDC = random(0.1, 4);
    zDC = random(0.1, 4);
    cC = random(0.1,3);
    mag = random(300, 600);
    pX = random(-200, 200);
    pY = random(-200, 200);
    step = random(0.3, 0.6);
    run = true;
    end = false;
    frameCount = 0;
    clr = 0;
}

void gradient_line( color s, color e, float x, float y, float xx, float yy ) {
  for ( int i = 0; i < 200; i ++ ) {
    stroke( lerpColor( s, e, i/200.0) );
    line( ((200-i)*x + i*xx)/200.0, ((200-i)*y + i*yy)/200.0, 
      ((200-i-1)*x + (i+1)*xx)/200.0, ((200-i-1)*y + (i+1)*yy)/200.0 );
  }
}

void draw() {

    if (!run)
        return;
    translate(width / 2 + pX, height / 2 + pY);
    float w = map(sin(radians(frameCount * step * zC)), -1, 1, -100, 100);
    float wx = map(cos(radians(frameCount * step * xC + w)), -1, 1, -mag, mag);
    float wy = map(sin(radians(frameCount * step * yC)), -1, 1, -mag, mag);
    
    float d = map(sin(radians(frameCount * step * zDC)), -1, 1, -100, 100);
    float dx = map(cos(radians(frameCount * step * xDC + d)), -1, 1, -mag, mag);
    float dy = map(sin(radians(frameCount * step * yDC)), -1, 1, -mag, mag);

    float c = map(sin(frameCount * step * cC), -1, 1, 0, 4);
    stroke(255, 255, 255, 0);
    if(frameCount > 100 && !end){
        clr = lerp(clr, c, .1);
    }
    if(end){
        clr = lerp(clr, 0, .1);
        if(clr < 0.1)
            run = false;
    }

    strokeWeight(clr);
    gradient_line(color(r, g, b), color(190,30,45), dx, dy, wx, wy);   

    
    translate(-width / 2 - pX, -height / 2 - pY);
    fill(#101010);
    strokeWeight(0);
    stroke(255, 255, 255, 0);
    rect(0, 0, width, height/2-810/2);
    rect(0, height/2+810/2, width, height/2-810/2);
    rect(0, 0, width/2-586/2, height);
    rect(width/2+586/2, 0, width/2+586/2, height);
    fill(0);
}


void keyPressed() {
    if (key == 'r') {
        setup();
    }
    if (key == 'x') {
        end = true;
    }
}
