length = 26;
dia = 8;
wall = 1.8;
//cylinder(h = length, r1 = length, r2=0, $fn=4);


/* https://www.reddit.com/r/openscad/comments/3al0m4/copying_and_rotating/ */
module copy_rotate(degrees,vec){
    children();
    rotate(degrees, vec)
    children();
}

/* https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids */
module prism(l, w, h){
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
}

module stick_holder() {
  difference() {
    translate([0,0,length/2])
    cube([dia+2*wall, dia+2*wall, length], center=true);  
    
    translate([0,0,dia/2+wall+0.01])
    cylinder(h=length-dia/2-wall+0.01, d1=dia-0.2, d2=dia+0.2, $fn=32);
  }
}


translate([0,0,dia/2+wall])
rotate([0,-90,0])
stick_holder();

translate([0,0,dia/2+wall])
rotate([90,0,0])
stick_holder();

translate([0,0,dia/2+wall])
stick_holder();

cube([dia/2+wall, dia/2+wall, dia/2+wall]);

copy_rotate(-90, [0,0,1])
translate([-dia/2 -wall, -length+dia/2+wall -dia/2 -wall, dia+2*wall])
prism(dia+2*wall, length-dia/2-wall, length-dia/2-wall);

translate([-dia/2-wall, -length+dia/2+wall -dia/2 -wall,0])
rotate([0,-90,0])
prism(dia+2*wall, length-dia/2-wall, length-dia/2-wall);
