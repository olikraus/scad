/*
    https://www.meshy.ai/workspace      
    https://pixeldojo.ai/ai-stl-generator?utm_source=chatgpt.com
*/


$fn = 100;

/*
radius = 40;     // Distance from center
cube_size = 5;   // Size of each cube
count = 48;      // Number of cubes
mountain = 30;


function hfn(angle) = sin(angle/4)*sin(angle/4)*mountain;

function rfn(angle) = radius + sin((angle+180)/4)^2*radius;

for (i = [0 : count-1]) {
    angle = 360*2 / count * i;
    translate([ rfn(angle) * cos(angle), rfn(angle) * sin(angle), hfn(angle) ])
        rotate([0, 0, angle])
            cube(cube_size, center=true);
}

*/

// from openSCAD user manual
function flatten(l) = [ for (a = l) for (b = a) b ] ;

// add a z-value to a 2d polygon list
// this will make a 3d point list from a 2d polygon
// result is a point list with 3d points (refered below as pl)
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
    
    
function getprofilefaces(points_per_profile, profile_cnt) = flatten([
    // faces between the profiles
    genmultifaces(points_per_profile, profile_cnt-1),
    // start lid
    [[for(i=[0:points_per_profile-1]) points_per_profile-1-i]],
    // end lid
    [[for(i=[0:points_per_profile-1]) i+points_per_profile*profile_cnt-points_per_profile]]
]);

/* like getprofilefaces, but without lid, instead the first profile is connected to the last */
function getclosedprofilefaces(points_per_profile, profile_cnt) = flatten([
    // faces between the profiles
    genmultifaces(points_per_profile, profile_cnt-1),
    genfaces(points_per_profile*profile_cnt-points_per_profile, 0, points_per_profile)
]);



/*
  rotate the given polygon around the y axis.
  "poly2d": 2D polygon, centered around origin
  "radius": rotation extrude radius
  "angle": rotation extrude angle
  "ylen" is the total strech towards y direction.
  "cnt" number of point sets to use, similar to $fn
*/    
    
// cosinus version is much better, not used here
function curved_ramp_genpoints_cos(poly2d, radius, angle, ylen, cnt) = flatten([
    for(i=[0:cnt-1])
    rotate_y_pl(
        translate_pl(addz(poly2d, 0), 
            [-radius,ylen*(1-cos(i*180/(cnt-1)))/2,0]
            ), 
        i*angle/(cnt-1))
]);


function genpoints_ring_pl(pl, radius, height, cnt) = flatten([
    for(i=[0:cnt-1])
        rotate_y_pl(
            translate_pl(addz(pl, 0), 
                [-radius,cos(i*180/cnt)^2*height,0]
                ), 
            i*360/cnt)
    
]);
    

/*
    Track profile is centered in x
    and is placed on y (so basline y=0)
*/
track_height = 30;
track_width = 10;
track_cnt = 64;
track_delta = 20;
track_base_height = track_height - track_delta;
track_radius = 40;
track_profile = [
    [-track_width/2, 0],
    [-track_width/2, track_height],
    [track_width/2, track_height],
    [track_width/2, 0]
];

/*
    track slide
*/
slide_length = 8;
slide_gap_width = 1;
slide_wall_width = 3;
slide_wall_height = 4;
slide_plate_height = 2;
slide_inner_dia = 4;
slide_outer_dia = 6;
slide_dia_gap = 0.8;

shaft_inner_dia = 8;
shaft_outer_dia = 10.8;
shaft_dia_gap = 0.8;
shaft_inner_height = track_height*1.5;
shaft_outer_height = track_height;


slide_rod_length = track_radius-track_width+slide_gap_width*2-shaft_outer_dia/2;


//pts = curved_ramp_genpoints_cos(track_profile, 50, 360-360/track_cnt, 0, track_cnt);
pts = genpoints_ring_pl(track_profile, track_radius, track_delta, track_cnt);
//fs = getprofilefaces(len(track_profile), track_cnt);
fs = getclosedprofilefaces(len(track_profile), track_cnt);
    
//echo("pts", pts);
//echo("fs", fs);

module track_slide() {
    union() {
        translate([-track_width/2-slide_gap_width-slide_wall_width,-slide_length/2,0])
        difference() {
            cube([track_width+slide_gap_width*2+slide_wall_width*2, slide_length, slide_wall_height+slide_plate_height]);
            translate([slide_wall_width, -0.01,-0.01 ])
            cube([track_width+slide_gap_width*2, slide_length+0.02, slide_wall_height]);
        };
        
        
        translate([0,0, slide_wall_height+slide_plate_height-slide_inner_dia])
        translate([(track_width+slide_gap_width*2)/2+0.01,0,slide_inner_dia/2])
        rotate([0,90,0])
        cylinder(d=slide_inner_dia, h=slide_rod_length);
        
        translate([0,0, slide_wall_height+slide_plate_height-slide_inner_dia])
        translate([track_width/2+slide_gap_width+slide_wall_width+slide_length*0.15,0,0])
        cylinder(d=slide_length, h=4, $fn=3);
    }
}

module outer_shaft() {
    difference() {
        union() {
            //cylinder(d=shaft_outer_dia, h=shaft_inner_height);
            translate([-shaft_outer_dia/2, -shaft_outer_dia/2, 0])
            cube([shaft_outer_dia, shaft_outer_dia, shaft_outer_height]);
            translate([0,0, track_base_height])
            rotate([0,-90,0])
            difference() {
                cylinder(d=shaft_outer_dia, h=slide_rod_length);
                cylinder(d=slide_inner_dia+slide_dia_gap, h=slide_rod_length+0.01);
            }
        }
        translate([0,0,-0.01])
        //cylinder(d=shaft_inner_dia+shaft_dia_gap, h=shaft_inner_height+0.02);
        translate([-(shaft_inner_dia+shaft_dia_gap)/2, -(shaft_inner_dia+shaft_dia_gap)/2, 0])
        cube([shaft_inner_dia+shaft_dia_gap, shaft_inner_dia+shaft_dia_gap, shaft_outer_height+0.02]);
    }
}


    //cylinder(d=shaft_inner_dia, h=shaft_outer_height);

    translate([-(shaft_inner_dia)/2, -(shaft_inner_dia)/2, 0])
    cube([shaft_inner_dia, shaft_inner_dia, shaft_inner_height]);

difference() {
    union() {
        cylinder(r=track_radius-track_width/2-2, h=2);
        cylinder(d1=shaft_inner_dia*2.4, d2=0, h=12);
    }
    for(i=[0:7])
        rotate([0,0,i*360/8])
        translate([20, 0, -0.01])
        cylinder(d=12,h=2.02);
}

//polygon(track_profile);
difference() {
    translate([0,0,-track_delta])
    rotate([90,0,0])
    polyhedron(points=pts, faces=fs, convexity=4);    
    
    translate([-track_radius*2, -track_radius*2, -track_delta])
    cube([track_radius*4, track_radius*4, track_delta]);
} 

//cylinder(r=5,h=track_height*2);

/* slide */
//translate([-track_radius,0,track_height-slide_wall_height+1])
translate([-track_radius*0.8,track_radius*1.2,slide_wall_height+slide_plate_height])
rotate([180,0,0])
track_slide();

translate([track_radius*1.2,track_radius*1.4,shaft_outer_dia/2])
rotate([90,0,0])
outer_shaft();

