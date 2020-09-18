/*

  puzzle_step3.scad

  Winston Freer Tile Puzzle: Magic Setup
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;


o=0;
f=1;
translate([o+0,f*4,0]) part1();
translate([o+0,f*2,0]) part2();
translate([o+5*ts+f*6,ts+f*2,0]) part3();
translate([o-2*ts+f*0,-ts,0]) part4();
translate([o-2*ts+f*3,-ts,0]) part5();
translate([o-2*ts+f*4,-ts+f*2,0]) part6();
translate([o+2*ts+f*4,0,0])part7();
