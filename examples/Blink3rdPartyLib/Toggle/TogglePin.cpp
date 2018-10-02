// This program is free software and is licensed under the same conditions as
// describe in https://github.com/sudar/Arduino-Makefile/blob/master/licence.txt

#include "TogglePin.h"

#ifdef ARDUINO
#if ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif
#endif // ARDUINO

TogglePin::TogglePin(int pinNumber, bool state)
	: _pinNumber(pinNumber), _state(state)
{
	pinMode(_pinNumber, OUTPUT);
	digitalWrite(_pinNumber, _state ? HIGH : LOW);
}

bool
TogglePin::toggle()
{
	_state = !_state;
	digitalWrite(_pinNumber, _state ? HIGH : LOW);
	return _state;
}
