/*

  shopping_cart_smartphone_holder.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
  
  8 Nov 2021 (https://github.com/olikraus/scad/issues/1)
    - Make cart clip side walls thicker (add 1 mm on both sides)
    - Increase height as suggested in the thingiverse comments (63-->65)
    
  16 Jan 2022
    - Increased stop champfer (4.6 --> 5.0)
    - Increased stability of cart holder stopper (extra big champfer)

*/


/* [basic] */

// Width (in mm) of the smartphone. Add 1 or more millimeters here.
smartphone_width = 83;

// Thickness (in mm) of the smartphone. Add 1 to 3 millimeters.
// This value must be between 13 and 20
smartphone_thickness = 14;

/* [advanced] */

// Height (in mm) of the shopping cart holder
height = 65;

// Diameter of the metal bar of the shopping cart
// Defaults to 11 mm
cart_grid_dia = 11;

// Wall width (in mm), should be thin enough to bend the material and thick enough to be stable
wall = 2;

// Extra width for the side walls of the card clip
// this can be between 0 and 2 mm
extra_wall_width = 1;

/* [expert] */


// Gap between the phone box and the cart clip. Half this value for each side. Also used for the joint axis.
phone_clip_gap = 1;

// Generic_chamfer (in mm), used for inner cut outs 
generic_chamfer = 1;

// Stop_chamfer / triangle which fixes the smartphone holder at a specific angle
stop_chamfer = 5.0;

// Small chamfer (in mm), which is used for some outside walls
mini_chamfer = 0.5;


/* [hidden] */

$fn=32;

extra_wall_radius = 4;


/* more or less derived values */
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


/*
  ChamferZCube(w=1,h=10)

  A cube, which can be used to chamfer along the z axis

  Args:
    w: The width of the cube is sqrt(2)*w
    h: Height of the cube
    d: The cube has a descent below z=0 plane and an ascent beyond h by this value
  Notes:
    The cube is centered around z-axsis and placed on z=0 plane.

*/
module ChamferZCube(w=1,h=10, d=0) {
  translate([0,0,h/2])
  rotate([0,0,45])
  cube([sqrt(2)*w,sqrt(2)*w,h+2*d], center=true);
}

module ChamferXCube(w=1,h=10, d=0) {
  rotate([45,0,0])
  cube([h+2*d,sqrt(2)*w,sqrt(2)*w], center=true);
}

module ChamferYCube(w=1,h=10, d=0) {
  rotate([0,45,0])
  cube([sqrt(2)*w,h+2*d,sqrt(2)*w], center=true);
}

/*
  CenterCube(dim, ChamferBody = 0, ChamferBottom=0, ChamferTop=0)

  A cube which is centered along z axis but is placed on z=0 plane
  Optionally allows chamfer along z axis.

  Args:
    dim: Same as for cube(dim)
    ChamferBody: The amount to chamfer for edges parallel to z axis
    ChamferBottom: The amount to chamfer for edges in z=0 plane
    ChamferTop: The amount to chamfer for edges in z=dim[2] plane
  Example:
    CenterCube([10, 20, 5]);

    // create a rectangle bowl
    // thanks to chamfer no support is required with 3d print
    difference() {  
      wallthickness=2;
      xwidth = 10;
      ywidth = 20;
      height = 5;
      CenterCube( 
        [xwidth+2*wallthickness, ywidth+2*wallthickness, height], 
        ChamferBottom = wallthickness);
      translate([0,0,wallthickness])
      CenterCube([xwidth,ywidth,height]);
    }

*/


