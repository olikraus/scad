/*
   photo_background_stand.scad

   (c) olikraus@gmail.com
 
   This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
   To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
   

   v1.0 initial version
   v1.1 changed infill from 60% to 40%, increased radius
   
*/  

/* [basic] */

// The gap for the paper in mm
paper_gap = 0.4;

// The inner radius of the stand in mm
inner_radius = 60;

// The straight extension of the channel in mm
extension_length = 40;

// The width of the stand in mm
channel_depth = 15;

/* [advanced] */

side_wall = 1.6;

bottom_wall = 2;

fragments=128;


chamfer = side_wall*0.7;
channel_height = side_wall*2+paper_gap;
outer_radius = inner_radius + channel_height;

upoly = [
  [0,0],
  [side_wall*2+paper_gap, 0],
  [side_wall*2+paper_gap, channel_depth],
  [side_wall+paper_gap+chamfer, channel_depth],
  [side_wall+paper_gap, channel_depth-3*chamfer],
  [side_wall+paper_gap, bottom_wall],
  [side_wall, bottom_wall],
  [side_wall, channel_depth-3*chamfer],
  [side_wall-chamfer, channel_depth],
  [0, channel_depth]
];

opoly = [
  [0,0],
  [side_wall*2+paper_gap, 0],
  [side_wall*2+paper_gap, channel_depth+0.01],
  [0, channel_depth+0.01]
];

module pbs() {
  union() {
    rotate([90,0,0])
    linear_extrude(height = extension_length)
      translate([inner_radius,0,0])
      polygon(upoly);

    rotate_extrude(angle = 90, convexity = 4, $fn=fragments)
      translate([inner_radius,0,0])
      polygon(upoly);

    rotate([0,-90,0])
    linear_extrude(height = extension_length)
      translate([0,inner_radius+channel_height,0])
      rotate([0,0,-90])
      polygon(upoly);

    difference()
    {
      union() {
        translate([outer_radius-channel_height, outer_radius-channel_height, 0])
        rotate([0,0,45])
        translate([0,0,channel_depth/2])
        cube([channel_height, channel_height, channel_depth], center=true);
          
        translate([outer_radius-channel_height,0.01,0])
        cube([channel_height, outer_radius-0.01, channel_depth]);

        translate([0.01,outer_radius,0])
        rotate([0,0,-90])
        cube([channel_height, outer_radius-0.01, channel_depth]);
      }
      rotate_extrude(angle = 90, convexity = 4, $fn=fragments)
        translate([inner_radius,0,0])
        polygon(opoly);
    }
  }
}

pbs();
translate([15,20,0])
rotate([0,0,180])
pbs();
