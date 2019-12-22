/*

  ttt_high_straight_2.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  straight two grid tile train tube track
*/
include <train_tube_track.scad>;

difference() {
    translate([0, 0, height])
    straight_track_h_double_plug(2*grid);
    translate([0, -grid/2, 0])
    gate_cutout();
    translate([0, grid/2, 0])
    gate_cutout();
}
