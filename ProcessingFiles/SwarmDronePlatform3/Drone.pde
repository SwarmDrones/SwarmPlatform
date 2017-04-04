import processing.serial.*;// serial communication //<>// //<>//
import controlP5.*;
import peasy.*;

class Drone
{
  String id;
  float []pos;// position
  float []ori;// orientation
  // might not need the PID constants or variables since Gui holds them now 
  float []PIDtilt; // tilt PID constants
  float []PIDpos; // position PID constants
  boolean PIDTiltChange;// to check wether or not new pid values need to be sent to drone
  boolean PIDPosChange;// to check wether or not new pid values need to be sent to drone
  
  
  // drones pop up window 
  boolean popWindow;
  boolean selected;
  DropdownList ddl; // dropdown list 
  
  Drone(String _id, float location[], float orientation[], float pidTilt[], float pidPos[])
  {
    id = _id;
    popWindow = false;
    selected = false;
    pos = new float[3];
    ori = new float[3];
    PIDtilt = new float [3];
    PIDpos = new float [3];
    PIDTiltChange = true;
    PIDPosChange = true;
    
    for(int i = 0; i < 3; i++)
    {
      pos[i] = location[i];
      ori[i] = orientation[i];
      PIDtilt[i] = pidTilt[i];
      PIDpos[i] = pidPos[i];
    }
    
    
  }
  void move(float newPos[],float newOri[])
  {
    for(int i = 0; i < 3; i++)
    {
      pos[i] = newPos[i];
      ori[i] = newOri[i];
    }
  }
  
 void display()
  {
    displayDrone(); 
  }
  
  void mousePressed(int x, int y, PeasyCam cam)
  {
    //println(x + ", " + y + "\t:\t" + pos[0] + "," + pos[1]);
    int x3d = int(screenX(pos[0], pos[1], pos[2]));
    int y3d = int(screenY(pos[0], pos[1], pos[2]));
    float vertices3D[] = {0,0,0}; 
    int vertices2D[] = {0,0,0}; 
    if((x<= (x3d +100) && x >=(x3d -100)) && (y <= (y3d +100) && y >= (y3d-100)))
    {
      popWindow = !popWindow;
      
    }
  }
  void displayDrone()
  {
    pushMatrix();
    stroke(0);
    rotateX(0);
    rotateY(0);
    rotateZ(0);
    translate(pos[0], pos[1], 800/1000);
    
    rotateZ(radians(ori[2]));
    rotateX(radians(ori[1]));
    rotateY(radians(ori[0]));
    fill(100, 100, 100);
    box(20);
    // make the other parts 45 degress from 0
    rotateZ(radians(45));
    fill(255, 0, 0);
    box(5,5,100);    
    sphere(10);
    fill(0, 0, 255);
    box(100,10,10);
    
    // propellers
    ellipse(50, 0, 30, 30);
    ellipse(-50, 0, 30, 30);
    sphere(10);
    fill(0, 255, 0);
    box(10,100,10);
    ellipse(0, 50, 30, 30);
    ellipse(0, -50, 30, 30);
    sphere(10);
    rotateX(0);
    rotateY(0);
    rotateZ(0);
    //popMatrix();
    translate(-pos[0], -pos[1], -800/1000);
    //show if selected drone
    if(selected)
    {
      translate(pos[0], pos[1], 30); 
      pushStyle(); 
      fill(116,244,255); 
      noStroke(); 
      sphere(10); 
      popStyle();
    }
    popMatrix();
  }
}