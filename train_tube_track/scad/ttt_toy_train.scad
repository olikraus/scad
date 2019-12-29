/*

  ttt_toy_train_scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  Example train for the TTT project
  
  print with brim (and remove all the brim!)
    
*/

$fn=64;

module wheel(dia=6, thickness=2) {
    depth=0.4;
    tire=0.8;
    crossing=1.0;
    //translate([0,0,-(thickness-depth)])
    union() {
        difference() {
            cylinder(d=dia,h=thickness);
            translate([0,0,thickness-depth+0.001])
            cylinder(d=dia-2*tire,h=depth);
        }
        for(i=[0:3]) {
            rotate([0,0,90/2*i])
            translate([0,0,thickness-depth/2-depth/3])
            cube([dia-crossing/2,crossing/2,depth], center=true);
        }
        cylinder(d=crossing*1.1,h=thickness);
    }
}

/*
    origin (x,z) is in the middle of the window
    window looks into y direction

*/
module window(width=4, height=5, is_crossing=true) {
    thickness=1;
    depth=0.3;
    frame=0.5;
    crossing=0.5;
    union() {
        difference() {
            translate([0,-thickness/2+depth,0])
            cube([width,thickness,height],center=true);
            
            translate([-(width-frame*2)/2,0.001,-(height-frame*2)/2])
            cube([width-frame*2, depth, height-frame*2]);    
        }
        if ( is_crossing ) {
            translate([-width/2,0,-crossing/2])
            cube([width, depth*0.7, crossing]);

            translate([-crossing/2,0,-height/2])
            cube([crossing, depth*0.7, height]);
        }
    }
}

/* 
    origin is the middle of the roof 
*/
module roof(length=10, dia=19)
{
    height=6;
    frame=1;
    depth=0.5;
    translate([-length/2,0,0])
    rotate([-90,0,-90])
    translate([0,dia/2-height,0])
    difference() {
        translate([0,0,0.001])
        cylinder(d=dia, h=length-0.002);

        translate([0,0,frame])
        difference() {
            translate([0,0,0.001])
            cylinder(d=dia+0.001,h=length-2*frame-0.002);
            
            cylinder(d=dia-depth*2,h=length-2*frame);
            translate([-dia/2,-frame-(dia/2-height),0])
            cube([dia, dia,length-2*frame]);
        }
        
        translate([-dia/2,-(dia/2-height),0])
        cube([dia, dia,length]);
    }
}

module body(height=15, 
    length=20, 
    width=16, 
    wheel_thickness=2, 
    wheel_diameter=6,
    is_ramp_cutout_front=true,
    is_ramp_cutout_back=true) {

    difference() {
        translate([0,0,height/2])
        cube([length, width, height], center=true);

        if ( is_ramp_cutout_front ) {
            translate([length/2,0,0])
            rotate([0,45,0])
            cube([2,width+0.002,2], center=true);
        }

        if ( is_ramp_cutout_back ) {
            translate([-length/2,0,0])
            rotate([0,45,0])
            cube([2,width+0.002,2], center=true);
        }
        
        translate([0, width/2-wheel_thickness/2, wheel_diameter/2])
        cube([length+0.001, wheel_thickness+0.001, wheel_diameter*1.2+0.001], center=true);

        translate([0,-width/2+wheel_thickness/2, wheel_diameter/2])
        cube([length+0.001, wheel_thickness+0.001, wheel_diameter*1.2+0.001], center=true);
    }
}

module wagon(length=30) {
    union() {
    body_length=length;
    body_height=15;
    body_width=16;
    wheel_thickness=1.5;
    wheel_diameter=5.5;
    window_width=body_length/2-2;
    translate([0,0,body_height])
    roof(length=body_length+1);
    body(length=body_length, height=body_height, width=body_width,
        wheel_thickness=wheel_thickness, 
        wheel_diameter=wheel_diameter);

    translate([-body_length*0.23, body_width/2, body_height*.7])
    window(width=window_width, height=6);

    translate([body_length*0.23, body_width/2, body_height*.7])
    window(width=window_width, height=6);

    translate([-body_length*0.23, -body_width/2, body_height*.7])
    rotate([0,0,180])
    window(width=window_width, height=6);

    translate([body_length*0.23, -body_width/2, body_height*.7])
    rotate([0,0,180])
    window(width=window_width, height=6);

    translate([-body_length/2+wheel_diameter,body_width/2-wheel_thickness,wheel_diameter/2])
    rotate([90,0,180])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);

    translate([body_length/2-wheel_diameter,body_width/2-wheel_thickness,wheel_diameter/2])
    rotate([90,0,180])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);

    translate([-body_length/2+wheel_diameter,-body_width/2+wheel_thickness,wheel_diameter/2])
    rotate([90,0,0])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);

    translate([body_length/2-wheel_diameter,-body_width/2+wheel_thickness,wheel_diameter/2])
    rotate([90,0,0])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);
    }
}

