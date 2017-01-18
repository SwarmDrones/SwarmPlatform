#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>
#include <DroneCom.h>
#include <PX4.h>

#define PARAM_FOCAL_LENGTH_MM 16
#define BNO055_SAMPLERATE_DELAY_MS (100)
Adafruit_BNO055 bno = Adafruit_BNO055(55);

bool FirstRunBNO = false; // reset droll, dpitch, dyaw, values
bool FirstRunADNS = false; // reset d*_cam values
bool FirstRunL = false; // reset d*_cm, d*_in values


double ct = 0.00;
double pt = 0.00;
double dt = 0.00;

double roll = 0.00, pitch = 0.00, yaw = 0.00;
double droll = 0.00, dpitch = 0.00, dyaw = 0.00;
double proll = 0.00, ppitch = 0.00, pyaw = 0.00;
double x_cm = 0.00, y_cm = 0.00;    // 

double x_in = 0.00, y_in = 0.00;
double ix_in = 0.00, iy_in = 0.00;

// for motion flow cam
/*int32_t x_cam = 0.00;
int32_t y_cam = 0.00;
double x_cam_comp = 0.00;
double y_cam_comp = 0.00;
int8_t dx_cam = 0.00;
int8_t dy_cam = 0.00;
int8_t quality = 0.00;*/

PX4 px4;
int px = 0;
int py = 0;
double x_rate;
double y_rate;
double flow_x;
double flow_y;
  
float focal_length_px = (PARAM_FOCAL_LENGTH_MM) / (4.0f * 6.0f) * 1000.0f;


/*
 *  FULL RUNNING LOOP TO BE CALLED IN VOID LOOP()
 *  Calibration of variables function called in void setup()
 */
void fullRun();
void partRun();

/*
 *  BNO055 IMU functions
 */



void setup()
{                   
                                  
  Serial.begin(115200);
  Serial.println("Orientation Sensor Test"); Serial.println("");
  /******************************************************************************
   * THE IMU SENSOR SETUP
   *****************************************************************************/
  if(!bno.begin())
  {
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }
  delay(1000);
  sensor_t sensor;
  bno.getSensor(&sensor);
  /******************************************************************************
   * THE OPTICAL FLOW SENSOR SETUP
   *****************************************************************************/
  

  /*
   * Run the function once to make sure it starts at zero position
   */
   Serial.println("Calibrating initical conditions");
   partRun();
   Serial.println("Initial conditions set");
  
  
}

void loop()
{
  fullRun();
}
void partRun()
{
  sensors_event_t event;
  bno.getEvent(&event);
  
  // calculating change in time since last loop
  pt = ct;
  ct = millis();
  dt = ct-pt;

  // calculating change in angles since last loop
  proll = roll;
  ppitch = pitch;
  pyaw = yaw;
  roll = event.orientation.z;
  pitch = event.orientation.y;
  yaw = event.orientation.x;
  droll = roll - proll;
  dpitch = pitch - ppitch;
  dyaw = yaw - pyaw;


  //x_cam_comp = x_cam + ix_cm;
  //x_cam_comp = x_cam + ix_cm;
  //x_cam += dx_cam;
/*
  x_cam = 0.00;
  y_cam = 0.00;
  x_cam_comp = 0.00;
  y_cam_comp = 0.00;
  dx_cam = 0.00;
  dy_cam = 0.00;
  sonar.ix_cm = 0.00;
  sonar.iy_cm = 0.00;
 */
  droll = 0.00;
  dpitch = 0.00;
  dyaw = 0.00;
  
}
void fullRun()
{
  /* Get a new sensor event */
  sensors_event_t event;
  bno.getEvent(&event);
  
  // calculating change in time since last loop
  pt = ct;
  ct = millis();
  dt = ct-pt;

  // calculating change in angles since last loop
  proll = roll;
  ppitch = pitch;
  pyaw = yaw;
  roll = event.orientation.z;
  pitch = event.orientation.y;
  yaw = event.orientation.x;
  droll = roll - proll;
  dpitch = pitch - ppitch;
  dyaw = yaw - pyaw;

  // Fetch I2C data  
  px4.update_integral();
  x_rate = px4.gyro_x_rate_integral() / 10.0f;       // mrad
  y_rate = px4.gyro_y_rate_integral() / 10.0f;       // mrad
  flow_x = px4.pixel_flow_x_integral() / 10.0f;      // mrad
  flow_y = px4.pixel_flow_y_integral() / 10.0f;      // mrad  
  
  int timespan = px4.integration_timespan();               // microseconds
  int ground_distance = px4.ground_distance_integral();    // mm
  int quality = px4.quality_integral();
  
  if (quality > 100)
  {
    // Update flow rate with gyro rate
    float pixel_x = flow_x + x_rate; // mrad
    float pixel_y = flow_y + y_rate; // mrad
    
    // Scale based on ground distance and compute speed
    // (flow/1000) * (ground_distance/1000) / (timespan/1000000)
    float velocity_x = pixel_x * ground_distance / timespan;     // m/s
    float velocity_y = pixel_y * ground_distance / timespan;     // m/s 
    
    // Integrate velocity to get pose estimate
    px = px + velocity_x * 100;
    py = py + velocity_y * 100;
  }
  
  // output drone location
  printLocation(px4.quality_integral(), px, py, ground_distance);
  // ouput drone orientation
  printOrientation(roll, pitch, yaw);
}







