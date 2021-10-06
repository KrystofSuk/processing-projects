import peasy.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioInput in;
BeatDetect beat;
BeatDetect beat2;

PeasyCam cam;
PImage imgs[];
int beatDur = 6;

void setup() {
    imgs = new PImage[17];
    imgs[0] = loadImage("a.jpg");
    imgs[1] = loadImage("b.jpg");
    imgs[2] = loadImage("c.jpg");
    imgs[3] = loadImage("d.jpg");
    imgs[4] = loadImage("e.jpg");
    imgs[5] = loadImage("f.jpg");
    imgs[6] = loadImage("g.jpg");
    imgs[7] = loadImage("h.jpg");
    imgs[8] = loadImage("i.jpg");
    imgs[9] = loadImage("j.jpg");
    imgs[10] = loadImage("k.jpg");
    imgs[11] = loadImage("l.jpg");
    imgs[12] = loadImage("m.jpg");
    imgs[13] = loadImage("n.jpg");
    imgs[14] = loadImage("o.jpg");
    imgs[15] = loadImage("p.jpg");
    imgs[16] = loadImage("q.jpg");
    for (int i = 0; i < 17; ++i) {
        print(i + "\n");
        if(imgs[i].width *.7 > width && imgs[i].height *.7 > height)
            imgs[i].resize(round(imgs[i].width *.7), round(imgs[i].height *.7));
        if(imgs[i].width < width && imgs[i].height < height)
            imgs[i].resize(round(imgs[i].width *4), round(imgs[i].height *4));
    }
    size(1920, 1080, P3D);
    cam = new PeasyCam(this, 500);
    minim = new Minim(this);
    in = minim.getLineIn(Minim.STEREO, 1024);
    beat = new BeatDetect();
    beat.setSensitivity(1);
    beat2 = new BeatDetect();
    beat2.setSensitivity(300);
    frameRate(120);
    fullScreen();
}

int bt, idx = 0;
float x, y = 0;

float dX, dY, dtX, dtY = 0;
float dT, dtT = 30;

int cnt = 120;
int cnt2 = 0;
int phase = 0;
int phaseDur = 0;

void draw() {
    cnt -= 1;
    cnt2 -= 1;
    if(cnt <= 0){
        cnt = 120;
        dX = random(-0.07, 0.06);
        dY = random(-0.07, 0.06);
    }
    if(cnt2 <= 0){
        cnt2 = 120*2;
        dT = round(random(1)* 90) +5;
    }
    
    dtX = lerp(dtX, dX, 0.001);
    dtY = lerp(dtY, dY, 0.001);
    dtT = lerp(dtT, dT, 0.01);

    beat.detect(in.mix);
    beat2.detect(in.mix);
    print(dtT + " " + dT + "\n");
    background(0);

    
    if (bt == 0) {
        perspective(PI / 3.0, width / height, 10, 10000000);
        
        cam.rotateY(dtX + 0.01);
        cam.rotateX(dtY + 0.01);
        cam.setDistance(0 + abs(sin(frameCount * 0.005)) * 600);
        hint(DISABLE_DEPTH_TEST);
        
        int total = round(dtT);
        PVector[][] pp = new PVector[total][total];
        for (int i = 0; i < total; ++i) {
            float lat = map(i, 0, total - 1, -HALF_PI, HALF_PI);
            for (int j = 0; j < total; ++j) {
                float lon = map(j, 0, total - 1, -PI, PI);
                int imnd = i + j * total;
                float r = 200 + in.mix.get(imnd % 1024) * 200;
                float x = r * cos(lat) * cos(lon);
                float y = r * sin(lat) * cos(lon);
                float z = r * sin(lon);
                pp[i][j] = new PVector(x, y, z);
            }
        }
        
        for (int i = 0; i < total - 1; ++i) {
            beginShape(TRIANGLE_STRIP);
            strokeWeight(1);
            stroke(255, in.mix.get(i) * 500);
            noFill();
            for (int j = 0; j < total; ++j) {
                vertex(pp[i][j].x, pp[i][j].y, pp[i][j].z);
                vertex(pp[i + 1][j].x, pp[i + 1][j].y, pp[i + 1][j].z);
            }
            endShape();
        }
    }
    if (beat.isOnset() || bt != 0) {
        bt -= 1;
        background(255);
        cam.beginHUD();
        image(imgs[idx], x, y);
        cam.endHUD();
        if (beat.isOnset()){
            idx = floor(random(0, 17));
            x = -random(imgs[idx].width - width);
            y = -random(imgs[idx].height - height);
            bt =  beatDur;
        }



    }
    
    if (beat2.isOnset()) {
        strokeWeight(0);
        if(phaseDur == 0){
            phaseDur = 2;
        }
        phaseDur--;

        if(phase == 1){
            phase = 2;
        }
        else if(phase == 2){
            phase = 1;
        }
        else if(phase == 3){
            cam.beginHUD();
            fill(0);
            stroke(0);
            rect(width/2 - 150, height/2-150, 300, 300, 0);
            cam.endHUD();
            phase = 4;
        }
        else if(phase == 4){
            cam.beginHUD();
            fill(255);
            stroke(255);
            rect(width/2 - 150, height/2-150, 300, 300, 0);
            cam.endHUD();
            phase = 3;
        }

        if(phaseDur == 0)
        {
            float rnd = random(0,100);
            if(rnd < 5){
                phase = 3;
                phaseDur = 3;
            }
            else if(rnd < 15){
                phase = 1;
                phaseDur = 4;
            }
            else if(rnd < 20){
                phase = 5;
                phaseDur = 2;
            }
            else if(rnd < 30){
                phase = 6;
                phaseDur = 2;
            }
            else if(rnd < 35){
                phase = 7;
                phaseDur = 2;
            }
            else
                phase = 0;
        }
    }

    if(phase == 1){
        cam.beginHUD();
        fill(0);
        stroke(0);
        rect(width/2 - 150, height/2-150, 300, 300, 0);
        cam.endHUD();
    }
    if(phase == 2){
        cam.beginHUD();
        fill(255);
        stroke(255);
        rect(width/2 - 150, height/2-150, 300, 300, 0);
        cam.endHUD();
    }
    if(phase == 5){
        cam.beginHUD();
        fill(255,0 ,0);
        stroke(255,0 ,0);
        circle(width/2, height/2, 300);
        cam.endHUD();
    }
    if(phase == 6){
        cam.beginHUD();
        fill(0);
        stroke(0);
        rect(0, 0, width/2 - 500, height, 0);
        rect(width/2 + 500, 0, width/2 - 500, height, 0);
        rect(0, 0, width, height/2 - 500, 0);
        rect(0, height/2 + 500, width, height/2 - 500, 0);
        cam.endHUD();
    }
    if(phase == 7){
        cam.beginHUD();
        fill(0);
        stroke(0);
        rect(0, 0, width/2 - 200, height, 0);
        rect(width/2 + 200, 0, width/2 - 200, height, 0);
        rect(0, 0, width, height/2 - 200, 0);
        rect(0, height/2 + 200, width, height/2 - 200, 0);
        cam.endHUD();
    }
}
