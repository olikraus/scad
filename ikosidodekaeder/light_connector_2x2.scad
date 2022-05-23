/*

  light_connector_4x5.scad
   
  
  3mm x 120mm
  https://www.greenstuffworld.com/de/flugbasestaebe/600-3-mm-runde-acryl-staebe-transparent.html
  
*/

include <light_connector_lib.scad>

for( y=[0:1] ) {
  for( x=[0:1] ) {
    translate([x*20, y*26, 0])
    light_connector();
  }
}


