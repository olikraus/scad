/*

    Miele vacuum cleaner hose/tube connector for 47mm hose
    
    (c) olikraus@gmail.com

    CC BY-NC-SA 4.0
    Attribution-NonCommercial-ShareAlike 4.0 International
    https://creativecommons.org/licenses/by-nc-sa/4.0/
    
*/

/* [Configuration] */

// Diameter (mm) of the target to which the adapter/connector should fit. Examples: Bosch POF 1400: 40.4 mm, Bosch PST 750: 31.6 mm, Miele 35mm Nozzles: 34.4-2*3
target_end_diameter = 28.4;

// If target_end_diameter > target_start_diameter, then the diameter becomes more wider. Difference between target_end_diameter and target_start_diameter should be small. Example: Bosch POF 1400: 40.0 mm, Bosch PST 750: 31.2 mm, Miele 35mm Nozzles: 34.8-2*3
target_start_diameter = 28.8;

// Length (mm) of the tube for the target. Examples: Bosch POF 1400: 25 mm, Bosch PST 750: 15 mm, Miele 35mm Nozzles: 15 mm
target_length = 20;

// Add mount option (M4)
add_mount = true;

/* [Hidden] */

$fn = 256;

// Wall thickness of the connector (mm)
connector_wall_thickness = 3;
hose_r = (47.2)/2;      // 47.6
hose_2nd_r = hose_r-3.2;
connector_hose_thickness = connector_wall_thickness; //

dist_hose_side_start = 3.0*1.0;     // 3.0
dist_snap = 3*1.0;
snap_depth = 1.5*1.0;
dist_hose_outer_overlap = 31.0-dist_snap-dist_hose_side_start;
dist_hose_inner_overlap = 3.6*1.0;
dist_connector_extend = 2*1.0;
base_extra_thickness = 1.6; // make the base more thicker for the snap, but also for better stability during 3d printing

adapter_end_inner_r = target_end_diameter/2;
adapter_start_inner_r = target_start_diameter/2;
adapter_end_outer_r = adapter_end_inner_r+connector_hose_thickness;
adapter_start_outer_r = adapter_start_inner_r+connector_hose_thickness;
adapter_length = target_length;

connector_adapter_transition_length = abs(adapter_end_inner_r-hose_2nd_r)*1.2;

connector_length 
    = dist_hose_side_start
    +dist_snap
    +dist_hose_outer_overlap
    +dist_hose_inner_overlap
    +dist_connector_extend;
connector_outer_r = hose_r + connector_hose_thickness;

connector_points = [
        [hose_r, 0],   // inside buttom
        [connector_outer_r+base_extra_thickness, 0],   // outside bottom
        [connector_outer_r+base_extra_thickness, dist_hose_side_start], 
        [connector_outer_r, dist_hose_side_start+base_extra_thickness],
        [connector_outer_r, connector_length],

        [adapter_start_outer_r, connector_length+connector_adapter_transition_length],
                
        [adapter_end_outer_r, connector_length+connector_adapter_transition_length+adapter_length], // outside top
        
        [adapter_end_inner_r, connector_length+connector_adapter_transition_length+adapter_length], // inside top
        
        [adapter_start_inner_r, connector_length+connector_adapter_transition_length],
        
        [hose_2nd_r, connector_length],   // innen oben
        
        [hose_2nd_r, dist_hose_side_start+dist_snap+dist_hose_outer_overlap+dist_hose_inner_overlap],
        [hose_r, dist_hose_side_start+dist_snap+dist_hose_outer_overlap], 
        [hose_r, dist_hose_side_start+dist_snap],
        //[hose_r+1, dist_hose_side_start+dist_snap], 
        [hose_r+snap_depth, dist_hose_side_start],
        [hose_r, dist_hose_side_start-snap_depth/2]
    ];

//polygon(points = connector_points);

/*
    M4 Hex Nut
    d = 7.5
    
    If required, rotate around x axis (not the y axis!)
*/
module m4nut(nh=4, rh=100) {
    let( x=1.2 ) {
        union() {
            cylinder(d=7.5+x, h = nh, $fn=6);
            cylinder(d=4.4, h=rh);
        }
    }
}


mount_plate_height = 12;
mount_plate_length = 72;         // should be larger than connector_outer_r*2

module mount_bar(inner_nut=true) {
    translate([0,0,mount_plate_height])
    rotate([180,0,0])
    difference() {
        translate([-mount_plate_length/2,-mount_plate_height/2,0])
        cube([mount_plate_length, mount_plate_height, mount_plate_height]);

        translate([-30,0,-0.1])
        m4nut();
        if ( inner_nut ) {
            translate([-20,0,-0.1])
            m4nut();
            translate([20,0,-0.1])
            m4nut();
        }
        translate([30,0,-0.1])
        m4nut();
    }
}


if ( add_mount )
difference() {
    union() {
        translate([0,connector_outer_r-mount_plate_height/2+3,0])
        mount_bar();

        translate([0,-connector_outer_r+mount_plate_height/2-3-mount_plate_height/2,mount_plate_height/2])
        rotate([-90,0,0])
        mount_bar(inner_nut=false);


        translate([-mount_plate_length/2+mount_plate_height, -mount_plate_length/2+mount_plate_height*3/2, 0])
        cube([mount_plate_length-mount_plate_height*2,mount_plate_length-mount_plate_height*3,mount_plate_height]);
    }
    translate([0,0,-0.1])
    cylinder(r=connector_outer_r-0.1, h=dist_hose_outer_overlap);
}


rotate_extrude(angle = 360)
    polygon(points = connector_points);
