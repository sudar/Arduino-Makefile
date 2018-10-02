// This program is free software and is licensed under the same conditions as
// describe in https://github.com/sudar/Arduino-Makefile/blob/master/licence.txt

#ifndef TOGGLEPIN_H_
#define TOGGLEPIN_H_

class TogglePin
{
 public:
	TogglePin(int pinNumber, bool state);

	bool toggle();

 private:
	const int _pinNumber;
	bool _state;
};

#endif
