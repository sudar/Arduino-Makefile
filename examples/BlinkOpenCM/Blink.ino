/*
  Blink
  Turns an LED on for one second, then off for one second, repeatedly.

  This example code is in the public domain.
 */

void setup() {
  // initialize the led pin as an output.
  pinMode(BOARD_LED_PIN, OUTPUT);
}

void loop() {
  digitalWrite(BOARD_LED_PIN, HIGH);   // set the LED on
  delay(1000);                         // wait for a second
  digitalWrite(BOARD_LED_PIN, LOW);    // set the LED off
  delay(1000);                         // wait for a second
}
