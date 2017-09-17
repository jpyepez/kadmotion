
import processing.video.*;
import java.util.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Capture cam;

ArrayList<ColorContainer> pix_prev, pix_new;
boolean isMoving[];

int colorThreshold;
float grid_num;
float pix_rate;
boolean isFirstFrame;

color[] palette = {#081435, #967EC4, #9FA7DD, #9FC7DD, #9FD4DD, #9FDDD6};

void setup() {
  fullScreen();
  println(width, height);
  noCursor();

  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("localhost", 6448); // use standard wekinator address

  pix_prev = new ArrayList<ColorContainer>();
  pix_new = new ArrayList<ColorContainer>();

  colorThreshold = 40;
  grid_num = 24;              // must be common denominator of width and height
  pix_rate = width/grid_num;
  isFirstFrame = true;

  isMoving = new boolean[(int)(grid_num * (height/pix_rate))];
  for(boolean state : isMoving) {
    state = false;
  }

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
    
  // The camera can be initialized directly using an 
  // element from the array returned by list():
  cam = new Capture(this, width, height);
  cam.start();     
}

void draw() {
  fill(palette[0], 25);
  rect(0, 0, width, height);

  getNewColors();
  // drawCam(pix_new);
  // colorSides();
  getMovement();
  handleMotion();
  drawBool();
  storeColors();
}

// get new screen colors
void getNewColors() {

  // get camera
  if (cam.available() == true) {
    cam.read();
  }

  // get pixel colors and store them in container array
  cam.loadPixels();
  for (int i = 0; i < cam.width; i += pix_rate) {
    for (int j = 0; j < cam.height; j += pix_rate) {
      color c = cam.pixels[i + j * cam.width];
      ColorContainer cont = new ColorContainer(c);
      pix_new.add(cont);
    }
  }
  cam.updatePixels();
}

// compare difference between current and previous frames
void getMovement() {

  if(!isFirstFrame) {

    for (int i = 0; i < pix_prev.size(); i++) {
      ColorContainer c_prev = pix_prev.get(i);
      ColorContainer c_new = pix_new.get(i);
          
      float dif = abs(red(c_prev.getInnerColor()) - red(c_new.getInnerColor()));
      if(dif > colorThreshold) {
        isMoving[i] = true;
      } else {
        isMoving[i] = false;
      }
    }
  }
}

// store colors for next frame
void storeColors() {
  pix_prev = new ArrayList(pix_new);
  pix_new.clear();
  isFirstFrame = false;
}

// draw a camera from a ColorContainer array
void drawCam(ArrayList<ColorContainer> colors) {

  // draw color rects
  int contCounter = 0;
  pushMatrix();
  for (int i = 0; i < cam.width; i+=pix_rate) {
    for (int j = 0; j < cam.height; j+=pix_rate) {
      pushMatrix();

      translate(cam.width - i, j);
      noStroke();
      ColorContainer cont = colors.get(contCounter);
      fill(cont.getInnerColor());
      rect(0, 0, -pix_rate, pix_rate);

      contCounter++;

      popMatrix();
    }
  }
  popMatrix();
}

void drawBool() {

  // draw color rects
  int counter = 0;
  pushMatrix();
  for (int i = 0; i < cam.width; i+=pix_rate) {
    for (int j = 0; j < cam.height; j+=pix_rate) {
      pushMatrix();

      translate(cam.width - i, j);
      noStroke();
      if(isMoving[counter]) {
        fill(palette[(int)random(1, palette.length - 1)]);
        // rect(0, 0, -pix_rate, pix_rate);
        beginShape();
        vertex(0, 0);
        vertex(-pix_rate, 0);
        vertex(-pix_rate, pix_rate);
        endShape(CLOSE);
      }

      counter++;

      popMatrix();
    }
  }
  popMatrix();
}

// send OSC message with motion values
void oscSend(String addr, float global, float left, float right) {
  OscMessage myMessage = new OscMessage(addr);
  myMessage.add(global);
  myMessage.add(left);
  myMessage.add(right);
  oscP5.send(myMessage, myRemoteLocation);
}

void handleMotion() {

  // get global motion
  int motionCounter = 0;
  for (boolean status : isMoving) {
    if(status) { motionCounter++; }
  }
  float motion_norm = float(motionCounter)/isMoving.length; // normalize

  // get sides
  int counter_l = 0;
  int counter_r = 0;
  for(int i = 0; i < isMoving.length; i++) {
    if(isMoving[i]) {
      if(i < isMoving.length/2) { 
        counter_r++;
      } else { 
        counter_l++;
      }
    }
  }
  float l_norm = float(counter_l)/(isMoving.length/2);
  float r_norm = float(counter_r)/(isMoving.length/2);

  oscSend("/wek/inputs", motion_norm, l_norm, r_norm);
}

void colorSides() {

  // draw color rects
  int counter = 0;
  pushMatrix();
  for (int i = 0; i < cam.width; i+=pix_rate) {
    for (int j = 0; j < cam.height; j+=pix_rate) {
      pushMatrix();

      translate(cam.width - i, j);
      noStroke();
      if(counter < isMoving.length/2 ) {   // draw right side
        fill(0, 255, 0 );
        rect(0, 0, -pix_rate, pix_rate);
      } else {
        fill(0, 0, 255);
        rect(0, 0, -pix_rate, pix_rate);
      }

      counter++;
      popMatrix();
    }
  }
  popMatrix();
}

