/*

  puzzle_part_1.scad

  Winston Freer Tile Puzzle: Part 1
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;


rotate([0,90,-90])
translate([-7*ts,-6.5*ts,0])
part1();


