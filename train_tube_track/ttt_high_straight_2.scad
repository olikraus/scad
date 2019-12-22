/*
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
