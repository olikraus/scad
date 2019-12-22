/*
    straight one grid tile train tube track
*/
include <train_tube_track.scad>;

difference() {
    translate([0, 0, height])
    straight_track_h_double_plug(grid);
    gate_cutout();
}

/*
translate([grid, 0,0])
rotate([0,0,90])
platform(is_base=false, side_fix = 0);

*/