/*

  light_controller_box.scad
  
  The top of the box can be equipped with two LED rings 
  and two rotary encoders

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.


*/


$fn=64;


screw_dia=2.45;
plate_h = 7;
plate_size = 60;
middle_size=16;
box_wall=2;
box_height = 35;
led_ring_outer_dia=50.8;
led_ring_height = 5;        // must smaller than plate_h

module screw() {
    translate([0,0,-0.601])
    cylinder(d=6.4, h=0.602, $fn=20);
    translate([0,0,-2.5-0.6])
    cylinder(d1=screw_dia, d2=6.4, h=2.5, $fn=20);
    translate([0,0,-(box_height-2)])
    cylinder(h=box_height-2, d=screw_dia, $fn=20);
}

module rot_enc_plate() {
    o = led_ring_outer_dia-3;
    difference() {
        translate([0,0,plate_h/2])
        cube([plate_size-0.6,plate_size-0.6,plate_h], 
            center=true);
        translate([0,0,plate_h-led_ring_height])
        cylinder(h=10, d=led_ring_outer_dia);
        cylinder(h=10, d=7.4, center=true);
        translate([-o/2,-o/2,plate_h+0.01]) screw();
        translate([-o/2,o/2,plate_h+0.01]) screw();
        translate([o/2,-o/2,plate_h+0.01]) screw();
        translate([o/2,o/2,plate_h+0.01]) screw();
        translate([0,20,0])
        cylinder(h=20,d=10, center=true);
    }
}

module rot_enc_plate_co() {
    o = led_ring_outer_dia-3;
    union() {
    translate([0,0,-plate_h/2+0.01 ])
   cube([plate_size,plate_size,plate_h], center=true);
    
        translate([-o/2,-o/2,0]) screw();
        translate([-o/2,o/2,0]) screw();
        translate([o/2,-o/2,0]) screw();
        translate([o/2,o/2,0]) screw();
    translate([0,0,-(box_height-2)])
    cylinder(d=led_ring_outer_dia+6,h=box_height-2);
    
    translate([0,0,-(box_height-2)/2])
    cube([60,30,box_height-2], center=true);
    }
}

module button_plate() {
    o = led_ring_outer_dia-3;
    difference() {
        translate([0,0,2])
        cube([middle_size-0.6, plate_size-0.6, 4], center=true);
        
        translate([0,0,1-0.01])
        cube([middle_size-2.6, o-7, 2], center=true);
        
        translate([0,-o/2,4]) screw();
        translate([0,o/2,4]) screw();
        
        translate([0,10,0])
        cylinder(d=6+0.6, h=20, center=true);

        translate([0,-10,0])
        cylinder(d=10+0.8, h=20, center=true);
    }
    
    
}



module button_plate_co() {
    o = led_ring_outer_dia-3;
    translate([0,0,-2])
    cube([middle_size, plate_size, 4], center=true);
    translate([0,-o/2,0]) screw();
    translate([0,o/2,0]) screw();
    
    translate([0,0,-(box_height-2)/2])
    cube([middle_size, o-7, box_height-2], center=true);
}


translate([0,plate_size+5,4])
    rotate([180,0,0])
    button_plate();

translate([plate_size/2+box_wall+middle_size/2+2,plate_size+5,0])
rot_enc_plate();

translate([-plate_size/2-box_wall-middle_size/2-2,plate_size+5,0])
rot_enc_plate();

difference() {
    translate([0,0,box_height/2])
    cube([plate_size*2+box_wall*4+middle_size,
        plate_size+box_wall*2,
        box_height], center=true);

    translate([0,0,box_height+0.01 ])
    button_plate_co();

    translate([plate_size/2+box_wall+middle_size/2,0,box_height+0.01 ])
    rot_enc_plate_co();

    translate([-plate_size/2-box_wall-middle_size/2,0,box_height+0.01 ])
    rot_enc_plate_co();

    translate([plate_size+box_wall+middle_size/2,0,9.5])
    rotate([0,90,0])
    cylinder(d=12, h=20, center=true, $fn=24);


    translate([plate_size/2+box_wall+middle_size/2,plate_size/2,12])
    rotate([90,0,0])
    cylinder(d=14, h=20, center=true, $fn=24);

    translate([0,0,box_height/2])
    rotate([0,90,0])
    cylinder(d=box_height-10, h=30, center=true, $fn=24);
}


