/*
 * Blink(LED)
 */


#define BDPIN_LED_USER_1        22
#define BDPIN_LED_USER_2        23
#define BDPIN_LED_USER_3        24
#define BDPIN_LED_USER_4        25


int led_pin = 13;
int led_pin_user[4] = { BDPIN_LED_USER_1, BDPIN_LED_USER_2, BDPIN_LED_USER_3, BDPIN_LED_USER_4 };

void setup() {
  // Set up the built-in LED pin as an output:
  pinMode(led_pin, OUTPUT);
  pinMode(led_pin_user[0], OUTPUT);
  pinMode(led_pin_user[1], OUTPUT);
  pinMode(led_pin_user[2], OUTPUT);
  pinMode(led_pin_user[3], OUTPUT);

  Serial.begin(115200);

}

void loop() {
  int i;

  digitalWrite(led_pin, HIGH);  // set to as HIGH LED is turn-off
  delay(100);                   // Wait for 0.1 second
  digitalWrite(led_pin, LOW);   // set to as LOW LED is turn-on
  delay(100);                   // Wait for 0.1 second


  for( i=0; i<4; i++ )
  {
    digitalWrite(led_pin_user[i], HIGH);
    delay(100);
  }
  for( i=0; i<4; i++ )
  {
    digitalWrite(led_pin_user[i], LOW);
    delay(100);
  }

  Serial.println( String(10) );
}
