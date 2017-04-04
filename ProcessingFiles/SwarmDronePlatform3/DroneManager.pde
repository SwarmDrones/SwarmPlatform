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
    drones = new Drone[cap];
    dGUI = new GUI[cap]; //<>//
    comm = new Comm(parent);
  }
  void addDrone(Drone d)
  {
    println("Added Drone: " + filled);
    if(filled < capacity)
    {
      dGUI[filled] = new GUI(parent);
      dGUI[filled].valChanged = false;
      drones[filled] = d;
      filled++;
    }
  }
  // this will output to each drone via serial if values for PID are set by users
  void checkDrones()
  {
    // see if any drones needs new PID values
    for(int i = 0; i < filled; i++)
    {
      
      if(dGUI[i].valChanged == true)
      {
        println("checked gui:" + i);
        String out = dGUI[i].getCommStuff();
        comm.output2Drone(drones[i].id, "", out);
      }
    }
    
    comm.updateRXMsg(); //<>//
    // see if any new drone orientation and position values came in.
    if(comm.msgInFlag == true)
    {
      final int addSize = 5;
      String header = comm.getMsgIn();
      println("incoming: " + header);
      
      // getting the drone id
      int droneIdIdx = 0;
      for(int i = 0; i < header.length(); i++)
      {
        if(header.charAt(i) == ':')
        {
          droneIdIdx = i;
          break;
        }
      }
      String droneId = header.substring(0, droneIdIdx);
      println("drone id is: " + droneId);
      
      // getting the subject of message
      int subIdx = 0;
      for(int i = droneIdIdx+1; i < header.length(); i++)
      {
        if(header.charAt(i) == ':')
        {
          subIdx = i;
          break;
        }
      }
      String subject = header.substring(droneIdIdx+2, subIdx); //<>//
      println("subject is: " + subject);
      subIdx++;
      // gettingt the values
      String values = header.substring(subIdx);
      println("values are: " + values);
      String []vals = split(values, ' ');
      // check if a new drone needs to be added
      boolean check = false;
      for(int i = 0; i < filled; i++)
      {
        //println("checking if drone exist:" + drones[i].id + "==" + droneId);
        String edId = drones[i].id;
        if(edId.equals(droneId) == true)
        {
          //println("checks out fine");
          check = true;
        }
      }
      if(!check)
      {
         // add a new drone
         float []zeros = {0.00, 0.00, 0.00};
         Drone dtemp = new Drone(droneId, zeros, zeros, zeros, zeros);
         addDrone(dtemp);
      }
      
      // change the values for the drone according to incoming message.
      if(subject.equals("Orientation") == true)
      {
        println("recieved " + subject);
        int droneIdx = -1;
        for(int i = 0; i < filled; i++)
        {
          String edId = drones[i].id;
          if(edId.equals(droneId) == true)
          {
             droneIdx = i; 
          }
        }
        for(int i = 0; i < 3; i++)
        {
          drones[droneIdx].ori[i] = float(vals[i]); 
        }
        
      }
      else if(subject.equals("Location") == true)
      {
        println("recieved " + subject);
        int droneIdx = -1;
        for(int i = 0; i < filled; i++)
        {
          String edId = drones[i].id;
          if(edId.equals(droneId) == true)
          {
             droneIdx = i; 
          }
        }
        for(int i = 0; i < 3; i++)
        {
          drones[droneIdx].pos[i] = float(vals[i])/10; 
        }
        
      }
    }
    
  }
  void mousePressed(int x, int y,PeasyCam cam)
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
    for(int i = 0; i < filled; i++)
    {
       drones[i].mousePressed(x, y, cam); 
    }
  }
  void draw()
  {
    for(int i = 0; i < filled; i++)
    {
       drones[i].display();
       if(drones[i].popWindow == true)
       {
          cam.setRollRotationMode();
          //cam.setRotations(0,0,0);
       }
       else
       {
         cam.setFreeRotationMode();
       }
       float pos[] = {drones[i].pos[0], drones[i].pos[1], drones[i].pos[2]};
       boolean show = drones[i].popWindow && drones[i].selected;
       dGUI[i].draw(show, pos);
    }
    
  }
  void controlEvent(ControlEvent theEvent) 
  {
    for(int i = 0; i < filled; i++)
    {
       dGUI[i].controlEvent(theEvent); 
    }
  }
}