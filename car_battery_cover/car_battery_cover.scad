

$fn=64;
connector_dia = 4;
connector_height = 7;
mesh_height = 10;
mesh_cutout_height = 8.4;
mesh_cutout_dia = 56;
mesh_cutout_wall = 3;
mesh_cutout_delta = 6;

module con() {
    translate([0,0, 2])
    cylinder(h=connector_height-2, d=connector_dia, $fn=32);  
    cylinder(h=2, d1=connector_dia+4, d2=connector_dia, $fn=16);
}

module mesh() {
  union() {
    for(i=[0:7:70])
      translate([0,i,0])
      cube([70.01, 1.6, mesh_height]);

    for(i=[0:7:70])
      translate([i,0,0])
      cube([1.6, 70.01, mesh_height]);  
    
    translate([0,5,0])
    cube([15,10,mesh_height]);
    
    translate([0,45,0])
    cube([15,10,mesh_height]);
  }
}

translate([70/2+mesh_cutout_delta, 70/2+mesh_cutout_delta, mesh_height-mesh_cutout_height])
difference() {
  cylinder(d1=mesh_cutout_dia-10, d2=mesh_cutout_dia,h=mesh_cutout_height);
  
  translate([0,0,-0.01])
  cylinder(d1=mesh_cutout_dia-mesh_cutout_wall-10, 
    d2=mesh_cutout_dia-mesh_cutout_wall,h=mesh_cutout_height+0.02);
}

difference() {
  mesh();  
  translate([70/2+mesh_cutout_delta, 70/2+mesh_cutout_delta, mesh_height-mesh_cutout_height+0.01])
  cylinder(d1=mesh_cutout_dia-10, d2=mesh_cutout_dia,h=mesh_cutout_height);
}


translate([5, 10, mesh_height])
con();
translate([5, 10+40, mesh_height])
con();

translate([5+7,6,0])
cube([2,48,connector_height+mesh_height]);
