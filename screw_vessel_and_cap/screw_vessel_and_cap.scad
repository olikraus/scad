/*

  screw_vessel_and_cap.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
  
  This is just an experimental (and maybe useless) 
  thing to test 3d printer friendly threads.

*/

/* [basic] */

// Radius of vessel and cap in mm. The inner diameter of the vessel is 2*radius.
radius = 20;

// The height of the vessel without screw cap in mm.
vessel_height = 10;

/* [advanced] */

// Thickness of the bottom of the vessel in mm.
vessel_bottom_thickness = 1.4;

// Thickness of the lid/cap in mm.
cap_thickness = 1.4;

/* [expert] */

// Height of the thread in mm. Total height of the thread is pitch*revolutions.
pitch = 3;

// Number of revolutions for the thread
revolutions=2;

// Gap between the thread of the vessel and the thread of the cap in mm.
gap=0.4;

// segments per revolution
$fn=64;

/* [hidden] */

wall = pitch*0.3+gap+1;
//wall = 2;

/* from openSCAD user manual */
function flatten(l) = [ for (a = l) for (b = a) b ] ;

/*
  add a z-value to a 2d polygon list
  this will make a 3d point list from a 2d polygon
*/
function addz(poly2d, z) = [for(i=poly2d) [i[0],i[1], z]];

/* translate point list pl by vector v */
function translate_pl(pl, v) = 
    [for(i=pl) [i[0]+v[0],i[1]+v[1],i[2]+v[2]]];

function scale_x_translate_xy(pl, sx, dx, dy) = 
    [for(i=pl) [i[0]*sx+dx,i[1]+dy,i[2]]];

/*
  rotate 3d point list around x axis
  https://de.wikipedia.org/wiki/Drehmatrix
*/
function rotate_x_pl(pl, a) = [ for(i=pl) [
        i[0],
        cos(a)*i[1]-sin(a)*i[2],
        sin(a)*i[1]+cos(a)*i[2]
]];

/* 
  rotate 3d point list around y axis
*/
function rotate_y_pl(pl, a) = [ for(i=pl) [
        cos(a)*i[0]+sin(a)*i[2],
        i[1],
        -sin(a)*i[0]+cos(a)*i[2]
]];

/* 
  generate the faces (=segment) between two polygons
  "i1": index of the first polygon
  "i2": index of the second polygon
  "cnt": number of points in the polygon
  The generated segment does not have a start/end lid. 
  Called by generate_all_segments.
*/
function generate_segment(i1, i2, cnt) = [ 
    for(i=[0:cnt-1]) [
        // correct openSCAD orientation considered
        i1+1+i >= i1+cnt ? i1 : i1+1+i,
        i2+1+i >= i2+cnt ? i2 : i2+1+i, 
        i2+i, 
        i1+i
    ]
];

/*
  generate the faces between multiple polygons of the same shape
  "pcnt": Number of points in the polygon
  "scnt": Number of faces sets (segments), this is number of polygons - 1
*/
function generate_all_segments(pcnt, scnt) = flatten([
    for(i=[0:scnt-1]) generate_segment(i*pcnt, i*pcnt+pcnt, pcnt)
]);
    
/*
  Generate the faces for the polyhedron. Same as "generate_all_segments"
  but adds a lid at start and end.
*/
function generate_faces(pcnt, scnt) = flatten([
  generate_all_segments(pcnt, scnt), 
  [[for(i=[0:pcnt-1]) 
        pcnt-1-i]], 
  [[for(i=[0:pcnt-1]) 
        i+(scnt+1)*pcnt-pcnt]]
]);
    

/*
  Generate the points for the complete thread.
  It will be the base for a single polyhedron which makes up the thread.
  For this purpose the poly2d list is replicated "cnt+1" times.
  "cnt" is the number of expected segments between the points.
  This means, for cnt=1 segments, we have to create two set of polygons.
  Result is a list of 3d-points.
  
  Args:
    poly2d: A vector of coordinates which describes the profile of the thread.
      The left border of poly2d should be the y axis (x=0).
    radius: The inner radius of the thread. poly2d will be moved by this 
      distance into x direction.
    twist: By which degree the thread will be rotated around y axis.
    ylen: The length (y axis) of the generated thread
    cnt: The number of sections for the overall thread. Note the difference
      to $fn: $fn denotes the number of sections per 360 degree. "cnt" instead
      is "cnt=$fn*twist/360"
    start_cnt: Does a linear increasing scale of poly2d for the first 
      "start_cnt" segments.
    end_cnt: Does a linear decreasing scale of poly2d for the last 
      "end_cnt" segments.
  
*/
function rotate_twist_extrude_points(poly2d, radius, twist, ylen, cnt, 
  start_cnt = 0, end_cnt = 0) = 
