/*

  train tube track

  straight_track_no_plug(length)
    Straight track of given "length", centered around origin
    
  straight_track_h_no_plug(length)
    Straight track of given "length", centered around origin, Extra solid  block towards -z
    
  straight_track_single_plug(length)
    Same as "straight_track_no_plug", but with one plug at the right end

  straight_track_h_single_plug(length)
    Same as "straight_track_h_no_plug", but with one plug at the right end

  straight_track_double_plug(length)

  straight_track_h_double_plug(length)
  
*/
// vector translation by [1,1]
// ni = [[0,0],[10,0],[10,5],[0,5]]; 
// nit = [for(i=[0:len(ni)-1]) ni[i]+[1,1]];

/*=====================================================*/
/* changable variables */
/*=====================================================*/


$fn=32;

inner_width=10;
inner_height=4;
outer_width=20;		// it is sometimes assumed, that this is equal to grid/2
outer_height=8;
upper_notch = 2;  // 2
plug_diameter = 3;
plug_distance = 2.5;
plug_gap = 0.5;

d = 0.01;       // mini delta to avoid artefacts during scad preview
grid = 40;	// should be double of outer_width, at least this is sometimes assumed
height = 32;	// height of the second level track above ground. Probably trains should not be higher than this

// multiple ships are inside the tube, they always must fit in the smallest curve
ship_width = inner_width-1.5;
ship_length = 12;       // longer then inner_width
ship_height = inner_height-0.4;		// changed from -1 to 0.4
ship_tooth_width_factor = 0.46;  // width of the tooth cutout rel. to ship width
house_gear_width_factor = 0.6;  // must be higher than ship_tooth_width_factor
ship_end_dia_extend = 1;    // diameter extension of the ship end cutout

gear_radius = 8;  // this is fixed and must not be changed
gear_thickness = ship_width*ship_tooth_width_factor/2;
//gear_center_hole_diameter = 1;  // anything which fits on the dc motor axis

// end of curve straight track length
// must be more than plug_diameter/2 + plug_distance
eocstl=5;

// ship tooth width
ship_tw = 0.30;

/*=====================================================*/
/* polygons */
/*=====================================================*/


ship_tooth_profile = [
    [ -(ship_length/4)/2+ship_tw, 0],
    [ -(ship_length/16)/2, 3*ship_height/4],
    [ +(ship_length/16)/2, 3*ship_height/4],
    [ +(ship_length/4)/2-ship_tw, 0],    
];

gear_tooth_profile = [
    [ -(ship_length/4)/2+1.5*ship_tw, 0],
    [ -(ship_length/32)/2, 3*ship_height/4+0.5 ],	// chaned from 0.5 to 0.6, back to 0.5
    [ +(ship_length/32)/2, 3*ship_height/4+0.5 ],
    [ +(ship_length/4)/2-1.5*ship_tw, 0],    
];

tube_profile = [
    [-outer_width/2,-outer_height/2],
    [-outer_width/2,+outer_height/2],
    [-upper_notch/2,+outer_height/2],
    [-upper_notch/2,+inner_height/4+outer_height/4], //
    [-inner_width/2,+inner_height/2], //
    //[+inner_width/2,+inner_height/2],
    [-inner_width/2,+inner_height/2],
    [-inner_width/2,-inner_height/2],
    [+inner_width/2,-inner_height/2],
    [+inner_width/2,+inner_height/2],
    [+inner_width/2,+inner_height/2], //
    [+upper_notch/2,+inner_height/4+outer_height/4], //
    [+upper_notch/2,+outer_height/2],
    [+outer_width/2,+outer_height/2],
    [+outer_width/2,-outer_height/2]
];

tube_profile_h = [
    [-outer_width/2,-outer_height/2-height],
    [-outer_width/2,+outer_height/2],
    [-upper_notch/2,+outer_height/2],
    [-upper_notch/2,+inner_height/4+outer_height/4], //
    [-inner_width/2,+inner_height/2], //
    //[+inner_width/2,+inner_height/2],
    [-inner_width/2,+inner_height/2],
    [-inner_width/2,-inner_height/2],
    [+inner_width/2,-inner_height/2],
    [+inner_width/2,+inner_height/2],
    [+inner_width/2,+inner_height/2], //
    [+upper_notch/2,+inner_height/4+outer_height/4], //
    [+upper_notch/2,+outer_height/2],
    [+outer_width/2,+outer_height/2],
    [+outer_width/2,-outer_height/2-height]
];

