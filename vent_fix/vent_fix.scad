$fn=32;

include <base_objects.scad>


w = 16;
l = 26;
t = 2.6;
h = 20;
screw_dia = 3;

 module vent_fix() {
  difference() {
    union() {
      // base plate
      difference() {
        CenterCube([w,l,t]);
        translate([0,0,-t/2])
        RoundCenterCube([screw_dia,l*0.6,t*2], Radius=screw_dia/2, ChamferBottom=0, ChamferTop=0);
        translate([0,0,t-screw_dia/2])
        RoundCenterCube([2*screw_dia,l*0.6+screw_dia,t*2], Radius=screw_dia, ChamferBottom=screw_dia/2, ChamferTop=0);
      }

      // vertical plate
      translate([0,l/2,0])
      union() {
        CenterCube([w, t, h]);
        CopyMirror([1,0,0]) {
          translate([w/2-t/2,-h*0.7/2,0])
          rotate([0,0,-90])
          TriangularPrism(bottom=[h*0.7,t], h=h*0.7, fh=0, fd=0);
        }
      }
    }
    translate([0,l/2+0.6,-0.01])
    rotate([0,0,-90])
    TriangularPrism(bottom=[t,2*w], h=h*0.4, fh=0, fd=0);
  }
}

translate([w*0.8, 0, 0])
vent_fix();

translate([-w*0.8, 0, 0])
vent_fix();
