// A derived Blink, that uses an example 3rd party library.
// Turns on an LED on for one second, then off for one second, repeatedly.
// This example code is in the public domain.

#include <TogglePin.h>

#ifdef ARDUINO
#if ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif
#endif // ARDUINO

int main()
{
	init();
	TogglePin led(13, false);
	while (true) {
		delay(1000);
		led.toggle();
	}
}
