include <base_objects.scad>


/*
  ideen: 
  Befestigung mit Rampamuffe / Einschraubmutter
  
  8 dec 2025: 25mm -> 30mm
  30 dec 2025: more wider tempalte 2
  
  
  Scrhitte:
  1. Part 1, Template 1: 
    1.1 Mit dem Anschlag an ein Holz anlegen, dann auf das Holz aufschrauben
    1.2 Mit der Anzeichenhilfe (Ruler) im Abstand der Ruler breite einen Strich einzeichnen und 
      einmal um das Template fahren
    1.3 An dem Strich mit der Stichsäge aussägen
    1.4 Mit 17mm Kopierhülse und 8mm Fräser am Template herumfräsen
  2. Part 1, Template 2:
    2.1 Part 1 in das Template 2 einlegen und mit dem Template umdrehen
    2.2 Innenteil: Wieder mit dem Ruler anzeichnen
    2.3 Holz herausnehmen und mit der Stichsäge entlang der eingezeichneten Linie aussägen
    2.4 Holz seinsetzen
    2.5. Das Template auf einer alten holzplatte befestigen (anschrauben)
    2.6. Herausnehmen und die kanten rundfräsen 25.4mm Rundfräser fand ich fast zu wenig,
      mal mit dem 28.6mm Rund-Fräser probieren. Den fuß natürlich  nicht rund fräsen
    2.7. Template 2 benutzen um die löcher für die Einschraubmutter zu boren
    2.8. Loch für die Stange bohren (in der Schraubzwinge einklemmen, damit das Holz nicht reisst) 
      TODO: Mit Kugellager?
      
      
    
  
*/

$fn=64;         // this is overwritten and set to 256 for the solid arc and the base plate

arc_outer_height = 200;  // height of the arc
arc_outer_width = 220; // total outer width of the arc
arc_depth = 10;     // depth of the arc (not used for the tempate)
arc_thickness = 30;


milling_gap = 4.5;              // (17-8)/2
milling_gap_small = 2.5;              // (17-12)/2 = 2.5
milling_extension = 9; // thinkness of the template for the milling copy (Überstand Kopierhülse)
template_extra_size= 5;
template_target_extend = 11;     // height to hold the wood arc, should ca half the wood arc thinkness

/*
module ellipsoid(rx=30, ry=20, rz=10, $fn=100) {
    scale([rx, ry, rz]) sphere(r=1, $fn=$fn);
}
*/

/*
    h: Height of the arc
    w: base width of the arc
    z: thickness of the arc (z-axis), default: 1
    o: extra offset on height and width, default: 0
    
*/
module solid_arc(h=20, w=10, z=1, o=0) {
    difference() {
        scale([w/2+o,h+o, 1])
        cylinder(r=1,h=z, $fn=256);
        translate([0,0,-0.02])
        scale([2,2,2])
        translate([-w/2-o,-h-o,0])
        cube([w+o*2,h+o,z]);
    }
}


/*
  no need to print this part, this is just to see how it could look like
*/
module wood_arc() {
    difference() {
        solid_arc(w=arc_outer_width, h=arc_outer_height, z=arc_depth, o=0);
        translate([0,-0.01,-0.01])
        solid_arc(w=arc_outer_width, h=arc_outer_height, z=arc_depth+0.02, o=-arc_thickness);
    }
}

/*    
    M3: headdia=6, headheight=4
    M4: headdia=8, headheight=5
*/
module m3cut() {
    let(d=3.4, hd=d*2.3) {              // making d=3 a little bit wider
        union() {
            cylinder(d1=d, d2=hd, h=(hd-d)/2);
            
            translate([0,0,(hd-d)/2-0.005])
            cylinder(d=hd, h=milling_extension);
            
            translate([0,0,-milling_extension*2])
            cylinder(d=d, h=milling_extension*4);
        }
    }
}


/*
    turn around template_1 and mill around the edges. 
    The lower ruler has to be placed at the edge of the wood
*/
module template_1() {
    let (r=30) {
        difference() {
            union() {
                solid_arc(w=arc_outer_width, h=arc_outer_height, z=milling_extension, o=-milling_gap);
                translate([(-arc_outer_width+milling_gap*2)/2, -r,0])
                cube([arc_outer_width-milling_gap*2, r, milling_extension+template_target_extend]);
            }

            translate([0,0,milling_extension])
            rotate([0,180,0]) {
                translate([ arc_outer_width*0.2, arc_outer_height*0.2,milling_extension/2])
                m3cut();
                translate([ -arc_outer_width*0.2, arc_outer_height*0.2,milling_extension/2])
                m3cut();
                translate([ 0, arc_outer_height*0.6,milling_extension/2])
                m3cut();
            }
        }
    }
}

