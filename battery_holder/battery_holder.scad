$fn=32;

include <base_objects.scad>


chamfer=1;
inner_length = 110;
inner_width = 40;
wall_extend = 5;
wall_height = 25;
plate_extend = 20;
plate_height = 5;

triangle_width = 7;
triangle_extend = plate_extend-wall_extend;
triangle_height = wall_height-plate_height;

screw_distance = 100;



module m4_cutout(height) {
    cylinder(d=7.66+0.3, h=height, $fn=6);
    translate([0,0,-height])
    cylinder(d=4+0.3, h=height*3, $fn=64);
}


module triangle_support() {
    translate([0,0,plate_height])
    TriangularPrism(bottom = [triangle_extend, triangle_width], h=triangle_height);
}

module bat_holder()
{
    difference() {
        union() {
            cube([inner_width+plate_extend, inner_length+plate_extend, plate_height]);
            cube([inner_width+wall_extend, inner_length+wall_extend, wall_height]);

        }
        translate([-0.01, -0.01, -0.01])
        cube([inner_width, inner_length, wall_height*2]);

        translate([0, 0, plate_height * 2/3])
        translate([inner_width+plate_extend/2,inner_length+plate_extend/2, 0])
        m4_cutout(wall_height);

        translate([0, 0, plate_height * 2/3])
        translate([inner_width+plate_extend/2,inner_length+plate_extend/2-screw_distance, 0])
        m4_cutout(wall_height);
        
    }

    translate([inner_width+wall_extend, chamfer*2, 0])
    translate([triangle_extend/2, triangle_width/2,0])
    triangle_support();

    translate([inner_width+wall_extend, inner_length-triangle_width+wall_extend-chamfer*2, 0])
    translate([triangle_extend/2, triangle_width/2,0])
    triangle_support();

    translate([chamfer*2, inner_length+wall_extend, 0])
    translate([triangle_width/2,triangle_extend/2,0])
    rotate([0,0,90])
    triangle_support();

    translate([inner_width -triangle_width+wall_extend-chamfer*2, inner_length+wall_extend, 0])
    translate([triangle_width/2,triangle_extend/2,0])
    rotate([0,0,90])
    triangle_support();
}

module front_holder()
{
    difference() {
        translate([0,-25,0])
        union() {
            cube([inner_width+plate_extend, 50, plate_height]);
            cube([inner_width+wall_extend, 50, wall_height]);

        }
        translate([-0.01, 8, -0.01])
        cube([inner_width, inner_length, wall_height*2]);
        translate([-0.01, -8-inner_length, -0.01])
        cube([inner_width, inner_length, wall_height*2]);

        translate([52,0,-10])
        cylinder(d=3.2, h=wall_height*2);
        
    }

    translate([inner_width+wall_extend, 15, 0])
    translate([triangle_extend/2, triangle_width/2,0])
    triangle_support();

    translate([inner_width+wall_extend, -15-triangle_width, 0])
    translate([triangle_extend/2, triangle_width/2,0])
    triangle_support();


}


/*
bat_holder();
translate([inner_width-5,plate_extend+5,0])
mirror([1,0,0]) 
bat_holder();
*/

front_holder();