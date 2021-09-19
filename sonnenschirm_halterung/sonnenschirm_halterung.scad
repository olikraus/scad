/*

  sonnenschirm_halterung.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

*/

$fn=64;

inner_dia = 14;
outer_dia = 15.5;
chamfer = 0.5;
//h1 = 55;
h1 = 54;
h2 = 3;
h3 = 4;
h4 = 8;
h5 = 20;

h6 = 20;
h7 = 50;
wall = 2;

points = [
  [0, h1+h2+h3+h4+h5],
  [(inner_dia)/2, h1+h2+h3+h4+h5],
  [(inner_dia)/2, h2+h3+h4+h5+chamfer],
  [(outer_dia)/2, h2+h3+h4+h5],
  [(outer_dia)/2, h3+h4+h5],
  [(inner_dia)/2, h3+h4+h5-chamfer],
  [(inner_dia)/2, h4+h5+chamfer],
  [(outer_dia)/2, h4+h5],
  [(outer_dia)/2, h5],
  [(inner_dia)/2, h5-chamfer],
  [(inner_dia)/2, 0],
  [0, 0] 
];


rotate([180,0,0])
union() {
  rotate_extrude()  
  polygon(points);  

  translate([0,0,-(h6+h7)/2])
  intersection() {
    union() {
      cube([inner_dia, wall, h6+h7], center=true);
      rotate([0,0,90])
      cube([inner_dia, wall, h6+h7], center=true);
    }
    cylinder(d2=inner_dia, d1=wall, h=h6+h7, center=true);
  }

  translate([0,0,-h6])
  cylinder(d2=inner_dia, d1=0, h=h6);
  
  
  translate([0,0,h1+h2+h3+h4+h5-10/2])
  intersection() {
    union() {
      cube([50, 0.8, 10], center=true);
      rotate([0,0,90])
      cube([50, 0.8, 10], center=true);  
    }
    cylinder(d2=50, d1=inner_dia, h=10, center=true);
  }
}



