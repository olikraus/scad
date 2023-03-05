
width=60;
length=40;
height=18;
wall = 1.4;
gap=2;

module copy_mirror(vec=[0,1,0]) {
    children();
    mirror(vec) 
    children();
}


module concave_fillet(dia, length) {
  translate([0,-dia/2,dia/2])
  difference() {
    translate([0,dia/4,-dia/4])
    cube([length,dia/2,dia/2], center=true);
    rotate([0,90,0])
    cylinder(d=dia, h=length+0.02, center=true, $fn=64);
  }
}



copy_mirror([0,1,0])
{
  translate([0,-gap/2-wall,wall])
  concave_fillet(height*2, length);
  
  translate([0,-gap*0.6,height])
  rotate([0,90,0])
  cylinder(d=gap*0.6,h=length, center=true, $fn=16);

  translate([0,-gap/2-wall/2, height/2+wall])
  cube([length, wall, height], center=true);
}

translate([0,0,wall/2])
cube([length, width, wall], center=true);