include <christmas_pyramid_2.scad>

/*
    äußere löcher: bohrvorlage für die schrauben in die Einschraubmutter des bogens
    
    4x innere löcher: Zum festscrhauben der kopiervorlage.abs
        Die löcher sollten innerhalb der base disk liegen
*/

/*
translate([0,0,base_height])
rotate([90,0,0])
wood_arc();
*/

/*
translate([0,0,-11])
rotate([0,0,45])
base_plate(h=base_height, o=0, is_cutout=true);
*/
//base_plate_template1();
translate([0,0,milling_extension+template_target_extend])
rotate([180,0,0])
base_plate_template2();


