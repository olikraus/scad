/*
  
    merge.scad

  some parts, put together

*/

include <base_objects.scad>;
include <light_matrix_lib.scad>;

include <light_connector_lib.scad>

dia = 5;
idia = 3.4;
da = acos((-sqrt((5+2*sqrt(5))/15)));
nodeFn =32;

module nodeEnd() {
  difference() {
    cylinder(d=dia, h=12, $fn=nodeFn);
    cylinder(d=idia, h=12.01, $fn=nodeFn);
  }
}

//cube([40,40,1], center=true);

module ikosidodekaederConnector() {
  difference() {
    union() {
      scale([0.65,1,1])
      rotate([0,0,45])
      // arg 1: height, depends on idia
      // arg 2: base width
      cylinder(5,12.76,0,$fn=4);


      translate([0,0,6])
      rotate([0,31.5,0])
      rotate([0,0,(108-90)/2+45])
      union() {
        sphere(d=dia, $fn=nodeFn);
        rotate([0,0,-108])
        union() {
          rotate([0,0,108])
          rotate([0,90,0])
          nodeEnd();

          rotate([0,90,0])
          nodeEnd();

          rotate([180-da,0,0])
          rotate([0,0,-60])
          rotate([0,90,0])
          nodeEnd();
        }
        rotate([da-180,0,0])
        rotate([0,0,60])
        rotate([0,90,0])
        nodeEnd();
      }
    }
    translate([0,0,-1+0.001])
    cube([30,30,2], center=true);
  }
}



for( y=[0:1] ) {
  for( x=[0:2] ) {
    translate([x*20, y*34, 0])
    light_mount_connector();
  }
}



//lightMatrix();

translate([20, 18, 0])
lightFrame();

for( x=[0:4] ) {
  
  translate([x*20-20,-40,0])
  ikosidodekaederConnector();
}