let (poly3d=addz(poly2d, 0))
flatten([
  for(i=[0:cnt])
    rotate_y_pl(
      scale_x_translate_xy(poly3d, 
            i < floor(start_cnt) ? (i+0.5)/floor(start_cnt) : (i > cnt-floor(end_cnt) ? (cnt-i+0.5)/floor(end_cnt) : 1), 
            radius, 
            i*ylen/cnt
          ), 
      i*twist/cnt
    )
]);

/*
    RotateTwistExtrude(poly2d, twist, ylen, cnt, start_cnt = 0, end_cnt=0)
    
    Extrude the polygon "poly2d" around and along y axis. The generated 
    polyhedron always has a start and an end. The extrusion follows
    the right hand rule. If the polygon is placed on the positve
    x plane (all x coordinates >= 0), then the second polygon will be 
    extruded into negative z axis.
  
    The commands
      rotate([90,0,0]) RotateTwistExtrude(profile, 360, 0, 8);
    and
      rotate_extrude($fn=8) polygon(profile);
    generate the almost same polyhedron, except that the start and
    end points are identical for RotateTwistExtrude. 
        
    Args:
      poly2d: A closed polygon. It shouldn't cross the y axix (fully in positive
        or negative x plane)
      twist: Corresponds to the angle value of the rotate_extrude command,
        but can be (much) larger than 360 degree
      ylen: The y distance of the start and the end points of the generated polyhedron.
      cnt: The number of sections, which should be generated.
        For twist=360 this corresponds to the $fn value.
        In general "cnt" could be roughly twist/360*$fn.
      start_cnt: Number of start section (lower end) for which poly2d
        will be scaled from 0 to 1
      end_cnt: Number of end section (upper end) for which poly2d
        will be scaled from 1 to 0
        
    Example:
      pitch=10;       // y distance per revolution
      revolutions=3;  
      sections_per_revolution=$fn;
      RotateTwistExtrude(profile, 360*revolutions, pitch*revolutions, revolutions*sections_per_revolution);
    
*/
module RotateTwistExtrude(poly2d, radius, twist, ylen, cnt, 
    start_cnt = 0, end_cnt=0) {
  pts = rotate_twist_extrude_points(poly2d, radius, twist, ylen, 
      floor(cnt), start_cnt, end_cnt);
  fs = generate_faces(len(poly2d), floor(cnt));
  polyhedron( points=pts,
    faces=fs, 
    convexity=twist/180+5 );
}


/*
  The idea is to have a 45 degree slope for the 3D printer.
  45 degree slope condition: (inner_height-outer_height)/2 = outer_r-inner_r 
  Technically this is a 90 degree thread instead of a 60 degree 
  ISO metric thread.

  width must be <= height/2.
  If width = height/2 then the profile will be a triangle.
  For width < height/2 the profile is a trapezoid.
  In both cases the profile is symetrical to the x axis and
  the left edge is on the y axis.
*/
function get_thread_profile(height, width, delta=0) =
 let(
  inner_r = 0, 
  outer_r = width, 
  inner_height = height, 
  outer_height = height - width*2)
[
  [inner_r,       -inner_height/2-delta],
  [outer_r+delta, -outer_height/2],
  [outer_r+delta, outer_height/2],
  [inner_r,       inner_height/2+delta] 
];
    

/*
  OuterThread(radius = 20, pitch=4, revolutions=2, inner_wall = 2)
  
  Create a tube and place a thread on the outside surface of 
  the tube.
  The height of the generated object is "pitch*revolutions"
  OuterThread and InnerThread must have the same
  "radius" and "pitch" value in order to fit together.
  
  Args
    radius: The "radius" is the radius of the cylinder on which
      the thread is placed: This means radius of the 
      generated object is "radius" + width of the thread.
    pitch: The distance between two threads
    revolutions: The number of revolutions of the thread
    inner_wall: The width of the inner wall. The tube
      has a inner radius of "radius"-"inner_wall".
      There will be no inner tube if "inner_wall" is zero.
      A solid inner cylinder will be created if "inner_wall" is
     greater or equal to "radius" 
    $fn: Number of sections per revolution. Defaults to 16
      if not provided.
*/