module engine_house(length=12) {
    body_length=length;
    body_height=15;
    body_width=16;
    wheel_thickness=1.5;
    wheel_diameter=5.5;
    union() {
        translate([0,0,body_height])
        roof(length=body_length+1);
        body(length=body_length, 
            height=body_height, 
            width=body_width,
            wheel_thickness=wheel_thickness, 
            wheel_diameter=wheel_diameter,
            is_ramp_cutout_back=false);

/*
        translate([0,body_width/2-wheel_thickness,wheel_diameter/2])
        rotate([90,0,180])
        wheel(dia=wheel_diameter, thickness=wheel_thickness);

        translate([0,-body_width/2+wheel_thickness,wheel_diameter/2])
        rotate([90,0,0])
        wheel(dia=wheel_diameter, thickness=wheel_thickness);
*/
        translate([0, -body_width/2, body_height*.7])
        rotate([0,0,180])
        window(width=body_length*0.7, height=6);

        translate([0, body_width/2, body_height*.7])
        rotate([0,0,0])
        window(width=body_length*0.7, height=6);

        /* front left window */
        translate([-body_length/2, -body_width/2+2, body_height*.8])
        rotate([0,0,90])
        window(width=3, height=3.6, is_crossing=false);

        /* front right window */
        translate([-body_length/2, +body_width/2-2, body_height*.8])
        rotate([0,0,90])
        window(width=3, height=3.6, is_crossing=false);

        /* back window */
        translate([body_length/2, 0, body_height*.7])
        rotate([0,0,-90])
        window(width=body_width*0.7, height=6);
    }
}

module engine_steam(length=18) {
        
    body_length=length;
    body_height=7;
    body_width=16;
    wheel_thickness=1.5;
    wheel_diameter=5.5;
    steam_offset=0.5;


    body(length=body_length, 
        height=body_height, 
        width=body_width,
        wheel_thickness=wheel_thickness, 
        wheel_diameter=wheel_diameter,
        is_ramp_cutout_front=false);

    translate([steam_offset,0,body_height*1.2])
    rotate([0,90,0])
    cylinder(d=body_width*0.65,h=body_length-steam_offset, 
        center=true);

/*
    translate([-body_length/2+wheel_diameter,body_width/2-wheel_thickness,wheel_diameter/2])
    rotate([90,0,180])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);

    translate([body_length/2-wheel_diameter,body_width/2-wheel_thickness,wheel_diameter/2])
    rotate([90,0,180])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);

    translate([-body_length/2+wheel_diameter,-body_width/2+wheel_thickness,wheel_diameter/2])
    rotate([90,0,0])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);

    translate([body_length/2-wheel_diameter,-body_width/2+wheel_thickness,wheel_diameter/2])
    rotate([90,0,0])
    wheel(dia=wheel_diameter, thickness=wheel_thickness);
*/
}

module chimney(dia=4, height=8) {
    chimney_dia=dia;
    chimney_height=height;
    bowl_dia=chimney_dia+2.5;
    union() {
        translate([0,0,chimney_height-0.001])
        difference()
        {
            sphere(d=bowl_dia);
            translate([0,0,bowl_dia*0.7])
            cube([bowl_dia,bowl_dia,bowl_dia], center=true);
            cylinder(d=chimney_dia,h=bowl_dia);
        }
        cylinder(d=chimney_dia,h=chimney_height);
    }
}

module engine(length=32) {

    engine_length=length;
    body_width=16;
    wheel_thickness=1.5;
    wheel_diameter=5.5;

    translate([-engine_length*0.45,0,11])
    chimney();

    translate([-engine_length*0.6/2,0,0])
    engine_steam(length=engine_length*0.6);

    translate([engine_length*0.4/2,0,0])
    engine_house(length = engine_length*0.4);


    for(i=[0:3]) {
        translate([i*engine_length/4-engine_length/2+
            engine_length*0.025,
            -body_width/2+wheel_thickness,wheel_diameter/2])
        rotate([90,0,0])
        wheel(dia=5.5, thickness=wheel_thickness);
        
        translate([i*engine_length/4-engine_length/2+
            engine_length*0.025,
            +body_width/2-wheel_thickness,wheel_diameter/2])
        rotate([-90,0,0])
        wheel(dia=5.5, thickness=wheel_thickness);    
    }
}

difference() {
    engine(length=30);
    translate([2,0,0])
    cube([4.8,2.2,16], center=true);
}

translate([30,0,0])
difference() {
    wagon(length=12*2-4);
    cube([4.8,2.2,16], center=true);
}

translate([60,0,0])
difference() {
    wagon(length=12*2-4);
    cube([4.8,2.2,16], center=true);
}