/*=====================================================*/
/* internal functions */
/*=====================================================*/

// from openSCAD user manual
function flatten(l) = [ for (a = l) for (b = a) b ] ;

// add a z-value to a 2d polygon list
// this will make a 3d point list from a 2d polygon
function addz(poly2d, z) = [for(i=poly2d) [i[0],i[1], z]];
    
// translate point list pl by vector v
function translate_pl(pl, v) = 
    [for(i=pl) [i[0]+v[0],i[1]+v[1],i[2]+v[2]]];

// rotate 3d point list around x axis
//https://de.wikipedia.org/wiki/Drehmatrix
function rotate_x_pl(pl, a) = [ for(i=pl) [
        i[0],
        cos(a)*i[1]-sin(a)*i[2],
        sin(a)*i[1]+cos(a)*i[2]
]];

// rotate 3d point list around y axis
function rotate_y_pl(pl, a) = [ for(i=pl) [
        cos(a)*i[0]+sin(a)*i[2],
        i[1],
        -sin(a)*i[0]+cos(a)*i[2]
]];

// generate the faces between two polygons
// "i1": index of the first polygon
// "i2": index of the second polygon
// "cnt": number of points in the polygon
// called by genmultifaces
function genfaces(i1, i2, cnt) = [ 
    for(i=[0:cnt-1]) [
        // correct openSCAD orientation considered
        i1+1+i >= i1+cnt ? i1 : i1+1+i,
        i2+1+i >= i2+cnt ? i2 : i2+1+i, 
        i2+i, 
        i1+i
    ]
];

// generate the faces between multiple polygons of the same shape
// "pcnt": Number of points in the polygon
// "scnt": Number of faces sets, this is number of polygons - 1
function genmultifaces(pcnt, scnt) = flatten([
    for(i=[0:scnt-1]) genfaces(i*pcnt, i*pcnt+pcnt, pcnt)
]);


/*=====================================================*/
/* grid size base plate */
/*=====================================================*/

module base_grid(ylen, gap=0.2) {
  h = (outer_height-inner_height)/2;
  translate([0,0, -outer_height/2+h/2])
  cube([grid-gap, ylen-gap, h], center=true);
}


/*=====================================================*/
/* internal objects */
/*=====================================================*/


// plug_raw is only used for cutout
module plug_raw(gap) {
    union() {
      translate([0,plug_distance-d, 0])
	  cylinder(h=outer_height+d,d=plug_diameter-gap,center = true); 
      translate([0,plug_distance-d, -outer_height/4])
	  cylinder(h=outer_height+d,d1=plug_diameter+1,d2=plug_diameter,center = true); 
      translate([0,plug_distance/2, 0])
	  cube([plug_diameter/2-gap, plug_distance, outer_height+d], center=true); 
    }
}

// reduced version of plug_raw, if the plug is somehow in the air
module plug_raw_r(gap) {
  difference() {
    union() {
      translate([0,plug_distance-d, outer_height*7/16])
	  cylinder(h=outer_height*1/8+d,d2=plug_diameter-gap, d1=plug_diameter-gap,center = true); 
      translate([0,plug_distance-d, 0])
	  cylinder(h=outer_height*3/4+d,d2=plug_diameter-gap, d1=0,center = true); 
      translate([0,plug_distance/2, 0])
	  cube([plug_diameter/2-gap, plug_distance, outer_height+d], center=true); 
    }
    translate([0,0,-outer_height/3])
    cube([outer_width*2, outer_width*2, outer_height], center = true);
  }
}

// a piece of straight track without any plugs
// centered, y direction
module straight_track_no_plug(length, is_base=false) {
    translate([0, length/2])
    rotate([90, 0, 0]) 
    linear_extrude(height=length) 
    polygon(tube_profile);
    
    if ( is_base == true ) {
      base_grid(length);
    }
}

