
$fn=16;

height = 20;
dia = 130;
inner_mount_hole_dia = 6;
top_shift = 3;

difference() {
  union() {
    intersection() {
      cylinder(d1=dia, d2=0, h=height);
      union() {
          
    translate([-inner_mount_hole_dia/2,0,-1])
    cube([inner_mount_hole_dia,dia,height*2]);
          
        for(i=[0:45:180-45] ) {
          rotate([0,0, i])
          translate([0,0,height/2])
          cube([dia, 2, height], center=true);
        }

        //translate([0,-4,0])
        //cube([dia, 8, height]);
      }
    }
    
    difference() {
      union() {
          cylinder(d1=dia, d2=dia, h=1, $fn=128);
          translate([0,0,1-0.01])
          cylinder(d1=dia, d2=0, h=height-1, $fn=128);
      }
      translate([0,0,-0.01])
      cylinder(d1=dia-5, d2=0, h=height-2, $fn=128);
    }
    

    cylinder(d=inner_mount_hole_dia+4, h=height-2, $fn=64);     // middle cylinder
    
  }  // union

  /*
  translate([10,-2.5,-0.01])
  cube([dia, 5, height]);

  translate([0,-2.5,-0.01])
  cube([dia, 5, height-5]);
  */
  
  translate([0,0,-0.01])
  cylinder(d=inner_mount_hole_dia, h=height*2, $fn=32);

    translate([-1.5,0,-1])
    cube([3,dia,height-top_shift]);



}


