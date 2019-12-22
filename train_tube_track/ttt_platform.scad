/*
    platfrom grid length
    upside down for better 3d printing
*/
include <train_tube_track.scad>;

translate([0,0,height+outer_height/2])
rotate([180,0,0])
platform(is_base=false, side_fix = -1);