// a piece of straight track without any plugs
// centered, y direction
module straight_track_h_no_plug(length) {
  difference() {
    translate([0, length/2])
    rotate([90, 0, 0]) 
    linear_extrude(height=length) 
    polygon(tube_profile_h);
    
    /* track start chamfer */
    translate([0,length/2+d,-inner_height/2])
      rotate([55,0,0])
      cube([inner_width, 0.8,2], center=true);	
    mirror([0,1,0])
    translate([0,length/2+d,-inner_height/2])
      rotate([55,0,0])
      cube([inner_width, 0.8,2], center=true);	
  }
}

// a piece of straight track with plug at +y
// centered
module straight_track_single_plug(length) {
    difference() {
        translate([0, 0, 0]) straight_track_no_plug(length);
        translate([-inner_width/2-(outer_width-inner_width)/4, length/2, 0]) 
            rotate([0,0,180]) 
            plug_raw(0);
	/* track start chamfer */
	translate([0,length/2+d,-inner_height/2])
	  rotate([55,0,0])
	  cube([inner_width, 0.8,2], center=true);	
    }
    translate([inner_width/2+(outer_width-inner_width)/4, length/2, 0]) 
        plug_raw_r(plug_gap);
}

module straight_track_h_single_plug(length) {
    difference() {
	translate([0, 0, 0]) straight_track_h_no_plug(length);
	translate([-inner_width/2-(outer_width-inner_width)/4, length/2, 0]) 
	    rotate([0,0,180]) 
	    plug_raw(0);
    }
    translate([inner_width/2+(outer_width-inner_width)/4, length/2, 0]) 
	plug_raw_r(plug_gap);
	
}

// a piece of straight track with plug at both ends
// centered
module straight_track_double_plug(length, is_base = false) {
    difference() {
        translate([0, 0, 0]) straight_track_no_plug(length, is_base);
        translate([-inner_width/2-(outer_width-inner_width)/4, length/2, 0]) 
            rotate([0,0,180]) 
            plug_raw(0);
        rotate([0,0,180])
        translate([-inner_width/2-(outer_width-inner_width)/4, length/2, 0]) 
            rotate([0,0,180]) 
            plug_raw(0);
	/* track start chamfer */
	translate([0,length/2+d,-inner_height/2])
	  rotate([55,0,0])
	  cube([inner_width, 0.8,2], center=true);	
	mirror([0,1,0])
	translate([0,length/2+d,-inner_height/2])
	  rotate([55,0,0])
	  cube([inner_width, 0.8,2], center=true);	
    }
    translate([inner_width/2+(outer_width-inner_width)/4, length/2, 0]) 
        plug_raw_r(plug_gap);
    rotate([0,0,180])
    translate([inner_width/2+(outer_width-inner_width)/4, length/2, 0]) 
        plug_raw_r(plug_gap);
}

module gate_cutout(){
  translate([0,0,height*0.4])
  rotate([0,90,0])
  cylinder(d=((grid+outer_width)/2),h=grid,center=true);
  cube([grid, ((grid+outer_width)/2), height*0.8], center=true);
}

module straight_track_h_double_plug(length) {
    difference() {
        translate([0, 0, 0]) straight_track_h_no_plug(length);
        translate([-inner_width/2-(outer_width-inner_width)/4, length/2, 0]) 
            rotate([0,0,180]) 
            plug_raw(0);
        rotate([0,0,180])
        translate([-inner_width/2-(outer_width-inner_width)/4, length/2, 0]) 
            rotate([0,0,180]) 
            plug_raw(0);
    }
    translate([inner_width/2+(outer_width-inner_width)/4, length/2, 0]) 
        plug_raw_r(plug_gap);
    rotate([0,0,180])
    translate([inner_width/2+(outer_width-inner_width)/4, length/2, 0]) 
        plug_raw_r(plug_gap);
}

/*=====================================================*/
/* flat curved track */
/*=====================================================*/

// curved track

module curved_track(curve, r) {
rotate_extrude(angle=curve, convexity = 10, $fn=100) 
    translate([r, 0, 0]) polygon(tube_profile);
translate([r,-eocstl/2,0]) rotate([0,0,180]) straight_track_single_plug(eocstl);
rotate([0,0,curve]) translate([r,+eocstl/2,0])  straight_track_single_plug(eocstl);
}



module ttt_curve90_1() {
    translate([eocstl, eocstl, 0]) curved_track(90, grid/2-eocstl);
}

module ttt_curve180_2() {
 translate([0, eocstl, 0]) curved_track(180, grid/2);
}

