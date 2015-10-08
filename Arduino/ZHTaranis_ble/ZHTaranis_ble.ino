// This sketch will read analgog values from A0-A5 and then generate a PPM signal on the pin of your choice (default 9)
// The output of this sketch has been tested with an Orange RX 2.4GHz that I usually use with a taranis. 
// However I've bypassed the taranis altogether and talk directly to the Tx module. 
//
// TODO: Test  this as a trainer port input
// 


#define VWW_ENABLE_BLE 1


#if defined(VWW_ENABLE_BLE)
  // BLE libraries available here: http://redbearlab.com/rbl_library
  // Redbear includes
  #include <SPI.h>
  #include <boards.h>
  #include <ble_shield.h>
  #include <services.h>
  const uint16_t kLEDConnectedPin = 4;
  const uint16_t kLEDInitializedPin = 5;
#endif



#define VWW_ENABLE_PPM 1

#if defined(VWW_ENABLE_PPM)

#define CHANNELS 8  //set the number of chanels
#define ZH_DEFAULT_SERVO_VALUE 1500  //set the default servo value
#define ZH_DEFAULT_SERVO_MAX_VALUE 2000  //set the default servo value
#define ZH_DEFAULT_SERVO_MIN_VALUE 1000  //set the default servo value
#define ZH_FRAME_LENGTH 22500  //set the PPM frame length in microseconds (1ms = 1000µs)
#define ZH_PULSE_LENGTH 300  //set the pulse length
#define ZH_STATE_POSITIVE 1  //set polarity of the pulses: 1 is positive, 0 is negative
#define ZH_PPM_OUT_PIN 9  //set PPM signal output pin on the arduino
uint8_t  g_ppmInput[CHANNELS] = {A0, A1, A2, A3, A4, A5, A4, A5}; // Input pins
int ppm[CHANNELS];
#endif

uint16_t throttle = 1500;


void setup(){  
  #if defined(VWW_ENABLE_BLE)
//    Serial.begin(57600);  
    
    pinMode(kLEDConnectedPin, OUTPUT);
    digitalWrite(kLEDConnectedPin, LOW);
  
    pinMode(kLEDInitializedPin, OUTPUT);
    digitalWrite(kLEDInitializedPin, LOW);
  
    // Init. and start BLE library.
    ble_begin();
    Serial.println("BLE setup");
  #endif


  
#if defined(VWW_ENABLE_PPM)
  // Setup analog inputs
  for (uint8_t i = 0;  i < CHANNELS - 2; ++i) {
    // set up input pins
    pinMode(g_ppmInput[i], INPUT);
    ppm[i] = map(analogRead(g_ppmInput[i]), 0, 1024, 1000, 2000);
  }
  ppm[6] = ZH_DEFAULT_SERVO_MIN_VALUE;
  ppm[7] = ZH_DEFAULT_SERVO_MIN_VALUE;

  pinMode(ZH_PPM_OUT_PIN, OUTPUT);
  digitalWrite(ZH_PPM_OUT_PIN, !ZH_STATE_POSITIVE);  //set the PPM signal pin to the default state (off)
  
  cli();
  TCCR1A = 0; // set entire TCCR1 register to 0
  TCCR1B = 0;
  
  OCR1A = 100;  // compare match register, change this
  TCCR1B |= (1 << WGM12);  // turn on CTC mode
  TCCR1B |= (1 << CS11);  // 8 prescaler: 0,5 microseconds at 16mhz
  TIMSK1 |= (1 << OCIE1A); // enable timer compare interrupt
  sei();
#endif
}

void loop(){
#if defined(VWW_ENABLE_PPM)
  for (uint8_t i = 0;  i < CHANNELS - 2; ++i) {
      ppm[i] = map(analogRead(g_ppmInput[i]), 0, 1024, 1000, 2000);
  }
  ppm[6] = ZH_DEFAULT_SERVO_MIN_VALUE;
  ppm[7] = ZH_DEFAULT_SERVO_MIN_VALUE;
//  ppm[0] = throttle;

  delay(10);
#endif
  
#if defined(VWW_ENABLE_BLE)
    // If data is ready
    while(ble_available())
    {   
        // read out command and data
        byte data0 = ble_read();
        byte data1 = ble_read();
        byte data2 = ble_read();
        
        if (data0 == 0xFF){
            Serial.println("Recieved initialize command.");
            digitalWrite(kLEDInitializedPin, HIGH);            
        } else if (data0 == 0x01){
            uint16_t value = data1 * 0xFF;
            value += data2;
            throttle = value;
            char   buffer[16];  //buffer used to format a line (+1 is for trailing 0)
            sprintf(buffer, "Throttle command: %d", throttle);  
            Serial.println(buffer);
            
        } else {
          Serial.println("Invalid command.");
        }
    }
    
    // Set status LED to on if connected
    if (ble_connected()) {
      digitalWrite(kLEDConnectedPin, HIGH);
    } else {
      digitalWrite(kLEDConnectedPin, LOW);
    }
    
    // Allow BLE Shield to send/receive data
    ble_do_events();
    
#endif

}

#if defined(VWW_ENABLE_PPM)

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
      OCR1A = (ppm[cur_chan_numb] - ZH_PULSE_LENGTH) * 2;
      calc_rest = calc_rest + ppm[cur_chan_numb];
      cur_chan_numb++;
    }     
  }
  interrupts();
}

#endif