module template_2() {
    difference() {
      translate([-(arc_outer_width+template_extra_size*2)/2,-template_extra_size,0])
      cube([arc_outer_width+template_extra_size*2,arc_outer_height+template_extra_size*2,milling_extension+template_target_extend]);
      
      translate([0,-0.01,-0.01])
      solid_arc(w=arc_outer_width, h=arc_outer_height, z=milling_extension+0.02+template_target_extend, o=-arc_thickness+milling_gap);
      translate([0,-0.01,milling_extension])
      solid_arc(w=arc_outer_width, h=arc_outer_height, z=milling_extension+0.02+template_target_extend, o=0);
      //wood_arc();
      translate([-(arc_outer_width-arc_thickness*2+milling_gap*2)/2,-template_extra_size*2-0.01,-0.01])
      cube([arc_outer_width-arc_thickness*2+milling_gap*2, template_extra_size*2+0.02, 2*milling_extension+0.02+template_target_extend]);
        
      translate([0,0,milling_extension+template_target_extend])
      rotate([0,45,0])
      translate([-3,0,-3])
      cube([6,arc_outer_height*3, 6]);

      translate([arc_outer_width/2*0.9, arc_outer_height*0.9, 7])
      rotate([180,0,0])
      m3cut();

      translate([-arc_outer_width/2*0.9, arc_outer_height*0.9, 7])
      rotate([180,0,0])
      m3cut();

      translate([arc_outer_width/2*0.987, arc_outer_height*0.3, 7])
      rotate([180,0,0])
      m3cut();

      translate([-arc_outer_width/2*0.987, arc_outer_height*0.3, 7])
      rotate([180,0,0])
      m3cut();

      translate([arc_outer_width/2*0.80, arc_outer_height*0.9, 14])
      m3cut();

      translate([-arc_outer_width/2*0.80, arc_outer_height*0.9, 14])
      m3cut();

      translate([arc_outer_width/2*0.98, arc_outer_height*0.4, 14])
      m3cut();

      translate([-arc_outer_width/2*0.98, arc_outer_height*0.4, 14])
      m3cut();


      translate([-(arc_outer_width-arc_thickness)/2,-arc_outer_height*0.1,milling_extension+template_target_extend])
      rotate([0,45,0])
      translate([-3,0,-3])
      cube([6,arc_outer_height*0.2, 6]);

      translate([+(arc_outer_width-arc_thickness)/2,-arc_outer_height*0.1,milling_extension+template_target_extend])
      rotate([0,45,0])
      translate([-3,0,-3])
      cube([6,arc_outer_height*0.2, 6]);

      translate([-arc_outer_width*0.5,arc_outer_height-10,milling_extension+template_target_extend-1+0.01])
      linear_extrude(height=1)
      text("cutter 8mm", 9);

      translate([-arc_outer_width*0.5,arc_outer_height-40,milling_extension+template_target_extend-1+0.01])
      linear_extrude(height=1)
      text("screws!", 9);

    }
}

/*
translate([0,0,40])
wood_arc();
template_2();
*/

/*===============================================*/
base_height = 20;
base_disc = arc_outer_width-2*(arc_thickness+15);

function rot_z(v, a) =
    [ v[0]*cos(a) - v[1]*sin(a),
      v[0]*sin(a) + v[1]*cos(a),
      v[2] ];

function sv(sc, v) =
    [ sc[0]*v[0], sc[1]*v[1], sc[2]*v[2] ];


/*
sc = [1.12,0.86,1];                     // base plate scale 
candle4v = sv(sc,rot_z([0,0.85,0], 46));         // extend, angle´
candle2v = sv(sc, [0,0.98,0]);
*/

sc = [1.12,0.92,1];                     // base plate scale 
candle4v = sv(sc,rot_z([0,0.83,0], 46));         // extend, angle´
candle2v = sv(sc, [0,0.917,0]);

/*
    teelicht dia = 40
*/
module candle(o=0, h=base_height) {
    cylinder(d=56+o, h=h);
}

module candle_cut(o=0) {
        translate([0,0, base_height/2])
        cylinder(d=42+o, h=base_height);
}




