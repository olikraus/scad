
include <christmas_pyramid_2.scad>

echo(base_disc);

insert_gap=1.4;   // extra gap for the disc to rotate inside

difference() {
    cylinder(d=base_disc-milling_gap*2-insert_gap*2, h=milling_extension, $fn=256);
      CopyMirror(vec=[1,0,0])
      CopyMirror(vec=[0,1,0])
      translate([(base_disc/2)*0.53,(base_disc/2)*0.53,milling_gap/2+2])  // added milling_gap/2 after print
   //   rotate([180,0,0])
      m3cut();
    
    /* marker für die mittelachse */
    translate([0,0,-1])
    cylinder(d=4, h=100);

  translate([-base_disc/3,10,milling_extension-1+0.01])
  linear_extrude(height=1)
  text("cutter 8mm", 9);

}
