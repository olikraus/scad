/*

  smd_holder.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

*/

/* [basic] */

// basic diameter of all holders
dia = 20;

// diameter of the needle
needle_dia = 0.8;


/* [advanced] */

// height of the PCB holder
height = 30;

// PCB position above ground (must be lower then 'height')
pcb_height = 25;

// PCB cutout edge size
pcb_cutout = 4;

// height of the SMD holder without the arm height itself (which is dia/2)
smd_height = 40;

// smd part holder arm length */
arm_length = 50;

// screw diameter ring magnet
magnet_screw_dia = 2;

// screw diameter ring magnet
magnet_screw_height = 15;

// screw diameter for the screw, which will fix the needle
needle_screw_dia = 4;

needle_screw_head_dia = 7;

// nut size (diameter) of the screw, which will fix the needle
needle_nut_dia = 7.2;

needle_nut_height = 3.2;

chamfer = 1;

/* [expert] */

// segments per revolution
$fn=64;

/* [hidden] */

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


module pcb_holder() {
    /* campfer cylinder plate */
    translate([0,0,height-chamfer])
    intersection() {
      cylinder(d=dia, h=chamfer);
      cylinder(d1=dia, d2=0, h=(dia)/2);
    }
    
  difference() {
    cylinder(d=dia, h=height-chamfer);
    
    /* cutout for magnet screw */
    cylinder(d=magnet_screw_dia, h=magnet_screw_height);
    
    /* cutout for PCB */
    translate([0,-dia*0.52,pcb_height])
    rotate([45,0,0])
    cube([dia, pcb_cutout, pcb_cutout], center=true);
  };
};

module smd_holder() {
  union() {
    /* campfer cylinder plate */
    translate([0,0,smd_height+dia/2-chamfer])
    intersection() {
      cylinder(d=dia, h=chamfer);
      cylinder(d1=dia, d2=0, h=(dia)/2);
    }
    
    translate([0,-dia/3,smd_height])
    rotate([45,0,0])
    cube([dia/3, dia*sqrt(2)/2, dia*sqrt(2)/2], center=true);

    difference() {
      /* body (without campfer plate */
      cylinder(d=dia, h=smd_height+dia/2-chamfer);

      /* cutout for magnet screw */
      cylinder(d=magnet_screw_dia, h=magnet_screw_height);
    }

    /* 0.8: move arm and cylinder a little bit together: this will look better */
    translate([0, -arm_length/2+0.8, smd_height])
    difference() {
      CenterCube([dia, arm_length, dia/2], ChamferBody=chamfer, ChamferBottom=chamfer, ChamferTop=chamfer);

      translate([-needle_dia/2,-arm_length/2-dia,-1])
      cube([needle_dia, arm_length, dia/2+2]);
      
      // gap
      translate([0, -arm_length/2+dia/4, dia/4])
      rotate([0,90,0])
      cylinder(d=needle_screw_dia, h=dia+2, center=true);

      // cutout for the needle
      translate([0,-arm_length/2+dia/2,-dia/4])
      rotate([0,0,45])
      CenterCube([needle_dia*1.4,needle_dia*1.4,dia]);

      translate([dia/2-needle_nut_height/2+0.01, -arm_length/2+dia/4, dia/4])
      rotate([0,90,0])
      cylinder(d=needle_nut_dia, h=needle_nut_height, center=true, $fn=6); // m=3.2 DIN 934 

      translate([-dia/2+needle_nut_height/2-0.01, -arm_length/2+dia/4, dia/4])
      rotate([0,90,0])
      cylinder(d=needle_nut_dia, h=needle_nut_height, center=true); // m=3.2 DIN 934 
      
    }
  }
}

/* print all parts */

translate([0,0,smd_height+dia/2])
rotate([0,180,0])
smd_holder();

translate([dia*2, 0, 0])
pcb_holder();

translate([dia*2, -dia*2, 0])
pcb_holder();

