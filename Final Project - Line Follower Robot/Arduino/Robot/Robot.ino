const int warningLed = 13;
const int leftSensor = A1;
const int rightSensor = A0;
const int centerSensor = A2;
const int leftMotor = 3;
const int rightMotor = 5;
const int leftMotor2 = 2;
const int rightMotor2 = 4;
const int modeButton = 7;

int threshold = 600;
int leftMotorValue = 0;
int rightMotorValue = 0;
int leftMotorValue2 = 0;
int rightMotorValue2 = 0;

enum st{
  None,
  Calibrating,
  Stopped,
  Forward,
  TurnRight,
  TurnLeft,
  Reversed 
  };
  
st status;

void setup() {
  Serial.begin(9600);
  status = Calibrating;
  pinMode(warningLed, OUTPUT);
  pinMode(leftMotor2, OUTPUT);
  pinMode(rightMotor2, OUTPUT);
  pinMode(modeButton, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(modeButton), changeMode, FALLING);
  
//  digitalWrite(leftMotor2, 0);
//  digitalWrite(rightMotor2, 0);
//  analogWrite(leftMotor, 255);
//  analogWrite(rightMotor, 255);
}

bool checkSensors(){ 
  Serial.print("Left  Sensor: ");
  Serial.println(analogRead(leftSensor));
  Serial.print("Right Sensor: ");
  Serial.println(analogRead(rightSensor));
  if(analogRead(leftSensor) >= threshold && analogRead(rightSensor) >= threshold){
    status = Forward;
  }
  else if (analogRead(leftSensor) <= threshold && analogRead(rightSensor) >= threshold){
    status = TurnLeft;
    }
  else if (analogRead(leftSensor) >= threshold && analogRead(rightSensor) <= threshold){
    status = TurnRight;
    }else if (analogRead(leftSensor) < threshold && analogRead(rightSensor) < threshold){
      status = Stopped;
      }
    fixDirection();
}

void fixDirection(){
//  Serial.println(status);
  switch(status){
    case Forward: 
    Serial.println("Forward");
    leftMotorValue = 255;
    rightMotorValue = 255;
    leftMotorValue2 = LOW;
    rightMotorValue2 = LOW;
    break;
    case TurnLeft:
    
  Serial.println("Left");
    rightMotorValue = 200;
    leftMotorValue = 0;
    leftMotorValue2 = LOW;
    rightMotorValue2 = LOW;
    break;
    case TurnRight:
    
  Serial.println("Right");
    rightMotorValue = 0;
    leftMotorValue = 200;
    leftMotorValue2 = LOW;
    rightMotorValue2 = LOW;
    break;
    case Stopped:
  Serial.println("Stopped");
    rightMotorValue = 0;
    leftMotorValue = 0;
    leftMotorValue2 = LOW;
    rightMotorValue2 = LOW;
    break;
    case Reversed:
    rightMotorValue = 0;
    leftMotorValue = 0;
    leftMotorValue2 = HIGH;
    rightMotorValue2 = HIGH;
    break;
    case Calibrating:
    threshold = analogRead(leftSensor)+ 100;
    break;
    //case None:
//    digitalWrite(warningLed, HIGH);
    //break;
  }
  Serial.println("-------------");
  analogWrite(leftMotor, leftMotorValue);
  analogWrite(rightMotor, rightMotorValue);
  digitalWrite(leftMotor2, leftMotorValue2);
  digitalWrite(rightMotor2, rightMotorValue2);
}

void changeMode(){
  if (status == Calibrating)
     status = Forward;
   else {
    delay(1000);
    status = Calibrating;
   }
}

void calibrate(){
  threshold = analogRead(leftSensor)+ 50;
}

void loop() {
//  if (status != Calibrating)
//delay(1000);

      checkSensors();
//  else calibrate();
  //delay(10);
}
