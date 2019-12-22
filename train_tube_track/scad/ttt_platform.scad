/*

  ttt_platform.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  platfrom grid length
  upside down for better 3d printing
*/
include <train_tube_track.scad>;

translate([0,0,height+outer_height/2])
rotate([180,0,0])
platform(is_base=false, side_fix = -1);