/*=====================================================*/
/* curved ramp track */
/*=====================================================*/
/* local functions and modules */

/*
  rotate the given polygon around the y axis.
  "poly2d": 2D polygon, centered around origin
  "radius": rotation extrude radius
  "angle": rotation extrude angle
  "ylen" is the total strech towards y direction.
  "cnt" number of point sets to use, similar to $fn
*/    

// linear version is not used
function curved_ramp_genpoints_lin(poly2d, radius, angle, ylen, cnt) = flatten([
    for(i=[0:cnt-1])
    rotate_y_pl(
        translate_pl(addz(poly2d, 0), [-radius,i*ylen/(cnt-1),0]), 
        i*angle/(cnt-1))
]);

// cosinus version is much better 
function curved_ramp_genpoints_cos(poly2d, radius, angle, ylen, cnt) = flatten([
    for(i=[0:cnt-1])
    rotate_y_pl(
        translate_pl(addz(poly2d, 0), 
            [-radius,ylen*(1-cos(i*180/(cnt-1)))/2,0]
            ), 
        i*angle/(cnt-1))
]);
    
    
/*
  rotate the given polygon around the y axis.
  "radius": rotation extrude radius
  "angle": rotation extrude angle
  "ylen" is the total strech towards y direction.
  "cnt" number of point sets to use, similar to $fn
*/        
module curved_ramp_raw(radius, angle, ylen, cnt) {
    pts = curved_ramp_genpoints_cos(tube_profile_h, 
            radius, angle, ylen, cnt);
    f1 = genmultifaces(len(tube_profile_h), cnt-1);
    f2 = [for(i=[0:len(tube_profile_h)-1]) 
            len(tube_profile_h)-1-i];
    f3 = [for(i=[0:len(tube_profile_h)-1]) 
            i+len(pts)-len(tube_profile_h)];
    fs = flatten([f1, [f2], [f3]]);
    difference() {
        rotate([90, 0, 0])
        polyhedron( points=pts, faces=fs, convexity=20 );
	
        translate([0,grid,-ylen/2-outer_height/2])
        cube([grid*8, grid*8, ylen], center=true);    
    }
}


/*=====================================================*/
/* public curved ramp track */


module ttt_curved180_ramp_2() {
    // lower plug   
    translate([-grid/2, -eocstl/2, 0])
    straight_track_single_plug(eocstl);

    // 180 degree curve and ramp
    translate([0, -eocstl, 0])
    curved_ramp_raw(grid/2, 180, height, 64);

    // upper plug
    translate([grid/2, -eocstl/2, height])
    straight_track_h_single_plug(eocstl);
}

module ttt_curved180_ramp_3() {
    // lower plug   
    translate([-2*grid/2, -eocstl/2, 0])
    straight_track_single_plug(eocstl);

    // 180 degree curve and ramp
    translate([0, -eocstl, 0])
    curved_ramp_raw(2*grid/2, 180, height, 64);

    // upper plug
    translate([2*grid/2, -eocstl/2, height])
    straight_track_h_single_plug(eocstl);
}

module ttt_curved180m_ramp_3() {
    // lower plug   
    translate([-2*grid/2, eocstl/2, 0])
    rotate([0,0,180])
    straight_track_single_plug(eocstl);

    // 180 degree curve and ramp
    translate([0, eocstl, 0])
    mirror([0,1,0])
    curved_ramp_raw(2*grid/2, 180, height, 64);

    // upper plug
    translate([2*grid/2, eocstl/2, height])
    rotate([0,0,180])
    straight_track_h_single_plug(eocstl);
}


module ttt_curved270_ramp_3() {
  // lower plug   
  translate([-grid/2, -eocstl/2, 0])
  straight_track_single_plug(eocstl);

  // 270 degree curve and ramp
  translate([eocstl, -eocstl, 0])
  curved_ramp_raw(grid/2+eocstl, 270, height, 64);

  // upper plug
  translate([eocstl/2,grid/2, height])
  rotate([0,0,90])
  straight_track_h_single_plug(eocstl);
}

module ttt_curved270m_ramp_3() {
  // lower plug   
  translate([-grid/2, +eocstl/2, 0])
  rotate([0,0,180])
  straight_track_single_plug(eocstl);

