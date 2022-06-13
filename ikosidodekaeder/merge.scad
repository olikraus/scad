/*
  
    merge.scad

  some parts, put together

*/

include <base_objects.scad>;
include <light_matrix_lib.scad>;

include <light_connector_lib.scad>

for( y=[0:1] ) {
  for( x=[0:2] ) {
    translate([x*20, y*34, 0])
    light_mount_connector();
  }
}



//lightMatrix();

translate([20, 18, 0])
lightFrame();