module CenterCube(dim, ChamferBody = 0, ChamferBottom=0, ChamferTop=0) {
  difference() {
    translate([0,0,dim[2]/2])
    cube(dim, center=true);

    if ( ChamferBody > 0 ) {
      translate([dim[0]/2,dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);
      
      translate([-dim[0]/2,dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);

      translate([-dim[0]/2,-dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);

      translate([dim[0]/2,-dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);
    }
    
    if ( ChamferBottom > 0 )
    {
      translate([-dim[0]/2,0,0])
      ChamferYCube(w=ChamferBottom,h=dim[1],d=0.01);

      translate([dim[0]/2,0,0])
      ChamferYCube(w=ChamferBottom,h=dim[1],d=0.01);

      translate([0,-dim[1]/2,0])
      ChamferXCube(w=ChamferBottom,h=dim[0],d=0.01);

      translate([0,dim[1]/2,0])
      ChamferXCube(w=ChamferBottom,h=dim[0],d=0.01);
    }
    
    if ( ChamferTop > 0 )
    {
      translate([-dim[0]/2,0,dim[2]])
      ChamferYCube(w=ChamferTop,h=dim[1],d=0.01);

      translate([dim[0]/2,0,dim[2]])
      ChamferYCube(w=ChamferTop,h=dim[1],d=0.01);

      translate([0,-dim[1]/2,dim[2]])
      ChamferXCube(w=ChamferTop,h=dim[0],d=0.01);

      translate([0,dim[1]/2,dim[2]])
      ChamferXCube(w=ChamferTop,h=dim[0],d=0.01);
    }
    
  }
}

/*
  Archoid(r=10, b=20, l=30)

  A chest like element with a half cylinder on the top
  and a box as a base.
  If used with difference, the result is a archway.

  Args:
    r: Radius of the half-cylinder
    b: height of the base block
    l: length of the chest in x direction.
    $fn: resolution of the half cylinder
  Notes:
    The width of the chest is 2*r, the height is b+r.
    Archoid(r=10, b=20, l=30, $fn=4) becomes a house.

*/
module Archoid(r=10, b=20, l=30) {
  union() {
    translate([0,0,b])
    difference() {
      rotate([0,90,0])
      cylinder(r=r,h=l,center=true);
      translate([0,0,-r])
      cube([2*l,2*l,2*r], center=true);
    }
    translate([0,0,b/2])
    cube([l,2*r,b+0.01], center=true);
  }
}


/*
  TriangularPrism(bottom = [10,10], h=7, fh=0, fd=0)

  Args:
    buttom: Bottom square (width, height)
    h: Distance of the top square/peak to z=0 plane
    fh: front height (lowest x)
    fd: triangle peak as offset from the lowers x position
  Notes:
    The bottom square is placed in the z=0 plane.
    The square is centered around z axis.
  Example:
    TriangularPrism(bottom = [10,10], fh=0, h=7, fd=0);
      This is a ramp with, the triangle peak is at -5
    TriangularPrism(bottom = [10,10], fh=0, h=7, fd=5);
      A real triangular prism, the peak is at x=0
    TriangularPrism(bottom = [10,10], fh=7, h=7, fd=5);
      The ramp goes from x=5 to x=0.
      There is another top square from x=0 to x=-5
*/


module TriangularPrism(bottom = [10,10], h=7, fh=0, fd=0)
{
  lx = bottom[0];
  ly = bottom[1];
  p = [
    [ -lx/2, -ly/2,  0 ],  //0
    [ lx/2,  -ly/2,  0 ],  //1
    [ lx/2,  ly/2,  0 ],  //2
    [ -lx/2,  ly/2,  0 ],  //3
    [ -lx/2, -ly/2,  fh ],  //4
    [ -lx/2+fd,  -ly/2,  h ],  //5
    [ -lx/2+fd,  ly/2,  h ],  //6
    [ -lx/2,  ly/2,  fh ]]; //7
    
  f = [
    [0,1,2,3],  // bottom
    [4,5,1,0],  // front
    [7,6,5,4],  // top
    [5,6,2,1],  // right
    [6,7,3,2],  // back
    [7,4,0,3]]; // left
  polyhedron( p, f );
}

module copy_mirror(vec=[0,1,0]) {
    children();
    mirror(vec) 
    children();
} 

module phone_box() {
  translate([0,0,-axis_z])
  difference() {
    CenterCube([smartphone_width+2*wall, smartphone_thickness+2*wall, height],
      ChamferBody=mini_chamfer,ChamferTop=mini_chamfer);
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
    
    for( z=[5:6.5:(height-5)] ) {
      for( x=[-(smartphone_width-10)/2:(smartphone_width-10)/10:(smartphone_width-10)/2] ) {
        translate([x,smartphone_thickness/2,z])
        rotate([90,0,0])
        cylinder(d=5, h=wall*3, center=true, $fn=16);
      }
    }
    for( z=[5:6.5:(lhpb-5)] ) {
      for( x=[-(smartphone_width-10)/2:(smartphone_width-10)/10:(smartphone_width-10)/2] ) {
        translate([x,-smartphone_thickness/2,z])
        rotate([90,0,0])
        cylinder(d=5, h=wall*3, center=true, $fn=16);
      }
    }
  }
}


module cart_clip() {
  height_correction = 1;
  translate([0,0,-axis_z])
  union() {
    difference() {
      union() {
        difference() {
          /* not sure why, but the clip is a little bit to high, so remove 1 mm from height */
          CenterCube([smartphone_width+4*wall+2*extra_wall_width+phone_clip_gap, smartphone_thickness+2*wall, height-height_correction], ChamferTop=mini_chamfer);
          
          /* remove inner lower block */
          translate([0,0,-0.01])
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall, lhcc+0.02]);

          /* remove inner upper block */
          translate([0,5,lhcc+wall])
          /* generic_chamfer */
          /* generic_chamferBody = 0, generic_chamferBottom=0, generic_chamferTop=0 */
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall+10, height+0.02],
            ChamferBody = generic_chamfer, ChamferBottom=generic_chamfer+3, ChamferTop=generic_chamfer);
            
          /* remove full front wall */
          translate([0,smartphone_thickness-0.01,-0.01])
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall, height+0.02]);
          
          /* remove lower back wall */
          translate([0,+wall-smartphone_thickness,-height+lhcc])
          CenterCube([smartphone_width+2*wall+phone_clip_gap, smartphone_thickness+0*wall, height+0.02]);

          translate([0,generic_chamfer-smartphone_thickness+3,lhcc+wall])
          CenterCube([smartphone_width-16,smartphone_thickness, height-lhcc-cart_grid_dia ]);
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
        
      } // union
      
      /* Create slide in gap for phone_box */
      copy_mirror([1,0,0])
      translate([(smartphone_width)/2+wall-stop_chamfer/2+phone_clip_gap/2,wall,-0.01])
      CenterCube([stop_chamfer, smartphone_thickness+2*wall, height+0.02], ChamferBody=generic_chamfer);

      /* shopping cart connection */ 
      
      translate([0,-1,height-height*0.33-cart_grid_dia])
      Archoid(r=cart_grid_dia/2, b=height*0.3,l=smartphone_width+4*wall+2*extra_wall_width+phone_clip_gap+0.01);
      
      translate([0,-smartphone_thickness/2,height-height*0.33-cart_grid_dia])
      CenterCube([smartphone_width+4*wall+2*extra_wall_width+phone_clip_gap+0.01, smartphone_thickness+0*wall, 9]);
      
      /* remove the wall extra thickness from the lower part of the chart clip */ 

      copy_mirror([1,0,0])
      translate([-(smartphone_width+4*wall+phone_clip_gap+2*extra_wall_radius+2*extra_wall_width)/2+extra_wall_width,0,0])
      rotate([0,0,90])
      Archoid(r=extra_wall_radius, b=lhcc,l=smartphone_thickness+2*wall+0.01);
      
    }
    
    /* lower axis */
    
    difference() {
      /* phone_clip_gap/2 shift is an experimental value */
      translate([0,phone_clip_gap/2,axis_z+phone_clip_gap/2])
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
    
    /* upper enforcement */
    translate([0,-smartphone_thickness/2,height-2*wall-1])
    rotate([0,90,0])
    cylinder(r=wall, h=smartphone_width-4*wall, center=true);

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

