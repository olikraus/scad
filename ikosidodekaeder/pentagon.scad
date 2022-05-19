

height=9;
dia=70;

module PentagonFrame(dia, height, wall) {
  difference() {
    cylinder(d=dia, h=height, $fn=5);
    translate([0,0,-0.01])
    cylinder(d=dia-wall, h=height+0.02, $fn=5);
  }
}

difference() {
  union() {
    PentagonFrame(dia,height, 14);

    for(w = [0:4] ) {
      rotate([0,0,w*360/5])
      translate([0,0,height/2])
      cube([dia-14,3, height], center=true);
    }
    
    cylinder(d=16, h=height);
  }
  translate([-4,0,0])
  cylinder(d=3.1, h=height*3, center=true, $fn=16);
  translate([-4,0,height/2])
  cylinder(d=6, h=height, $fn=16);
  translate([4,0,0])
  cylinder(d=3.1, h=height*3, center=true, $fn=16);
  translate([4,0,height/2])
  cylinder(d=6, h=height, $fn=16);
  
}