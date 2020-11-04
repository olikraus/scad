
/* "Moon Runes:style=Regular" */
use <moonrune.ttf>;

$fn=48;

f = 1.0;
fontsize=13*f;
height = 86*f;
width = 56*f;
ogap=2;

module rplate(corner_radius=5, offset=0, thickness=1) {
    hull() {
        translate([-width/2+offset,-height/2+offset,0])
        cylinder(r=corner_radius,h=thickness);

        translate([-width/2+offset,height/2-offset,0])
        cylinder(r=corner_radius,h=thickness);

        translate([width/2-offset,-height/2+offset,0])
        cylinder(r=corner_radius,h=thickness);

        translate([width/2-offset,height/2-offset,0])
        cylinder(r=corner_radius,h=thickness);
    }
}

/*
difference() {
    rplate(5, 1, 1);
    //scale([0.9, 0.9, 1.02])rplate(7, 1, 1);
    translate([0,0,-0.01])
    rplate(4, 1.5, 1.02);
}
*/

difference() {
    //translate([0,0,0.7])
    //cube([width,height,1.4], center=true);
    rplate(5, 5, 1.4);
    
    translate([0,0,0.8])
    union() {
    translate([0,(30-2)*f,0])
    linear_extrude(2) 
    text("DVFS", halign="center", 
        valign="center", 
        size=fontsize, 
        font="Moon Runes:style=Regular" );

    translate([0,(10-2)*f,0])
    linear_extrude(2) 
    text("FSDV", halign="center", 
        valign="center", 
        size=fontsize, 
        font="Moon Runes:style=Regular" );

    translate([0,(-10-2)*f,0])
    linear_extrude(2) 
    text("SDVF", halign="center", 
        valign="center", 
        size=fontsize, 
        font="Moon Runes:style=Regular" );

    translate([0,(-30-2)*f,0])
    linear_extrude(2) 
    text("VFSD", halign="center", 
        valign="center", 
        size=fontsize, 
        font="Moon Runes:style=Regular" );
    }
}

