

//Constants & Global Variables
char a = 'b'; //this is the character used to receive incoming serial commands from MATLAB; initialize to anything but 'a'
const int BUZZER=3;
const int GSR=A2;
int threshold=0;
int sensorValue;


//--------------------------------------------------------------------------------------
//Start of Primary Functions, such as setup() and loop()
//--------------------------------------------------------------------------------------

void setup()
{
  long sum=0;

  //open serial
  Serial.begin(9600); //According to Table 20-7 in the ATmega328 datasheet, pg. 193, the max. synchronous (U2Xn=0) serial baud rate that an Arduino (w/16MHz clock) can do is 1Mbps
  pinMode(BUZZER,OUTPUT);
  digitalWrite(BUZZER,LOW);
  delay(1000);
  
  //First, send a single 'a' character to MATLAB
  //Serial.write('a');//send character via serial port to MATLAB, to begin verification of connectivity; I choose not to use Serial.println() here because it adds a 
  //carriage return character (ASCII 13, or '\r') and a newline character (ASCII 10, or '\n') to the end of the data, which I don't want.
  //See reference page on Serial.println() for details.
  //while(a!='a'){ //keep looping until the Arduino receives an 'a' back from MATLAB; once an 'a' is received, continue on
    //a = Serial.read(); //read a single byte from Arduino's hardware serial buffer; note: if nothing is in the buffer, this will return -1
  //}  

}


void loop(){
    


  a = Serial.read(); //read a single byte from Arduino's hardware serial buffer; note: if nothing is in the buffer, this will return -1
  if (a=='R') //if this is true, it means MATLAB has just sent a request for a data packet!
  {   
    sensorValue=analogRead(GSR); 
    Serial.println(sensorValue);
      

  } //end of if (a=='R') statement
  
  
} //end of loop() function








