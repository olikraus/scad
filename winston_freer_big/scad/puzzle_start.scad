/*

  puzzle_start.scad

  Winston Freer Tile Puzzle: Start Setup
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;

translate([0,0,height/2+ledge_height])
union() {
translate([0,4,0]) part1();
translate([0,2,0]) part2pre();
part3();
translate([2,0,0]) part4();
translate([4,0,0]) part5();
translate([6,0,0]) part6();
translate([2,-2,0])part7();
translate([4,-2,0])part8();
translate([6,-2,0])part9();
translate([6,-1,0])part10();
}
//box();
