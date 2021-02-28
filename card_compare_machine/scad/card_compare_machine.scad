/*

  card_compare_machine.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

*/

$fn=20;

/* dimensions of the cards */
card_width = 63;
card_height = 88;
/* outer gap of the cards */
card_gap = 1;   
/* inner rail size, must be greater than card_gap */
card_rail = 10;

/* the card rail is shorter than the cards by this value */
/* the card driving wheel is below the front rail */
card_front_gap = card_height/4;

/* the height of the tray */
tray_height = 30;

/* card tray angle: Must be < 11 Degree */
card_tray_angle = 10;

/* diameter of the drive wheel */
wheel_diameter = 65;

/* how much should the wheel lift the cards beyond tray rails */
wheel_card_lift = 0.5;

/* thickness of all the walls */
wall=3;

/* Extra gap so that the tray can be stacked on the motor house */
pile_gap = 0.2;

/* mount hole diameter */
mhd = 2.8;


/* derived: the height of the card cast edge above reference level 0 */
cast_edge_z = wall+sin(card_tray_angle)*(card_height-card_front_gap);

/* derived: motor block height */
motor_block_height = wheel_diameter/2+20+20;

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
        
        translate([7,8,0])
        cylinder(h=8,d=3.4, center=true, $fn=16);
        
        translate([7,-8,0])
        cylinder(h=8,d=3.4, center=true, $fn=16);

        translate([-7,8,0])
        cylinder(h=8,d=3.4, center=true, $fn=16);
        
        translate([-7,-8,0])
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
    translate([0,36,33-26.5/2])
    rotate([90,0,0])
    cylinder(h=27,d=wheel_diameter, center=true, $fn=32);
}


/* inner chamfer */
module triangle(h) {
  linear_extrude(height=h)
  polygon([[0,0],[wall,0],[0,wall]]);
}

module tray() {
  iw = card_width+card_gap;
  ih = card_height+card_gap;
  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+wall-0.01;
  tz = 20;        /* depends on card_tray_angle, just needs to be high enough */

  intersection() 
  {
    union() {
      rotate([card_tray_angle,0,0])
      difference() {
          translate([-tw/2,0,-2*tz])
          cube([tw, th-card_front_gap, 3*tz]);
          
          translate([-iw/2,wall,wall])
          cube([iw, ih-card_front_gap, tz]);

          translate(
              [-(iw-card_rail*2)/2,wall+card_rail,-2*tz-0.01])
          cube([iw-card_rail*2, ih-card_front_gap, 3*tz]);
          
          //translate([-iw/2,ih+wall-card_front_gap,-0.01])
          //cube([iw, card_front_gap, wall+0.02]);
      }

      difference() {
          translate([-tw/2,0,0])
          cube([tw, th, tray_height]);
          
          translate([-iw/2,wall,-0.01])
          cube([iw, ih, tray_height+0.02]);
      }
    }
    translate([-tw/2,0,0])
    cube([tw, th, tray_height]);
  }
}

module sorter_house(isMotor = true) {

  mh = motor_block_height+cast_edge_z+wheel_card_lift-wheel_diameter/2-20;

  iw = card_width+card_gap;
  ih = card_height+card_gap;

  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+2*wall;

  difference() {
    translate([-tw/2,0,0])
    cube([tw, th, motor_block_height]);

    translate([-iw/2,wall,-0.01])
    cube([iw+0.02, ih+0.02, motor_block_height+0.02]);

    /*
    translate([-iw/2,3*wall,motor_block_height/4])
    cube([iw+0.02, ih+0.02, motor_block_height]);  
  */

    /* upper round cutout of the motor */
    translate([0,card_height-card_front_gap,motor_block_height-33/2-4])
    difference() {
      rotate([0,90,90])
      cylinder(d=33, h=2*card_height, center=true);
      
      translate([0,0,-card_height/2])
      cube([2*card_height,2*card_height,card_height], center=true);
      
    }
    
    /* lower block cutout of the motor */

    //rotate([0,0,90])
    //translate([-2*card_width/2,card_height-card_front_gap-33/2,mh])
    //cube([3*card_height,33,motor_block_height-33/2-4-mh]);
    
    translate([-33/2,-card_height,  mh+0.01])
    cube([33, 3*card_height,motor_block_height-33/2-4-mh+0.01]);

  }

  /* the motor will be mounted on top of this block */

