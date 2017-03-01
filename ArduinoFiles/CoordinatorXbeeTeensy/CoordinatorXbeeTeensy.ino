#include <Wire.h>

#include <DroneCom.h>


DroneCom comm;

String mInX = "";
String mOutX = "";

String mInP = "";
String mOutP = "";

bool rxX = false;
bool txX = false;

bool rxP = false;
bool txP = false;

void setup()
{
  comm.init();
}

void loop()
{
  mInX = "";// messages comm
  mOutX = "";

  mInP = ""; 
  mOutP = "";
  ////////////////////////////////// XBEE COMMUNICATION PORTION //////////////////////////////
  // recieve messages from Processing
  while(Serial.available())
  {
    mInP += Serial.readString();
    rxP = true;
  }
  // recieving messages from xbee
  comm.updateRXMsg();
  if(comm.checkInFlag())
  {
    
      mInX = comm.getMessage();
      
      rxX = true;
    
  }

  // check if recieved from xbee
  if(rxX)
  {
    txP = true;
    rxX = false;
  }
  // send out to processing if messaged recieved from xbee
  if(txP)
  {
    txP = false;
    mOutP = mInX;// comm.incoming2Processing(mInX);
    Serial.println(mOutP);
    /*char buf[mOutP.length()];
    mOutP.toCharArray(buf, mOutP.length());//getBytes(buf, sizet);
    Serial.print("incoming RX:");
    for(int i = 0; i < mOutP.length(); i++)
    {
        Serial.print(buf[i], HEX);
        Serial.print(" ");
    }*/
  }
  // check if recieved from processing 
  if(rxP)
  {
    rxP = false;
    txX = true; 
  }
  // send out to Xbee if messaged recieved from Processing
  if(txX)
  {
    txX = false;
    mOutX = mInP;
    comm.transmit2Drone(mOutX);
    
  }

  
  /////////////////////////////////////// END ////////////////////////////////////////////////
  //Wait to reduce serial load
  delay(5);
}