module base_plate(h=base_height, o=0, is_cutout=false) {
    /*
    let(nsc = [sc[0]*arc_outer_width+o, sc[1]*arc_outer_width+o, sc[2]],
        ncandle4v=[candle4v[0]*arc_outer_width/2, candle4v[1]*arc_outer_width/2], candle4v[2],
        ncandle2v=[candle2v[0]*arc_outer_width/2, candle2v[1]*arc_outer_width/2], candle2v[2]
    )
    */
    let(
    nsc = [sc[0]*arc_outer_width+o,
           sc[1]*arc_outer_width+o,
           sc[2]],

    ncandle4v = [candle4v[0]*arc_outer_width/2,
                 candle4v[1]*arc_outer_width/2,
                 candle4v[2]],

    ncandle2v = [candle2v[0]*arc_outer_width/2,
                 candle2v[1]*arc_outer_width/2,
                 candle2v[2]]
    )
    difference() {
        union() {
            // y = x+o = x*f 
            // f = (x+o)/x = 1 + o/x
            scale(nsc)
            cylinder(d=1, h=h, $fn=256);

            CopyMirror(vec=[1,0,0])
            CopyMirror(vec=[0,1,0])
            translate(ncandle4v)
            candle(o=o, h=h);
            
            CopyMirror(vec=[0,1,0])
            translate(ncandle2v)
            candle(o=o, h=h);
        }
        if ( is_cutout ) {
            CopyMirror(vec=[1,0,0])
            CopyMirror(vec=[0,1,0])
            translate(ncandle4v)
            candle_cut();
            CopyMirror(vec=[0,1,0])
            translate(ncandle2v)
            candle_cut();  
            translate([0,0,base_height/2])
            cylinder(d=base_disc, h=base_height);
        }
    }
}

module base_plate_template1() {
  difference() {
    base_plate(is_cutout=false, o=-milling_gap*2, h=milling_extension);           // milling_gap had the wrong direction :-(
    
      translate([0,22,1-0.01])
      rotate([180,0,0])
      linear_extrude(height=1)
      text("cutter 8mm", 9);

      translate([0,11,1-0.01])
      rotate([180,0,0])
      linear_extrude(height=1)
      text("template 17mm", 9);
  

    
    translate([-(arc_outer_width-arc_thickness)/2,0,-1])
    cylinder(d=3, h=100);

    /* marker für die schrauben für den bogen */
    translate([-(arc_outer_width-arc_thickness)/2,0,-1])
    cylinder(d=4, h=100);

    translate([+(arc_outer_width-arc_thickness)/2,0,-1])
    cylinder(d=4, h=100);

    translate([0,0,-1])
    cylinder(d=4, h=100);

      CopyMirror(vec=[1,0,0])
      CopyMirror(vec=[0,1,0])
      translate([(base_disc/2)*0.53,(base_disc/2)*0.53,milling_gap/2+2])  // added milling_gap/2 after print
      rotate([180,0,0])
      m3cut();

  }
}

//milling_extension = 9; // thinkness of the template for the milling copy (Überstand Kopierhülse)
//template_target_extend = 11;     // height to hold the wood arc, should ca half the wood arc thinkness


module base_plate_template2() {
  let(w=240,h=milling_extension+template_target_extend,
    nsc = [sc[0]*arc_outer_width,
           sc[1]*arc_outer_width,
           sc[2]],
    ncandle4v = [candle4v[0]*arc_outer_width/2,
                 candle4v[1]*arc_outer_width/2,
                 candle4v[2]],

    ncandle2v = [candle2v[0]*arc_outer_width/2,
                 candle2v[1]*arc_outer_width/2,
                 candle2v[2]]
    ) {
    difference() {
      translate([-w/2,-w/2,0])
      cube([w, w, h]);


      translate([w/2-75,w/2-40,h-1+0.01])
      linear_extrude(height=1)
      text("cutter 12mm", 9);

      translate([w/2-86,w/2-55,h-1+0.01])
      linear_extrude(height=2)
      text("template 17mm", 9);
      

      translate([0,0,-0.01])
      rotate([0,0,45])
      base_plate(is_cutout=false, o=0, h=template_target_extend+0.01);

      rotate([0,0,45])
      union() {
            CopyMirror(vec=[1,0,0])
            CopyMirror(vec=[0,1,0])
            translate(ncandle4v)
            candle_cut(o=milling_gap_small*2);
            CopyMirror(vec=[0,1,0])
            translate(ncandle2v)
            candle_cut(o=milling_gap_small*2);
            
            translate([0,0,base_height/2])
            cylinder(d=base_disc+milling_gap_small*2, h=base_height, $fn=128);
      }
      
      CopyMirror(vec=[1,0,0])
      CopyMirror(vec=[0,1,0])
      translate([100,100,template_target_extend])
      m3cut();

    }
  }  
}

