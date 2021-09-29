int margin = 300;
float speed = 5;
int yOff = 100;

Line[] lines;
int[] actives;

int threads = 6;
PFont f;
int nm = 0;
void setup() {
    size(1920, 1080);
    nm = round(random(30, 1500));
    lines = new Line[nm];
    for (int i = 0; i < lines.length; i++) {
        lines[i] = new Line(); // Create each object
        lines[i].start();
    }
    
    actives = new int[threads];
    for (int i = 0; i < threads; ++i) {
        actives[i] = i;
        lines[i].display = true;
    }
    smooth();
    frameRate(60);

    //printArray(PFont.list());
    f = createFont("iosevka-regular.ttf", 32);
    textFont(f);

    
    background(255);
    fill(0,0,0,255);
    stroke(255);
    strokeWeight(40);
    circle(width / 2, height / 2 - yOff, margin * 2);
    textSize(40);
    fill(0);
    textAlign(CENTER);
    text("Circle Of Chaos " + nm, width/2, height - 220);   
}

void reset(){
    size(1920, 1080);
    lines = new Line[nm];
    for (int i = 0; i < lines.length; i++) {
        lines[i] = new Line();
        lines[i].start();
    }
    
    actives = new int[threads];
    for (int i = 0; i < threads; ++i) {
        actives[i] = i;
        lines[i].display = true;
    }
    smooth();
    frameRate(60);

    //printArray(PFont.list());
    f = createFont("iosevka-regular.ttf", 32);
    textFont(f);

    
    background(255);
    fill(0,0,0,255);
    stroke(255);
    strokeWeight(40);
    circle(width / 2, height / 2 - yOff, margin * 2);
    textSize(40);
    fill(0);
    textAlign(CENTER);
    text("Circle Of Chaos " + nm, width/2, height - 220);   
}


void draw() {
    for (int i = 0; i < threads; ++i) {        
        if (actives[i] < lines.length) {
            if (!lines[actives[i]].display)
                lines[actives[i]].display = true;
            lines[actives[i]].update();
            lines[actives[i]].draw();
            if (lines[actives[i]].done) {
                actives[i] = actives[i] + threads;
            }
        }
    }
    fill(0,0,0,0);
    stroke(255);
    strokeWeight(40);
    circle(width / 2, height / 2 - yOff, margin * 2); 
}

class Line{
    float x, y;
    float aX, aY;
    float dX, dY;
    float dirX, dirY;
    float percentile;
    boolean display;
    boolean done;
    float stroke;
    float weight;
    
    void start() {
        /*
        x = random(-margin + width/2, margin + width/2);
        y = random(-margin + height/2, margin + height/2);
        
        while (dist(x,y,width/2,height/2) > margin) {
        x = random(-margin + width/2, margin + width/2);
        y = random(-margin + height/2, margin + height/2);
    }
        aX = x;
        aY = y;
        dX = random(-margin + width/2, margin + width/2);
        dY = random(-margin + height/2, margin + height/2);
        
        while (dist(dX,dY,width/2,height/2) > margin) {
        dX = random(-margin + width/2, margin + width/2);
        dY = random(-margin + height/2, margin + height/2);
    }
        */
        
        float angle = random(0,1) * PI * 2;
        x = cos(angle) * margin + width / 2;
        y = sin(angle) * margin + height / 2 - yOff;
        
        aX = x;
        aY = y;
        
        angle = random(0,1) * PI * 2;
        dX = cos(angle) * margin + width / 2;
        dY = sin(angle) * margin + height / 2 - yOff;
        
        
        dirX = dX - x;
        dirY = dY - y;
        dirX /= speed;
        dirY /= speed;
        percentile = 0.0;
        display = false;
        stroke = random(0,255);
        weight = random(1,6);
        done = false;
    }
    
    void update() {
        if (!display || done)
            return;
        aX += dirX;
        aY += dirY;
        if (abs(aX - dX) < 0.1 && abs(aY - dY) < 0.1) {
            done = true;
        }
    }
    
    void draw() {
        if (!display)
            return;
        stroke(stroke);
        strokeWeight(weight);
        line(x, y, aX, aY);
    }
}


void keyPressed() {
    if (key == ' ') {
        setup();
    }
    if (key == 'r') {
        reset();
    }
}


