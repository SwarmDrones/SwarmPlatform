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
      String portName = Serial.list()[8]; //change the 0 to a 1 or 2 etc. to match your port
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
          mIn = rx_headerInter(mIn, mIn.length());
        }
        if(mIn.length() > 0)
        {
            if(verifyIncoming(mIn) == true)
            {
                mIn = rx_headerInter(mIn, mIn.length());
                msgInFlag = true;
                print("incoming message: ");
                println(mIn);
            }
        }
        
    }

  /**
     @brief : varifies that the full package was recieved
    */
    private boolean verifyIncoming(String header)
    {
        
        
        byte sum = byte(0x00);
        byte checking[] = new byte[header.length()-3];
        for(int i = 0; i < (header.length()-3); i++)
        {
                checking[i] = (byte)header.charAt(i+2);
        }
        sum = chksum8(checking, header.length()-3);
        byte checksum = byte(0xFF - sum);
        if(header.charAt(header.length()-1)== (checksum))
        {
            return true;
            //Serial.println("true message");
        }
        else 
        {
            msgInFlag = false;
            println("false message");
            return false;
        }
    }

  private byte[] tx_headerGen(String destinationAddress, String message, int sizet)
  { 
      int nBytes = (17 + sizet + 1);
      byte[] header = new byte[nBytes] ;
      //start delimeter
      header[0] = (byte)(0x7E);
      
      // size of meassage is in two bytes
      header[1] = (byte)(((nBytes-4) >> 8) & 0xFF);
      header[2] = (byte)((nBytes-4) & 0xFF);
      
      // frame type and id
      header[3] = (byte)(0x10);
      header[4] = (byte)(0x01);

      // destination address
      for(int i = 0; i < 8; i++)
      {
          header[5+i] =(byte)(destinationAddress.charAt(i)); 
      }
      header[13]= (byte)(0xFF);
      header[14]= (byte)(0xFE);

      //options
      header[15]= (byte)(0x00);
      header[16]= (byte)(0x00);

      //message
      for(int i = 0; i < sizet; i++)
      {
          header[17+i] = (byte)message.charAt(i);
          
      }

      // checksum where sum is from frame type to end of rfdata
      byte sum = byte(0x00);
      byte[] checking = new byte[14+sizet];
      for(int i = 3; i < (17+sizet); i++)
      {
            checking[i-3] = header[i];
      }
      sum = chksum8(checking, 14 + sizet);
      byte checksum = (byte)(0xFF-sum);
      header[17+sizet]= (checksum);
            
      return header;        

  }



  private String rx_headerInter(String rx_message, int sizet)
  {
      println("incoming: "+rx_message);
      for(int i = 0; i< rx_message.length(); i++)
      {
        print(hex(byte(rx_message.charAt(i))));
        print(" ");
      }
      println("");
          
      final int dataLen = sizet - 13;// length of data in message
      final int addLen = 5; // length of address
      //int totalLen = (dataLen + addLen +1);
  
      String out = "";
  
      // parsing the address portion in the header
      
      for(int i = 0; i < addLen; i++)
      {
              out+= rx_message.charAt(i+4);
      }
      
      print("out address: ");
      
      println(out);
      
      out += ':';   //out[addLen] = ':';
      // parsing the data portion of the header
      String data = ""; 
      for(int i = 0; i < dataLen-1; i++)
      {
              out+= rx_message.charAt(i+10);//out[i + addLen] = rx_message[i+16];
              data += rx_message.charAt(i+10);
      }
      println("data In: " + data);
      //int total = dataLen + addLen;
      //println(out);
      return out;
      
  }
  private byte chksum8( byte[] buff, int len)
  {
      byte sum = byte(0);       // nothing gained in using smaller types!
      for ( int i = 0; i < len; i++)
      {
        sum += buff[i];
      }
             
     return (byte)sum;
   }
   
   public void output2Drone(String droneId, String subject, String value)
   {
     String data = subject;
     data += ":";
     data += value;
     byte header[] = tx_headerGen(droneId, data, data.length());
     print(droneId + ": ");
     for(int i = 0; i < header.length; i++)
     {
       print(hex(header[i]));
       print(" ");
     }
     println("");
     // @todo: somehow send it to serial here.
     
   }
}