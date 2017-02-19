import processing.serial.*;// serial communication
import processing.opengl.*;// graphics
import peasy.*; // camera
import controlP5.*;
ControlP5 cp5;
PeasyCam cam;


// arrays hold the vertices of 3d object 
float vertices3D[] = {0,0,0}; 
int vertices2D[] = {0,0,0}; 

// index of current mouseover / clicked vertex 
int vertexMouseOver = -1; 
int vertexKlicked= -1; 

// z value in model/world space of current vertex 
float zModelMouseOver; 
float zModelKlick; 

final int h = 800;
final int w = 1400;

float Dloc[] = {200, 200, 0.0};
float Dori[] = {0.0, 0.0, 0.0};
float DoriGain[] = {1.0, 1.0, 1.0};
float DposGain[] = {1.0, 1.0, 1.0};

Drone drone;
DroneManager dm;
void setup()
{
  size(1400, 800,OPENGL);
  frameRate(60);
  //////////////////////////////////// Serial setup////////////////////////////////
  
  //////////////////////////////////// interface setup////////////////////////////////
  cp5 = new ControlP5(this);
  cp5.setPosition(0,0,0);
  //////////////////////////////////// drone setup////////////////////////////////
  dm = new DroneManager(3);
  drone = new Drone(Dloc, Dori, DoriGain, DposGain, cp5);
  dm.addDrone(drone);
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
  for(int i = 0; i < 3; i++)
  {
     vertices3D[i] = drone.pos[0]; 
  }
  
  background(255,255,255);
  drone.display(cam);
  if(drone.popWindow == true)
  {
    cam.setRollRotationMode(); //<>//
    //cam.setRotations(0,0,0);
  }
  else
  {
    cam.setFreeRotationMode();
  }
  hitDetect();
  
}

void mousePressed()
{
  cam.beginHUD();
  drone.mousePressed(mouseX, mouseY, cam);
  cam.endHUD();
}

void hitDetect() { 
  // mouse hit detection using screnX, screenY 
  
  vertexMouseOver = -1; 
  
 
    int x = int(screenX(vertices3D[0], vertices3D[1], vertices3D[2])); 
    int y = int(screenY(vertices3D[0], vertices3D[1], vertices3D[2])); 
    
    vertices2D[0] =  x; 
    vertices2D[1] =  y; 
    
    if (x > mouseX-100 && x < mouseX+100 && y > mouseY-100 && y < mouseY+100) { 
       //vertexMouseOver = i; 
       println("mouse over this");
        pushMatrix(); 
        translate(vertices3D[0], vertices3D[1], 30); 
        pushStyle(); 
        fill(0,0,0); 
        noStroke(); 
        sphere(40); 
        popStyle(); 
        popMatrix(); 
    } 
   
}