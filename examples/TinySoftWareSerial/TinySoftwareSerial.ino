#include <SoftwareSerial.h>

SoftwareSerial mySerial(3, 4); // RX, TX

void setup() {  
    mySerial.begin(9600);
}

void loop() {
    mySerial.println(millis()); 
    delay(1000);
}
