/*

  puzzle_step2.scad

  Winston Freer Tile Puzzle: Step 2, two tiles removed
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;


translate([0,4,0]) part1();
translate([0,2,0]) part2pre();
translate([-6*ts,-2*ts,0]) part6();
translate([2+ts,0,0]) part3();
translate([4+1*ts,0,0]) part4();
translate([6+1*ts,0,0]) part5();
translate([2+ts,-2,0])part7();
translate([4+ts,-2,0])part8();
//translate([6,-1+ts,0])part9();
//translate([6+3*ts,-1,0]) part10();

