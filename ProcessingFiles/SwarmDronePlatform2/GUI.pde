import controlP5.*;
/**
 * TODO : create portion of interface that would allow user to set destination for drone
 *        - this can be done by adding a button that would allow user to click somewhere on the screen so that user can then choose a new location.
          - A second buttont to allow user to cancel destination setter.
*/
class GUI
{
  ControlP5 cp;
  int nDrones;
  String selectedName;
  int selectedAxis;
  
  float[][] pidTilt;
  float[][] pidPos;
  float[] pidTiltMinMax;
  float[] pidPosMinMax;
  float[] loc;
  float[] ori;
  final int numAxis = 3;
  final int numConsts = 3;
  
  boolean popWindow;
  boolean valChanged;
  String forComm;
  GUI(PApplet parent)// this will only work for one drone
  {
    popWindow = false;
    valChanged = false;
    pidTilt = new float[numAxis][numConsts];
    pidPos = new float[numAxis][numConsts];
    pidTiltMinMax = new float[2];
    pidPosMinMax = new float[2];
    pidTiltMinMax[0] = 0.0; pidTiltMinMax[1] = 100.0;
    pidPosMinMax[0] = 0.0; pidPosMinMax[1] = 100.0;
    
    loc = new float[3];
    ori = new float[3];
    
    cp = new ControlP5(parent);
    init();
    
  }
  void gui() 
  {
    
    hint(DISABLE_DEPTH_TEST);
    cam.beginHUD();
    //cp.setPosition(int(loc[0]), int(loc[1]));
    cp.draw();
    cam.endHUD();
    hint(ENABLE_DEPTH_TEST);
  }
  
  void draw(boolean show, float pos[])
  {
    updateGui(show, pos);
    gui();
  }
  void updateGui(boolean show, float pos[])
  {
    popWindow = show;
    if(popWindow == true)
    {
      cp.show();
      cam.setRotations(0,0,0);
    }
    else
    {
      //println("object pressed to hide");
      cp.hide();
    }
    updateLoc(pos); 
  }
  void updateLoc(float pos[])
  {
    for(int i = 0; i < 3; i++)
    {
      loc[i] = pos[i];
    }
    
  }
  
