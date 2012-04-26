# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches.

Until March 2012, this was simply posted on my website where you can
still find [what
documentation](http://mjo.tc/atelier/2009/02/arduino-cli.html
"Documentation") exists.

If you're using Debian or Ubuntu, you can find this in the arduino-core package.

## Options

If you are defining your own `main()` function, you can stop the Ardunio's
built-in `main()` from being compiled with your code by defining the
`NO_CORE_MAIN_FUNCTION` variable:

    NO_CORE_MAIN_FUNCTION = 1
