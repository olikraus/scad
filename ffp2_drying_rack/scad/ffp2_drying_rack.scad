/*

  ffp2_drying_rack.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
*/


$fn=32;

clip_len=40;
clip_height=8;
clip_thickness=2;
clip_diameter = clip_height-3;
clip_cylinder_len = 2.5;

/* min 8 for clip_cyllinder_len=2.5 
    also depends on clip_diameter and in turn on clip_height
    clip_triangle_len must be also larger than press_fit_len
*/
clip_triangle_len = 10;

/* clip hole diameter extention, so that the clip fits better */
clip_diameter_gap = 0.1; 


hook_len=6;
hook_nose_height=3;
hook_nose_width=2;
hook_thickness=3;

wall_thickness=4;
wall_height=70;
wall_width=60;

press_fit_len=5;
press_fit_diameter=clip_height-2;


module triangle_block() {
    linear_extrude(height=clip_height)
    polygon(points=[[0,0],[clip_triangle_len,0],[0,clip_triangle_len]]);
}

module clip_m() {
    union() {
        translate([0,clip_thickness,0])
        triangle_block();
        cube([clip_len, clip_thickness,clip_height]);
        translate([clip_len-(clip_height)/2,clip_thickness,clip_height/2])
        rotate([-90,0,0])
        difference() {
            cylinder(d=clip_diameter, h=clip_cylinder_len);
            translate([0,(clip_diameter)/2,0])
            rotate([-38,0,0])
            translate([-clip_height/2, -clip_height, 0])
            cube([clip_height,clip_height,clip_height]);
        }
    }
}


module clip_f() {
    translate([0,clip_thickness,0])
    difference() {
        rotate([0,0,90])
        triangle_block();
        translate([-clip_height/2,-0.01,clip_height/2])
        rotate([-90,0,0])
        cylinder(d=clip_diameter+clip_diameter_gap, 
                h=clip_cylinder_len+0.5);
    }
}

module hook() {
    rotate([-90,0,0])
    linear_extrude(height=hook_thickness, center=true)
    polygon(points=[
        [0,-1],
        [1,0],
        [hook_len-hook_nose_width-1,0],
        [hook_len-hook_nose_width,-1],
        [hook_len-hook_nose_width,-hook_nose_height],
        [hook_len,-hook_nose_height],
        [hook_len,0],
        [0,hook_len]]);
}

module press_fit_f() {
    difference() {
        translate([0,-clip_height/2,0])
        cube([clip_triangle_len, clip_height, clip_height]);
        
        translate([clip_triangle_len-press_fit_len,
            -press_fit_diameter/3/2,
            -0.01])
        cube([press_fit_len+0.01,press_fit_diameter/3,clip_height/2]);
        

        translate([clip_triangle_len-press_fit_len,0,clip_height/2])
        rotate([0,90,0])
        cylinder(d=press_fit_diameter,h=press_fit_len+0.01, $fn=64);
    }

    translate([0,clip_height/2,0])
    triangle_block();

    mirror([0,1,0])
    translate([0,clip_height/2,0])
    triangle_block();
}

module press_fit_m() {

    translate([-clip_len+clip_triangle_len,0,0])
    union() {
        translate([0.5-press_fit_len,-(press_fit_diameter/3-0.2)/2,0])
        cube([press_fit_len-0.5,press_fit_diameter/3-0.2,clip_height/2]);
        
        translate([0,0,clip_height/2])
        rotate([0,-90,0])
        cylinder(
            d1=press_fit_diameter, 
            d2=press_fit_diameter*0.95, 
            h=press_fit_len-0.5, $fn=6);
        
        translate([0,-clip_height/2,0])
        cube([clip_len-clip_triangle_len, clip_height, clip_height]);
        
        translate([clip_len-clip_triangle_len,clip_height/2,0])
        mirror([1,0,0])
        triangle_block();

        translate([clip_len-clip_triangle_len,-clip_height/2,0])
        rotate([0,0,180])
        triangle_block();
        
    }
}

module pure_wall() {
    difference() {
        union() {
            translate([-wall_thickness/2,0,0])
            cube([wall_thickness, wall_width, clip_height]);

            translate([wall_thickness/2,0,clip_height])
            rotate([0,-90,0])
            linear_extrude(height=wall_thickness)
            polygon(points=[
                [0,0],
                [0,wall_width],
                [wall_height-clip_height,wall_width/2+clip_height],
                [wall_height-clip_height,wall_width/2-clip_height]
            ]);


            
        }

        translate([wall_thickness,0,clip_height])
        rotate([0,-90,0])
        linear_extrude(height=wall_thickness*2)
        polygon(points=[
        [0,clip_triangle_len],
        [0,wall_width-clip_triangle_len],
        [wall_height-clip_height-clip_triangle_len,wall_width/2]
        ]);
    }
    
}


module wall(is_left=1, is_right=1) {
    union() {
        //translate([-wall_thickness/2,0,0])
        //cube([wall_thickness, wall_width, wall_height]);
        pure_wall();
        if ( is_right) {
            translate([wall_thickness/2,0,0])
            clip_m();

            translate([wall_thickness/2,wall_width,0])
            mirror([0,1,0])
            clip_m();

            translate([wall_thickness/2,wall_width/2,0])
            press_fit_f();
            
            translate([wall_thickness/2,
                    wall_width/2,
                    wall_height-hook_nose_height])            
            hook();
                      
        }

        if ( is_left) {

            translate([-wall_thickness/2,0,0])
            clip_f();

            translate([-wall_thickness/2,wall_width,0])
            mirror([0,1,0])
            clip_f();
            
            translate([-wall_thickness/2,wall_width/2,0])
            press_fit_m();
            
            mirror([1,0,0])
            translate([wall_thickness/2,
                    wall_width/2,
                    wall_height-hook_nose_height])
            hook();
            
        }
    }
}


//wall(1,1);