  // 270 degree curve and ramp
  translate([eocstl, eocstl, 0])
  mirror([0,1,0])
  curved_ramp_raw(grid/2+eocstl, 270, height, 64);

  // upper plug
  translate([eocstl/2,-grid/2, height])
  rotate([0,0,90])
  straight_track_h_single_plug(eocstl);
}

/*=====================================================*/
/* platform with proper height for the high level tube */
/*=====================================================*/

/*
  platform 1x1 grid
  
  width: Width of the pillars, 3mm seems to be too less for 3d printing
    so it should be 4 or more
  is_base: whether to place a base plate or not
  bheight: height of an additional border
  side_fix: reduces the side door height
  ext: makes the platform asynmetric
*/
module platform(width=4, bheight = 6, side_fix=8, ext=0, is_base=true)
{
    //ext = grid/4;
    //ext = 0;

    translate([ext/2,0, height/2])
    difference() {
        cube([grid+ext, grid, height+outer_height], center=true);

        translate([0,0,-grid/8-side_fix])
        rotate([90,0,0])
        cylinder(d=grid+ext-width*2, h=2*grid, center=true);
	
        translate([0,0,-height/2-grid/8-side_fix])
        cube([grid-width*2+ext, 2*grid, height], center=true);    
	
        translate([0,0,1])
        rotate([0,90,0])
        cylinder(d=grid-width*2, h=2*grid, center=true);

        translate([0,0,-height/2+1])
        cube([2*grid, grid-width*2, height], center=true);
    }

    if( is_base ) {
      translate([ext/2,0,-outer_height/2+(outer_height-inner_height)/4])
      
      union() {
	cube([grid+ext, grid,(outer_height-inner_height)/2], center=true);

	translate([-grid-ext,0,(outer_height-inner_height)/2]/2)
	translate([width, 0, bheight]/2)
	cube([width, grid, bheight], center = true);

	translate([grid+ext,0,(outer_height-inner_height)/2]/2)
	translate([-width, 0, bheight]/2)
	cube([width, grid, bheight], center = true);
      }
    }
    
    
}



/*=====================================================*/
/* ship */
/*=====================================================*/

/*
  length: should be the global value of "ship_length" or a  multiple of ship_length/4
  Maybe 5*ship_length/4 will work, but obviously it should not be too large otherwise
  ships will not be able to move through curves
  
  The reduce argument is intended to comensate the minkowski operation.
  Note that a sphere with radius r requires 2*r as reduction value.
*/
module ttt_ship_body_plain(length, reduce) {
  union() {
    difference() {
	// cube is not reduced in y direction, instead this is achieced by following translate op
	translate([0, reduce/2, 0])
        cube([ship_width-reduce, length-reduce, ship_height-reduce], center = true);
        translate([0,(-length-ship_end_dia_extend)/2,0])
        cylinder(h=ship_height+d, d=ship_width+ship_end_dia_extend+reduce, center=true );
    }
    translate([0,length/2,0])
    cylinder( h = ship_height-reduce, d = ship_width-reduce, center = true );
  };
}

// full ship body
module ttt_ship_body_4() {
  difference() {
    ttt_ship_body_plain(ship_length, 0);
    translate([0,-ship_tw,-ship_height/2-d])
    rotate([90,0,90])
    for(i=[-1:4]) {
     translate([i*ship_length/4,0,0])
     linear_extrude(height=ship_width*ship_tooth_width_factor, center=true) polygon(ship_tooth_profile);
    }
  }
}

// 3/4 ship length body
module ttt_ship_body_3() {
  difference() {
    ttt_ship_body_plain(3*ship_length/4, 0);
    translate([0,-ship_tw+ship_length/8,-ship_height/2-d])
    rotate([90,0,90])
    for(i=[-1:4]) {
     translate([i*ship_length/4,0,0])
     linear_extrude(height=ship_width*ship_tooth_width_factor, center=true) polygon(ship_tooth_profile);
    }
  }
}

// full ship body, no brim
module ttt_ship_body_m_4() {
  difference() {
    minkowski()
    {
	ttt_ship_body_plain(ship_length, 1.6);
	sphere(0.8, $fn=8);
    };
    translate([0,-ship_tw,-ship_height/2-d])
    rotate([90,0,90])
    for(i=[-1:4]) {
     translate([i*ship_length/4,0,0])
     linear_extrude(height=ship_width*ship_tooth_width_factor, center=true) polygon(ship_tooth_profile);
    }
  }
}

