/*

    pumpcart case

    issues
        100U doesn't fit --> not fixed

*/


$fn=64;

module rounded_cube_centered(dims, r) {
    
    // Safety check: radius cannot exceed half of the smallest dimension
    max_r = min(dims.x, dims.y, dims.z) / 2;
    actual_r = min(r, max_r);
    
    x_off = dims.x / 2 - actual_r;
    y_off = dims.y / 2 - actual_r;
    z_bot = actual_r;
    z_top = dims.z - actual_r;

    hull() {
        // Bottom 4 spheres
        translate([-x_off, -y_off, z_bot]) sphere(r = actual_r);
        translate([ x_off, -y_off, z_bot]) sphere(r = actual_r);
        translate([-x_off,  y_off, z_bot]) sphere(r = actual_r);
        translate([ x_off,  y_off, z_bot]) sphere(r = actual_r);

        // Top 4 spheres
        translate([-x_off, -y_off, z_top]) sphere(r = actual_r);
        translate([ x_off, -y_off, z_top]) sphere(r = actual_r);
        translate([-x_off,  y_off, z_top]) sphere(r = actual_r);
        translate([ x_off,  y_off, z_top]) sphere(r = actual_r);
    }
}


// Usage: [width, depth, height], radius, smoothness
//rounded_cube_centered([40, 20, 15], 5, $fn=128);

// len=44.1
module pumpcart() {
    rotate([0,90,0])
    union() {
        translate([0,0,6])
        cylinder(d=11, h=38.1);
        cylinder(d=8, h=6.001);
    }
}

module aaa() {
    rotate([0,90,0])
    cylinder(d=10.1, h=44);
}

// w=20, len=102, d=11.3
module u10030()
{
    rotate([0,90,0])
    union() {
        cylinder(h=102, d=5);
        cylinder(h=27, d=8.0);
        
        translate([0,0,102-20.1])
        cylinder(h=20.1, d=11.3);
        // h=2.3
        translate([-4, -10,102-20.1-2.3+0.001])
        cube([8,20,2.3]);
    }
}

//u10030();

case_length = 116;
case_width = 22;  // u100 should fit
case_height = 16.4;
case_edge_radius = 4;
case_wall = 1.4;
u100_lift = 6+case_wall;
aaa_lift = 16;

difference() {
    intersection() {
        translate([case_length/2,0,0])
        rounded_cube_centered([case_length,case_width,case_height*2], case_edge_radius);
        translate([0,-case_width/2,0])
        cube([case_length,case_width,case_height]);
    }
    

    // cutout for the upper part of the u100
    intersection() {
        translate([case_length-case_wall-22.4,-20,0])   // 22.4 = 20.1+2.3
        cube([40,40,40]);
        translate([(case_length-case_wall*2)/2+case_wall,0,case_wall+5.5])
        rounded_cube_centered([case_length-case_wall*2,case_width-case_wall*2,case_height*2],   case_edge_radius);
    }

    // u100 is right adjusted to the case wall
    translate([case_length-102-case_wall, 0, u100_lift])
    u10030();

    //translate([(case_length-case_wall*2)/2+case_wall,0,case_wall+4.5])
    //rounded_cube_centered([case_length-case_wall*2,8,case_height*2], case_edge_radius);
    
    //translate([case_wall,-4,case_wall+5.5])
    //cube([case_length-case_wall*2,8,case_height*2]);


    
    //translate([(case_length-case_wall*2)/2+case_wall,0,case_wall+5])
    //rounded_cube_centered([case_length-case_wall*2,case_width-case_wall*2,case_height*2], //case_edge_radius);
    
    translate([case_wall,-5/2,u100_lift])
    cube([case_length-case_wall*2,5,40]);

    translate([case_wall,-8/2,u100_lift])
    cube([44,8,40]);

       
    translate([case_wall,0,aaa_lift])
    aaa();

    translate([case_wall+45.4,0,aaa_lift])
    pumpcart();

}


