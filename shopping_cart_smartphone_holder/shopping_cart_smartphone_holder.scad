/*

  shopping_cart_smartphone_holder.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

*/
include <base_objects.scad>;

$fn=32;

/* [basic] */

// Width of the smartphone. Add 2 or more millimeters here.
smartphone_width = 85;

// Thickness of the smartphone. Add 1 to 3 millimeters.
smartphone_thickness = 14;

/* [advanced] */

// Height of the shopping cart holder
height = 50;

// Wall width, should be thin enough to bend the material and thick enough to be stable
wall = 1.9;

// Gap between the phone box and the cart clip. Half this value for each side. Also used for the joint axis.
phone_clip_gap = 0.8;

// generic_chamfer
generic_chamfer = 1;

// stop_chamfer
stop_chamfer = 4;

// cart_grid_dia
cart_grid_dia = 11;

axis_dia = smartphone_thickness-5;  // diameter for the joint axis
axis_z = axis_dia/2+wall*2;  // position of the joint axis
lhcc = 20;    // lower height cart clip
lhpb = lhcc-wall*1.5;    // lower height phone box

/*
n = 3;
nstep = smartphone_width / n;
nfirst = nstep / 2;
nwidth = nstep - 10;
*/

module copy_mirror(vec=[0,1,0]) {
    children();
    mirror(vec) 
    children();
} 

module phone_box() {
  translate([0,0,-axis_z])
  difference() {
    CenterCube([smartphone_width+2*wall, smartphone_thickness+2*wall, height]);
    translate([0,0,wall])
    
    CenterCube([smartphone_width, smartphone_thickness, height],
              ChamferBody = generic_chamfer, ChamferBottom=generic_chamfer, ChamferTop=generic_chamfer
    );
    //translate([0,-wall-0.01,lh])
    //CenterCube([smartphone_width, smartphone_thickness, height]);

    translate([0,-wall+0.01-smartphone_thickness,lhpb])
    CenterCube([smartphone_width+2*wall+0.02, smartphone_thickness+2*wall, height]);
    translate([0,0,wall])

    translate([0,-wall+0.01-smartphone_thickness/2,lhpb-wall])
    CenterCube([smartphone_width, smartphone_thickness+2*wall, height]);
    translate([0,0,wall])
    
    translate([0,0,axis_z])
    rotate([0,90,0])
    cylinder(d=axis_dia, h=smartphone_width+2*wall+0.01, center=true);
    
    for( z=[5:(height-10)/6:(height-5)] ) {
      for( x=[-(smartphone_width-10)/2:(smartphone_width-10)/10:(smartphone_width-10)/2] ) {
        translate([x,smartphone_thickness/2,z])
        rotate([90,0,0])
        cylinder(d=5, h=wall*3, center=true, $fn=16);
      }
    }
    for( z=[5:(height-10)/6:(lhpb-5)] ) {
      for( x=[-(smartphone_width-10)/2:(smartphone_width-10)/10:(smartphone_width-10)/2] ) {
        translate([x,-smartphone_thickness/2,z])
        rotate([90,0,0])
        cylinder(d=5, h=wall*3, center=true, $fn=16);
      }
    }
  }
}


module cart_clip() {
  translate([0,0,-axis_z])
  union() {
    difference() {
      union() {
        difference() {
          CenterCube([smartphone_width+4*wall+phone_clip_gap, smartphone_thickness+2*wall, height]);
          
          /* remove inner lower block */
          translate([0,0,-0.01])
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall, lhcc+0.02]);

          /* remove inner upper block */
          translate([0,5,lhcc+wall])
          /* generic_chamfer */
          /* generic_chamferBody = 0, generic_chamferBottom=0, generic_chamferTop=0 */
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall+10, height+0.02],
            ChamferBody = generic_chamfer, ChamferBottom=generic_chamfer, ChamferTop=generic_chamfer);
            
          /* remove full front wall */
          translate([0,smartphone_thickness-0.01,-0.01])
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall, height+0.02]);
          
          /* remove lower back wall */
          translate([0,+wall-smartphone_thickness,-height+lhcc])
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall, height+0.02]);

          translate([0,generic_chamfer-smartphone_thickness,lhcc+wall])
          CenterCube([smartphone_width-20,smartphone_thickness, height-lhcc-cart_grid_dia ]);
          /*
          for( x=[nfirst:nstep:smartphone_width] ) {
            translate([x-smartphone_width/2,-smartphone_thickness/2-wall,0])
            cylinder(d=smartphone_thickness*1.5, h=height-cart_grid_dia-4+0.01);
            //CenterCube([nwidth, smartphone_thickness*1.2, height-cart_grid_dia-4+0.01]);
          }
          */
          
        }
        translate([0,smartphone_thickness/2-stop_chamfer/2,lhcc])
        rotate([180,0,0])
        rotate([0,0,90])
        TriangularPrism(bottom = [stop_chamfer,smartphone_width], h=stop_chamfer, fh=0, fd=stop_chamfer/2);

        
      }
      /* Create slide in gap for phone_box */
      copy_mirror([1,0,0])
      translate([(smartphone_width)/2+wall-stop_chamfer/2+phone_clip_gap/2,wall,-0.01])
      CenterCube([stop_chamfer, smartphone_thickness+2*wall, height+0.02], ChamferBody=generic_chamfer);

      /* shopping cart connection */ 
      /*
      translate([0,-1,height-cart_grid_dia+1])
      rotate([0,90,0])
      cylinder(d=cart_grid_dia, h=smartphone_width+4*wall+phone_clip_gap+0.01, center=true);
      */
      
      translate([0,-1,height-cart_grid_dia-cart_grid_dia+1])
      Archoid(r=cart_grid_dia/2, b=cart_grid_dia,l=smartphone_width+4*wall+phone_clip_gap+0.01);

      //translate([0,-1,height-cart_grid_dia])
      //rotate([180,0,0])
      //Archoid(r=cart_grid_dia/2, b=cart_grid_dia,l=smartphone_width+4*wall+phone_clip_gap+0.01);
      
      translate([0,-smartphone_thickness/2,height-cart_grid_dia-cart_grid_dia+1])
      CenterCube([smartphone_width+4*wall+phone_clip_gap+0.01, smartphone_thickness+0*wall, 9]);
    }
    /* lower axis */
    difference() {
      translate([0,0,axis_z])
      rotate([0,90,0])
      cylinder(d=axis_dia-phone_clip_gap, h=smartphone_width+4*wall+phone_clip_gap+0.01, center=true);
      
      translate([0,0,-0.01])
      CenterCube([smartphone_width-3, smartphone_thickness+0*wall, lhcc+0.02]);
      
      copy_mirror([1,0,0])
      translate([0,-(smartphone_thickness+2*wall)/2,(smartphone_thickness+2*wall)/2])
      rotate([-90,0,0])
      translate([smartphone_width/2-0.5,0,0])
      TriangularPrism(bottom = [4,smartphone_thickness+2*wall], h=smartphone_thickness+2*wall, fh=0, fd=0);
    }
  }
}


/*
difference() {
  union() {
    phone_box();
    rotate([37,0,0])
    cart_clip();
  }
  translate([-50,0,0])
  cube([50, 100, 100], center=true);
}
*/

translate([0,0,axis_z])
union() {
translate([0,1.7*smartphone_thickness,0])
phone_box();
  
translate([0,0,-(axis_z-(smartphone_thickness+2*wall)/2)])
rotate([90,0,0])
cart_clip();
}

