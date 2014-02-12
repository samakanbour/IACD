// Source: http://www.openprocessing.org/sketch/49159
// SAMA KANBOUR

int  nFramesInLoop = 10;
int  nElapsedFrames;
Flower  f;
 
void setup () {
  size (500, 500);
  nElapsedFrames = 0;
  frameRate (nFramesInLoop);
  smooth();
  background (247);
  f = new Flower (200, width/2, height/2, 200, 0.5);
}
 
void draw () {
  float modFrame = (float) (frameCount % nFramesInLoop);
  float p = modFrame / (float)nFramesInLoop;
  background (247);
  fill (211, 196, 154, 80);
  noStroke();
  ellipse (width/2, height/2, 450, 450);
  f.display();
}

class Anchor {
  private float angle, minAngle, maxAngle, length;
  private int centerX, centerY;
  private ArrayList branches;
  Anchor (float angle, float minAngle, float maxAngle, float length, int centerX, int centerY, float minNext ) {
    this.angle = angle;
    this.minAngle = minAngle; 
    this.maxAngle = maxAngle;
    this.length = length;
    this.centerX = centerX;
    this.centerY = centerY;
    branches = new ArrayList();
    createBranches(angle, centerX, centerY, 0, random (length /15.0, length /2.0), 0, minNext);
  }

  public int getCenterX () {
    return centerX;
  }
  public int getCenterY () {
    return centerY;
  }

  private void createBranches (float fAngle, float startX, float startY, float totalLength, float flength, int count, float minNext) {
    float mangle = minAngle / 4;
    float weighing = 0.5;
    float [] [] points = new float [5] [2];
    if (flength>80) points = new float [6] [2];
    points [0] [0] = points [1] [0] = startX;                                                                                                                  // startpunkt x
    points [0] [1] = points [1] [1] = startY;                                                                                                                  // startpunkt y
    points [points.length-2] [0] = points [points.length-1] [0] = startX + cos (radians (fAngle)) * flength;                                                   // endpunkt x
    points [points.length-2] [1] = points [points.length-1] [1] = startY + sin (radians (fAngle)) * flength;                                                   // endpunkt y
    if (flength<=80) {
    points [2] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
    points [2] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
    } else {
    weighing = 0.4;
    points [2] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
    points [2] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
    weighing = 0.6;
    points [3] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
    points [3] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
    }
    //----- add new branch
    branches.add (new Branch (points));
    //----- calculate current branch length
    totalLength += flength;
    //----- recursion
    if (count < 25 && flength > 1.5) {
      count++;
      int dir = (int) random(0, 3);
      //----- one or two anchors
      if (dir <= 1) {
      float nextflength = flength * random(0.75, 1.20);
      if ( totalLength+nextflength < length) createBranches (fAngle + random (minAngle*2, maxAngle*2), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
      } else {
        float nextflength = flength * random(minNext, 1.05);
        if ( totalLength+nextflength < length) createBranches (fAngle + random (minAngle/2, 0), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
        nextflength = flength * random(minNext, 1.05);
        if ( totalLength+nextflength < length) createBranches (fAngle + random (0, maxAngle/2), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
      }
    }
  }
 
  public void display () {
    Branch br;
    for (int i = 0; i < branches.size(); i++) {
      br = (Branch) branches.get (i);
      br.display();
    }
  }
}
 
 
class Branch {
  private float [] [] points;
  Branch (float [] [] points) {
  this.points = new float [points.length] [points[0].length];
  arrayCopy (points, this.points);
  }
  public void display () {
  noFill();
  stroke (0, 50);
  beginShape();
  for (int i = 0; i < points.length; i++) {
    curveVertex (points [i] [0], points [i] [1]);
  }
  endShape();
  }
}


class Flower {
  private Anchor [] anchor;
  private int num, centerX, centerY, d;
  private float minNext;
  private float [] angles, length;

  Flower (int num, int centerX, int centerY, int d, float minNext) {
    this.num = num;
    this.centerX = centerX;
    this.centerY = centerY;
    this.d = d;
    this.minNext = minNext;
    this.angles = new float [num];
    this.length = new float [num];
    createFlower();
  }

  private void createFlower() {
    anchor = new Anchor [num];
    for (int i = 0; i < num; i++) {
      angles [i] = random (360);
    }
    arrayCopy (sort (angles), angles);
    float minLength = d*10, maxLength = 0;
    for (int i = 0; i < length.length; i++) {
      length [i] = d;
      if (length [i] < minLength) minLength = length [i];
      if (length [i] > maxLength) maxLength = length [i];
    }
  }

  public void display(){
    for (int i = 0; i < num; i++) {
      anchor[i] = new Anchor (angles [i], -20, 20, length [i], centerX, centerY, minNext);
      anchor[i].display();
    }
  }
}
