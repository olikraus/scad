/*

  stand.gcad

  dia * 0.588 = sec

*/

ikosidodekaederSecLen = 90;

ikosidodekaederDia = ikosidodekaederSecLen / 0.588;

standLowerDia = ikosidodekaederDia + 26;
standUpperDia = ikosidodekaederDia + 12;
standHeight = 10;
ikosidodekaederOuterDia = ikosidodekaederDia+6;
bottomHeight = 2;

echo(ikosidodekaederDia);

difference() {
  cylinder(d1=standLowerDia, d2=standUpperDia,standHeight, $fn=5);
  
  /* cutout for the ikosidodekaeder itself */
  translate([0,0,bottomHeight])
  cylinder(d=ikosidodekaederOuterDia,standHeight, $fn=5);
  
  /* cutout on the buttom to reduce printing material and time */
  translate([0,0,-0.01])
  cylinder(d=ikosidodekaederDia*0.7, standHeight);
}

for(w = [0:4] ) {
  rotate([0,0,w*360/5])
  translate([standUpperDia/2/2,0,bottomHeight/2])
  cube([standUpperDia/2, 8, bottomHeight], center=true);
}
