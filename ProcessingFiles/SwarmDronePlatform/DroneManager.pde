class DroneManager
{
  Drone []drones;
  GUI []dGUI;
  Comm comm;
  int capacity;
  int filled;
  PApplet parent;
  
  DroneManager(int cap,  PApplet _parent)
  {
    filled = 0;
    capacity = cap;
    parent = _parent;
    drones = new Drone[3];
    dGUI = new GUI[3];
    comm = new Comm(parent);
  }
  void addDrone(Drone d)
  {
    if(filled < capacity)
    {
      dGUI[filled] = new GUI(parent);
      drones[filled] = d;
      filled++;
    }
  }
  // this will output to each drone via serial if values for PID are set by users
  void checkDrones()
  {
    for(int i = 0; i < filled; i++)
    {
      if(dGUI[i].valChanged)
      {
        String out = dGUI[i].getCommStuff();
        comm.output2Drone(drones[i].id, "PID", out);
      }
    }
  }
  void mousePressed(int x, int y)
  {
    int indx = 0;
    boolean newSelect = false;
    for(int i = 0; i < filled; i++)
    {
      indx = i;
      int x3d = int(screenX(drones[i].pos[0], drones[i].pos[1], drones[i].pos[2]));
      int y3d = int(screenY(drones[i].pos[0], drones[i].pos[1], drones[i].pos[2]));
      if((x<= (x3d +100) && x >=(x3d -100)) && (y <= (y3d +100) && y >= (y3d-100)))
      {
        drones[i].selected = true;
        newSelect = true;
        break;
      }
    }
    if(newSelect == true)
    {
      for(int i = 0; i < filled; i++)
      {
        drones[i].selected = false;
      }
      drones[indx].selected = true;
    }
    
    
  }
}