/*
  rpm_meeter.scad
*/

wall = 0.4;
bottom_thickness = 0.8;
minkowski_radius = 1.6;
oled_width = 25.8;
oled_height = 26.4;
oled_thickness = 4;
oled_screw_corner = 4.4;
oled_corner_cutout_thickness = 4;
oled_screw_hole_length = 6;
oled_screw_dia = 2.4;   // diameter for the hole into which oled screw has to fit

oled_plate_width = oled_width+2*wall;
oled_plate_height = oled_height+2*wall+minkowski_radius/2;

oled_tilt_angle = 65;
oled_base_height = 15; /* distance between zero level and oled lower border */

oled_upper_x = cos(oled_tilt_angle)*oled_plate_height;
oled_upper_y = sin(oled_tilt_angle)*oled_plate_height+oled_base_height;
rpm_meter_depth = 19; // includes wall
rpm_meter_height = 50; // includes wall
rpm_meter_width = oled_width + 2*wall;


p = 
[ 
  [0,0],
  [0,oled_base_height],
  [oled_upper_x,oled_upper_y],
  [oled_upper_x,rpm_meter_height],
  [rpm_meter_depth,rpm_meter_height],
  [rpm_meter_depth,0]
];


module oled_box() {
  union() {
    cube([oled_height, oled_thickness+minkowski_radius, oled_width]); // roughly the dimension of the oled

    //translate([oled_screw_corner,-oled_corner_cutout_thickness+0.01,0])
    //cube([oled_height-oled_screw_corner*2, oled_corner_cutout_thickness, oled_width]); // roughly the dimension of the oled

    translate([0,-oled_corner_cutout_thickness+0.01,oled_screw_corner])
    cube([oled_height, oled_corner_cutout_thickness, oled_width-oled_screw_corner*2]); // roughly the dimension of the oled

    translate([oled_screw_corner/2, 0.01, oled_screw_corner/2])
    rotate([90,0,0])
    cylinder(d=oled_screw_dia, h=oled_screw_hole_length*2);

    translate([oled_screw_corner/2, 0.01, oled_width-oled_screw_corner/2])
    rotate([90,0,0])
    cylinder(d=oled_screw_dia, h=oled_screw_hole_length*2);

    translate([oled_height-oled_screw_corner/2, 0.01, oled_screw_corner/2])
    rotate([90,0,0])
    cylinder(d=oled_screw_dia, h=oled_screw_hole_length);

    translate([oled_height-oled_screw_corner/2, 0.01, oled_width-oled_screw_corner/2])
    rotate([90,0,0])
    cylinder(d=oled_screw_dia, h=oled_screw_hole_length);
  }
}

module rpm_box_lower_cutout() {
  translate([wall, -minkowski_radius+bottom_thickness, wall+oled_screw_corner])
  cube([rpm_meter_depth-2*wall, oled_upper_y-3*wall-minkowski_radius, oled_width-2*oled_screw_corner]);
}

module rpm_box_upper_cutout() {
translate([wall+oled_upper_x, wall, wall+oled_screw_corner])
cube([rpm_meter_depth-oled_upper_x-2*wall, rpm_meter_height-2*wall, oled_width-2*oled_screw_corner ]);
}

translate([0,0,minkowski_radius])
rotate([90,0,0])
difference() {
  
  minkowski() {
    linear_extrude(height=rpm_meter_width, slices=1)
    polygon(p);
    sphere(r=minkowski_radius, $fn=32);
  }
  
  //linear_extrude(height=rpm_meter_width, slices=1)
  //polygon(p);

  // create a space for the oled
  translate([0,oled_base_height,0])
  rotate([0,0,oled_tilt_angle])
  translate([wall, -oled_thickness+0.01, wall])
  oled_box();
  
  rpm_box_lower_cutout();
  rpm_box_upper_cutout();
  
  translate([rpm_meter_depth,10,rpm_meter_width/2])
  rotate([0,90,0])
  cylinder(r=7, h=(minkowski_radius+wall)*2, center=true, $fn=24);
  
  translate([rpm_meter_depth,rpm_meter_height-10,rpm_meter_width/2])
  rotate([0,90,0])
  cylinder(r=7, h=(minkowski_radius+wall)*2, center=true, $fn=24);
  
}
