

triangle_height = 14;
f = 1.8;

dove_inner_r = 10*f;
dove_h = 5;
dove_lower_w = 15*f;
dove_upper_w = 11*f;

module dove_ring(gap=0) {
        let( pts = [
         [0+dove_inner_r+gap+gap*0.5,                   gap*0.5],
         [dove_lower_w+dove_inner_r-gap-gap*1.3,    gap*0.5],
         /*[dove_lower_w-(dove_lower_w-dove_upper_w)/2+dove_inner_r-gap, dove_h-gap],*/
         [dove_lower_w-(dove_lower_w-dove_upper_w)/2+dove_inner_r-gap*1.3, dove_h],
         [0+dove_inner_r+gap*0.5, dove_h]
        ]) {
        //translate([0,0,gap])
        rotate_extrude(convexity = 10, $fn = 128)
            polygon(pts);
        }
}

module upper_triangle() {
    intersection() {
        dove_ring(0.3);
        cylinder(h=dove_h, r=dove_inner_r+dove_lower_w*1.5, $fn=3);
    }
    
    translate([0,0,dove_h])
    cylinder(h=(triangle_height-dove_h)/2, r=dove_inner_r+dove_lower_w*1.5, $fn=3);
}

module lower_triangle() {
    difference() {
        cylinder(h=(triangle_height-dove_h)/2+dove_h-0.01, r=dove_inner_r+dove_lower_w*1.5, $fn=3);
        translate([0,0,(triangle_height-dove_h)/2])
        dove_ring(0);
    }
}

/*
translate([0,0,(triangle_height-dove_h)/2])
upper_triangle();
lower_triangle();
*/

translate([dove_inner_r+dove_lower_w*1.5+12, 0, 0])
lower_triangle();
translate([0,0,(triangle_height-dove_h)/2+dove_h])
rotate([0,180,0])
upper_triangle();

