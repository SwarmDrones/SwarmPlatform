

class DroneManager
{
  Drone []drones;
  int capacity;
  int filled;
  
  DroneManager(int cap)
  {
    filled = 0;
    capacity = cap;
    drones = new Drone[3];
  }
  void addDrone(Drone d)
  {
    if(filled < capacity)
    {
      filled++;
      drones[filled] = d;
    }
  }
  // this will output to each drone via serial if values for PID are set by users
  void checkDrones()
  {
    
  }
}