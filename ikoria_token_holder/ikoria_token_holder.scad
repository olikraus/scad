/*
    Ikoria Token Holder (ith)
    
    Intended for the octagon paper ikoria tokens
*/

$fn=128;


/* edge to edge diameter of the ikoria paper tokens */
ikoria_token_diameter = 20;
/* diameter of the token holder */
/* must be larger than ikoria_token_diameter */
ith_outer_diameter = 26.4;
/* inner visible hole */
/* must be smaller than ikoria_token_diameter */
ith_inner_diameter = 17;

/* height definitions for the token holder */
ith_h3 = 1.0;            /* height of the upper lid */
ith_h2 = 0.7;            /* hupper press fit height */
ith_h1 = 0.5;            /* height of the MTG paper token */
ith_h0 = ith_h2+ith_h3;  /* bottom height */
ith_gap=-0.2;            /* -0.1: soft fit, -0.2 strong fit */
ith_overlap_height = 1.2;  /* lower press fit height */

ith_lower_wall_thickness=0.8;


/* internal values */
ith_middle_diameter = 
    ith_outer_diameter-ith_lower_wall_thickness*2;
ith_overlap_thickness = 1.5;
ith_overlap_gap=0.3; /* inner gap */

module ith_lower() {
    difference() {
        cylinder(h=ith_h0+ith_h1+ith_h2, d=ith_outer_diameter);
        translate([0,0,ith_h0])
        cylinder(h=ith_h1+ith_h2+0.01, d=ikoria_token_diameter, $fn=8);
        
        translate([0,0,ith_h0+ith_h1])
        cylinder(h=ith_h2+0.01, d=ith_middle_diameter);
        
        translate([0,0,-0.01])
        cylinder(h=ith_h0+ith_h1+0.02, d=ith_inner_diameter);

        translate([0,0,-0.001])
        cylinder(h=2*ith_h0/3, 
            d1=ith_inner_diameter+3, 
            d2=ith_inner_diameter);

        /* 0.3 is an extra gap between lower and upper part*/
        translate([0,0,ith_h0+ith_h1-ith_overlap_height-0.3+0.001])
        difference() {
            cylinder(h=ith_overlap_height+0.3, 
                d=ith_middle_diameter);
            translate([0,0,-0.01])
            cylinder(h=ith_h2+ith_overlap_height+0.3+0.02, 
                d=ith_middle_diameter
                    -ith_overlap_thickness*2
                    -ith_overlap_gap*2);
            
        }
        
    }


}


module ith_upper() {
    
    translate([0,0,ith_h2+ith_h3+ith_overlap_height])
    rotate([180,0,0])
    difference() {
        
        union() {
            intersection() {
                
                cylinder(h=ith_h2+ith_overlap_height+0.01, 
                    d=ith_middle_diameter-2*ith_gap, $fn=8);

                translate([0,0,-ith_h2*1.0])
                cylinder(h=ith_h2*2+ith_overlap_height, 
                    d1=ith_middle_diameter-ith_h2
                        -0.5-ith_gap*2, 
                    d2=ith_middle_diameter+ith_h2
                        -0.5-ith_gap*2+ith_overlap_height);
            }
            translate([0,0,ith_h2+ith_overlap_height])
                cylinder(h=ith_h3, d=ith_outer_diameter);
        }
        /* inner hole */
        translate([0,0,-0.01])
        cylinder(h=ith_h2+ith_h3+ith_overlap_height+0.02, 
            d=ith_inner_diameter);

        /* inner hole, overlap with lower part */
        translate([0,0,-0.01])
        cylinder(h=ith_overlap_height, 
            d=ith_middle_diameter-ith_overlap_thickness*2);
        
        /* visibility cutout */
        translate([0,0,ith_h2+ith_h3+ith_overlap_height+0.001])
        rotate([180,0,0])
        cylinder(h=2*ith_h0/3, 
            d1=ith_inner_diameter+3, 
            d2=ith_inner_diameter);
    }
}

/*
difference() {
    union() {
        ith_lower();
        //translate([ith_outer_diameter+5, 0, 0])
        translate([0, 0, 10])
        ith_upper();
    }
    translate([0,-50,-0.01])
    cube([50,50,50]);
}
*/

ith_lower();
translate([ith_outer_diameter+5, 0, 0])
ith_upper();
