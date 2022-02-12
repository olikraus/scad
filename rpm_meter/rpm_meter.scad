/*
  rpm_meeter.scad
*/

wall = 0.4;
bottom_thickness = 0.8;
minkowski_radius = 1.6;
oled_width = 25.8;
oled_height = 26.4;
oled_display_height = 12;
oled_display_width = 23;
oled_display_hshift = 1.4;
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
rpm_meter_depth = 21; // includes wall
rpm_meter_height = 50; // includes wall
rpm_meter_width = oled_width + 2*wall;


p = 
[ 
  [3,0],
  [0,oled_base_height-6],
  [0,oled_base_height],
  [oled_upper_x,oled_upper_y],
  [oled_upper_x,rpm_meter_height],
  [rpm_meter_depth,rpm_meter_height],
  [rpm_meter_depth,0]
];


module copy_mirror(vec=[0,1,0]) {
    children();
    mirror(vec) 
    children();
}
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
  translate([wall+2, -minkowski_radius+bottom_thickness, wall+oled_screw_corner])
  cube([rpm_meter_depth-2*wall-2, oled_upper_y-3*wall-minkowski_radius, oled_width-2*oled_screw_corner]);
}

module rpm_box_upper_cutout() {
translate([wall+oled_upper_x, wall, wall+oled_screw_corner])
cube([rpm_meter_depth-oled_upper_x-2*wall, rpm_meter_height-2*wall, oled_width-2*oled_screw_corner ]);
}


module rpm_box() {
  translate([-rpm_meter_depth/2,oled_width/2,minkowski_radius])
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
    
    translate([rpm_meter_depth,11,rpm_meter_width/2])
    rotate([0,90,0])
    cylinder(r=8, h=(minkowski_radius+wall)*2, center=true, $fn=24);
    
    translate([rpm_meter_depth,rpm_meter_height-11,rpm_meter_width/2])
    rotate([0,90,0])
    cylinder(r=8, h=(minkowski_radius+wall)*2, center=true, $fn=24);
    
  }
}

module square_frustum(bottom=[10,10], top=[0,0], h=10, ChamferBody=0) {
  c = ChamferBody/2;
  lx = bottom[0]-2*c;
  ly = bottom[1]-2*c;
  ux = top[0]-2*c;
  uy = top[1]-2*c;
  p = [
    [ -lx/2-c, -ly/2+c,  0 ],  //0 / 0, 0
    [ -lx/2+c, -ly/2-c,  0 ],  //0 / 1, 1
  
    [ lx/2-c,  -ly/2-c,  0 ],  //1 / 0, 2
    [ lx/2+c,  -ly/2+c,  0 ],  //1 / 1, 3
  
    [ lx/2+c,  ly/2-c,  0 ],  //2 / 0, 4
    [ lx/2-c,  ly/2+c,  0 ],  //2 / 1, 5
  
    [ -lx/2+c,  ly/2+c,  0 ],  //3 / 0, 6
    [ -lx/2-c,  ly/2-c,  0 ],  //3 / 1, 7
  
    [ -ux/2-c, -uy/2+c,  h ],  //4 / 0, 8
    [ -ux/2+c, -uy/2-c,  h ],  //4 / 1, 9
  
    [ ux/2-c,  -uy/2-c,  h ],  //5 / 0, 10
    [ ux/2+c,  -uy/2+c,  h ],  //5 / 1, 11
 
    [ ux/2+c,  uy/2-c,  h ],  //6 / 0, 12
    [ ux/2-c,  uy/2+c,  h ],  //6 / 1, 13
    
    [ -ux/2+c,  uy/2+c,  h ], //7 / 0, 14
    [ -ux/2-c,  uy/2-c,  h ]]; //7 / 1, 15
    
  f = [
    [0,1,2,3,4,5,6,7],  // bottom
    [8,9,1,0], // front left
    [9,10,2,1],  // front 
    [10,11,3,2], // front right
    [15,14,13,12,11,10,9,8],  // top
    [11,12,4,3],  // right
    [12,13,5,4],  // back right
    [13,14,6,5],  // back
    [14,15,7,6], // back left
    [15,8,0,7]]; // left
  polyhedron( p, f );
}

module oled_bezel() {
  difference() {
    translate([0,0,minkowski_radius/2])
    cube([oled_height-0.3, oled_width-0.3, minkowski_radius], center=true); 

    copy_mirror([1,0,0])
    copy_mirror([0,1,0])
    translate([oled_height/2-oled_screw_corner/2, oled_width/2-oled_screw_corner/2, 0])
    cylinder(d=oled_screw_dia, h=oled_screw_hole_length*2, center=true);

    translate([oled_display_hshift,0,-0.01])
    square_frustum([oled_display_height, oled_display_width], [oled_display_height+minkowski_radius, oled_display_width+minkowski_radius],minkowski_radius+0.02, ChamferBody=1);
    //cube([oled_display_height, oled_display_width, minkowski_radius*4], center=true); 
  }
}

rpm_box();
translate([-rpm_meter_depth-oled_height/4, 0, 0])
oled_bezel();