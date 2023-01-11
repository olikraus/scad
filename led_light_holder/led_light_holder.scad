
$fn=32;

wall = 2.6;
inner_width = 35.5;
outer_width = inner_width + 2*wall;
total_len = 10;
base_height = wall;
inner_height = 15;
outer_height = inner_height+1*base_height;

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
translate([0,0, base_height/2])
cube([iw, len, base_height], center=true);
*/

difference()
{
  CenterCube([outer_width, total_len, outer_height]);
  translate([0,0,base_height+0.01])
  CenterCube([inner_width, 2*total_len, inner_height], ChamferBottom=3.6, ChamferTop=3.6);
  translate([0,0,base_height+inner_height/2])
  CenterCube([inner_width-4.6, 2*total_len, inner_height]);

  cylinder(d=4,h=base_height*3, center=true);
  
  translate([0,0,-0.5])
  cylinder(d1=0, d2=12, h=5);
}
