/*

  base_objects.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  SquareFrustum(bottom=[10,10], top=[0,0], h=10, ChamferBody=1)
  CenterCube(dim, ChamferBody = 0, ChamferBottom=0, ChamferTop=0)
  CenterCylinder(Height=10, Radius=5, ChamferBottom=0, ChamferTop=0)
  RoundCenterCube(dim, Radius=0, ChamferBottom=0, ChamferTop=0)
  Archoid(r=10, b=20, l=30)
  TriangularPrism(bottom = [10,10], h=7, fh=0, fd=0)
  
  CopyMirror(vec=[0,1,0])

*/


/*
  SquareFrustum(bottom=[10,10], top=[0,0], h=10)
  https://en.wikipedia.org/wiki/Frustum
  
  Args:
    buttom: Bottom square (width, height)
    top: Top square (width, height)
    h: Distance of the top square to z=0 plane
    ChamferBody: The amount to chamfer for edges parallel to z axis
  Notes:
    The bottom square is placed in the z=0 plane.
    The squares are centered around z axis.
  Example:
    SquareFrustum([20,20], [10,4], h=20);
    

    // create a rectangle bowl
    // same example as for CenterCube
    // SquareFrustum might be more flexible because it is not
    // restricted to the 45 degree chamfer
    
    union() {
      wallthickness=2;
      xwidth = 10;
      ywidth = 20;
      height = 5;
      translate([0,0,wallthickness])
      difference() {
        CenterCube([xwidth+2*wallthickness,ywidth+2*wallthickness,5-wallthickness]);
        CenterCube([xwidth,ywidth,5-wallthickness+0.01]);
      }    
      SquareFrustum(
        bottom=[xwidth,ywidth], 
        top=[xwidth+2*wallthickness,ywidth+2*wallthickness], 
        h=wallthickness);
    }
    
*/
module SquareFrustum_old(bottom=[10,10], top=[0,0], h=10) {
  lx = bottom[0];
  ly = bottom[1];
  ux = top[0];
  uy = top[1];
  p = [
    [ -lx/2, -ly/2,  0 ],  //0
    [ lx/2,  -ly/2,  0 ],  //1
    [ lx/2,  ly/2,  0 ],  //2
    [ -lx/2,  ly/2,  0 ],  //3
    [ -ux/2, -uy/2,  h ],  //4
    [ ux/2,  -uy/2,  h ],  //5
    [ ux/2,  uy/2,  h ],  //6
    [ -ux/2,  uy/2,  h ]]; //7
    
  f = [
    [0,1,2,3],  // bottom
    [4,5,1,0],  // front
    [7,6,5,4],  // top
    [5,6,2,1],  // right
    [6,7,3,2],  // back
    [7,4,0,3]]; // left
  polyhedron( p, f );
}

module SquareFrustum(bottom=[10,10], top=[0,0], h=10, ChamferBody=0) {
  c = ChamferBody/2;
  lx = bottom[0]-2*c;
  ly = bottom[1]-2*c;
  ux = top[0]-2*c;
  uy = top[1]-2*c;
  p = [
    [ -lx/2-c, -ly/2+c,  0 ],  //0 / 0, 0
    [ -lx/2+c, -ly/2-c,  0 ],  //0 / 1, 1
  
    [ lx/2-c,  -ly/2-c,  0 ],  //1 / 0, 2
    [ lx/2+c,  -ly/2+c,  0 ],  //1 / 1, 3
  
    [ lx/2+c,  ly/2-c,  0 ],  //2 / 0, 4
    [ lx/2-c,  ly/2+c,  0 ],  //2 / 1, 5
  
    [ -lx/2+c,  ly/2+c,  0 ],  //3 / 0, 6
    [ -lx/2-c,  ly/2-c,  0 ],  //3 / 1, 7
  
    [ -ux/2-c, -uy/2+c,  h ],  //4 / 0, 8
    [ -ux/2+c, -uy/2-c,  h ],  //4 / 1, 9
  
    [ ux/2-c,  -uy/2-c,  h ],  //5 / 0, 10
    [ ux/2+c,  -uy/2+c,  h ],  //5 / 1, 11
 
    [ ux/2+c,  uy/2-c,  h ],  //6 / 0, 12
    [ ux/2-c,  uy/2+c,  h ],  //6 / 1, 13
    
    [ -ux/2+c,  uy/2+c,  h ], //7 / 0, 14
    [ -ux/2-c,  uy/2-c,  h ]]; //7 / 1, 15
    
