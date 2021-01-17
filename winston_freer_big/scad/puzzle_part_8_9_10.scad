/*

  puzzle_part_8_9_10.scad

  Winston Freer Tile Puzzle: Parts 8, 9 and 10
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;


rotate([0,90,-90]) 
translate([-6*tw,0,0]) 
part8();

translate([1.5*tw,0,0])
rotate([0,90,-90]) 
translate([-7*tw,0,0]) 
part9();


translate([3*tw,0,0])
rotate([0,90,-90]) 
translate([-7*tw,-ts,0]) 
part10();

