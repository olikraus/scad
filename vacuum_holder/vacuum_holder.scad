/*

    vacuum holder

    arch pillar base more wider arch_dia 16->14
    frame_insulation_wall 2-->4

*/

include <base_objects.scad>;


$fn=16;

arch_dist = 20;
arch_dia = 14;
arch_wall = arch_dist-arch_dia;
arch_h = 8;    // must be > arch_dia/2

vac_x_size = arch_dist*3;
vac_y_size = arch_dist*5;

frame_insulation_wall = 4;
frame_insulation_width = 10;
frame_insulation_height = 4;
frame_w = frame_insulation_wall*2+frame_insulation_width;

hose_dia = 34.6;
hose_wall = 3;
hose_h = 30; 

module arch_hall($fn=$fn) {
    difference() {
        union() {
            intersection()
            {
                CenterCube([vac_x_size, vac_y_size,arch_h]);            
                union() {
                    for( i = [ 0 : vac_y_size/arch_dist/2 ] ) {
                        CopyMirror([0,1,0])
                        translate([0, i*arch_dist+arch_dist/2, 0])
                        CenterCube([vac_x_size,arch_wall,arch_h]);
                    }
                    for( i = [ 0 : vac_x_size/arch_dist/2 ] ) {
                        CopyMirror([1,0,0])
                        translate([i*arch_dist+arch_dist/2, 0, 0])
                        CenterCube([arch_wall, vac_y_size,arch_h]);
                    }
                }
            }
        }

        for( i = [ 0 : vac_x_size/arch_dist/2 ] ) {
            CopyMirror([1,0,0])
            translate([i*arch_dist, vac_y_size/2+0.01, 0])
            rotate([90,0,0])
            cylinder( d=arch_dia, h = vac_y_size+0.02 );
        }

        for( i = [ 0: vac_y_size/arch_dist/2 ] ) {
            CopyMirror([0,1,0])
            translate([-vac_x_size/2-0.01, i*arch_dist, 0])
            rotate([0,90,0])
            cylinder( d=arch_dia, h = vac_x_size+0.02 );
        }
    }
}

module arch_frame() {
    difference() {
        CenterCube([vac_x_size+2*frame_w, vac_y_size+2*frame_w,arch_h]);

        translate([0,0,-0.01])
        CenterCube([vac_x_size-0.02, vac_y_size-0.02, arch_h+0.02]);
        
        CopyMirror([0,1,0])
        translate([0,(vac_y_size+frame_w)/2,-0.01])
        CenterCube([vac_x_size+2*frame_w-2*frame_insulation_wall, frame_insulation_width,frame_insulation_height]);

        CopyMirror([1,0,0])
        translate([(vac_x_size+frame_w)/2,0,-0.01])
        CenterCube([frame_insulation_width,vac_y_size+2*frame_w-2*frame_insulation_wall, frame_insulation_height]);
          
    }
}


//translate([0,0,arch_h+2]);
module lid($fn=$fn) {
    union() {
        difference() {
            CenterCube([vac_x_size+2*frame_w, vac_y_size+2*frame_w,2]);
            translate([0,0,-0.01])
            CenterCube([arch_dist-arch_wall, arch_dist-arch_wall,2+0.02]);
        }
        difference()
        {
            union() {
                cylinder(d=hose_dia+hose_wall*2, h=hose_h);
                cylinder(d1=hose_dia+hose_wall*2+8*2, d2=hose_dia+hose_wall*2, h=8);
            }
            translate([0,0,-0.01])
            cylinder(d=hose_dia, h=hose_h+0.02);
        }
    }
}

arch_hall($fn=4);
arch_frame();
translate([0,0,arch_h])
lid($fn=128);
