/*

  card_compare_machine.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

*/

include <base_objects.scad>;

$fn=20;

/* dimensions of the cards */
card_width = 63;
card_height = 88;

/* outer gap of the cards */
//card_gap = 2;  
card_gap_w = 2; // 7 Mar 21: increased 1->2
card_gap_h = 3;  // 21 Mar: 2->3

/* inner rail size, must be greater than card_gap */
card_rail = 10;

/* the card rail is shorter than the cards by this value */
/* the card driving wheel is below the front rail */
card_front_gap = card_height/4;

/* the height of the tray */
tray_height = 30;

/* card tray angle: Must be < 11 Degree */
card_tray_angle = 22;

/* diameter of the drive wheel */
wheel_diameter = 65;

/* how much should the wheel lift the cards beyond tray rails */
wheel_card_lift = 1;

/* thickness of all the walls */
wall=2;

/* Extra gap so that the tray can be stacked on the motor house */
pile_gap = 0.8;

/* The extended wall to hold the tray */
pile_holder_height = 8;

/* mount hole diameter */
mhd = 2.9;	// 7 Mar 2020 increased from 2.8 to 2.9

/* The height of the left and right eject slot for the sorter */
sorter_card_slot_height = 3;

/* The width of the outside rails in the sorter */
sorter_rail_width = 10;


/* derived: the height of the card cast edge above reference level 0 */
cast_edge_z = card_rail+sin(card_tray_angle)*(card_height-card_front_gap);

/* This is the overall height of the eject house */
house_height = 125;

/* motor mount height of the eject house */
motor_mount_height = 55;

/* eject_sorter_rail_height */
eject_sorter_rail_height = 25;


/* led_diffuser_cone_diameter */
led_diffuser_cone_diameter = 18;

/*==============================================*/
/* helper function */

module CopyMirror(vec=[0,1,0]) {
    children();
    mirror(vec) 
    children();
} 

/*==============================================*/
/* helper objects */

module motor_mount_bracket() {
    color("DarkSlateGray", 0.4)
    difference() {
            
        translate([0,1.5,0])
        difference() {
            union() {
                translate([0,0,1.5])
                cube([26.5, 33, 3], center=true);

                translate([0,33/2-3/2,(33-26.5/2)/2])
                cube([26.5, 3, 33-26.5/2], center=true);

                translate([0,33/2,33-26.5/2])
                rotate([90,0,0])
                cylinder(h=3,d=26.5,$fn=16);
            }

            translate([0,33/2+0.1,33-26.5/2])
            rotate([90,0,0])
            cylinder(h=3.2,d=8, $fn=16);

            translate([8.5,33/2+0.1,33-26.5/2])
            rotate([90,0,0])
            cylinder(h=3.4,d=3.2, $fn=16);

            translate([-8.5,33/2+0.1,33-26.5/2])
            rotate([90,0,0])
            cylinder(h=3.4,d=3.2, $fn=16);
        }
        
        cylinder(h=8,d=10, center=true);
        
        translate([8,7,0])
        cylinder(h=8,d=3.4, center=true, $fn=16);
        
        translate([8,-7,0])
        cylinder(h=8,d=3.4, center=true, $fn=16);

        translate([-8,7,0])
        cylinder(h=8,d=3.4, center=true, $fn=16);
        
        translate([-8,-7,0])
        cylinder(h=8,d=3.4, center=true, $fn=16);
    }
}

/*
    GM25-370ABHL
    25GA 370
    6V, 165 rpm
*/
module motor() {
    motor_mount_bracket();

    color("Silver",0.3)
    translate([0,15-0.1,33-26.5/2])
    rotate([90,0,0])
    cylinder(h=70,d=25, $fn=16);

    color("Silver",0.3)
    translate([0,36+4,33-26.5/2])
    rotate([90,0,0])
    cylinder(h=27,d=wheel_diameter, center=true, $fn=32);
}


/* inner chamfer */
module triangle(h) {
  linear_extrude(height=h)
  polygon([[0,0],[wall,0],[0,wall]]);
}


/*=====================================================*/
/* grove 2x1 */

