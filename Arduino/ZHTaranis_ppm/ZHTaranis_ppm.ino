// This sketch will read analgog values from A0-A5 and then generate a PPM signal on the pin of your choice (default 9)
// The output of this sketch has been tested with an Orange RX 2.4GHz that I usually use with a taranis. 
// However I've bypassed the taranis altogether and talk directly to the Tx module. 
//
// TODO: Test  this as a trainer port input
// 



#define CHANNELS 8  //set the number of chanels
#define ZH_DEFAULT_SERVO_MID_VALUE 1500  //set the default servo value
#define ZH_DEFAULT_SERVO_MAX_VALUE 2000  //set the default servo value
#define ZH_DEFAULT_SERVO_MIN_VALUE 1000  //set the default servo value
#define ZH_FRAME_LENGTH 22500  //set the PPM frame length in microseconds (1ms = 1000µs)
#define ZH_PULSE_LENGTH 300  //set the pulse length
#define ZH_STATE_POSITIVE 1  //set polarity of the pulses: 1 is positive, 0 is negative
#define ZH_PPM_OUT_PIN 9  //set PPM signal output pin on the arduino

#define ZH_INPUT_1 "I1"
#define ZH_INPUT_2 "I2"
#define ZH_INPUT_3 "I3"
#define ZH_INPUT_4 "I4"
#define ZH_INPUT_5 "I5"
#define ZH_INPUT_6 "I6"
#define ZH_INPUT_7 "I7"
#define ZH_INPUT_8 "I8"


uint8_t  g_ppmInput[CHANNELS] = {A0, A1, A2, A3, A4, A5, A4, A5}; // Input pins
int g_ppmOutput[CHANNELS];

int g_throttle = ZH_DEFAULT_SERVO_MID_VALUE;
int g_aileron = ZH_DEFAULT_SERVO_MID_VALUE;
int g_elevator = ZH_DEFAULT_SERVO_MID_VALUE;
int g_rudder = ZH_DEFAULT_SERVO_MID_VALUE;
int g_aux1 = ZH_DEFAULT_SERVO_MID_VALUE;
int g_aux2 = ZH_DEFAULT_SERVO_MID_VALUE;
int g_aux3 = ZH_DEFAULT_SERVO_MID_VALUE;
int g_aux4 = ZH_DEFAULT_SERVO_MID_VALUE;

String g_serialString = "";


void setup(){  
  Serial.begin(57600);  
  Serial.flush();
  
  pinMode(ZH_PPM_OUT_PIN, OUTPUT);
  digitalWrite(ZH_PPM_OUT_PIN, !ZH_STATE_POSITIVE);  //set the PPM signal pin to the default state (off)

  // Setup analog inputs
  for (uint8_t i = 0;  i < CHANNELS; ++i) {
    // set up input pins
    pinMode(g_ppmInput[i], INPUT);
    g_ppmOutput[i] = ZH_DEFAULT_SERVO_MID_VALUE;
  }


  
  cli();
  TCCR1A = 0; // set entire TCCR1 register to 0
  TCCR1B = 0;
  
  OCR1A = 100;  // compare match register, change this
  TCCR1B |= (1 << WGM12);  // turn on CTC mode
  TCCR1B |= (1 << CS11);  // 8 prescaler: 0,5 microseconds at 16mhz
  TIMSK1 |= (1 << OCIE1A); // enable timer compare interrupt
  sei();

}

void loop(){

  readSerial();  
  writePPMValues();
  delay(10);
}



//leave this alone
ISR(TIMER1_COMPA_vect){  
  static boolean state = true;
  
  TCNT1 = 0;
  noInterrupts();
  if(state) {  //start pulse
    digitalWrite(ZH_PPM_OUT_PIN, ZH_STATE_POSITIVE);
    OCR1A = ZH_PULSE_LENGTH * 2;
    state = false;
  } else {  //end pulse and calculate when to start the next pulse
    static byte cur_chan_numb;
    static unsigned int calc_rest;
  
    digitalWrite(ZH_PPM_OUT_PIN, !ZH_STATE_POSITIVE);
    state = true;

    if(cur_chan_numb >= CHANNELS){
      cur_chan_numb = 0;
      calc_rest = calc_rest + ZH_PULSE_LENGTH;// 
      OCR1A = (ZH_FRAME_LENGTH - calc_rest) * 2;
      calc_rest = 0;
    }
    else{
      OCR1A = (g_ppmOutput[cur_chan_numb] - ZH_PULSE_LENGTH) * 2;
      calc_rest = calc_rest + g_ppmOutput[cur_chan_numb];
      cur_chan_numb++;
    }     
  }
  interrupts();
}


void readSerial(){
    //expect a string like wer,qwe rty,123 456,hyre kjhg,
  //or like hello world,who are you?,bye!,
  while (Serial.available()) {
    delay(1);  //small delay to allow input buffer to fill
    char c = Serial.read();  //gets one byte from serial buffer
    if (c == '\n') {
      break; //breaks out of capture loop to print readstring
    } 
    g_serialString += c; //makes the string readString
  }

  if(g_serialString.length() > 0) {
    // Command strings will look like "I1:1000\n" where I1 is input 1 and 1000 is the value.
    Serial.println(g_serialString); 
    int commaLoc = g_serialString.indexOf(',');
    String commandString = g_serialString.substring(0, commaLoc);
    String valueString = g_serialString.substring(commaLoc+1, g_serialString.length());
    int value = valueString.toInt();
    // Clip the value into valid range
    if(value < ZH_DEFAULT_SERVO_MIN_VALUE){
      value = ZH_DEFAULT_SERVO_MIN_VALUE;
    } 
    if(value > ZH_DEFAULT_SERVO_MAX_VALUE){
      value = ZH_DEFAULT_SERVO_MAX_VALUE
    }
    
    g_serialString=""; // we are done parsing. Clear string for next round
    if(commandString.equals(ZH_INPUT_1)){
      g_throttle = value;
    } else if(commandString.equals(ZH_INPUT_2)){
      g_aileron = value;
    } else if(commandString.equals(ZH_INPUT_3)){
      g_elevator = value;
    } else if(commandString.equals(ZH_INPUT_4)){
      g_rudder = value;
    } else if(commandString.equals(ZH_INPUT_5)){
      g_aux1 = value;
    } else if(commandString.equals(ZH_INPUT_6)){
      g_aux2 = value;
    } else if(commandString.equals(ZH_INPUT_7)){
      g_aux3 = value;
    } else if(commandString.equals(ZH_INPUT_8)){
      g_aux4 = value;
    } else {
      Serial.print("Unknown command: ");
      Serial.println(commandString);
      return;
    }
    
    Serial.print("command: ");
    Serial.println(commandString);
    Serial.print("value: ");
    Serial.println(value);  
  }
}
  
  
  
void writePPMValues(){
  g_ppmOutput[0] = g_throttle;
  g_ppmOutput[1] = g_aileron;
  g_ppmOutput[2] - g_elevator;
  g_ppmOutput[3] = g_rudder;
  g_ppmOutput[4] = g_aux1;
  g_ppmOutput[4] = g_aux2;
  g_ppmOutput[4] = g_aux3;
  g_ppmOutput[4] = g_aux4;

}
