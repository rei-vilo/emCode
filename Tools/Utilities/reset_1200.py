#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2026
# All rights reserved
#
# Last update: 27 May 2019 release 10.8.8
#

import serial
import sys
import time

if len(sys.argv) < 2:
    print "Missing serial port"
    sys.exit()

print 'Setting %s at 1200' % sys.argv[1]

ser = serial.Serial(sys.argv[1], baudrate=1200)

time.sleep(1)

ser.close()
