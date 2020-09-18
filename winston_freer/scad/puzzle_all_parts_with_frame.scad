/*

  winston_freer_3d_print.scad

  Winston Freer Tile Puzzle: All In One Setup for 3D Printer
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;



translate([ts,0.5*ts,0])
rotate([0,90,-90])
translate([-7*ts,-6.5*ts,0])
part1();

translate([ts,1.5*ts,0])
rotate([0,-90,-90])
translate([0,-3*ts,0])
part2();

translate([ts,2.5*ts,0])
rotate([0,90,-90]) 
translate([-6*ts,-ts,0]) 
part5();

translate([ts,3.5*ts,0])
rotate([0,90,-90]) 
translate([-5*ts,0,0])
part7();

translate([ts,4.5*ts,0])
translate([0,0,2*ts])
rotate([0,90,-90]) 
part3();

translate([ts,5.5*ts,0])
rotate([0,90,-90]) 
translate([-7*ts,-2*ts,0]) 
part6();


translate([ts,6.5*ts,0])
rotate([0,90,-90]) 
translate([-3*ts,-ts,0]) 
part4();

translate([4*ts,0.5*ts,0])
rotate([0,90,-90]) 
translate([-6*ts,0,0]) 
part8();

translate([4*ts,0.5*ts,0])
translate([1.5*ts,0,0])
rotate([0,90,-90]) 
translate([-7*ts,0,0]) 
part9();

translate([0*ts,3.5*ts,0])
translate([3*ts,0,0])
rotate([0,90,-90]) 
translate([-7*ts,-ts,0]) 
part10();


frame();