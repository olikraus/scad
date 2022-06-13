/*

  light_mount_connector_3x2.scad
   
  
  3mm x 120mm
  https://www.greenstuffworld.com/de/flugbasestaebe/600-3-mm-runde-acryl-staebe-transparent.html
  
*/

include <light_connector_lib.scad>

for( y=[0:1] ) {
  for( x=[0:2] ) {
    translate([x*20, y*34, 0])
    light_mount_connector();
  }
}


