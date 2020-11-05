
$fn=64;


screw_dia=2;
plate_h = 5;
plate_size = 60;
box_wall=2;
box_height = 22;

module screw() {
    translate([0,0,-2])
    cylinder(d1=screw_dia, d2=6, h=2);
    translate([0,0,-(box_height-2)])
    cylinder(h=box_height-2, d=screw_dia);
}

module rot_enc_plate() {
    difference() {
        translate([0,0,plate_h/2])
        cube([plate_size-0.8,plate_size-0.8,plate_h], 
            center=true);
        translate([0,0,1])
        cylinder(h=10, d=50);
        cylinder(h=10, d=6, center=true);
        translate([-47/2,-47/2,plate_h+0.01]) screw();
        translate([-47/2,47/2,plate_h+0.01]) screw();
        translate([47/2,-47/2,plate_h+0.01]) screw();
        translate([47/2,47/2,plate_h+0.01]) screw();
        translate([0,20,0])
        cylinder(h=20,d=10, center=true);
    }
}

module rot_enc_plate_co() {
    union() {
    translate([0,0,-plate_h/2+0.01 ])
   cube([plate_size,plate_size,plate_h], center=true);
    
        translate([-47/2,-47/2,0]) screw();
        translate([-47/2,47/2,0]) screw();
        translate([47/2,-47/2,0]) screw();
        translate([47/2,47/2,0]) screw();
    translate([0,0,-(box_height-2)])
    cylinder(d=50,h=box_height-2);
    
    translate([0,0,-(box_height-2)/2])
    cube([60,30,box_height-2], center=true);
    }
}


translate([plate_size/2+box_wall/2+2,plate_size+5,0])
rot_enc_plate();

translate([-plate_size/2+box_wall/2-2,plate_size+5,0])
rot_enc_plate();

difference() {
    translate([0,0,box_height/2])
    cube([plate_size*2+box_wall*3,
        plate_size+box_wall*2,
        box_height], center=true);

    translate([plate_size/2+box_wall/2,0,box_height+0.01 ])
    rot_enc_plate_co();

    translate([-plate_size/2-box_wall/2,0,box_height+0.01 ])
    rot_enc_plate_co();

    translate([plate_size,0,9.5])
    rotate([0,90,0])
    cylinder(d=12, h=20, center=true);


    translate([plate_size/2,plate_size/2,9])
    rotate([90,0,0])
    cylinder(d=10, h=20, center=true);

    translate([0,0,9.5])
    rotate([0,90,0])
    cylinder(d=12, h=20, center=true);

    
}


