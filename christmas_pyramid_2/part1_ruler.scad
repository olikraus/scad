/*
    The idea is to have a tool, which allows to draw a line, which can be used 
    for precutting:
    
    Use part1 template 1:
        1. plase that template on a wood plate
        2. put a pen into the hole of the below tool and attach it to the template
        3. draw a line around the template. That line should have a distance of the 
            ring width around the template. The marks the milling edge and can
            be used for precutting
        4. With a saw follow the line, ensure to be outside the line all the time
        
*/

include <christmas_pyramid_2.scad>

inner_dia = 12;
outer_dia = inner_dia + milling_gap*2;

difference() {
    cylinder(d=outer_dia, h = 4);
    translate([0,0,-0.01])
    cylinder(d=inner_dia, h = 4.02);
}