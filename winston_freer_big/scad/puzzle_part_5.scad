/*

  puzzle_part_5.scad

  Winston Freer Tile Puzzle: Part 5
      
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/

include <winston_freer.scad>;


rotate([0,90,-90]) 
translate([-6*ts,-ts,0]) 
part5();
