/*

  ttt_gear.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  render the main gear for train tube track

*/
include <train_tube_track.scad>;

/*
    1st Parameter: Hole Diameter
    2nd Parameter: Depth of the flat aches area (if any)
*/
ttt_gear(3+0.2, 0.5+0.1);