import processing.serial.*;// serial communication
import processing.opengl.*;// graphics
import peasy.*; // camera
PeasyCam cam; //<>//

final int h = 800;
final int w = 1400;

float Dloc[] = {200, 200, 0.0};
float Dori[] = {0.0, 0.0, 0.0};
float DoriGain[] = {1.0, 1.0, 1.0};
float DposGain[] = {1.0, 1.0, 1.0};
GUI gui;
Drone drone;
DroneManager dm;
void setup()
{
  size(1400, 800,OPENGL);
  frameRate(60);
  //////////////////////////////////// Serial setup////////////////////////////////
  
  //////////////////////////////////// interface setup////////////////////////////////
  gui = new GUI( this);
  //////////////////////////////////// drone setup////////////////////////////////
  //dm = new DroneManager(3, this);
  drone = new Drone("drone", Dloc, Dori, DoriGain, DposGain);
  //dm.addDrone(drone);
  //////////////////////////////////// Camera setup////////////////////////////////
  cam = new PeasyCam(this,0, 0, 0,1000);
  cam.setMinimumDistance(20);
  cam.setMaximumDistance(2000);
  
  // Simple 3 point lighting
  pointLight(255, 200, 200,  400, 400,  500);
  pointLight(255, 200, 255, w, h,  0);
  pointLight(255, 255, 255,    -500,   -500, -500);
}
void draw()
{
  background(255,255,255);
  drone.display();
  if(drone.popWindow == true)
  {
    cam.setRollRotationMode();
    //cam.setRotations(0,0,0);
  }
  else
  {
    cam.setFreeRotationMode();
  }
  float pos[] = {drone.pos[0],drone.pos[1], drone.pos[2]};
  gui.draw(drone.popWindow, pos);
  //hitDetect();
  
}

void mousePressed()
{
  //droneManager.mousePressed(mouseX, mouseY);
  //gui.mousePressed(mouseX, mouseY, cam);
 
  int x3d = int(screenX(drone.pos[0], drone.pos[1], drone.pos[2]));
  int y3d = int(screenY(drone.pos[0], drone.pos[1], drone.pos[2]));
  if((mouseX<= (x3d +100) && mouseX >=(x3d -100)) && (mouseY <= (y3d +100) && mouseY >= (y3d-100)))
  {
    drone.selected = true;
  }
  drone.mousePressed(mouseX, mouseY, cam);
  
}

void controlEvent(ControlEvent theEvent) 
{
  gui.controlEvent(theEvent);
}
 

  

/*
void hitDetect() { 
  // mouse hit detection using screnX, screenY 
  
  vertexMouseOver = -1; 
  
 
    int x = int(screenX(vertices3D[0], vertices3D[1], vertices3D[2])); 
    int y = int(screenY(vertices3D[0], vertices3D[1], vertices3D[2])); 
    
    vertices2D[0] =  x; 
    vertices2D[1] =  y; 
    
    if (x > mouseX-100 && x < mouseX+100 && y > mouseY-100 && y < mouseY+100) { 
       //vertexMouseOver = i; 
       //println("mouse over this");
        pushMatrix(); 
        translate(vertices3D[0], vertices3D[1], 30); 
        pushStyle(); 
        fill(0,0,0); 
        noStroke(); 
        sphere(40); 
        popStyle(); 
        popMatrix(); 
    } 
   
}*/