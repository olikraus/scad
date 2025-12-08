include <base_objects.scad>


/*
  ideen: 
  Befestigung mit Rampamuffe / Einschraubmutter
  
  8 dec 2026: 25mm -> 30mm
*/

$fn=256;

arc_outer_height = 200;  // height of the arc
arc_outer_width = 220; // total outer width of the arc
arc_depth = 10;     // depth of the arc (not used for the tempate)
arc_thickness = 30;

milling_gap = 4.5;
milling_extension = 9; // thinkness of the template for the milling copy (Überstand Kopierhülse)
template_extra_size= 5;
template_target_extend = 9;     // height to hold the wood arc, should ca half the wood arc thinkness

/*
module ellipsoid(rx=30, ry=20, rz=10, $fn=100) {
    scale([rx, ry, rz]) sphere(r=1, $fn=$fn);
}
*/

/*
    h: Height of the arc
    w: base width of the arc
    z: thickness of the arc (z-axis), default: 1
    o: extra offset on height and width, default: 0
    
*/
module solid_arc(h=20, w=10, z=1, o=0) {
    difference() {
        scale([w/2+o,h+o, 1])
        cylinder(r=1,h=z, $fn=256);
        translate([0,0,-0.02])
        scale([2,2,2])
        translate([-w/2-o,-h-o,0])
        cube([w+o*2,h+o,z]);
    }
}


/*
  no need to print this part, this is just to see how it could look like
*/
module wood_arc() {
    difference() {
        solid_arc(w=arc_outer_width, h=arc_outer_height, z=arc_depth, o=0);
        translate([0,-0.01,-0.01])
        solid_arc(w=arc_outer_width, h=arc_outer_height, z=arc_depth+0.02, o=-arc_thickness);
    }
}

/*    
    M3: headdia=6, headheight=4
    M4: headdia=8, headheight=5
*/
module m3cut() {
    let(d=3, hd=d*2.3) {
        union() {
            cylinder(d1=d, d2=hd, h=(hd-d)/2);
            
            translate([0,0,(hd-d)/2-0.005])
            cylinder(d=hd, h=milling_extension);
            
            translate([0,0,-milling_extension*2])
            cylinder(d=3, h=milling_extension*4);
        }
    }
}


/*
    turn around template_1 and mill around the edges. 
    The lower ruler has to be placed at the edge of the wood
*/
module template_1() {
    let (r=30) {
        difference() {
            union() {
                solid_arc(w=arc_outer_width, h=arc_outer_height, z=milling_extension, o=-milling_gap);
                translate([(-arc_outer_width+milling_gap*2)/2, -r,0])
                cube([arc_outer_width-milling_gap*2, r, milling_extension+template_target_extend]);
            }

            translate([0,0,milling_extension])
            rotate([0,180,0]) {
                translate([ arc_outer_width*0.2, arc_outer_height*0.2,milling_extension/2])
                m3cut();
                translate([ -arc_outer_width*0.2, arc_outer_height*0.2,milling_extension/2])
                m3cut();
                translate([ 0, arc_outer_height*0.6,milling_extension/2])
                m3cut();
            }
        }
    }
}

module template_2() {
    difference() {
      translate([-(arc_outer_width+template_extra_size*2)/2,-template_extra_size,0])
      cube([arc_outer_width+template_extra_size*2,arc_outer_height+template_extra_size*2,milling_extension+template_target_extend]);
      
      translate([0,-0.01,-0.01])
      solid_arc(w=arc_outer_width, h=arc_outer_height, z=milling_extension+0.02, o=-arc_thickness+milling_gap);
      translate([0,-0.01,milling_extension])
      solid_arc(w=arc_outer_width, h=arc_outer_height, z=milling_extension+0.02, o=0);
      //wood_arc();
      translate([-(arc_outer_width-arc_thickness*2+milling_gap*2)/2,-template_extra_size*2-0.01,-0.01])
      cube([arc_outer_width-arc_thickness*2+milling_gap*2, template_extra_size*2+0.02, 2*milling_extension+0.02]);
        
      translate([0,0,milling_extension+template_target_extend])
      rotate([0,45,0])
      translate([-3,0,-3])
      cube([6,arc_outer_height*3, 6]);

      translate([arc_outer_width/2*0.9, arc_outer_height*0.9, 7])
      rotate([180,0,0])
      m3cut();

      translate([-arc_outer_width/2*0.9, arc_outer_height*0.9, 7])
      rotate([180,0,0])
      m3cut();

      translate([arc_outer_width/2*0.98, arc_outer_height*0.4, 7])
      rotate([180,0,0])
      m3cut();

      translate([-arc_outer_width/2*0.98, arc_outer_height*0.4, 7])
      rotate([180,0,0])
      m3cut();

      translate([-(arc_outer_width-arc_thickness)/2,-arc_outer_height*0.1,milling_extension+template_target_extend])
      rotate([0,45,0])
      translate([-3,0,-3])
      cube([6,arc_outer_height*0.2, 6]);

      translate([+(arc_outer_width-arc_thickness)/2,-arc_outer_height*0.1,milling_extension+template_target_extend])
      rotate([0,45,0])
      translate([-3,0,-3])
      cube([6,arc_outer_height*0.2, 6]);

    }
}

/*
translate([0,0,40])
wood_arc();
template_2();
*/


