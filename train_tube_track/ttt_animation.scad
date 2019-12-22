/*
    grid tile train tube track motor house 
    
    n20 dc gear motor 10x12x25
    
    Mini N20 Gear Reduction Motor DC 3V-6V 55RPM Slow Speed
*/
include <train_tube_track.scad>

y=0;


motor_length = 26;
motor_height = 11;
motor_width = 12.4;
motor_holder_wall = 1;

//translate([0,0,height])
union() {
//    straight_track_h_double_plug(grid);
difference() {
    straight_track_double_plug(grid);

    /* cut out gear opening */
    translate([0,0,-inner_height+d])
    cube([ship_width*house_gear_width_factor,
    ship_length*1.9, inner_height], center=true);

    translate([-grid/2-1,0,0])
    cube([grid, 4*grid, 4*grid], center=true);    
    
}


difference() {

    union() {
        translate([0,0,-height/2-outer_height/2]) 
        difference() {
            cube([outer_width, grid, height], center=true);
            translate([-outer_width/2+gear_thickness/2,0,d])
            cube([outer_width, 
                ship_length*1.95, height+3*d], center=true);
        }
        /* N20 motor block holder */
        translate([motor_length/2+gear_thickness/2+d+1,0,
         -gear_radius-inner_height/2-motor_height/4-motor_holder_wall*2-4])
        difference() {
            cube([motor_length+motor_holder_wall*2, 
                motor_width+motor_holder_wall*2,
                motor_height/2+8], center=true);
            translate([(motor_length+motor_holder_wall*2)/2,
                0, -(motor_height/2+8)/2])
            scale([2, 1, 1])
            rotate([90,0,0])
            cylinder(r=8+1, h=motor_width+motor_holder_wall*2+0.1, center=true);
        }
    }
    
    /* N20 motor block cutout*/
    translate([motor_length/2+gear_thickness/2-d+1,0,-gear_radius-inner_height/2])
    cube([motor_length, motor_width, motor_height], center=true);
    
    /* N20 motor axis cutout*/    
    translate([0,0, -gear_radius-inner_height/2])
    rotate([0,90,0])
    cylinder(d=6,h=grid,center=true);
    
    translate([-grid/2-1,0,0])
    cube([grid, 4*grid, 4*grid], center=true);    
    
  }
  
}

translate([-0.5,0,-gear_radius-inner_height/2])
rotate([0,-90,0])

rotate([0,0,(y/2)*180/3.1415/(gear_radius+1)])
ttt_gear(3+0.2, 0.5+0.1);  

for( j=[-4:4] ) {
    translate([0, ship_length*1.5*j+y/2-1.2, 1])
        ttt_ship_body_m_4();
}

