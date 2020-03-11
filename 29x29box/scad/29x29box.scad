/*

    29x29box.scad
    
    290mm x 290mm game box organizer system scad library

    (c) olikraus@gmail.com

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
    To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

     
    Storage Box Organizer System for 29x29 Game Boxes
    (wiz war, imperial settlers and others)

*/
$fn=32;
wall=1.4;
floor=0.8;
xt=31;
yt=94;
zt=28;
handle_top_distance=4;
handle_diameter=10;
card_handle_dia=50;
inner_r=1.2;
floor_border=3;

// obsolete
module rawbox(xl=31, yl=94, zl=28) {
    difference() {
        cube([xl, yl, zl], center=true);
        translate([0,0,floor])
            cube([xl-wall*2, yl-wall*2, zl], center=true);        
    }
}

module rawboxr(xl=31, yl=94, zl=28) {
    difference() {
        cube([xl, yl, zl], center=true);
        translate([0,0,floor])
	minkowski()
	{
	  cube([xl-wall*2-2*inner_r, yl-wall*2-2*inner_r, zl-2*inner_r], center=true);        
	  sphere(r=inner_r);
	}
    }
    
}

module plainbox(xg=1, yg=1, zg=1) {
  rawboxr(xg*xt, yg*yt, zg*zt);
}

module box(xg=1, yg=1, zg=1, mesh=true) {
  difference() {
    rawboxr(xg*xt, yg*yt, zg*zt);
    /* bottom grid */
    /*
    for(y=[0:yg*15-1]) {  
      for(x=[0:xg*5-1]) {
	  translate([(x-(xg*5-1)/2)*xt/6,(y-(yg*15-1)/2)*yt/18,0])
	  cube([4,4,zg*zt+0.1], center=true);
      }
    }
    
    */
    
    if ( mesh ) {
      
      for(z=[0:zg*4-1]) {  
	for(x=[0:xg*4-1]) {
	    translate([(x-(xg*4-1)/2)*xt/4.5, 0,(z-(zg*4-1)/2)*zt/4.5])
	    rotate([90,0,0])
	    cylinder(d=5, h=yg*yt+0.1, center=true, $fn=12);
	}
      }

      for(z=[0:zg*4-1]) {  
	for(y=[0:yg*12-1]) {  
	    translate([0, (y-(yg*12-1)/2)*yt/12.8,(z-(zg*4-1)/2)*zt/4.5])
	    rotate([0,90,0])
	    cylinder(d=5, h=xg*yt+0.1, center=true, $fn=12);
	}
      }
    }
    
  }


  
}



module rawxsep(xl=31, zl=28) {
    difference() {
        cube([xl, wall, zl], center=true);
        translate([0,wall,zl/2-handle_diameter/2-handle_top_distance])
        rotate([90,0,0])
        cylinder(d=handle_diameter, h=wall*2);
    }
}

module xsep(xg=1, zg=1) {
    rawxsep(xg*xt, zg*zt);
}

module rawxpsep(xl=31, zl=28) {
        cube([xl, wall, zl], center=true);
}

module xpsep(xg=1, zg=1) {
    rawxpsep(xg*xt, zg*zt);
}


module rawysep(yl=94, zl=28) {
    difference() {
        cube([wall, yl, zl], center=true);
        translate([-wall,0,zl/2-handle_diameter/2-handle_top_distance])
        rotate([0,90,0])
        cylinder(d=handle_diameter, h=wall*2);
    }
}

module ysep(yg=1, zg=1) {
    rawysep(yg*yt, zg*zt);
}

module rawypsep(yl=31, zl=28) {
        cube([wall, yl, zl], center=true);
}

module ypsep(yg=1, zg=1) {
    rawypsep(yg*yt, zg*zt);
}


module cardslot(plain=0) {
    translate([0,0,-5.8])
    rotate([0,34,0])
   
    difference() {
        cube([wall,yt,2*zt-4], center=true);
        
        translate([-wall,0,zt-2+plain*2*card_handle_dia])
        rotate([0,90,0])
        cylinder(d=card_handle_dia, h=wall*2);
    }
}

module knob(zg=1) {
    knob_d=4.0; // flat upper area
    knob_r=4.0; // radius of the knob itself
    knob_f=1.3; // thinkness extension for the knob axis

    translate([0,0,-zt*zg/2])
    cylinder(r=knob_d*knob_f,h=zt*zg-knob_r/2, $fn=48);

    translate([0,0,zt*zg/2-knob_r])
    union() {
        cylinder(r=knob_d,h=knob_r*2, center=true);
        rotate_extrude(convexity = 10, $fn = 48)
        translate([knob_d,0,0]) 
        circle(r=knob_r-0.01, $fn=32);
    }

    translate([0,0,-zt*zg/2+knob_r+floor])
    difference() {
        translate([0,0,-knob_r])
        cylinder(h=knob_r,r=knob_d*knob_f+knob_r, $fn=48);
        rotate_extrude(convexity = 10, $fn = 48)
        translate([knob_d*knob_f+knob_r,0,0]) 
        circle(r=knob_r, $fn=32);
    }
}

module knob2(zg=1) {
    knob_d=5.0; // flat upper area
    knob_r=2; // radius of the knob itself
    knob_br=6; 


    cylinder(r=knob_d-knob_r, h=zt*zg-floor*2-0.01, center=true, $fn=48);
    
    translate([0,0,zt*zg/2-knob_r])
    union() {
        cylinder(r=knob_d,h=knob_r*2, center=true);
        rotate_extrude(convexity = 10, $fn = 48)
        translate([knob_d,0,0]) 
        circle(r=knob_r-0.01, $fn=32);
    }

    translate([0,0,zt*zg/2-knob_r*3+0.05-1.28])
    difference() {
        cylinder(h=knob_r+1.5,r=knob_d+0.6, $fn=48);
        rotate_extrude(convexity = 10, $fn = 48)
        translate([knob_d+1.5,0,0]) 
        circle(r=knob_r+1.5-0.01, $fn=32);
    }

    translate([0,0,knob_br-zt*zg/2+floor ])
    difference() {
        translate([0,0,-knob_br])
        cylinder(h=knob_br,r=knob_d-knob_r+knob_br, $fn=48);
        rotate_extrude(convexity = 10, $fn = 48)
        translate([knob_d-knob_r+knob_br,0,0]) 
        circle(r=knob_br, $fn=48);
    }

}