  f = [
    [0,1,2,3,4,5,6,7],  // bottom
    [8,9,1,0], // front left
    [9,10,2,1],  // front 
    [10,11,3,2], // front right
    [15,14,13,12,11,10,9,8],  // top
    [11,12,4,3],  // right
    [12,13,5,4],  // back right
    [13,14,6,5],  // back
    [14,15,7,6], // back left
    [15,8,0,7]]; // left
  polyhedron( p, f );
}


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
  CenterCylinder(Height=10, Radius=5, ChamferBottom=0, ChamferTop=0)

  A cylinder which is centered along z axis but is placed on z=0 plane
  Optionally allows chamfer along z axis (like the standard cylinder 
  object).
  Unlike the cylinder object, this element allows buttom and top chamfer.
  
  Preconditions:
    The Height must be equal or larger than ChamferBottom+ChamferTop
    The Radius must be equal or larger than ChamferBottom
    The Radius must be equal or larger than ChamferTop
  
  Args:
    height: Height of the cylinder
    dia:  Diameter of the cylinder
    ChamferBottom: The amount to chamfer for edges in z=0 plane
    ChamferTop: The amount to chamfer for edges in z=dim[2] plane
  Example:
    CenterCylinder(height=10, dia=10, ChamferBottom=1, ChamferTop=1);
*/
module CenterCylinder(Height=10, Radius=5, ChamferBottom=0, ChamferTop=0) {
  
  if ( ChamferBottom > Radius ) {
    echo(str("CenterCylinder Error: ChamferBottom=", ChamferBottom, " larger than Radius=", Radius));
  }
  if ( ChamferTop > Radius ) {
    echo(str("CenterCylinder Error: ChamferTop=", ChamferTop, " larger than Radius=", Radius));
  }
  if ( Height < ChamferBottom+ChamferTop ) {
    echo(str("CenterCylinder Error: Height (z-Size)=", Height, " is smaller than ChamferTop=", ChamferTop, "+ChamferBottom=", ChamferBottom));
  }
  
  union() {
    // top part
    if ( ChamferTop != 0 ) {
      translate([0,0,Height-ChamferTop])
      cylinder(h=ChamferTop,d1=2*Radius, d2=2*Radius-2*ChamferTop);
    }
    
    // middle part 
    if ( Height-ChamferTop-ChamferBottom > 0 ) {
      translate([0,0,ChamferBottom-0.001])
      cylinder(h=Height-ChamferTop-ChamferBottom+0.002, d=2*Radius);
    }
    // bottom part
    if ( ChamferBottom != 0 ) {
      cylinder(h=ChamferBottom,d2=2*Radius, d1=2*Radius-2*ChamferBottom);
    }
  }
}

/*

  RoundCenterCube(dim, Radius=0, ChamferBottom=0, ChamferTop=0)

  Similar to CenterCube, but has round body edges (instead of 
  ChamferBody). "dim" is a vector with x, y and z length, which
  describes the outer cube. 
  
  Chamfer must be equal or smaller than Radius
  x and y size must be larger or equal to 2*Radius  

  if x and y size are equal to 2*Radius, then element 
  will become a CenterCylinder()

  Preconditions:
    The Radius must be equal or larger than ChamferBottom
    The Radius must be equal or larger than ChamferTop
    dim[0] must be greater or equal to 2*Radius
    dim[1] must be greater or equal to 2*Radius
    dim[2] must be equal or larger than ChamferBottom+ChamferTop

  Args:
    dim: Size of the outer cube
    Radius: Body radius
    ChamferBottom: Bottom chamfer size
    ChamferTop: Top chamfer size
    
  Examples:
    RoundCenterCube([x,y,z]) --> Same as CenterCube
    
    r = 4;
    RoundCenterCube([2*r,2*r,6], Radius=r) --> Cylinder with Radius r and height 6
    
    r = 4;
    RoundCenterCube([2*r,2*r+2,6], Radius=r) --> 10x8 Oval 
    
*/

