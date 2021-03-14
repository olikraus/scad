/*

  show_eject.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  This is an extended scad file, not intended for 3d printing.

*/


include <card_compare_machine.scad>;


eject_house(true);

translate([0,-card_height-20,0])
sorter_house(true);

translate([0,-card_height-20,sorter_house_height])
funnel();

translate([0,-card_height-20,sorter_house_height+pile_holder_height+110])
raspi_holder();

/*
difference() {
  intersection() {
    translate([0,card_height/2,card_rail])
    rotate([-card_tray_angle,0,0])
    translate([0,0,-card_height*2/2])
    cube([card_height*4, card_height*4, card_height*2], center = true);
    translate([0,card_front_gap/2,0])
    CenterCube([card_width+card_gap, card_height-card_front_gap+card_gap, house_height]);
  }
  translate([0,0,-0.01])
  CenterCube([card_width+card_gap-card_rail*2, card_height+card_gap+0.02, house_height]);
  translate([0,0,-1])
  CenterCube([card_width+card_gap, card_height*2,card_rail+1], ChamferTop=card_rail);      
  rotate([-card_tray_angle,0,0])
  translate([0,0,card_rail*0.8-100])
  CenterCube([card_width+card_gap+0.02, card_height*2,card_rail+100], ChamferTop=card_rail);    
}
*/