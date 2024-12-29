$fn = 64;

base_r = 70;
base_h = 8;

/* base rotating disk plate radius */
base_dpr = 35;

/* base fence pillar height */
base_fph = 70;
/* base fence pillar radius */
base_fpr = 4;
/* base fence pillar pos, must be >  base_dpr + base_fpr*/
base_fpp = base_dpr + base_fpr + 15;
/* base fenze height */
base_fh = 15;

/* level 1 radius */
//l1_r = base_fpp + base_fpr + 6;
l1_r = base_r;
/* level thinkness */
l1_h = 8;
/* level 1 z position */
l1_z = base_fph+base_h;

/* level 1 disk plate radius */
//l1_dpr = 30;
l1_dpr = 35;

/* level 1 fence pillar height */
l1_fph = 20;
/* level 1 fence pillar radius */
l1_fpr = 4;
/* level 1 fence pillar pos, must be >  l1_dpr + l1_fpr */
//  l1_fpp = l1_dpr + l1_fpr + 4;
l1_fpp = base_fpp;
/* l1 fenze height */
l1_fh = 15;


cylinder( h=base_h, r=base_r, $fn=6);   // base hexagon

translate([0,0,base_h+2])
cylinder( h=3, r=base_dpr, $fn=64);      // base rotating disk

translate([0,0,l1_z])
cylinder( h=l1_h, r=l1_r, $fn=6);   // level 1 hexagon

translate([0,0,l1_z + l1_h +2 ])
cylinder( h=3, r=l1_dpr, $fn=64);      // level 1 rotating disk

translate([0,0,l1_z + l1_h + 2 + 3 ])   // level 1 inner house
cylinder( h=25, r=15, $fn=6);   // hexagon

translate([0,0,l1_z + l1_h + 2 + 3 + 25 ])   // level 1 roof
cylinder( h=3, r=20, $fn=6);   // hexagon

translate([0,0,l1_z + l1_h + 2 + 3 + 25 + 3 ])   // level 1 cone
cylinder(r2=0, r1=15, h=30);

echo("Base fence length", base_fpp-base_fpr*2+2);

echo("l1 fence length", l1_fpp-l1_fpr*2+2);

for( i = [0:5] ) {
    rotate([0,0,i*360/6])
    translate([base_fpp, 0, base_h] )
    cylinder( h = base_fph, r=base_fpr );
    
    /* base fence */
    rotate([0,0,i*360/6])
    translate([0, base_fpp*0.87, base_h])
    translate([0,0, base_fh/2])     // fix center
    cube([base_fpp-base_fpr*2, 2, base_fh], center=true);

    /* l1 pillar */
    rotate([0,0,i*360/6])
    translate([l1_fpp, 0, l1_z + l1_h  ])
    cylinder( h = l1_fph, r=l1_fpr );

    /* l1 fence */
    rotate([0,0,i*360/6])
    translate([0, l1_fpp*0.87, l1_z + l1_h])
    translate([0,0, l1_fh/2])     // fix center
    cube([l1_fpp-l1_fpr*2, 2, base_fh], center=true);

    /* candle lift / foot */
    rotate([0,0,i*360/6])
    translate([0, base_r*0.87-5-5, -5])
    difference() {
        cube([base_fpp-base_fpr*2, 10, 10], center=true);
        translate([0,0,8])
        cube([12, 12, 10], center=true);
    }
    
};
