$fn=64;


spacing = 10;  // distance between objects
count = 2;     // grid size (4x4)

// Loop through rows and columns
for (x = [0 : count - 1])
    for (y = [0 : count - 1])
        translate([x * spacing, y * spacing, 0])
            difference() {
                cylinder(h=6, d1=8.4, d2=8);
                translate([0,0,-0.01])
                cylinder(h=9, d=3.4);
            }
    