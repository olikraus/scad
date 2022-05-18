/*

  light_connector.scad
   
  
  3mm x 120mm
  https://www.greenstuffworld.com/de/flugbasestaebe/600-3-mm-runde-acryl-staebe-transparent.html
  
*/
$fn=32;

width=14;
height=10;
length=20;
boxmove=1.6;
edgeDia = 3.02;
outerLWDia = 4.7;
innerLWDia = 4.5;
clipWidth = 10.2;
clipHeight = height;
clipThinkness = 1.2;
clipXWidth = clipWidth*0.8;
clipXThinkness = width;
clipXOffset = 1; 
clipOffset = 1; /* offset of the clip cutout above ground */
clipDistance = 1.5; /* distance from the edge to the clip=wall between edge and clip */

difference() {
  translate([-width/2, -width/2+boxmove,0])
  cube([width, length, height]);

  /* LWL cutout */

  translate([0,0,height/2])
  rotate([-90,0,0])
  cylinder(d1=innerLWDia, d2=outerLWDia, h=length-width/2+boxmove+0.01);

  /* touch pad reflection hole */

  translate([0,-width,height/2])
  rotate([-90,0,0])
  cylinder(d=innerLWDia, h=length);

  /* ikosidodekaeder edge cutout */
  
  translate([0,0,height/2])
  rotate([0,90,0])
  cylinder(d=edgeDia, h=width+0.02, center=true);
  
  translate([0,0,-edgeDia*0.2])  
  cube([width+0.02, edgeDia*0.9, height], center=true);

  /* chamfer to reduce issues with brim */
  
  rotate([45,0,0])
  cube([width+0.02, edgeDia*1.2, edgeDia*1.2], center=true);

  /* battery clip cutout */
  
  translate([-clipWidth/2,-clipThinkness-edgeDia/2-clipDistance,clipOffset])
  cube([clipWidth, clipThinkness, clipHeight]);

  translate([-clipXWidth/2,-clipXThinkness-clipThinkness-edgeDia/2-clipDistance+0.01,clipXOffset+clipOffset])
  cube([clipXWidth, clipXThinkness, clipHeight]);
}

