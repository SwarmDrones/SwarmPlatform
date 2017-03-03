import processing.serial.*;



class Comm
{
  boolean msgInFlag;
  String mIn;
  String mOut;
  byte[] messageOut;
  byte[] messageIn;
  Serial myPort;
  Comm(PApplet parent)
  {
      // setting up the serial port
      for(int i = 0; i < Serial.list().length; i++)
      {
        println(Serial.list()[i]);
      }
      String portName = Serial.list()[3]; //change the 0 to a 1 or 2 etc. to match your port
      myPort = new Serial(parent, portName, 115200);
      msgInFlag = false;
      mIn = "";
      mOut = "";
  }
  
  String getMsgIn()
  {
    msgInFlag = false;
    return mIn;
  }
  
  /**
   @brief : receive incoming messages and parses out the address and message 
  */
  void updateRXMsg()
  {
      mIn = "";
      /*while(Serial1.available())
      {
          mIn += Serial1.readString();
      }
      */
      if(myPort.available() > 0) 
      {  
        mIn = myPort.readStringUntil('\n');         // read it and store it in val
        msgInFlag = true;
        println("incoming message");
      }
      
      
  }
 
 void output2Drone(String droneId, String subject, String value)
 {
   String data = droneId;
   data += subject;
   data += ":";
   data += value;
   myPort.write(data);
 }
}