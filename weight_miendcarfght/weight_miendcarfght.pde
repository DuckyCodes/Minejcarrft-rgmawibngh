import java.awt.Robot;

Robot rbt;
boolean skipFrame;

color white = #FFFFFF;
color black = #000000;
color dullBlue = #7092BE;

int gridSize;
PImage map;
PImage as;
PImage tree;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle;
void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX= width/2;
  eyeY = height/2+350;
  eyeZ = 0;

  focusX = width/2;
  focusY = height/2;
  focusZ =eyeZ;
  upX = 0;
  upY = 1;
  upZ = 0;

  map = loadImage("map.png");
  tree = loadImage("tree.jpg");
  as = loadImage("as.png");

  gridSize=100;

  leftRightHeadAngle = radians(270);
  noCursor();
  try { 
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;
}




void draw() {
  background(0);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  spotLight(255, 255, 255, eyeX, eyeY, eyeZ, focusX, focusY, focusZ, PI/2, 0.5);
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
  //move();
  //drawAxis();
  drawFloor(-2000, 2000, height-gridSize*4, gridSize);
  drawFloor(-2000, 2000, height-gridSize*0, gridSize);
  drawMap();
  drawFocalPoint();
  controlCamera();
}
void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}
void cube(float x, float y, float z, PImage t, float s) {
  pushMatrix();

  translate(x, y, z);
  noFill();
  noStroke();

  scale(s);


  beginShape(QUADS);
  texture(t);
  //     x,y,z,tx,ty
  //top
  vertex(0, 0, 0, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 0, 1, 1, 1);
  vertex(0, 0, 1, 0, 1);
  //bottom
  vertex(0, 1, 0, 0, 0);
  vertex(1, 1, 0, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(0, 1, 1, 0, 1);
  endShape();
  beginShape(QUAD);
  texture(t);
  //front 
  vertex(0, 0, 1, 0, 0);
  vertex(1, 0, 1, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(0, 1, 1, 0, 1);
  //back
  vertex(0, 0, 0, 0, 0);
  vertex(1, 0, 0, 1, 0);
  vertex(1, 1, 0, 1, 1);
  vertex(0, 1, 0, 0, 1);
  //right
  vertex(0, 0, 0, 0, 0);
  vertex(0, 0, 1, 1, 0);
  vertex(0, 1, 1, 1, 1);
  vertex(0, 1, 0, 0, 1);
  //left
  vertex(1, 0, 0, 0, 0);
  vertex(1, 0, 1, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(1, 1, 0, 0, 1);

  endShape();
  box(s); // H W D
  popMatrix();
}
void drawMap() {
  for (int x = 0; x< map.width; x++) {
    for (int y = 0; y< map.height; y++) {
      color c = map.get(x, y);
      //if (c==white) {
      //  pushMatrix();

      //  tree(x*gridSize-2000, height-gridSize, y*gridSize-2000, tree, gridSize);
      //  tree(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, tree, gridSize);
      //  tree(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, tree, gridSize);
      //  popMatrix();
      //}
      if (c== dullBlue) {

        cube(x*gridSize-2000, height-gridSize, y*gridSize-2000, tree, gridSize);
        cube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, tree, gridSize);
        cube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, tree, gridSize);
      }
      if (c==black) {

        cube(x*gridSize-2000, height-gridSize, y*gridSize-2000, as, gridSize);
        cube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, as, gridSize);
        cube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, as, gridSize);
      }
    }
  }
}



void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z<end) {
    cube(x, level, z, as, gap); 
    x = x + gap;
    if (x >=end) {
      x = start;
      z = z + gap;
    }
  }
}

void controlCamera() {

  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10; 
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10; 
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle+PI/2)*10; 
    eyeZ = eyeZ - sin(leftRightHeadAngle+PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX + cos(leftRightHeadAngle+PI/2)*10; 
    eyeZ = eyeZ + sin(leftRightHeadAngle+PI/2)*10;
  }
  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle +(mouseX - pmouseX)*0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
  upDownHeadAngle = upDownHeadAngle + (mouseY -pmouseY)*0.01;

  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;

  if (mouseX<2) {
    rbt.mouseMove(width-3, mouseY);
  } else if (mouseX> width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
}

void keyPressed() {
  if (key =='W'|| key == 'w') wkey = true;
  if (key =='A'|| key == 'a') akey = true;
  if (key =='D'|| key == 'd') dkey = true;
  if (key =='S'|| key == 's') skey = true;
}
void keyReleased() {
  if (key =='W'|| key == 'w') wkey = false;
  if (key =='A'|| key == 'a') akey = false;
  if (key =='D'|| key == 'd') dkey = false;
  if (key =='S'|| key == 's') skey = false;
}