// 3/4 ship length body
module ttt_ship_body_m_3() {
  difference() {
    minkowski()
    {
	ttt_ship_body_plain(3*ship_length/4, 1.6);
	sphere(0.8, $fn=8);
    };
    translate([0,-ship_tw+ship_length/8,-ship_height/2-d])
    rotate([90,0,90])
    for(i=[-1:4]) {
     translate([i*ship_length/4,0,0])
     linear_extrude(height=ship_width*ship_tooth_width_factor, center=true) polygon(ship_tooth_profile);
    }
  }
}



/*=====================================================*/
/* gear */
/*=====================================================*/


module ttt_gear(gear_center_hole_diameter, flat_area_depth) {
    union() {
        difference() {
	    union() {
	      cylinder(h=gear_thickness, 
		  r=gear_radius+0.1, center=true);
	      cylinder(h=gear_thickness*2, r=gear_center_hole_diameter);
	    }
	    difference() {
		cylinder(d=gear_center_hole_diameter, 
		    h=gear_thickness*4+d, center=true);
		translate([gear_center_hole_diameter-flat_area_depth,0,0])
		cube([gear_center_hole_diameter,
		      gear_center_hole_diameter,
		      gear_thickness*4+2*d], center=true);
	    }
        }
        for(i=[0:20:360]) {
        rotate([0,0,i])
        translate([0,gear_radius,0])
        linear_extrude(height=gear_thickness, center=true) polygon(gear_tooth_profile);
        }
    }
}

/*=====================================================*/
/* grove 2x1 cutout */
/*=====================================================*/

module grove_2x1(lh, uh, grove_pcb_height = 2) {
    translate([-20, -10, 0])
    difference() {
        grove_screw_d = 5;		// used as cutout, so 5 instead of 4
        grove_hole_d = 4;		// used as cutout, so make it 4 instead of 5

        union() {
            translate([10,20,lh])
                cylinder(h=uh+grove_pcb_height,d=grove_screw_d);
            translate([10,0,lh])
                cylinder(h=uh+grove_pcb_height,d=grove_screw_d);
            translate([40,10,lh])
                cylinder(h=uh+grove_pcb_height,d=grove_screw_d);
                
            cube([40, 20, uh+grove_pcb_height+lh]);
        }
        
        translate([40,10,-0.001])
            cylinder(h=lh,d=grove_screw_d);
        translate([10,0,-0.001])
            cylinder(h=lh,d=grove_screw_d);
        translate([10,20,-0.001])
            cylinder(h=lh,d=grove_screw_d);

        translate([30,0,-0.001])
            cylinder(
                h=grove_pcb_height+lh+0.002,
                d=grove_hole_d);
        translate([30,20,-0.001])
            cylinder(
                h=grove_pcb_height+lh+0.002,
                d=grove_hole_d);
        translate([0,10,-0.001])
            cylinder(
                h=grove_pcb_height+lh+0.002,
                d=grove_hole_d);
    }
}

/*=====================================================*/
/* surface_matrix (used by terrain generator) */
/*=====================================================*/


/*
 Name: 
   surface_matrix(matrix=[[1,1],[1,1]], lift=0, scale=[1,1,1])

 Description:
   Similar to the "surface" function:
   Calculate a polyhedron out of a height map, which is given as a
   matrix (vector of vectors)
  
 Arguments:
  matrix: 
      Vector of vectors with the height information.
      Values below 0 are treated as 0.
  lift:
    Extra z value to lift all points towards z direction.
  scale:
      A vector with three scale factors for x, y and z. Defaults to [1,1,1]
      This allows on the fly scaling of the generated polyhedron.

 Notes:
  convexity is fixed to 10
    "invert" and "center" arguments as known from the "surface" command are not supported
*/


