#include <Arduino.h>
#include <WiFi.h> //import for wifi functionality
#include <WebSocketsServer.h> //import for websocket
#include <vector>

#define UP 1
#define DOWN 2
#define LEFT 3
#define RIGHT 4
#define STOP 0
#define FRONT_RIGHT_MOTOR 0
#define BACK_RIGHT_MOTOR 1
#define FRONT_LEFT_MOTOR 2
#define BACK_LEFT_MOTOR 3

#define FORWARD 1
#define BACKWARD -1

struct MOTOR_PINS
{
  int pinIN1;
  int pinIN2;    
};

std::vector<MOTOR_PINS> motorPins = 
{
  {16, 17},  //FRONT_RIGHT_MOTOR
  {18, 19},  //BACK_RIGHT_MOTOR
  {27, 26},  //FRONT_LEFT_MOTOR
  {25, 33},  //BACK_LEFT_MOTOR   
};


const char *ssid =  "ESP32 APP";   //Wifi SSID (Name)   
const char *pass =  "12345678"; //wifi password

WebSocketsServer webSocket = WebSocketsServer(81); //websocket init with port 81

void rotateMotor(int motorNumber, int motorDirection)
{
  if (motorDirection == FORWARD)
  { 
    Serial.println("forward motion pins: " + String(motorPins[motorNumber].pinIN1) + ", " + String(motorPins[motorNumber].pinIN2));

    digitalWrite(motorPins[motorNumber].pinIN1, HIGH);
    digitalWrite(motorPins[motorNumber].pinIN2, LOW);    
  }
  else if (motorDirection == BACKWARD)
  { 
    Serial.println("backward motion pins: " + String(motorPins[motorNumber].pinIN1) + ", " + String(motorPins[motorNumber].pinIN2));

    digitalWrite(motorPins[motorNumber].pinIN1, LOW);
    digitalWrite(motorPins[motorNumber].pinIN2, HIGH);     
  }
  else
  {
    Serial.println("stopped pins: " + String(motorPins[motorNumber].pinIN1) + ", " + String(motorPins[motorNumber].pinIN2));
    digitalWrite(motorPins[motorNumber].pinIN1, LOW);
    digitalWrite(motorPins[motorNumber].pinIN2, LOW);       
  }
}
void processCarMovement(String inputValue)
{
  switch(inputValue.toInt())
  {

    case UP:
      rotateMotor(FRONT_RIGHT_MOTOR, FORWARD);
      rotateMotor(FRONT_LEFT_MOTOR, FORWARD);
      break;
  
    case DOWN:
      rotateMotor(FRONT_RIGHT_MOTOR, BACKWARD);
      rotateMotor(FRONT_LEFT_MOTOR, BACKWARD);
      break;
  
    case LEFT:
      rotateMotor(FRONT_RIGHT_MOTOR, FORWARD);
      rotateMotor(FRONT_LEFT_MOTOR, BACKWARD);
      break;
  
    case RIGHT:
      rotateMotor(FRONT_RIGHT_MOTOR, BACKWARD);
      rotateMotor(FRONT_LEFT_MOTOR, FORWARD);
      break;
  
    case STOP:
      rotateMotor(FRONT_RIGHT_MOTOR, STOP);
      rotateMotor(FRONT_LEFT_MOTOR, STOP);
      break;
  
    default:
      rotateMotor(FRONT_RIGHT_MOTOR, STOP);
      rotateMotor(FRONT_LEFT_MOTOR, STOP);
      break;
  }
}
void setUpPinModes()
{
  Serial.println("Setting up pin modes...");

  for (int i = 0; i < motorPins.size(); i++)
  {
    Serial.println("Setting up motor " + String(i) + " pins: " + String(motorPins[i].pinIN1) + ", " + String(motorPins[i].pinIN2));

    pinMode(motorPins[i].pinIN1, OUTPUT);
    pinMode(motorPins[i].pinIN2, OUTPUT);  
    rotateMotor(i, STOP);
  }
}


void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
    String cmd = "";
    switch(type) {
        case WStype_DISCONNECTED:
            Serial.println("Websocket is disconnected");
            //case when Websocket is disconnected
            break;
        case WStype_CONNECTED:{
            //wcase when websocket is connected
            Serial.println("Websocket is connected");
            Serial.println(webSocket.remoteIP(num).toString());
            webSocket.sendTXT(num, "connected");}
            break;
        case WStype_TEXT:
            cmd = "";
            for(int i = 0; i < length; i++) {
                cmd = cmd + (char) payload[i]; 
            } //merging payload to single string
            Serial.println(cmd);
            processCarMovement(cmd);

            webSocket.sendTXT(num, cmd+":success");
            break;
        case WStype_FRAGMENT_TEXT_START:
            break;
        case WStype_FRAGMENT_BIN_START:
            break;
        case WStype_BIN:
            break;
        default:
            break;
    }
}

void setup() {
   setUpPinModes();
   


   
   Serial.begin(9600); //serial start

   Serial.println("Connecting to wifi");
   
   IPAddress apIP(192, 168, 0, 1);   //Static IP for wifi gateway
   WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
   WiFi.softAP(ssid, pass); //turn on WIFI

   webSocket.begin(); //websocket Begin
   webSocket.onEvent(webSocketEvent); //set Event for websocket
   Serial.println("Websocket Started");
}

void loop() {
   webSocket.loop();
  //  rotateMotor(FRONT_RIGHT_MOTOR, STOP);
  //  rotateMotor(FRONT_LEFT_MOTOR, STOP);
}