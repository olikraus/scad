$fn=12;

hole_dia = 5;
hole_gap = 0.5;
cylinder_dia = 60;
cylinder_hext = 10;
h_cnt = 5;
drop_wall = 0.5;
cylinder_wall = 12;


cylinder_height = (h_cnt)*(hole_dia+hole_gap)+2*cylinder_hext;

n = floor(PI*cylinder_dia/(hole_dia+hole_gap));

module hole_maker() {
  rotate([0,90,0])
  cylinder(h = 4, d1=hole_dia, d2=1);
}

module hole_ring() {
  for( rot = [0:360/n:360] ) {
    rotate([0,0,rot])
    translate([cylinder_dia/2,0,0])
    hole_maker();
  }
}

module hole_roller() {
  for( i=[0:h_cnt-1] ) {
    translate([0,0,i*(hole_dia+hole_gap)])
    hole_ring();
  }

  translate([0,0,-(hole_dia+hole_gap)/2])
  difference() {
    translate([0,0,-cylinder_hext])
    cylinder(d=cylinder_dia+0.2, h = cylinder_height, $fn=4*$fn);
    translate([0,0,-0.01-cylinder_hext])
    cylinder(d=cylinder_dia-cylinder_wall, h = cylinder_height+0.02, $fn=4*$fn);
  }
}

//hole_roller();

module plant_drop() {
  rotate([0,90,0])  
  intersection() {
    union() {
      difference() {
        cylinder(h = 4, d1=hole_dia, d2=1);
        translate([0,0,-0.01])
        cylinder(h = 4, d1=hole_dia-drop_wall*2, d2=1-drop_wall*2);
      }
    }
    cylinder(d=hole_dia,h=1.5);
  }
}

module plant_ring() {
  for( rot = [0:360/n:360] ) {
    rotate([0,0,rot])
    translate([cylinder_dia/2,0,0])
    plant_drop();
  }
}

module plant_cut_out_ring() {
  for( rot = [0:360/n:360] ) {
    rotate([0,0,rot])
    translate([cylinder_dia/2-cylinder_wall-0.01,0,0])
    rotate([0,90,0])
    cylinder(d=hole_dia-drop_wall*2,h=cylinder_wall+0.2);
  }
}

module plant_roller() {
  for( i=[0:h_cnt-1] ) {
    translate([0,0,i*(hole_dia+hole_gap)])
    plant_ring();
  }

  difference() {
    translate([0,0,-(hole_dia+hole_gap)/2])
    difference() {
      translate([0,0,-cylinder_hext])
      cylinder(d=cylinder_dia+0.2, h = cylinder_height, $fn=4*$fn);
      
      cylinder(d1=cylinder_dia-cylinder_wall, 
        d2=cylinder_dia-cylinder_wall, 
        h = cylinder_height-2*cylinder_hext, $fn=4*$fn);
      
      translate([0,0,-cylinder_hext-0.01])
      cylinder(d1=cylinder_dia-cylinder_wall*2, 
        d2=cylinder_dia-cylinder_wall, 
        h = cylinder_hext+0.02, $fn=4*$fn);
      
      translate([0,0,cylinder_height-2*cylinder_hext-0.01])
      cylinder(d1=cylinder_dia-cylinder_wall, 
        d2=cylinder_dia-cylinder_wall*2, 
        h = cylinder_hext+0.02, $fn=4*$fn);
    }
    for( i=[0:h_cnt-1] ) {
      translate([0,0,i*(hole_dia+hole_gap)])
      plant_cut_out_ring();
    }
  }
}


hole_roller();

translate([cylinder_dia*0.8,cylinder_dia*0.8,0])
plant_roller();

