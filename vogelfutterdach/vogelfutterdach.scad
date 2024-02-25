
$fn=16;

height = 20;
dia = 110;
inner_mount_hole_dia = 5;

difference() {
  union() {
    intersection() {
      cylinder(d1=dia, d2=0, h=height);
      union() {
        for(i=[0:45:180-45] ) {
          rotate([0,0, i])
          translate([0,0,height/2])
          cube([dia, 1.4, height], center=true);
        }

        //translate([0,-4,0])
        //cube([dia, 8, height]);
      }
    }

    difference() {
      cylinder(d1=dia, d2=0, h=height, $fn=128);
      translate([0,0,-0.01])
      cylinder(d1=dia-10, d2=0, h=height-2);
    }

    cylinder(d=inner_mount_hole_dia+4, h=height-2);
  }

  /*
  translate([10,-2.5,-0.01])
  cube([dia, 5, height]);

  translate([0,-2.5,-0.01])
  cube([dia, 5, height-5]);
  */
  
  translate([0,0,-0.01])
  cylinder(d=inner_mount_hole_dia, h=height*2);

}