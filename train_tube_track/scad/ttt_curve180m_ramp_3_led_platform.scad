/*

  ttt_curve180m_ramp_3_led_platform.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
  
  180 degree curve with Grove RGB LED holder
  
*/

include <train_tube_track.scad>;

module inner_curved180_terrain() {
    intersection() {
        translate([-32, -40, -outer_height/2])
        terrain(64, 7, 1, [1,1,1], [
            [64, 18, 20, height-1],
            [64, 0, 22, height-8],
            [44, 0, 32, height/2+2],
            [22, 10, 32, height/4],
            [22, 50, 32, -height/5],
            [50, 50, 20, -height/4]
            ]);

        translate([0, -eocstl, 0])
        union() {
            difference() {
                cylinder(r=grid-outer_width/2, 
                    h=height*3, center=true);
                
                translate([0,grid-outer_width/2,0])
                cube([2*grid-outer_width, 
                        2*grid-outer_width, 
                        height*3+d], center=true);
            }
            cube([2*grid-outer_width, eocstl*2+d, height*3],
                center=true);
        }
    }
}

module outer_curved180_terrain() {
    difference() {
        translate([-32+grid, -40, -outer_height/2])
        terrain(64, 7, height, [1,1,1], [
            [42,26,15,4], 
            [40,6,15,3] 
        ]);
        cylinder(r=grid+outer_width/2, h=height*4, center=true);
         translate([2*grid-grid/2+outer_width/2,-grid/2,0])
        cube([grid, grid+d, height*2], center=true);
        
        translate([grid+outer_width/2-1,0,-outer_height])
        cube([grid, grid, height*2]);

        translate([grid-5,7,-outer_height])
        cube([grid, grid, height*2]);
        
        
    }
}
module grove_led() {
    cylinder(d=12, h=3*height, center=true);
    grove_2x1(0,0,15);
}

difference() {
    union() {
        ttt_curved180m_ramp_3();
        mirror([0,1,0])
        inner_curved180_terrain();
    }
    mirror([0,1,0])
    rotate([0,0,20])
    translate([0,-grid*1.27,outer_height/2+5])
    rotate([90,0,0])
    grove_led();
}


mirror([0,1,0])
outer_curved180_terrain();

mirror([0,1,0])
translate([2*grid-grid/2+outer_width/2,-grid/2,0])
platform(bheight = 6, side_fix=4, is_base=true);