module grove_2x1_cutout(lh, uh, grove_pcb_height = 2) {
    d = 0.6;
    translate([-20, -10, 0])
    union() {
      difference() {
          grove_screw_d = 5;		// used as cutout, so 5 instead of 4
          grove_hole_d = 4;		// used as cutout, so make it 4 instead of 5

          union() {
              translate([10,20,lh])
                  cylinder(h=uh+grove_pcb_height,d=grove_screw_d);
              translate([10,0,lh])
                  cylinder(h=uh+grove_pcb_height,d=grove_screw_d);
              translate([40,10,lh])
                  cylinder(h=uh+grove_pcb_height,d=grove_screw_d);
              
              translate([-d/2, -d/2, 0])
              cube([40+d, 20+d, uh+grove_pcb_height+lh]);
          }
          
          translate([40,10,-0.001])
              cylinder(h=lh,d=grove_screw_d);
          translate([10,0,-0.001])
              cylinder(h=lh,d=grove_screw_d);
          translate([10,20,-0.001])
              cylinder(h=lh,d=grove_screw_d);

          translate([30,0,-0.001])
              cylinder(
                  h=grove_pcb_height+lh+0.002,
                  d=grove_hole_d);
          translate([30,20,-0.001])
              cylinder(
                  h=grove_pcb_height+lh+0.002,
                  d=grove_hole_d);
          translate([0,10,-0.001])
              cylinder(
                  h=grove_pcb_height+lh+0.002,
                  d=grove_hole_d);
      }
      translate([10,0,lh-10])
          cylinder(h=uh+grove_pcb_height+20,d=2.2, $fn=8);
      translate([10,20,lh-10])
          cylinder(h=uh+grove_pcb_height+20,d=2.2, $fn=8);
      translate([40,10,lh-10])
          cylinder(h=uh+grove_pcb_height+20,d=2.2, $fn=8);
    }
}

module grove_2x1() {
  difference() {
    translate([0,0,-30+5])
    //cube([40+4,20+4,30], center=true);
    CenterCube([40+4,20+4,30], ChamferBody=0.8, ChamferTop=0.8);
    
    
    grove_2x1_cutout(3,12);
  }
}


/*==============================================*/
/* card tray for the eject block (obsolete at the moment) */

module tray() {
  iw = card_width+card_gap_w;
  ih = card_height+card_gap_h;
  tw = card_width+card_gap_w+2*wall;
  th = card_height+card_gap_h+2*wall-0.01;
  tz = 20;        /* depends on card_tray_angle, just needs to be high enough */

  intersection() 
  {
    union() {
    
      
      rotate([card_tray_angle,0,0])
      difference() {
          translate([-tw/2,0,-2*tz])
          cube([tw, th-card_front_gap, 3*tz]);
          
          translate([-iw/2,wall,wall])
          cube([iw, th-card_front_gap, tz]);

          translate(
              [-(iw-card_rail*2)/2,wall+card_rail,-2*tz-0.01])
          cube([iw-card_rail*2, ih-card_front_gap, 3*tz]);
          
      }

  
      difference() {
          translate([-tw/2,0,0])
          cube([tw, th, tray_height]);
          
          translate([-iw/2,wall,-0.01])
          cube([iw, th, tray_height+0.02]);
      }
    
    }
    translate([-tw/2,0,0])
    cube([tw, th, tray_height]);
  }
}

/*==============================================*/
/* card sorter house */
module SlopeCube(w = 10, l = 35, zs = 20, hs = 10, ze = 50, he = 10) {
/*
w = 10;
l = 35;
zs = 20;  // upper position on sorter side
hs = 20;   // height on sorter side
ze = 50;  // upper position on eject side
he = 10;  // height on eject side
*/

p = [
  [ -w/2, 0,  zs-hs ],  //0
  [ w/2,  0,  zs-hs ],  //1
  [ w/2,  l,  ze-he ],  //2
  [ -w/2, l,  ze-he ],  //3
  [ -w/2, 0,  zs ],  //4
  [ w/2,  0,  zs ],  //5
  [ w/2,  l,  ze ],  //6
  [ -w/2, l,  ze ]]; //7
  
f = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
polyhedron( p, f );
}


/*==============================================*/
/* card sorter house */

sorter_house_height = motor_mount_height + wheel_diameter/2 + 21 - pile_holder_height - eject_sorter_rail_height;

module sorter_house(isMotor = false) {

  cbo = 1;	// ChamferBody is 1 for all outer edges and 
  osd = 8*cbo;		// distance of the outer support rail to front and back
  osw = 5*cbo;	// width of the outer support rail
  osx = 3*cbo;		// outer support extend on both sides, so the per side extend is osx/2


