// This sketch will establish a BLE connection with an iOS application. It will read values and then send them out via serial port to another arduino which will generate PPM signal

// BLE libraries available here: http://redbearlab.com/rbl_library
// Redbear includes
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>
const uint16_t kLEDConnectedPin = 4;
const uint16_t kLEDInitializedPin = 5;

void setup(){  
    Serial.begin(57600);
    Serial1.begin(57600);
    
    pinMode(kLEDConnectedPin, OUTPUT);
    digitalWrite(kLEDConnectedPin, LOW);
  
    pinMode(kLEDInitializedPin, OUTPUT);
    digitalWrite(kLEDInitializedPin, LOW);
  
    // Init. and start BLE library.
    ble_begin();
    Serial.println("BLE setup");
}

void loop() {
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
            uint16_t throttle = value;
            char   buffer[16];  //buffer used to format a line (+1 is for trailing 0)
            sprintf(buffer, "Throttle command: %d", throttle);  
            Serial.println(buffer);
            
            char serialOut[16];  
            sprintf(serialOut, "I1,%d\n", throttle);  
            Serial.print(serialOut);
            Serial1.print(serialOut);
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
}

