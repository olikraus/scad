/*

  show_eject.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  This is an extended scad file, not intended for 3d printing.

*/


include <card_compare_machine.scad>;


eject_house(true);

translate([0,-card_height-22,0])
sorter_house(true);

translate([0,-card_height-22,sorter_house_height])
funnel();

translate([0,-card_height-20,sorter_house_height+pile_holder_height+110])
raspi_holder();

CopyMirror([1,0,0])
translate([card_width*1.15,-card_height-22,0])
ccm_double_basket();

translate([50,-190,0])
color("SlateBlue") linear_extrude(2) text("Double Basket", 16);

translate([-190,-190,0])
color("SlateBlue") linear_extrude(2) text("Double Basket", 16);

translate([-40,-210,0])
color("SlateBlue") linear_extrude(2) text("Sorter", 16);

translate([50,+40,0])
color("SlateBlue") linear_extrude(2) text("Eject Unit", 16);


translate([40,-100,150])
color("SlateBlue") linear_extrude(2) text("Funnel", 16);

translate([-25,-150,210])
rotate([0,0,55])
color("SlateBlue") linear_extrude(2) text("Raspi Holder", 12);

