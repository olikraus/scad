/*

  winston_freer_3d_print.scad

  Winston Freer Tile Puzzle: All In One Setup for 3D Printer
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;


translate([0,3*ts,0])
rotate([0,90,-90])
translate([-7*ts,-6*ts,0])
translate([0,4,0]) part1();

translate([-3*ts-5,2*ts,0])
rotate([0,-90,-90])
translate([0,2,0]) part2();

rotate([90,0,0]) part3();
translate([-2*ts,ts,0]) 
    rotate([90,0,0]) translate([0,-ts,0]) part4();
translate([-2*ts+2,ts,0]) 
    rotate([90,0,0]) translate([0,-ts,0]) part5();
translate([-2*ts+4,ts,0]) 
    rotate([90,0,0]) translate([0,-2*ts,0]) part6();
translate([2,0,0]) rotate([90,0,0]) part7();
translate([4,0,0]) rotate([90,0,0]) part8();
translate([3-ts,2*ts,0]) rotate([90,0,0]) part9();
translate([-ts,3*ts,0]) 
    rotate([90,0,0]) translate([0,-ts,0]) part10();

translate([-5,-ts,+height/2+ledge_height])
frame();