  translate([-33/2,card_height-33/2-5,0])
  difference() {
    cube([33,33,mh]);

    translate([7+33/2,8+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
    
    translate([7+33/2,-8+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);

    translate([-7+33/2,8+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
    
    translate([-7+33/2,-8+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
  }


  /* 4x inner chamfer for the motor house */
  translate([card_width/2+0.5,wall,0])
  rotate([0,0,90])
  triangle(motor_block_height);
  
  translate([-card_width/2-0.5,wall,0])
  rotate([0,0,0])
  triangle(motor_block_height);
  
  translate([card_width/2+0.52,card_height+wall+1.02,0])
  rotate([0,0,180])
  triangle(motor_block_height);
  
  translate([-card_width/2-0.52,card_height+wall+1.02,0])
  rotate([0,0,-90])
  triangle(motor_block_height);
  
  /* upper pedestal */
  difference() {
    translate([-(card_width+wall*4)/2,-wall,motor_block_height-wall])
    cube([card_width+wall*4, card_height+wall*4, wall*3]);
    
    translate([-(card_width+wall*2+pile_gap*2)/2,0,motor_block_height-wall-0.01])
    cube([card_width+wall*2+pile_gap*2, card_height+wall*2+pile_gap*2, wall*3+0.02]);

    translate([-card_width/2-wall*2-0.01,card_height*1.5,motor_block_height-wall-0.01])
    rotate([90,0,0])
    triangle(card_height*2);

    translate([+card_width/2+wall*2+0.01,card_height*1.5,motor_block_height-wall-0.01])
    rotate([90,-90,0])
    triangle(card_height*2);

    translate([-card_width,-wall-0.01,motor_block_height-wall-0.01])
    rotate([90,0,90])
    triangle(card_width*2);
    
  }
  

  if ( isMotor )
  {
    union() {
      translate([0,card_height-5,mh])
      rotate([0,0,180])
      motor();
    }
  }


}



module eject_house(isMotor=false) {

  mh = motor_block_height+cast_edge_z+wheel_card_lift-wheel_diameter/2-20;

  iw = card_width+card_gap;
  ih = card_height+card_gap-wall;

  tw = card_width+card_gap+2*wall;
  th = card_height+card_gap+wall;

  difference() {
    translate([-tw/2,0,0])
    cube([tw, th, motor_block_height]);
    
    translate([-iw/2,wall,-0.01])
    cube([iw+0.02, ih+0.02, motor_block_height+0.02]);

    translate([-iw/2,3*wall,motor_block_height/4])
    cube([iw+0.02, ih+0.02, motor_block_height]);  

    /* upper round cutout of the motor */
    translate([0,card_height-card_front_gap,motor_block_height-33/2-4])
    difference() {
      rotate([0,90,0])
      cylinder(d=33, h=2*card_width, center=true);
      
      translate([0,0,-card_height/2])
      cube([2*card_height,2*card_height,card_height], center=true);
      
    }

    /* lower block cutout of the motor */

    translate([-2*card_width/2,card_height-card_front_gap-33/2,mh])
    cube([2*card_width,33,motor_block_height-33/2-4-mh]);
    
  }

  /* 4x inner chamfer for the motor house */
  translate([card_width/2+0.5,wall,0])
  rotate([0,0,90])
  triangle(motor_block_height);
  
  translate([-card_width/2-0.5,wall,0])
  rotate([0,0,0])
  triangle(motor_block_height);
  
  translate([card_width/2+0.52,card_height+1.02,0])
  rotate([0,0,180])
  triangle(motor_block_height/4);
  
  translate([-card_width/2-0.52,card_height+1.02,0])
  rotate([0,0,-90])
  triangle(motor_block_height/4);

  /* the motor will be mounted on top of this block */

  translate([-card_width/2-33/2-wall,card_height-card_front_gap-33/2,0])
  difference() {
    cube([33,33,mh]);

    translate([8+33/2,7+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
    
    translate([8+33/2,-7+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);

    translate([-8+33/2,7+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
    
    translate([-8+33/2,-7+33/2,mh-16])
    cylinder(h=20,d=mhd, center=false, $fn=16);
  }

  /* 4x inner chamfer for the motor mount block */
  translate([-card_width/2-wall-0.5,card_height-card_front_gap-33/2,0])
  rotate([0,0,180])
  triangle(mh);

  translate([-card_width/2-0.5,card_height-card_front_gap-33/2,0])
  rotate([0,0,-90])
  triangle(mh);

  translate([-card_width/2-0.5,card_height-card_front_gap+33/2,0])
  rotate([0,0,0])
  triangle(mh);

  translate([-card_width/2-wall-0.5,card_height-card_front_gap+33/2,0])
  rotate([0,0,90])
  triangle(mh);

  /* upper pedestal */
  difference() {
    translate([-(card_width+wall*4)/2,-wall,motor_block_height-wall])
    cube([card_width+wall*4, card_height+wall*2+1, wall*3]);
    
    translate([-(card_width+wall*2+pile_gap*2)/2,0,motor_block_height-wall-0.01])
    cube([card_width+wall*2+pile_gap*2, card_height+wall*2+1, wall*3+0.02]);

    translate([-card_width/2-wall*2-0.01,card_height*1.5,motor_block_height-wall-0.01])
    rotate([90,0,0])
    triangle(card_height*2);

    translate([+card_width/2+wall*2+0.01,card_height*1.5,motor_block_height-wall-0.01])
    rotate([90,-90,0])
    triangle(card_height*2);

    translate([-card_width,-wall-0.01,motor_block_height-wall-0.01])
    rotate([90,0,90])
    triangle(card_width*2);
    
  }
  
  
  if ( isMotor )
  {
    union() {
      translate([0,card_height-card_front_gap,mh])
      translate([-35.5,0])
      rotate([0,0,-90])
      motor();
    }
  }
}

