#!/usr/bin/env python

from __future__ import print_function
import serial
import os.path
import argparse
from time import sleep

parser = argparse.ArgumentParser(description='Reset an Arduino')
parser.add_argument('--caterina', action='store_true', help='Reset a Leonardo, Micro, Robot or LilyPadUSB.')
parser.add_argument('--verbose', action='store_true', help="Watch what's going on on STDERR.")
parser.add_argument('--period', default=0.1, help='Specify the DTR pulse width in seconds.')
parser.add_argument('port', nargs=1, help='Serial device e.g. /dev/ttyACM0')
args = parser.parse_args()

if args.caterina:
    if args.verbose: print('Forcing reset using 1200bps open/close on port %s' % args.port[0])
    ser = serial.Serial(args.port[0], 57600)
    ser.close()
    ser.open()
    ser.close()
    ser.setBaudrate(1200)
    ser.open()
    ser.close()
    sleep(1)

    while not os.path.exists(args.port[0]):
        if args.verbose: print('Waiting for %s to come back' % args.port[0])
        sleep(1)

    if args.verbose: print('%s has come back after reset' % args.port[0])
else:
    if args.verbose: print('Setting DTR high on %s for %ss' % (args.port[0],args.period))
    ser = serial.Serial(args.port[0], 115200)
    ser.setDTR(False)
    sleep(args.period)
    ser.setDTR(True)
    ser.close()
