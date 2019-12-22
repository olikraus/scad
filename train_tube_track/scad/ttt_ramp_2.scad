/*
  ttt_ramp_2.scad
    
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
        
  ramp_height must be identical to "height" from <train_tube_track.scad>
*/

include <train_tube_track.scad>;

// the following variables are calculated by ramp_calc.c
ramp_height = 32.000000;
ramp_inner_length = 70.000000;
ramp_radius = 36.000000;
ramp_arc = 33.514179; // degree
ramp_slope = 33.514177; // degree
ramp_straight_length = 36.276711; 
ramp_straight_y = 19.877160;
ramp_straight_z = 5.985029;

difference() {
    union() {
        // left plug
        translate([0,2.50,0])
        rotate([0,0,180])
        straight_track_single_plug(eocstl);

        // first arc
        translate([0, eocstl, ramp_radius])
        rotate([0,90,0])
        rotate_extrude(angle=ramp_arc, convexity = 10, $fn=100) 
        translate([ramp_radius, 0, 0])
        rotate([0,0,90])
        polygon(tube_profile_h);

        // straight slope
        translate([0, eocstl+ramp_straight_y+0.0001, ramp_straight_z])
        rotate([ramp_slope, 0, 0])
        translate([0,ramp_straight_length/2,0 ])
        straight_track_h_no_plug(ramp_straight_length);

        // second arg
        translate([0,eocstl+ramp_inner_length+0.0001, ramp_height])
        translate([0,0, -ramp_radius])
        rotate([ramp_arc,0,0])
        rotate([0,-90,0])
        rotate_extrude(angle=ramp_arc, convexity = 20, $fn=100) 
        translate([ramp_radius, 0, 0])
        rotate([0,0,-90])
        polygon(tube_profile_h);

        // right plug
        translate([0,eocstl+2.5+ramp_inner_length+0.0001, ramp_height])
        straight_track_h_single_plug(eocstl);
    }
    translate([0,grid,-ramp_height/2-outer_height/2])
    cube([outer_width+0.1, grid*3, ramp_height], center=true);
    
}

