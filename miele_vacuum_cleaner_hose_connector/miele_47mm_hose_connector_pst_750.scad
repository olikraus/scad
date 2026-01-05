/*

    Miele vacuum cleaner hose/tube connector for 47mm hose
    
    (c) olikraus@gmail.com

    CC BY-NC-SA 4.0
    Attribution-NonCommercial-ShareAlike 4.0 International
    https://creativecommons.org/licenses/by-nc-sa/4.0/
    
*/

$fn = 256;

/* [Main Dimensions] */

// Diameter of the target to which the adapter/connector should fit (mm)
// Bosch POF 1400: 40.4 mm
// Bosch PST 750: 31.6 mm
target_end_diameter = 31.6;

// if target_end_diameter > target_start_diameter, then the diameter becomes more wider.
// difference between target_end_diameter and target_start_diameter should be small
// Bosch POF 1400: 40.0 mm
// Bosch PST 750: 31.2 mm
target_start_diameter = 31.2;


// Length of the tube for the target (mm)
// Bosch POF 1400: 25 mm
// Bosch PST 750: 15 mm
target_length = 15;

// Wall thickness of the connector (mm)
connector_wall_thickness = 3;

/* [Internal Dimensions] */

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
adapter_outer_r = adapter_end_inner_r+connector_hose_thickness;
adapter_length = target_length;

connector_adapter_transition_length = abs(adapter_end_inner_r-hose_2nd_r)*1.2;

connector_length 
    = dist_hose_side_start
    +dist_snap
    +dist_hose_outer_overlap
    +dist_hose_inner_overlap
    +dist_connector_extend;
connector_outer_dia = hose_r + connector_hose_thickness;

connector_points = [
        [hose_r, 0],   // innen unten
        [connector_outer_dia+base_extra_thickness, 0],   // außen unten
        [connector_outer_dia+base_extra_thickness, dist_hose_side_start],   // außen unten
        [connector_outer_dia, dist_hose_side_start+base_extra_thickness],  // außen oben
        [connector_outer_dia, connector_length],  // außen oben

        [adapter_outer_r, connector_length+connector_adapter_transition_length],  // außen oben
                
        [adapter_outer_r, connector_length+connector_adapter_transition_length+adapter_length],
        
        [adapter_end_inner_r, connector_length+connector_adapter_transition_length+adapter_length],
        
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

rotate_extrude(angle = 360)
    polygon(points = connector_points);