  void mousePressed(int x, int y, PeasyCam cam)
  {
    /*println(x + ", " + y + "\t:\t" + loc[0] + "," + loc[1]);
    if((x <= (loc[0]+100) && x >=(loc[0]-100)) && (y <= (loc[1] +100) && y >= (loc[1]-100)))
    {
      popWindow = !popWindow;
      
    }*/
  }
  void init()
  {
    cp.setAutoDraw(false);
    
    cp.addDropdownList("axis")
       .setPosition(0, 10)
       .setItemHeight(19)
       .setBackgroundColor(color(190))
       .addItem("X / Roll", 0)
       .addItem("Y / Pitch", 1)
       .addItem("Z / Yaw", 2)
       .setColorActive(color(255, 128))
       .setColorBackground(color(60));
         
    cp.addSlider("P:orientation")
       .setRange(pidTiltMinMax[0], pidTiltMinMax[1])
       .setValue(10.0)
       .setPosition(130,10)
       .setSize(100, 20);
       
    cp.addSlider("I:orientation")
      .setRange(pidTiltMinMax[0], pidTiltMinMax[1])
      .setValue(10.0)
      .setPosition(250, 10)
      .setSize(100, 20);
      
    cp.addSlider("D:orientation")
        .setRange(pidTiltMinMax[0], pidTiltMinMax[1])
        .setValue(10.0)
        .setPosition(370,10)
        .setSize(100, 20);
    cp.addSlider("P:position")
        .setRange(pidTiltMinMax[0], pidTiltMinMax[1])
        .setValue(10.0)
        .setPosition(130, 40)
        .setSize(100, 19);
    cp.addSlider("I:position")
        .setRange(pidTiltMinMax[0], pidTiltMinMax[1])
        .setValue(10.0)
        .setPosition(250, 40)
        .setSize(100, 19);
    cp.addSlider("D:position")
        .setRange(pidTiltMinMax[0], pidTiltMinMax[1])
        .setValue(10.0)
        .setPosition(370, 40)
        .setSize(100, 19);
    
    cp.addButton("Set Destination")
        .setPosition(500, 10)
        .setSize(80,50);
        
    cp.getController("P:orientation").setCaptionLabel("P :orientation");
    cp.getController("P:orientation").getCaptionLabel().setSize(10);
    cp.getController("P:orientation").getCaptionLabel().getStyle().setMarginLeft(-70);
    
    cp.getController("I:orientation").setCaptionLabel("I :orientation");
    cp.getController("I:orientation").getCaptionLabel().setSize(10);
    cp.getController("I:orientation").getCaptionLabel().getStyle().setMarginLeft(-70);
    
    cp.getController("D:orientation").setCaptionLabel("D :orientation");
    cp.getController("D:orientation").getCaptionLabel().setSize(10);
    cp.getController("D:orientation").getCaptionLabel().getStyle().setMarginLeft(-70);
    
    cp.getController("P:position").setCaptionLabel("P :position");
    cp.getController("P:position").getCaptionLabel().setSize(10);
    cp.getController("P:position").getCaptionLabel().getStyle().setMarginLeft(-70);
    
    cp.getController("I:position").setCaptionLabel("I :position");
    cp.getController("I:position").getCaptionLabel().setSize(10);
    cp.getController("I:position").getCaptionLabel().getStyle().setMarginLeft(-70);
    
    cp.getController("D:position").setCaptionLabel("D :position");
    cp.getController("D:position").getCaptionLabel().setSize(10);
    cp.getController("D:position").getCaptionLabel().getStyle().setMarginLeft(-70);
    
       
  }
  void controlEvent(ControlEvent theEvent) 
  {

    if(theEvent.isController()) 
    {
      //print("this is a controller: ");
      selectedName = theEvent.controller().getName();
      //selectedAxis = int(theEvent.controller().getValue());
      //println(selectedName);
      
      if(selectedName == "axis")
      {
        selectedAxis = int(theEvent.controller().getValue());
         
      }
      else if(selectedName == "P:orientation")
      {
        pidTilt[selectedAxis][0] = theEvent.controller().getValue();
        valChanged = true;
        forComm = str(selectedAxis);
        forComm += selectedName;
        forComm += ":";
        forComm += pidTilt[selectedAxis][1];
      }
      else if(selectedName == "I:orientation")
      {
        pidTilt[selectedAxis][1] = theEvent.controller().getValue();
        valChanged = true;
        forComm = str(selectedAxis);
        forComm += selectedName;
        forComm += ":";
        forComm += pidTilt[selectedAxis][2];
      }
      else if(selectedName == "D:orientation")
      {
        pidTilt[selectedAxis][2] = theEvent.controller().getValue();
        valChanged = true;
        forComm = str(selectedAxis);
        forComm += selectedName;
        forComm += ":";
        forComm += pidTilt[selectedAxis][2];
      }
      else if(selectedName == "P:position")
      {
        pidPos[selectedAxis][0] = theEvent.controller().getValue();
        valChanged = true;
        forComm = str(selectedAxis);
        forComm += selectedName;
        forComm += ":";
        forComm += pidPos[selectedAxis][0];
      }
      else if(selectedName == "I:position")
      {
        pidPos[selectedAxis][1] = theEvent.controller().getValue();
        valChanged = true;
        forComm = str(selectedAxis);
        forComm += selectedName;
        forComm += ":";
        forComm += pidPos[selectedAxis][1];
      }
      else if(selectedName == "D:position")
      {
        pidPos[selectedAxis][2] = theEvent.controller().getValue();
        valChanged = true;
        forComm = str(selectedAxis);
        forComm += selectedName;
        forComm += ":";
        forComm += pidPos[selectedAxis][2];
      }
      else if(selectedName == "Set Destination")
      {
        // TODO : some how change the interface here after botton is pressed.
      } 
    }
  }
  
  String getCommStuff()
  {
    this.valChanged = false;
    return forComm;
  }
}