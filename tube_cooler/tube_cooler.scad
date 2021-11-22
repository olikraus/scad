

//cylinder(d=40, h=20, $fn=64);
//cylinder(d1=40, d2=30, h=10);

include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>


wall=1;
// gap between the tube and the tube holder
tubeGap=0.1;
height=30;
chamfer0=1;
dia0=10;
chamfer1=2;
dia1=16;
chamfer2=3;
dia2=22;


module discChamfer(d, chamfer) {
  cylinder(d1=d, d2=d-chamfer*2, h=chamfer);
}

module cylinderChamfer(d, h, chamferTop=0, chamferBottom=0) {
  union() {
    if ( chamferBottom > 0 ) {
      cylinder(d1=d-chamferBottom*2, d2=d, h=chamferBottom+0.01);
    }
    translate([0,0,chamferBottom])
    cylinder(d=d, h=h-chamferBottom-chamferTop);
    if ( chamferTop > 0 ) {
      translate([0,0,h-chamferTop-0.01])
      cylinder(d1=d, d2=d-chamferTop*2, h=chamferTop);
    }
  }
}

module tubeWall(d, h, chamfer, isSolid=false) {
  difference() {
    cylinderChamfer(d=d, h=h, chamferBottom=chamfer);
    if ( isSolid == false ) {
      translate([0,0,wall])
      cylinderChamfer(d=d-wall*2, h=h, chamferBottom=chamfer-wall*0.2);
    }
  }
}


module tubeInnerHolder(d, h, chamfer) {
  intersection() {
    tubeWall(d=d, h=h, chamfer=chamfer, isSolid=true);
    rotate([0,0,-45])
    cube([h*3, wall, h*3], center=true);
  }
  intersection() {
    tubeWall(d=d, h=h, chamfer=chamfer, isSolid=true);
    rotate([0,0,45])
    cube([h*3, wall, h*3], center=true);
  }
}

module tube(d, h, chamfer) {
  union() {
    tubeWall(d, h, chamfer);
    tubeInnerHolder(d, h, chamfer);
  }
}

module tube2() {
  difference() {
    tube(dia2, height, chamfer=chamfer2);
    translate([0,0,dia2-dia1])
    tubeWall(dia1+tubeGap*2, height, chamfer=chamfer1-tubeGap, isSolid=true);
  }
}

module tube1() {
  difference() {
    tube(dia1, height-(dia2-dia1), chamfer=chamfer1);
    translate([0,0,dia1-dia0])
    tubeWall(dia0+tubeGap*2, height-(dia2-dia1), chamfer=chamfer0-tubeGap, isSolid=true);
  }
}

module tube0() {
    tubeWall(dia0, height-(dia2-dia0), chamfer=chamfer0);
}


/*
tube2();
translate([0,0,dia2-dia1])
tube1();
translate([0,0,dia2-dia0])
tube0();
*/

/*
difference() {
  tube(d=20, h=10, isSolid=false);
  translate([0,-25,0])
  cube([50,50,50], center=true);
}
*/

/*
tubeSize=10;
tubePitch = get_metric_iso_fine_thread_pitch(tubeSize);
//tubePitch = get_metric_iso_coarse_thread_pitch(tubeSize);

metric_bolt(headtype="", size=tubeSize, l=5, pitch=tubePitch, $fn=64);
//translate([20,0,0])
//metric_nut(size=tubeSize, pitch=tubePitch, center=false);

*/
