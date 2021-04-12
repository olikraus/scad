include <card_compare_machine.scad>;



module ccm_basket() {
  // inner dimensions of the house. 
  iw = card_width+card_gap_w;
  ih = card_height+card_gap_h;

  // outer dimensions of the house
  tw = card_width+card_gap_w+2*wall;
  th = card_height+card_gap_h+2*wall;

  difference() {  
    union() {

      // the main volume of the house
      // the slope is -6+x, so use 12
      CenterCube([tw,th,sorter_house_height-14], ChamferBody=1);

      // hook for the sorter
      translate([-tw/2-wall-1.5,0,0])
      CenterCube([wall*2+5,20*2,15], ChamferBody=1, ChamferTop=1);
      
      translate([-tw/2,0,15])
      ChamferYCube(w=1, h=20*2-2);
    }
  
    // hook cutout
    translate([-tw/2-wall-1,0,-0.01])
    CenterCube([wall+4,23*2,13], ChamferTop=1);
  
    // main inner cutout
    translate([0,0,-0.01])
    CenterCube([iw,ih,sorter_house_height+0.02], 
      ChamferBody=wall, ChamferTop=0);

    // open small sides of the basket
    translate([0,0,-0.01])
    CenterCube([iw/2,2*ih,sorter_house_height+0.02], 
      ChamferBody=wall, ChamferTop=0);

    //translate([0,  0,  12])

    CopyMirror([0,1,0])
    translate([0,ih/4,18])
    Archoid(r=12, b=sorter_house_height-14-12-15-12, l=2*card_width);

  }

  // add extra support for the complete block on the z=0 plane
  CopyMirror([0,1,0])
  translate([0,ih/3,0])
  CenterCube([tw, 6, wall], ChamferTop=1);

  CopyMirror([0,1,0])
  translate([0,ih/6,0])
  CenterCube([tw, 6, wall], ChamferTop=1);

  CopyMirror([0,1,0])
  translate([0,ih/2,0])
  CenterCube([tw, 6, wall], ChamferTop=1);

  CenterCube([tw, 6, wall], ChamferTop=1);

}

ccm_basket();

//translate([-card_width*1.3,0,0])
//sorter_house();
