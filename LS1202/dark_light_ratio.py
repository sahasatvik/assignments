#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from PIL import Image
import sys

f = sys.argv[1]
t = 50
if len(sys.argv) > 2:
    t = int(sys.argv[2])

flatten = lambda n: 255 if n > (t * 255)/ 100 else 0

img = Image.open(f).convert('L').point(flatten,  mode='1')
img.save('bw_' + str(t) + '_' + f)

dark, light = 0, 0
for i in img.getdata():
    if i == 255:
        light += 1
    else:
        dark += 1

print '%16d %16d %16f' % (dark, light, float(dark) / light)
