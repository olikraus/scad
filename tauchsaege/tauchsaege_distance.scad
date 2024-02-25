/*

  tauchsaege_distance.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

*/

include <base_objects.scad>;

$fn=16;

sled_width=16.8;
sled_height=6.5;
sled_extend=4.5;
extra_distance=21;
length=154;
translate([0,0,0])
difference() {
  CenterCube([sled_width+extra_distance, length, sled_height+sled_extend], 
    ChamferBody = 2, ChamferBottom=1, ChamferTop=1);
  translate([sled_width/2,-0.01,sled_extend])
  CenterCube([extra_distance+0.01, length+0.04, sled_height+0.01]);
}