module surface_matrix(matrix=[[1,1],[1,1]], lift=0, scale=[1,1,1]) {
    // Get all the z values from the height map and generate
    // a point list out of it.
    // Add the corners of z=0 plane to the end of the list.
    function hm_to_points(m, scalex=1, scaley=1,scalez=1) = [

        // Convert the height map to points.
        // Values below 0 are made 0.
        for( j=[0:len(m)-1] ) 
            for ( i =[0:len(m[0])-1] ) 
                [i*scalex, j*scaley, (m[j][i] > 0 ? m[j][i]*scalez : 0)+lift ]
        ,
        // Store the edges with z=0 at the end of the point list
        [0,0,0],
        [(len(m[0])-1)*scalex, 0, 0],
        [0, (len(m)-1)*scaley, 0],
        [(len(m[0])-1)*scalex, (len(m)-1)*scaley, 0] 
    ];

    // get lower left triangle face for a given point
    // width is the width of the heightmap
    function hm_pt_triangle_ll(width,x,y) = [ 
        y*width+x, (y+1)*width+x, (y+1)*width+x+1
    ];

    // get upper right triangle face for a given point
    // width is the width of the heightmap
    function hm_pt_triangle_ur(width,x,y) = [ 
        y*width+x, (y+1)*width+x+1, y*width+x+1
    ];

    // get all faces out of the height map for the polyhedron
    function hm_to_faces(m) = [
        // lower left triangle faces
        for( y=[0:len(m)-2] ) 
            for ( x =[0:len(m[0])-2] ) 
                hm_pt_triangle_ll(len(m[0]), x, y)
        ,
        // upper right triangle faces
        for( y=[0:len(m)-2] ) 
            for ( x =[0:len(m[0])-2] )         
                hm_pt_triangle_ur(len(m[0]), x, y)
        ,
        // all for sides
        [ 
            for( y=[0:len(m)-1] ) (len(m)-1-y)*len(m[0]),
            len(m)*len(m[0])+0,
            len(m)*len(m[0])+2
        ],
        [ 
            for( y=[0:len(m)-1] ) (y+1)*len(m[0])-1,
            len(m)*len(m[0])+3,
            len(m)*len(m[0])+1
        ],
        [ 
            for( x=[0:len(m[0])-1] ) x,
            len(m)*len(m[0])+1,
            len(m)*len(m[0])+0
        ],
        [ 
            for( x=[0:len(m[0])-1] ) len(m)*len(m[0])-1-x,
            len(m)*len(m[0])+2,
            len(m)*len(m[0])+3
        ],
        // buttom face
        [
            len(m)*len(m[0])+0,
            len(m)*len(m[0])+1,
            len(m)*len(m[0])+3,
            len(m)*len(m[0])+2
        ] 

    ];

    /*
    function hm_points_faces(matrix, scale) = [
            hm_to_points(matrix,scale[0],scale[1],scale[2]),
            hm_to_faces(matrix)
        ];
     */
    
    polyhedron( 
        points = hm_to_points(matrix,scale[0],scale[1],scale[2]), 
        faces = hm_to_faces(matrix), 
        convexity=10 );
}

/*=====================================================*/
/* terrain generator */
/*=====================================================*/

/*
 Name: 
    terrain(l=32, h=5, b=0, scale=[1,1,1], hills = [[0,0,0,0]]) {

 Description:
    terrain generator
    generates a quadratic size of a kind of a terrain

 Arguments:
    l: xy size of the generated polyhedron
    h: z-height of the polyhedron with (without scaling and hills)
    scale: scaling vector for x,y and z
    b: base plate offset (will be applied as lift to the surface_matrix procedure)
    hills: extra hills. this is a list of the following entries:
        [x, y, radius, height]
  
  Note:
    Algorithm is based on the square diamond algorithm
    
  Example:
    terrain(32, 4, [1,1,1], [ 
      [0, 0, 32, 20],
      [0, 32, 32, 20],
      [32, 32, 32, 20]
  ]);


*/
module terrain(l=32, h=5, b=0, scale=[1,1,1], hills = [[0,0,0,0]]) {

    tg_random_matrix = rands(0,1,10000, 758);

    function tg_rnd(x,y,w,s) = tg_random_matrix[((y*w+x)*s*17)%10000];

    function tg_init(w,h,size) = [
        for( y = [0:h-1] ) [ 
            for( x = [0:w-1] ) 
                (y % size) == 0 && (x % size) == 0 ?
                tg_rnd(x,y,w,1) :
                0
        ]
    ];

    function tg_init_zero(w,h, seed) = [
        for( y = [0:h-1] ) [ for( x = [0:w-1] ) 0 ] 
    ]; 
        
