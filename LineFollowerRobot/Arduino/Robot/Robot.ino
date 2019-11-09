const int warningLed = 13;
const int leftSensor = A0;
const int rightSensor = A1;
const int centerSensor = A2;
const int leftMotor = 3;
const int rightMotor = 5;
const int leftMotor2 = 2;
const int rightMotor2 = 4;

int threshold = 800;
int leftMotorValue = 0;
int rightMotorValue = 0;
int leftMotorValue2 = 0;
int rightMotorValue2 = 0;

enum st{
  None,
  calibrating,
  Stopped,
  Straight,
  TurnRight,
  TurnLeft,
  Reversed 
  };

  
st status;

void setup() {
  Serial.begin(9600);
  status = None;
  pinMode(warningLed, OUTPUT);
  pinMode(leftMotor2, OUTPUT);
  pinMode(rightMotor2, OUTPUT);
}

bool checkSensors(){ 
  Serial.println(analogRead(leftSensor));
  Serial.println(analogRead(rightSensor));
  Serial.println("-------------");
  if(analogRead(leftSensor) > threshold && analogRead(rightSensor) > threshold){
    status = Straight;
  }
  else if (analogRead(leftSensor) < threshold && analogRead(rightSensor) > threshold){
    status = TurnLeft;
    }
  else if (analogRead(leftSensor) > threshold && analogRead(rightSensor) > threshold){
    status = TurnRight;
    }else {
      status = None;
      }
    fixDirection();
}

void fixDirection(){
  Serial.println(status);
  switch(status){
    case Straight:
    leftMotorValue = 255;
    rightMotorValue = 255;
    leftMotorValue2 = LOW;
    rightMotorValue2 = LOW;
    break;
    case TurnLeft:
    rightMotorValue = 200;
    leftMotorValue = 0;
    leftMotorValue2 = LOW;
    rightMotorValue2 = LOW;
    break;
    case TurnRight:
    rightMotorValue = 0;
    leftMotorValue = 200;
    leftMotorValue2 = LOW;
    rightMotorValue2 = LOW;
    break;
    case Stopped:
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
    //case None:
//    digitalWrite(warningLed, HIGH);
    //break;
  }
  analogWrite(leftMotor, leftMotorValue);
  analogWrite(rightMotor, rightMotorValue);
  digitalWrite(leftMotor2, leftMotorValue2);
  digitalWrite(rightMotor2, rightMotorValue2);
}

void loop() {
  checkSensors();
}
