/*

  light_matrix_lib.scad
  
*/

$fn=16;

outerLWDia = 5.0;
innerLWDia = 4.6;

xcnt=8;
ycnt=8;
xstep=10;
ystep=10;
xwidth=xcnt*xstep;
ywidth=ycnt*ystep;
matrixHeight=14;
frameWall=2;
framePedestalOuterWidth=0.4;  // used for frame and matrix (=gap for the LED matrix)
framePedestalInnerWidth=4;  // used only by frame
framePedestalHeight=7;
framePedestalInsertDelta=0.3;
frameHeight=4;

module mountLug() {
  let ( w = 8, h = 3 ) {
    difference() {
      union() {
        translate([0,0,h])
        rotate([45,0,0])
        cube([w, h, h], center=true);
        
      
        translate([-w/2, 0, 0])
        cube([w, w-1, h]);
        translate([0,w-1,0])
        cylinder(h=h, d=w);
      }
      translate([0,w-1,0])
      cylinder(d=3, h= 3*h, center=true);
      translate([0,w-1,h*0.6])
      cylinder(d=6, h= h);
    }
  }
}

module lightMatrix() {
  difference() {
    CenterCube([xwidth+framePedestalOuterWidth*2, 
      ywidth+framePedestalOuterWidth*2, 
      matrixHeight], 
      ChamferBody = 1.2, ChamferBottom=0, ChamferTop=1.2);
    for( y=[0:ycnt-1] ) {
      for( x=[0:xcnt-1] ) {
        translate([x*xstep-xwidth/2+xstep/2, y*ystep-ywidth/2+ystep/2, -0.01])
        cylinder(d1=innerLWDia, d2=outerLWDia, h=matrixHeight+0.02);    
      }
    }
  }
}

module lightFrame() {
  union() {
    difference() {
      CenterCube([
        xwidth+frameWall*2+framePedestalOuterWidth*2, 
        ywidth+frameWall*2+framePedestalOuterWidth*2, 
        frameHeight+framePedestalHeight], ChamferBody = 1, ChamferBottom=0, ChamferTop=1);
      translate([0,0,-0.01])
      CenterCube([xwidth-framePedestalInnerWidth*2, ywidth-framePedestalInnerWidth*2, frameHeight+0.02], ChamferBody = 1, ChamferBottom=0, ChamferTop=0);
      translate([0,0,frameHeight])
      CenterCube([
        xwidth+framePedestalOuterWidth*2+2*framePedestalInsertDelta, 
        ywidth+framePedestalOuterWidth*2+2*framePedestalInsertDelta, 
        framePedestalHeight+0.02], ChamferBody = 0.5, ChamferBottom=0, ChamferTop=0);

      for(i=[-3:3] ) {
        translate([i*8,0,0])
        rotate([90,0,0])
        cylinder(d=5, h=xwidth*2, center=true);
      }

    }
    
    translate([-xwidth/2-frameWall-framePedestalOuterWidth,0,0])
    rotate([0,0,90])
    mountLug();

    translate([+xwidth/2+frameWall+framePedestalOuterWidth,0,0])
    rotate([0,0,-90])
    mountLug();
  }

}




