

w0 = 5.6;
h0 = 0.5;
w1 = 5.2;
h1 = 0.4;
w2 = 5.2;
h2 = 1.2;
w3 = 8;
h3 = 4;
w4 = 9;
h4 = 2;
w5 = 7.1;

module cutout() {
    union() {
        rotate([0,0,45])
        cylinder(h=h0+0.01,d1=w0*sqrt(2),d2=w0*sqrt(2), $fn=4);

        translate([0,0,h0])
        rotate([0,0,45])
        cylinder(h=h1+0.01,d1=w0*sqrt(2),d2=w1*sqrt(2), $fn=4);

        translate([0,0,h0+h1])
        rotate([0,0,45])
        cylinder(h=h2+0.01,d1=w2*sqrt(2),d2=w2*sqrt(2), $fn=4);

        translate([0,0,h0+h1+h2+h3/2])
        cube([w3,8,h3+0.02], center=true);

        pts = [[-w4/2,0],[-w5/2,h4],[w5/2,h4],[w4/2,0]];
        translate([0,0,h0+h1+h2+h3])
        translate([0,10,0])
        rotate([90,0,0])
        linear_extrude(height=20)
        polygon(pts);
    }
}

union() {
difference() {
    translate([0,0,(h0+h1+h2+h3+h4)/2])
    cube([10,10,h0+h1+h2+h3+h4-0.03], center=true);
    translate([0,0,-0.01])
    cutout();
}
/*
1.84 1.87 funktioniert nicht
1.80 war glaube ich zu locker
1.82 noch zu testen
*/
pfd=1.82;  
translate([7/2+0.15,0,0.2])
rotate([0,-10,0])
cylinder(d=pfd,h=1.6, $fn=32);

translate([-7/2-0.15,0,0.2])
rotate([0,10,0])
cylinder(d=pfd,h=1.6, $fn=32);

translate([0,7/2+0.15,0.2])
rotate([10,0,0])
cylinder(d=pfd,h=1.6, $fn=32);

translate([0,-7/2-0.15,0.2])
rotate([-10,0,0])
cylinder(d=pfd,h=1.6, $fn=32);
}

