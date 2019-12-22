#!/bin/bash

for i in {0..71}
  do 
    printf -v ii "%04d" $i
    let h=($i-30)*2
    echo $i $h
    openscad -Dy=$i ttt_animation.scad --render --camera -100,20,$h,0,0,0 --imgsize=640,480 -o $ii.png
 done
 
 convert -delay 15 0*.png -loop 0 ttt_animation.gif
 