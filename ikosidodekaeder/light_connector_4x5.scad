/*

  light_connector_4x5.scad
   
  
  3mm x 120mm
  https://www.greenstuffworld.com/de/flugbasestaebe/600-3-mm-runde-acryl-staebe-transparent.html
  
*/

include <light_connector_lib.scad>

for( y=[0:3] ) {
  for( x=[0:4] ) {
    translate([x*22, y*28, 0])
    light_connector();
  }
}


