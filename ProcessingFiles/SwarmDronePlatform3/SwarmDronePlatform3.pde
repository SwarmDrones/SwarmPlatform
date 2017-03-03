import processing.serial.*;// serial communication
import processing.opengl.*;// graphics
import peasy.*; // camera
PeasyCam cam; //<>//

final int h = 800;
final int w = 1400;

float Dloc[] = {200, 200, 0.0};
float Dloc2[] = {400, 400, 0.0};
float Dori[] = {0.0, 0.0, 0.0};
float DoriGain[] = {1.0, 1.0, 1.0};
float DposGain[] = {1.0, 1.0, 1.0};
//GUI gui;
Drone drone1;
Drone drone2;
DroneManager dm;
void setup()
{
  size(1400, 800,OPENGL);
  frameRate(60);
  //////////////////////////////////// drone setup////////////////////////////////
  dm = new DroneManager(3, this);
  //drone1 = new Drone("drone111", Dloc, Dori, DoriGain, DposGain);
  //drone2 = new Drone("drone222", Dloc2, Dori, DoriGain, DposGain);
  //dm.addDrone(drone1);
  //dm.addDrone(drone2);
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
  dm.draw();
  dm.checkDrones(); //<>//
  
}

void mousePressed()
{
  
  dm.mousePressed(mouseX, mouseY, cam);
  
  
}

void controlEvent(ControlEvent theEvent) 
{
  dm.controlEvent(theEvent);
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