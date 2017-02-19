import processing.serial.*;// serial communication
import controlP5.*;
import peasy.*;

class Drone
{
  float []pos;// position
  float []ori;// orientation
  
  float []PIDtilt; // tilt PID constants
  float []PIDpos; // position PID constants
  boolean PIDTiltChange;// to check wether or not new pid values need to be sent to drone
  boolean PIDPosChange;// to check wether or not new pid values need to be sent to drone
  
  
  // drones pop up window 
  boolean popWindow;
  ControlP5 cp5;
  DropdownList ddl; // dropdown list 
  
  Drone(float location[], float orientation[], float pidTilt[], float pidPos[], ControlP5 inter)
  {
    popWindow = false;
    cp5 = inter;
    
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
    
    initPopWindow();
    
  }
  void move(float newPos[],float newOri[])
  {
    for(int i = 0; i < 3; i++)
    {
      pos[i] = newPos[i];
      ori[i] = newOri[i];
    }
  }
  void mousePressed(int x, int y,PeasyCam cam )
  {
    println(x + ", " + y + "\t:Drone\t" + pos[0] + "," + pos[1] + "\t:Drone\t" );//+ cam.position[0] + ", " + cam.position[1]); //<>//
    if((x <= (pos[0]+100) && x >=(pos[0]-100)) && (y <= (pos[1]) && y >= (pos[1]-100)))
    {
      popWindow = !popWindow;
      if(popWindow == true)
      {
        cp5.show();
        cam.setRotations(0,0,0);
        //cam.lookAt(0,0,0);
        //cam.lookAt(pos[0], pos[1], (pos[2] + 100));
        println("object pressed to show");
      }
      else
      {
        println("object pressed to hide");
        cp5.hide();
      }
    }
  }
  void display(PeasyCam cam)
  {
    displayDrone(cam);
    updatePopWindow();
    //displayPopWindow();
     //<>//
  }
  void updatePopWindow()
  {
    //cp5.setPosition(int(pos[0]+50), int(pos[1]));
    ddl.setPosition(pos[0]+50, pos[1]);
  }
  void initPopWindow()
  {
    //pushMatrix();
    //Dropdown for roll/x pitch/y yaw/z
    ddl = cp5.addDropdownList("axis").setPosition(pos[0]+50, pos[1]-(19*3));
    ddl.setItemHeight(19)
       .setBackgroundColor(color(190))
       .addItem("X / Roll", 0)
       .addItem("Y / Pitch", 1)
       .addItem("Z / Yaw", 2)
       .setColorActive(color(255, 128))
       .setColorBackground(color(60));
   
    // sliders
    cp5.addSlider("P:orientation")
        .setRange(0.0, 10.0)
        .setValue(PIDtilt[0])
        //.setPosition(pos[0]+50, pos[1]+19)
        .setSize(100, 19);
    cp5.addSlider("I:orientation")
        .setRange(0.0, 10.0)
        .setValue(PIDtilt[1])
        //.setPosition(pos[0]+50, pos[1]+(19*2))
        .setSize(100, 19);
    cp5.addSlider("D:orientation")
        .setRange(0.0, 10.0)
        .setValue(PIDtilt[2])
        //.setPosition(pos[0]+50, pos[1]+(19*3))
        .setSize(100, 19);
    cp5.addSlider("P:position")
        .setRange(0.0, 10.0)
        .setValue(PIDtilt[1])
        //.setPosition(pos[0]+50, pos[1]+(19*4))
        .setSize(100, 19);
    cp5.addSlider("I:position")
        .setRange(0.0, 10.0)
        .setValue(PIDtilt[2])
        //.setPosition(pos[0]+50, pos[1]+(19*5))
        .setSize(100, 19);
    cp5.addSlider("D:position")
        .setRange(0.0, 10.0)
        .setValue(PIDtilt[1])
        //.setPosition(pos[0]+50, pos[1]+(19*2))
        .setSize(100, 19);
    //cp5.setPosition(0,0,0);
    cp5.hide();
    //ddl.setPosition(0,0);
    //popMatrix();
        
    
  }
  void displayDrone(PeasyCam cam)
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
    fill(255,0,0);
    box(5,5,100);    
    sphere(10);
    fill(0,255,0);
    box(100,10,10);
    
    // propellers
    ellipse(50, 0, 30, 30);
    ellipse(-50, 0, 30, 30);
    sphere(10);
    fill(0,0,255);
    box(10,100,10);
    ellipse(0, 50, 30, 30);
    ellipse(0, -50, 30, 30);
    sphere(10);
    rotateX(0);
    rotateY(0);
    rotateZ(0);
    //popMatrix();
    translate(-pos[0], -pos[1], -800/1000);
    popMatrix();
  }
}