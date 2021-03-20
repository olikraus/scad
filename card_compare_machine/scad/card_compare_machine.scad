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
card_gap = 2;  // 7 Mar 21: increased 1->2

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
pile_gap = 0.2;

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

/* This is the overall height of the eject house and the sorter house */
house_height = 110;

/* motor mount height of the eject house */
motor_mount_height = 45;

/* eject_sorter_rail_height */
eject_sorter_rail_height = 15;

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

/*==============================================*/
/* card tray for the eject block */

module tray() {
  iw = card_width+card_gap;
  ih = card_height+card_gap;
  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+2*wall-0.01;
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


  // height of the motor mount block
  mh = sorter_house_height+wheel_card_lift-sorter_card_slot_height-wheel_diameter/2-21;

  // inner dimensions of the house. 
  iw = card_width+card_gap;
  ih = card_height+card_gap;

  // outer dimensions of the house
  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+2*wall;
  
  motor_y_pos = -card_height/2+8;

  difference() {
    union() {
      // the main volume of the house
      CenterCube([tw,th,sorter_house_height], ChamferBody=1);
      
      // the pedestal for the tray
      translate([0,0,sorter_house_height-wall])
      CenterCube([tw+2*wall,th+2*wall,wall+pile_holder_height], ChamferBottom=wall, ChamferBody=1);
    }
    
    // main inner cutout
    translate([0,0,-0.01])
    CenterCube([iw,ih,sorter_house_height-sorter_card_slot_height+0.02], ChamferBody=wall, ChamferTop=sorter_rail_width);

    // cutout for the tray holder extention (pedestal)
    translate([0,0,sorter_house_height])
    CenterCube([tw,th,pile_holder_height+0.01]);
    
    translate([0,0,sorter_house_height-sorter_card_slot_height])
    CenterCube([iw*2, ih,pile_holder_height*2]);

    // cutout portal on both walls for the dc motor and usage of screw drivers
    //translate([0,  -(card_height/2-card_front_gap),  mh])
    translate([0,  0,  mh])
    rotate([0,0,90])
    Archoid(r=33/2, b=sorter_house_height-33/2-14-mh, l=2*card_height);
    
    // do some cutout for the wheels    
    translate([0,  0,  mh])
    Archoid(r=20, b=20, l=2*card_width);

    CopyMirror([1,0,0])
    translate([tw/2,0,sorter_house_height-sorter_card_slot_height])
    ChamferYCube(w=6, h=ih);    
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
  
  translate([33/2,-card_height/2,0])
  ChamferZCube(w=wall,h=mh);

  translate([33/2,-card_height/2-wall,0])
  ChamferZCube(w=wall,h=mh);

  translate([-33/2,-card_height/2,0])
  ChamferZCube(w=wall,h=mh);

  translate([-33/2,-card_height/2-wall,0])
  ChamferZCube(w=wall,h=mh);

  // add extra support for the complete block on the z=0 plane
  
  translate([0,th/4,0])
  CenterCube([tw, 6, wall], ChamferTop=1);

  translate([0,-th/4,0])
  CenterCube([tw, 6, wall], ChamferTop=1);


  // cat rail

translate([(iw-card_rail)/2,th/2,0])
SlopeCube(w = card_rail, l = 35, 
  zs = sorter_house_height+pile_holder_height,  hs = 40, 
  ze = motor_mount_height+wheel_diameter/2+21, he = 10);

translate([-(iw-card_rail)/2,th/2,0])
SlopeCube(w = card_rail, l = 35, 
  zs = sorter_house_height+pile_holder_height,  hs = 40, 
  ze = motor_mount_height+wheel_diameter/2+21, he = 10);


/*
  catch_rail_cut=5;
  catch_rail_len=40;  // the real length is catch_rail_len-catch_rail_cut
  translate([0,card_height/2+card_gap/2+wall, sorter_house_height-catch_rail_len+pile_holder_height])
  difference() {
    translate([0,catch_rail_len/2,0])
    CenterCube([card_width+card_gap, catch_rail_len, catch_rail_len]);
    
    translate([0,catch_rail_len,0])
    ChamferXCube(w=catch_rail_len,h=card_width+card_gap, d=0.02);
    
    translate([0,catch_rail_len/2,0])
    CenterCube([card_width+card_gap-2*card_rail, catch_rail_len+0.02, catch_rail_len+0.02]);

    translate([0,catch_rail_len,0])
    CenterCube([card_width+card_gap+0.02, 2*catch_rail_cut, catch_rail_len+0.02]);  
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

  
  mh = motor_mount_height;

  // inner dimensions of the house. 
  iw = card_width+card_gap;
  ih = card_height+card_gap;

  // outer dimensions of the house
  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+2*wall;
  
  // center position of the motor mount block 
  mmx = card_width/2+7;
  mmy = -(card_height/2-card_front_gap);

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
	  CenterCube([tw+2*wall,th+2*wall,wall+pile_holder_height], ChamferBottom=wall, ChamferBody=1);
	  
	  translate([tw/2,-card_height/2,0])
	  cylinder(d=4,h=house_height);

	  translate([-tw/2,-card_height/2,0])
	  cylinder(d=4,h=house_height);

	}
	// main inner cutout
	translate([0,0,-0.01])
	CenterCube([iw,ih,house_height+0.02], ChamferBody=wall);
	
	// translated cutout to open the front
	translate([0,-3*wall,mh-10])
	CenterCube([iw-2*wall,ih,house_height+0.02]);

	// open front cutout: full width, height a rail level and above
	// rail starting point is very low, but has a high slope, so add 10
	translate([0,-3*wall,rail_lift-5])	// the lift must not be that high, otherwise the sorter rail will not fit
	CenterCube([iw,ih,house_height+0.02]);

	// cutout for the tray holder extention (pedestal)
	translate([0,0,house_height])
	CenterCube([tw,th,pile_holder_height+0.01]);

      }


       // add the card rail at the top
      
      translate([0,0,rail_lift])
      difference() {
	intersection() {
	  translate([0,card_height/2,card_rail])
	  rotate([-card_tray_angle,0,0])
	  translate([0,0,-card_height*2/2])
	  cube([card_height*4, card_height*4, card_height*2], center = true);
	  translate([0,card_front_gap/2,0])
	  CenterCube([card_width+card_gap, card_height-card_front_gap+card_gap, house_height]);
	  
	  // leave a fixed gap at the lower end of the rail
	  translate([0,-4,0])
	  CenterCube([card_width+card_gap, card_height+card_gap, house_height]);
	}
	translate([0,0,-0.01])
	CenterCube([card_width+card_gap-card_rail*2, card_height+card_gap+0.02, house_height]);
	translate([0,0,-1])
	CenterCube([card_width+card_gap, card_height*2,card_rail+1], ChamferTop=card_rail);      
	rotate([-card_tray_angle,0,0])
	translate([0,0,card_rail*0.8-100])
	CenterCube([card_width+card_gap+0.02, card_height*2,card_rail+100], ChamferTop=card_rail);    
      }
    }

    // cutout portal on both walls for the dc motor and usage of screw drivers
    translate([0,  -(card_height/2-card_front_gap),  mh])
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

  funnel_extra_width = 20;

  h1 = pile_holder_height;
  h2 = 35;
  h3 = 20;
  h4 = 35;
  h5 = 20;

  // inner dimensions of the house. 
  iw = card_width+card_gap;
  ih = card_height+card_gap;

  // outer dimensions of the house
  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+2*wall;
  
  difference() {
    union() {
      difference() {
	CenterCube([tw,th,h1], ChamferBody=0);
	translate([0,0,-0.01])
	CenterCube([iw,ih,h1+0.02], ChamferBody=1.5);
      }  
      
      translate([0,0,h1])
      difference() {
	SquareFrustum([tw, th], [tw+funnel_extra_width, th], h=h2);
	translate([0,wall,-0.01])
	SquareFrustum([iw, th], [iw+funnel_extra_width, th+0.02], h=h2+0.02);
      }

      translate([0,0,h1+h2])
      difference() {
	CenterCube([tw+funnel_extra_width,th,h3], ChamferBody=0);
	translate([0,wall,-0.01])
	CenterCube([iw+funnel_extra_width,th,h3+0.02]);
      }  

      translate([0,0,h1+h2+h3])
      difference() {
	SquareFrustum([tw+funnel_extra_width, th], [tw, th], h=h4);
	translate([0,wall,-0.01])
	SquareFrustum([iw+funnel_extra_width, th], [iw, th+0.02], h=h4+0.02);
      }

      translate([0,0,h1+h2+h3+h4])
      difference() {
	CenterCube([tw,th,h5], ChamferBody=0);
	translate([0,wall,-0.01])
	CenterCube([iw,th,h5+0.02], ChamferBody=1.5);
      }  


      translate([0,0,h1+h2+h3+h4+h5-wall])
      difference() {
	// pedestal 
	CenterCube([tw+2*wall,th+2*wall,wall+pile_holder_height], ChamferBottom=wall, ChamferBody=1);

	// cutout for the pedestal
	translate([0,0,wall-0.01])
	CenterCube([tw,th,pile_holder_height+0.02]);
	
	translate([0,wall+0.01,-0.01])
	CenterCube([iw,th,wall+pile_holder_height+0.02]);
      }
    } // union
    translate([tw/2,0,h1+h2+h3+h4+h5-2*wall])
    CenterCube([tw+2*wall, 20, pile_holder_height+2*wall+0.01]);
    
    translate([tw/2,-th/2+wall/2+15,h1+h2+h3+h4+h5+wall])
    CenterCube([tw+2*wall, 20, pile_holder_height+2*wall+0.01]);

    translate([tw/2-wall/2-16,-th/2,h1+h2+h3+h4+h5+wall])
    CenterCube([20, th+2*wall, pile_holder_height+2*wall+0.01]);


    // Archoid cutout to save some material (it might also look better)
    translate([0,0,h1+h2/2])
    rotate([0,0,90])
    Archoid(r=33/2, b=h2/2+h3+h4/2, l=2*card_width);    

  }  // difference
  
    
  
  
}

/*==============================================*/
/* raspi holder */

module raspi_holder() {
// inner dimensions of the house. 
  iw = card_width+card_gap;
  ih = card_height+card_gap;

  // outer dimensions of the house
  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+2*wall;
  
  difference() {
    union() {
    
      CenterCube([tw,th,wall],ChamferBody=wall);

      translate([0,-th/2+wall/2+31,0])
      CenterCube([tw,wall,pile_holder_height],ChamferBody=0);
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
    
  }
}