module RoundCenterCube(dim, Radius=0, ChamferBottom=0, ChamferTop=0)
{
  /* argument checks */
  
  if ( ChamferBottom > Radius ) {
    echo(str("RoundCenterCube Error: ChamferBottom=", ChamferBottom, " larger than Radius=", Radius));
  }
  if ( ChamferTop > Radius ) {
    echo(str("RoundCenterCube Error: ChamferTop=", ChamferTop, " larger than Radius=", Radius));
  }

  if ( dim[0] < 2*Radius ) {
    echo(str("RoundCenterCube Error: X-Size=", dim[0], " is smaller than 2*Radius=", 2*Radius));
  }
  if ( dim[1] < 2*Radius ) {
    echo(str("RoundCenterCube Error: Y-Size=", dim[1], " is smaller than 2*Radius=", 2*Radius));
  }
  
  if ( dim[2] < ChamferBottom+ChamferTop ) {
    echo(str("RoundCenterCube Error: Height (z-Size)=", dim[2], " is smaller than ChamferTop=", ChamferTop, "+ChamferBottom=", ChamferBottom));
  }

  /* check whether this is a simple cylinder */
  
  if ( dim[0] <= 2*Radius && dim[1] <= 2*Radius ) {
    CenterCylinder(Height=dim[2], Radius=Radius, ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
  }
  else
  {  
    union() {
      if ( dim[0]/2-Radius == 0 ) {
        translate([0, dim[1]/2-Radius])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
        translate([0, -dim[1]/2+Radius])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
      }
      else if (dim[1]/2+Radius == 0) {
        translate([dim[0]/2-Radius, 0])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
        translate([-dim[0]/2+Radius, 0])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
      }
      else
      {
        translate([dim[0]/2-Radius, dim[1]/2-Radius])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
        translate([-dim[0]/2+Radius, dim[1]/2-Radius])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
        translate([dim[0]/2-Radius, -dim[1]/2+Radius])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
        translate([-dim[0]/2+Radius, -dim[1]/2+Radius])
        CenterCylinder(Radius=Radius, Height=dim[2], ChamferBottom=ChamferBottom, ChamferTop=ChamferTop);
      }

      if ( dim[0] > 2*Radius ) {
        difference() {
          translate([0,0,dim[2]/2])
          cube([dim[0]-2*Radius, dim[1], dim[2]], center=true);
          
          if ( ChamferTop > 0 )
          {

            translate([0,-dim[1]/2,dim[2]])
            ChamferXCube(w=ChamferTop,h=dim[0],d=0.01);

            translate([0,dim[1]/2,dim[2]])
            ChamferXCube(w=ChamferTop,h=dim[0],d=0.01);
          }
          if ( ChamferBottom > 0 )
          {
            translate([0,-dim[1]/2,0])
            ChamferXCube(w=ChamferBottom,h=dim[0],d=0.01);

            translate([0,dim[1]/2,0])
            ChamferXCube(w=ChamferBottom,h=dim[0],d=0.01);
          }
        }
      }
      if ( dim[1] > 2*Radius ) {
        difference() {
          translate([0,0,dim[2]/2])
          cube([dim[0], dim[1]-2*Radius, dim[2]], center=true);
          
          if ( ChamferTop > 0 )
          {
            translate([-dim[0]/2,0,dim[2]])
            ChamferYCube(w=ChamferTop,h=dim[1],d=0.01);

            translate([dim[0]/2,0,dim[2]])
            ChamferYCube(w=ChamferTop,h=dim[1],d=0.01);
          }
          if ( ChamferBottom > 0 )
          {
            translate([-dim[0]/2,0,0])
            ChamferYCube(w=ChamferBottom,h=dim[1],d=0.01);

            translate([dim[0]/2,0,0])
            ChamferYCube(w=ChamferBottom,h=dim[1],d=0.01);
          }      
        }
      }
    } // union
  } // check for cylinder
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
    fd: triangle peak as offset from the lower x position
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


module CopyMirror(vec=[0,1,0]) {
    children();
    mirror(vec) 
    children();
}

