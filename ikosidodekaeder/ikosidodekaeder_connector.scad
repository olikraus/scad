/*

  ikosidodekaeder_connector.scad
   
  
  https://memory-alpha.fandom.com/wiki/Kal-toh
  
  https://de.wikipedia.org/wiki/Ikosidodekaeder
  
  pentagonal faces: 108 Degree
  triangular faces: 60 Degree
  
  The dihedral angle between triangular and pentagonal faces is
  alpha	=	cos^(-1)(-sqrt(1/(15)(5+2sqrt(5))))	
	=	142.623... degrees.
  

  3mm x 120mm
  https://www.greenstuffworld.com/de/flugbasestaebe/600-3-mm-runde-acryl-staebe-transparent.html
  
*/

dia = 5;
idia = 3.4;
da = acos((-sqrt((5+2*sqrt(5))/15)));
nodeFn =32;

module nodeEnd() {
  difference() {
    cylinder(d=dia, h=12, $fn=nodeFn);
    cylinder(d=idia, h=12.01, $fn=nodeFn);
  }
}

//cube([40,40,1], center=true);

module ikosidodekaederConnector() {
  difference() {
    union() {
      scale([0.65,1,1])
      rotate([0,0,45])
      // arg 1: height, depends on idia
      // arg 2: base width
      cylinder(5,12.76,0,$fn=4);


      translate([0,0,6])
      rotate([0,31.5,0])
      rotate([0,0,(108-90)/2+45])
      union() {
        sphere(d=dia, $fn=nodeFn);
        rotate([0,0,-108])
        union() {
          rotate([0,0,108])
          rotate([0,90,0])
          nodeEnd();

          rotate([0,90,0])
          nodeEnd();

          rotate([180-da,0,0])
          rotate([0,0,-60])
          rotate([0,90,0])
          nodeEnd();
        }
        rotate([da-180,0,0])
        rotate([0,0,60])
        rotate([0,90,0])
        nodeEnd();
      }
    }
    translate([0,0,-1+0.001])
    cube([30,30,2], center=true);
  }
}

ikosidodekaederConnector();