    function tg_get_val(m, x, y) =
        let( yy = (y+len(m)) % len(m), xx = (x+len(m[yy])) % len(m[yy]) )
        m[yy][xx];

    function tg_set_val(m, x, y, val) = [ 
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) yy==y && xx==x ? val : m[yy][xx]
        ]
    ];
        
    function tg_square(m, x, y, size, val) = 
        let(hs=size/2, 
            a=tg_get_val(m, x-hs, y-hs), 
            b=tg_get_val(m, x+hs, y-hs), 
            c=tg_get_val(m, x-hs, y+hs), 
            d=tg_get_val(m, x+hs, y+hs)
        )
        (a+b+c+d)/4+val;

    function tg_diamond(m, x, y, size, val) = 
        let(hs=size/2, 
            a=tg_get_val(m, x-hs, y), 
            b=tg_get_val(m, x+hs, y), 
            c=tg_get_val(m, x, y-hs), 
            d=tg_get_val(m, x, y+hs)
        )
        (a+b+c+d)/4+val;
            
    function tg_square_all(m, size, k) = [
        let(hs = floor(size/2), r = rands())
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) 
                ((yy+hs) % size) == 0 && ((xx+hs) % size) == 0 ? 
                    tg_square(m,xx,yy,size,tg_rnd(xx,yy,len(m[0]),size)*k) : 
                    m[yy][xx]
        ]
    ];
            
    function tg_diamond_a1(m, size, k) = [
        let(hs = floor(size/2))
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) 
                floor(yy % size) == 0 && floor((xx+hs) % size) == 0 ?
                    tg_diamond(m,xx,yy,size,tg_rnd(xx,yy,len(m[0]),size)*k) :
                    m[yy][xx]
        ]
    ];

    function tg_diamond_a2(m, size, k) = [
        let(hs = floor(size/2))
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) 
                (floor((yy+hs)%size) == 0) && (floor(xx%size) == 0) ? 
                    tg_diamond(m,xx,yy,size,tg_rnd(xx,yy,len(m[0]),size)*k) : 
                    m[yy][xx]
        ]
    ];


    function tg_diamond_square(m, size, k) = 
            tg_diamond_a2(
                tg_diamond_a1(
                    tg_square_all(m, size, k),
                size, k), 
            size, k);

    function tg_min(m) = min([ for (a = m) for (b = a) b ]);
        
    function tg_max(m) = max([ for (a = m) for (b = a) b ]);
        
    function tg_norm(m, scale) = [
        let( min = tg_min(m), max=tg_max(m) )
        for( y = [0:len(m)-1] ) [ 
            for( x = [0:len(m[y])-1] ) (m[y][x]-min)*scale/(max-min) 
        ] 
    ]; 

    // add an extra hill to a hight map
    // xx,yy position
    // r base radius of the hull
    // h height of the hill
    function tg_hill(m, xx, yy, r, h=1) = [
        for( y = [0:len(m)-1] ) [ 
            for( x = [0:len(m[y])-1] ) 
                m[y][x] +
                (abs(xx-x) < r && abs(yy-y) < r ? 
                (cos((x-xx)*180/r)+1)*(cos((y-yy)*180/r)+1)*h/4 : 
                0)
        ]
    ];

            
    function sum(list, cnt=0) = 
            cnt<len(list)-1 ? list[cnt] + sum(list, cnt+1) : list[cnt];

    //xx, yy, r, h=1
    function tg_multi_hill(m, vv) = [
        for( y = [0:len(m)-1] ) [ 
            for( x = [0:len(m[y])-1] ) 
                m[y][x] + 
                sum([for( v=vv )
                    (abs(v[0]-x) < v[2] && abs(v[1]-y) < v[2] ? 
                    (cos((x-v[0])*180/v[2])+1)*(cos((y-v[1])*180/v[2])+1)*v[3]/4 : 
                    0)
                ])
        ]
    ];

    function tg_recur(m, size, k) =
        size <= 1 ? 
        tg_diamond_square(m, size, k) :
        tg_recur(tg_diamond_square(m, size, k), floor(size/2), k/2.0);
            
    
    m = tg_init(l+1, l+1, l+1);
    mm = tg_norm(tg_recur(m, l+1, 1.0), h);
    mmm = tg_multi_hill(mm, hills);
    surface_matrix(mmm, b, scale);
}