module OuterThread(radius = 20, pitch=4, revolutions=2, inner_wall = 2) {  
  //thread_width = pitch/2-0.8;
  thread_width = pitch*0.3;
  sections_per_revolution = $fn==0?16:$fn;
  union() {
    if ( pitch > 0 )
    {
      difference() {
        /* generate the thread */
        rotate([90,0,0])
        RotateTwistExtrude(
          get_thread_profile(pitch*0.7, thread_width, 0), 
          radius, 
          360*revolutions, 
          pitch*revolutions, 
          revolutions*sections_per_revolution, 
          sections_per_revolution/4, sections_per_revolution/4);
        /* cut off the upper and lower part */
        translate([0,0,-pitch])
        cube([(radius+thread_width)*2.1,(radius+thread_width)*2.1,2*pitch], center=true);
        translate([0,0,pitch+pitch*revolutions])
        cube([(radius+thread_width)*2.1,(radius+thread_width)*2.1,2*pitch], center=true);
      }
    }
    /* add inner tube */
    if ( inner_wall > 0 )
    {
      difference() {
        cylinder(r=radius+0.01, h=pitch*revolutions, $fn=sections_per_revolution);
        
        if ( inner_wall < radius )
        {
          translate([0,0,-0.1])
          cylinder(r=radius-inner_wall, h=pitch*revolutions+0.2, $fn=sections_per_revolution);
        }
      }
    }
  }
}

/*
  InnerThread(radius = 20, pitch=4, revolutions=2, outer_wall = 2)
  
  Create a tube and cut out a thread from inside the tube.
  The height of the generated object is "pitch*revolutions"
  OuterThread and InnerThread must have the same
  "radius" and "pitch" value in order to fit together.
  
  Args
    radius: The inner radius of the thread. The outer
      radius of the generated object is "radius"+"outer_wall"
    pitch: The distance between two threads
    revolutions: The number of revolutions of the thread
    outer_wall: The thread is cut out of this wall.
      The thread width (pitch*0.3) must be smaller 
      than "outer_wall"-"gap". An assert will be generated if 
      this is not the case. For 3D prints, 
        "outer_wall"-"pitch"*0.3 
      should be at least nozzle diameter size.
    gap: Additional gap so that inner thread and outer thread
      fit for 3d printed parts. Defaults to 0.4.
    $fn: Number of sections per revolution. Defaults to 16
      if not provided.

*/  

module InnerThread(radius = 20, pitch=4, revolutions=2, outer_wall = 3, gap=0.4) {
  //thread_width = pitch/2-0.8;
  thread_width = pitch*0.3;
  sections_per_revolution = $fn==0?16:$fn;
  assert(thread_width+gap < outer_wall, 
    str("The wall must be thick enough for the thread width. thread_width+gap=", thread_width, "+", gap, ", outer_wall=", outer_wall ))
  difference() {
    /* create cylinder */
    cylinder(r=radius+outer_wall, h=pitch*revolutions, $fn=sections_per_revolution);
    /* remove the thread from that cylinder */
    translate([0,0,-pitch/2])
    rotate([90,0,0])
    RotateTwistExtrude(
      get_thread_profile(pitch*0.7, thread_width, gap), 
      radius, 
      360*(revolutions+1), 
      pitch*(revolutions+1), 
      (revolutions+1)*sections_per_revolution,
      0, 0);
    translate([0,0,-0.1])
    cylinder(r=radius+gap, h=pitch*revolutions+1.02, $fn=sections_per_revolution);
  }
}

//radius = 20;
//vessel_height = 10;
//pitch = 3;
//revolutions=2;
//gap=0.4;
//vessel_bottom_thickness = 1.4;
//cap_thickness = 1.4;
//wall = pitch*0.3+gap+1;

translate([0,0,cap_thickness])
InnerThread(radius, pitch, revolutions, wall);
cylinder(r=radius+wall, h=cap_thickness);

translate([(radius+wall)*2+2,0,0])
union() {
  translate([0,0,vessel_height])
  OuterThread(radius, pitch, revolutions, wall/2);
  difference() {
    cylinder(r=radius+wall, h=vessel_height);
  translate([0,0,vessel_bottom_thickness])
    cylinder(r=radius-wall/2, h=vessel_height-vessel_bottom_thickness+0.01);
  }
}