  // height of the motor mount block
  mh = sorter_house_height+wheel_card_lift-sorter_card_slot_height-wheel_diameter/2-21;

  // inner dimensions of the house. 
  iw = card_width+card_gap_w;
  ih = card_height+card_gap_h;

  // outer dimensions of the house
  tw = card_width+card_gap_w+2*wall;
  th = card_height+card_gap_h+2*wall;
  
  motor_y_pos = -card_height/2+10;

  difference() {
    union() {
      // the main volume of the house
      CenterCube([tw,th,sorter_house_height], ChamferBody=1);

      // same outer stripes like for the funnel (just decoration)
      CopyMirror([0,1,0])
      translate([0,th/2-osd,0])
      CenterCube([tw+osx,osw,sorter_house_height], ChamferBody=1);


      // the pedestal for the tray
      translate([0,0,sorter_house_height-wall])
      CenterCube([tw+2*wall+pile_gap,th+2*wall+pile_gap,wall+pile_holder_height], ChamferBottom=wall+pile_gap/3, ChamferBody=1);

      // rail from eject to sorter
      
      translate([(iw-card_rail)/2,th/2,0])
      SlopeCube(w = card_rail, l = 37, 
	zs = sorter_house_height+pile_holder_height,  hs = 40, 
	ze = motor_mount_height+wheel_diameter/2+21, he = 10);

      translate([-(iw-card_rail)/2,th/2,0])
      SlopeCube(w = card_rail, l = 37, 
	zs = sorter_house_height+pile_holder_height,  hs = 40, 
	ze = motor_mount_height+wheel_diameter/2+21, he = 10);

    }
    
    // main inner cutout
    translate([0,0,-0.01])
    CenterCube([iw,ih,sorter_house_height-sorter_card_slot_height+0.02], ChamferBody=wall, ChamferTop=sorter_rail_width);

    // cutout for the tray holder extention (pedestal)
    translate([0,0,sorter_house_height])
    CenterCube([tw+pile_gap,th+pile_gap,pile_holder_height+3]);
    
    translate([0,0,sorter_house_height-sorter_card_slot_height])
    CenterCube([iw*2, ih,pile_holder_height*2]);

    // cutout portal on both walls for the dc motor and usage of screw drivers
    //translate([0,  -(card_height/2-card_front_gap),  mh])
    translate([0,  0,  mh])
    rotate([0,0,90])
    Archoid(r=33/2, b=sorter_house_height-33/2-14-mh, l=2*card_height);
    
    // do some cutout for the wheels, Archoid is 12mm above ground
    translate([0,  0,  12])
    Archoid(r=24, b=18+mh-12, l=2*card_width);

    // cutout so that the cards can fall better on left and right side
    CopyMirror([1,0,0])
    translate([tw/2+osx,0,sorter_house_height-sorter_card_slot_height])
    ChamferYCube(w=6+osx, h=ih);    
  }
  

  
  // mount block for the motor
  translate([0,motor_y_pos,0])
  difference() {
    CenterCube([33,33,mh], ChamferBody=1);

    rotate([0,0,90])
    CopyMirror([1,0,0])
    CopyMirror([0,1,0])
    translate([7,8,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
  }

  // chamfer for the mount block
  
  translate([33/2,-ih/2,0])
  ChamferZCube(w=wall,h=mh);

  translate([33/2,-ih/2-wall,0])
  ChamferZCube(w=1,h=mh);

  translate([-33/2,-ih/2,0])
  ChamferZCube(w=wall,h=mh);

  translate([-33/2,-ih/2-wall,0])
  ChamferZCube(w=1,h=mh);

  // add extra support for the complete block on the z=0 plane
  
  translate([0,th/4,0])
  CenterCube([tw, 6, wall], ChamferTop=1);

  translate([0,-th/4,0])
  CenterCube([tw, 6, wall], ChamferTop=1);




/*
  catch_rail_cut=5;
  catch_rail_len=40;  // the real length is catch_rail_len-catch_rail_cut
  translate([0,card_height/2+card_gap_h/2+wall, sorter_house_height-catch_rail_len+pile_holder_height])
  difference() {
    translate([0,catch_rail_len/2,0])
    CenterCube([card_width+card_gap_w, catch_rail_len, catch_rail_len]);
    
    translate([0,catch_rail_len,0])
    ChamferXCube(w=catch_rail_len,h=card_width+card_gap_w, d=0.02);
    
    translate([0,catch_rail_len/2,0])
    CenterCube([card_width+card_gap_w-2*card_rail, catch_rail_len+0.02, catch_rail_len+0.02]);

    translate([0,catch_rail_len,0])
    CenterCube([card_width+card_gap_w+0.02, 2*catch_rail_cut, catch_rail_len+0.02]);  
  }
  */

  if ( isMotor )
  {
      translate([0,motor_y_pos,mh])
      //rotate([0,0,180])
      motor();
  }

}

/*==============================================*/
/* card eject house */

module eject_house(isMotor=false) {

  phh = pile_holder_height;
  mh = motor_mount_height;
  
  // extention of the eject house so that the wheel is placed more to the end of the cards
  ext = 14;

  // inner dimensions of the house. 
  iw = card_width+card_gap_w;
  ih = card_height+card_gap_h+ext;

  // outer dimensions of the house
  tw = card_width+card_gap_w+2*wall;
  th = card_height+card_gap_h+2*wall+ext;
  
  // center position of the motor mount block 
  mmx = card_width/2+7;
  mmy = -(card_height/2-card_front_gap)-ext/2;

   // lift is upper edge of the wheel minus cast_edge_z
  rail_lift = mh+wheel_diameter/2+21-cast_edge_z-wheel_card_lift; 
       

  difference() {
    union() {
      difference() {
	union() {
	  // the main volume of the house
	  CenterCube([tw,th,house_height], ChamferBody=1);
	  
	  // the pedestal for the tray
	  translate([0,0,house_height-wall])
	  CenterCube([tw+2*wall+pile_gap,th+2*wall+pile_gap,wall+phh], 
	    ChamferBottom=wall+pile_gap/3, ChamferBody=1);
	  
          // add extra half-pillar for stability
          CopyMirror([0,1,0])
          CopyMirror([1,0,0])
	  translate([tw/2,-card_height/2-ext/2,0])
	  cylinder(d=4,h=house_height);

	}
	// main inner cutout
	translate([0,0,-0.01])
	CenterCube([iw,ih,house_height+0.02], ChamferBody=wall);
	
	// translated cutout to open the front
	translate([0,-3*wall,mh-10])
	CenterCube([iw,ih,house_height+0.02]);

	// open front cutout: full width, height a rail level and above
	// rail starting point is very low, but has a high slope, so add 10
	//translate([0,-3*wall,rail_lift-5])	// the lift must not be that high, otherwise the sorter rail will not fit
	//CenterCube([iw,ih,house_height+0.02]);

	// cutout for the tray holder extention (pedestal)
	translate([0,0,house_height])
	CenterCube([tw+pile_gap,th+pile_gap,phh+0.01]);

	// cut out at the rear front to save some material
	translate([0,  card_height/2,  15])
	rotate([0,0,90])
	Archoid(r=(card_width-16)/2, b=house_height-33/2-30, l=card_height);

	// another window to save some material
	translate([0,  card_height/4,  15])
	Archoid(r=33/2+ext/4, b=mh-18, l=2*card_width);


	// one more window above the rail to save some material
	//translate([0,  card_height/2-16,  rail_lift+24])
	//Archoid(r=14, b=10, l=2*card_width);

      }


       // add the card rail at the top
      
      translate([0,-ext/2,rail_lift])
      difference() {
	intersection() {
        
	  translate([0,card_height/2,card_rail])
	  rotate([-card_tray_angle,0,0])
	  translate([0,0,-card_height*2/2])
	  cube([card_height*4, card_height*4, card_height*2], center = true);
          
	  translate([0,card_front_gap/2+ext/2,0])
	  CenterCube([card_width+card_gap_w, card_height-card_front_gap+card_gap_h+ext, 
            house_height]);
	  
	  // leave a fixed gap at the lower end of the rail
	  translate([0,-2.5,0])
	  CenterCube([card_width+card_gap_w, card_height+card_gap_h+2*ext, house_height]);
	}
        
        // inner complete cutout
	translate([0,0,-0.01])
	CenterCube([card_width+card_gap_w-card_rail*2, card_height+card_gap_h+0.02, house_height]);
        
	translate([0,0,-1])
	CenterCube([card_width+card_gap_w, card_height*2,card_rail+1], ChamferTop=card_rail);      
        
	rotate([-card_tray_angle,0,0])
	translate([0,0,card_rail*0.8-100])
	CenterCube([card_width+card_gap_w+0.02, card_height*2,card_rail+100], ChamferTop=card_rail);    
      }
    }

    // cutout portal on both walls for the dc motor and usage of screw drivers
    translate([0,  mmy,  mh])
    Archoid(r=33/2, b=33/2+2, l=2*card_width);    
  }
  
  // the motor will be mounted on top of this block

  translate([mmx, mmy,0])
  difference() {
    CenterCube([33,33,mh], ChamferBody=1);

    // screw holes updated, 28 Feb 14:24
    CopyMirror([1,0,0])
    CopyMirror([0,1,0])
    translate([7,8,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
    
    /* Add a slope to the motor block for better adjustment */
    translate([0,0,mh])
    rotate([0,4,0])
    CenterCube([33*2,33*2,mh]);
  }
  
  // add some inner chamfer to add more stability to the motor mount block
  
  translate([iw/2+wall,mmy-33/2,0])
  ChamferZCube(w=wall,h=mh);

  translate([iw/2+wall,mmy+33/2,0])
  ChamferZCube(w=wall,h=mh);

  translate([iw/2,mmy-33/2,0])
  ChamferZCube(w=wall,h=mh);

  translate([iw/2,mmy+33/2,0])
  ChamferZCube(w=wall,h=mh);

  // add extra support for the complete block on the z=0 plane
  
  translate([0,th/4,0])
  CenterCube([tw, 6, wall], ChamferTop=1);

  translate([0,-th/4,0])
  CenterCube([tw, 6, wall], ChamferTop=1);



  if ( isMotor )
  {
    union() {
      translate([0,mmy,mh])
      translate([mmx,0])
      rotate([0,0,90])
      motor();
    }
  }
}

/*==============================================*/
/* card funnel */

module funnel() {

  phh = pile_holder_height+4;

  cbo = 1;	// ChamferBody is 1 for all outer edges and 
  cbi = wall/2;  // Inner chamfer is wall for other parts, but might deviate here 
  funnel_extra_width = 14;

  osd = 8*cbo;		// distance of the outer support rail to front and back
  osw = 5*cbo;	// width of the outer support rail
  osx = 3*cbo;		// outer support extend on both sides, so the per side extend is osx/2

  /* card arrival is around pile_holder_height+35 */
  h1 = pile_holder_height;
  h2 = 30;
  h3 = 16;
  h4 = 30;
  h5 = 42;

  // inner dimensions of the house. 
  iw = card_width+card_gap_w;
  ih = card_height+card_gap_h;

  // outer dimensions of the house
  tw = card_width+card_gap_w+2*wall;
  th = card_height+card_gap_h+2*wall;
  
  difference() {
    union() {
      difference() {
	union() {
	  CenterCube([tw,th,h1], ChamferBody=cbo);
	  CopyMirror([0,1,0])
	  translate([0,th/2-osd,0])
	  CenterCube([tw+osx,osw,h1], ChamferBody=cbo);
	  
          
	}
	translate([0,0,-0.01])
	CenterCube([iw,ih,h1+0.02], ChamferBody=cbi);
	
	  translate([0,ih/2-wall+0.4,h1])
          rotate([8,0,0])               // increase the slope even more
	  ChamferXCube(w=wall+wall,h=iw, d=0);
      }  
      
      translate([0,0,h1])
      difference() {
	union() {
	  SquareFrustum([tw, th], [tw+funnel_extra_width, th], h=h2,ChamferBody=cbo);
	  CopyMirror([0,1,0])
	  translate([0,th/2-osd,0])
	  SquareFrustum([tw+osx, osw], [tw+funnel_extra_width+osx, osw], h=h2,ChamferBody=cbo);
	}
	translate([0,2*wall,-0.01])
	SquareFrustum([iw, th+2*wall], [iw+funnel_extra_width, th+2*wall+0.02], h=h2+0.02,ChamferBody=cbi);
      }

      translate([0,0,h1+h2])
      difference() {
	union() {
	  CenterCube([tw+funnel_extra_width,th,h3], ChamferBody=cbo);
	  CopyMirror([0,1,0])
	  translate([0,th/2-osd,0])
	  CenterCube([tw+funnel_extra_width+osx,osw,h3], ChamferBody=cbo);
	}
	translate([0,2*wall,-0.01])
	CenterCube([iw+funnel_extra_width,th+2*wall,h3+0.02], ChamferBody=cbi);
      }  

      translate([0,0,h1+h2+h3])
      difference() {
	union() {
	  SquareFrustum([tw+funnel_extra_width, th], [tw, th], h=h4, ChamferBody=cbo);
	  CopyMirror([0,1,0])
	  translate([0,th/2-osd,0])
	  SquareFrustum([tw+funnel_extra_width+osx, osw], [tw+osx, osw], h=h4,ChamferBody=cbo);	  
	}
	translate([0,2*wall,-0.01])
	SquareFrustum([iw+funnel_extra_width, th+2*wall], [iw, th+2*wall+0.02], h=h4+0.02, ChamferBody=cbi);
      }

      // add a holder for the grove motor driver
      difference() {
        translate([iw/2+12,0,h1+h2+h3+h4-20])
        rotate([0,60,0])
        grove_2x1();

        translate([0,0,h1])
	translate([0,2*wall,-0.01])
	SquareFrustum([iw, th+2*wall], [iw+funnel_extra_width, th+2*wall+0.02], h=h2+0.02,ChamferBody=cbi);

        translate([0,0,h1+h2])
	translate([0,2*wall,-0.01])
	CenterCube([iw+funnel_extra_width,th+2*wall,h3+0.02], ChamferBody=cbi);

        translate([0,0,h1+h2+h3])
	translate([0,2*wall,-0.01])
	SquareFrustum([iw+funnel_extra_width, th+2*wall], [iw, th+2*wall+0.02], h=h4+0.02, ChamferBody=cbi);

      }


      translate([0,0,h1+h2+h3+h4])
      difference() {
	union() {
	  CenterCube([tw,th,h5], ChamferBody=cbo);
	  CopyMirror([0,1,0])
	  translate([0,th/2-osd,0])
	  CenterCube([tw+osx,osw,h5], ChamferBody=cbo);
	}
	translate([0,0,-0.01])
	CenterCube([iw,ih,h5+0.02], ChamferBody=cbi);
	//translate([0,2*wall,-0.01])
	//CenterCube([iw,th+2*wall,h5+0.02], ChamferBody=cbi);
      }  


      translate([0,0,h1+h2+h3+h4+h5-wall])
      difference() {
	// pedestal 
	CenterCube([tw+2*wall+pile_gap,th+2*wall+pile_gap,wall+phh+0], 
	  ChamferBottom=wall+pile_gap/3, ChamferBody=cbo);
  
	// cutout for the pedestal
	translate([0,0,wall-0.01])
	CenterCube([tw+pile_gap,th+pile_gap,phh+0.02], ChamferBody=0);
	
	translate([0,+0.01,-0.01])
	CenterCube([iw,ih+pile_gap,wall+phh+0.02], ChamferBody=0);
	//translate([0,wall+0.01,-0.01])
	//CenterCube([iw,th+pile_gap,wall+phh+0.02], ChamferBody=0);
      }
    } // union
    translate([tw/2,0,h1+h2+h3+h4+h5-2*wall])
    CenterCube([tw+2*wall, 20, phh+2*wall+0.01]);
    
    translate([tw/2,-th/2+wall/2+15,h1+h2+h3+h4+h5+wall])
    CenterCube([tw+2*wall, 20, phh+2*wall+0.01]);

    translate([tw/2-wall/2-16,-th/2,h1+h2+h3+h4+h5+wall])
    CenterCube([20, th+2*wall, phh+2*wall+0.01]);


    // Archoid cutout to save some material (it might also look better)
    
    translate([0,-card_height/2,h1-1])
    rotate([0,0,90])
    Archoid(r=(iw-16)/2, b=h2+h3+h4+h5/3, l=card_height);     
    
    // add a chamfer to the bottom of the above achoid to let more light on the upper side
    translate([0,-ih/2,h1-1])
    ChamferXCube(w=2,h=iw-16, d=0);
    
    
    // archoid towards the eject house, actually belongs to the structure above
    translate([0,card_height/2,h1+h2/2])
    rotate([0,0,90])
    Archoid(r=iw/2, b=h2/2+h3+h4, l=card_height);    
    
    // left / right upper cutouts
    CopyMirror([0,1,0])
    translate([0,card_height/4-3,h1+h2+h3+h4+3])
    Archoid(r=11, b=h5*0.4, l=2*card_width);    

    // left / right upper middle cutouts
    CopyMirror([0,1,0])
    translate([0,card_height/4+0.5, h1+h2+h3+3])
    Archoid(r=7, b=h4*0.5, l=2*card_width);    

    translate([-card_width/2,0, h1+h2+h3+3])
    Archoid(r=7, b=h4*0.5, l=card_width);    
    
    // left / right middle cutouts
    
    CopyMirror([0,1,0])
    translate([0,-ih/4, h1+h2+h3/2])
    rotate([0,90,0])
    cylinder(d=h3-4, h=2*card_width, center=true);

    translate([-iw/2, 0, h1+h2+h3/2])
    rotate([0,90,0])
    cylinder(d=h3-4, h=card_width, center=true);

  }  // difference
  
    
    
  
}

/*==============================================*/
/* raspi holder */

module diffuser_cone(d, is_solid=false) {
  led_diameter=3+0.4;
  diffuser_cone_diameter=d;
  diffuser_wall=1;
  diffuser_height=12;
  difference() {
    cylinder(d1=diffuser_cone_diameter, 
      d2=led_diameter+2*diffuser_wall, h=diffuser_height, $fn=48);
    if ( is_solid == false ) {
      translate([0,0,-0.01])
      cylinder(d1=diffuser_cone_diameter-diffuser_wall*2, 
        d2=led_diameter, h=diffuser_height+0.02-3);
      cylinder(d=led_diameter,h=diffuser_height+0.01, $fn=16);
      translate([0,0,diffuser_height-1])
      cylinder(d=led_diameter+1,h=diffuser_height, $fn=16);
    }
  }
}


module raspi_holder_with_led() {
// inner dimensions of the house. 
  iw = card_width+card_gap_w;
  ih = card_height+card_gap_h;

  // outer dimensions of the house
  tw = card_width+card_gap_w+2*wall;
  th = card_height+card_gap_h+2*wall;
  
  difference() {
    union() {
    
      CenterCube([tw,th,wall],ChamferBody=wall);

      translate([0,-th/2+wall/2+31,0])
      CenterCube([tw,wall,pile_holder_height+2],ChamferBody=0);
      
    }
  

    translate([0,4,0]) 
    union() {
      CopyMirror([1,0,0])
      CopyMirror([0,1,0])
      translate([14/2,28/2,0])
      cylinder(d=2.4, h=3*wall, center=true);
      
      CopyMirror([0,1,0])
      translate([0,20/2,0])
      cylinder(d=6, h=3*wall, center=true);
    }
  
    // led cone cutout
    CopyMirror([1,0,0])
    translate([-tw/3,-th/2+wall/2+31+18/2,-0.01])
    diffuser_cone(led_diffuser_cone_diameter-0.2, true);

    CopyMirror([1,0,0])
    translate([-tw/3,th/3,-0.01])
    diffuser_cone(led_diffuser_cone_diameter-0.2, true);

  }
  
  // led cone 
  CopyMirror([1,0,0])
  translate([-tw/3,-th/2+wall/2+31+18/2,-0.01])
  diffuser_cone(led_diffuser_cone_diameter, false);

  CopyMirror([1,0,0])
  translate([-tw/3,th/3,-0.01])
  diffuser_cone(led_diffuser_cone_diameter, false);

}

module raspi_holder() {
// inner dimensions of the house. 
  iw = card_width+card_gap_w;
  ih = card_height+card_gap_h;

  // outer dimensions of the house
  tw = card_width+card_gap_w+2*wall;
  th = card_height+card_gap_h+2*wall;
  
  difference() {
    union() {
    
      CenterCube([tw,th,wall],ChamferBody=wall);

      translate([0,-th/2+wall/2+31,0])
      CenterCube([tw,wall,pile_holder_height+2],ChamferBody=0);
      
    }
  

    translate([0,4,0]) 
    union() {
      CopyMirror([1,0,0])
      CopyMirror([0,1,0])
      translate([14/2,28/2,0])
      cylinder(d=2.4, h=3*wall, center=true);
      
      CopyMirror([0,1,0])
      translate([0,20/2,0])
      cylinder(d=6, h=3*wall, center=true);
    }
    
    CopyMirror([1,0,0])
    translate([iw/3,ih/6,-0.01])
    CenterCube([iw/3,ih*0.6,wall*2]);

    translate([0,ih/2-12,-0.01])
    CenterCube([18,20,wall*2]);

    translate([0,-ih/3,-0.01])
    CenterCube([iw*0.7,20,wall*2]);

  }
  

}

