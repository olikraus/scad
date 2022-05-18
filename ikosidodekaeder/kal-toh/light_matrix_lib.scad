/*

  light_matrix_lib.scad
  
*/

$fn=16;

outerLWDia = 4.7;
innerLWDia = 4.4;

xcnt=8;
ycnt=8;
xstep=10;
ystep=10;
xwidth=xcnt*xstep;
ywidth=ycnt*ystep;
matrixHeight=15;
frameWall=2;
framePedestalWidth=1;
framePedestalHeight=3;
framePedestalInsertDelta=0.3;
frameHeight=4;



module lightMatrix() {
  difference() {
    CenterCube([xwidth+framePedestalWidth*2, 
      ywidth+framePedestalWidth*2, 
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
  difference() {
    CenterCube([
      xwidth+frameWall*2+framePedestalWidth*2, 
      ywidth+frameWall*2+framePedestalWidth*2, 
      frameHeight+framePedestalHeight], ChamferBody = 1, ChamferBottom=0, ChamferTop=1);
    translate([0,0,-0.01])
    CenterCube([xwidth, ywidth, frameHeight+0.02], ChamferBody = 1, ChamferBottom=0, ChamferTop=0);
    translate([0,0,frameHeight])
    CenterCube([
      xwidth+framePedestalWidth*2+2*framePedestalInsertDelta, 
      ywidth+framePedestalWidth*2+2*framePedestalInsertDelta, 
      framePedestalHeight+0.02], ChamferBody = 0.5, ChamferBottom=0, ChamferTop=0);

    for(i=[-3:3] ) {
      translate([i*8,0,0])
      rotate([90,0,0])
      cylinder(d=5, h=xwidth*2, center=true);
    }

  }
}




