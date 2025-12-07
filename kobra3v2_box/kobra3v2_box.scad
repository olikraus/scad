
include<base_objects.scad>

portal_y_size = 22.2;
portal_x_size = 40;

holder_height = 6;
holder_wall = 4;
holder_grab_overlap = 6;

box_height = 10;
box_x_size = 40;
box_y_size = 80;
box_wall = 3;
box_floor = 2;

snap_wall = 1; // reduced wall for the box
snap_extend = 1.8;
snap_ext_co = 2;

module CenterCube2(dim, ChamferBodyF = 0, ChamferBodyB = 0, ChamferBottom=0, ChamferTop=0) {
  difference() {
    translate([0,0,dim[2]/2])
    cube(dim, center=true);

    if ( ChamferBodyB > 0 ) {
      translate([dim[0]/2,dim[1]/2,0])
      ChamferZCube(w=ChamferBodyB,h=dim[2],d=0.01);
      
      translate([-dim[0]/2,dim[1]/2,0])
      ChamferZCube(w=ChamferBodyB,h=dim[2],d=0.01);
    }
    
    if ( ChamferBodyF > 0 ) {
      translate([-dim[0]/2,-dim[1]/2,0])
      ChamferZCube(w=ChamferBodyF,h=dim[2],d=0.01);

      translate([dim[0]/2,-dim[1]/2,0])
      ChamferZCube(w=ChamferBodyF,h=dim[2],d=0.01);
    }
    
    if ( ChamferBottom > 0 )
    {
      translate([-dim[0]/2,0,0])
      ChamferYCube(w=ChamferBottom,h=dim[1],d=0.01);

      translate([dim[0]/2,0,0])
      ChamferYCube(w=ChamferBottom,h=dim[1],d=0.01);

      translate([0,-dim[1]/2,0])
      ChamferXCube(w=ChamferBottom,h=dim[0],d=0.01);

      translate([0,dim[1]/2,0])
      ChamferXCube(w=ChamferBottom,h=dim[0],d=0.01);
    }
    
    if ( ChamferTop > 0 )
    {
      translate([-dim[0]/2,0,dim[2]])
      ChamferYCube(w=ChamferTop,h=dim[1],d=0.01);

      translate([dim[0]/2,0,dim[2]])
      ChamferYCube(w=ChamferTop,h=dim[1],d=0.01);

      translate([0,-dim[1]/2,dim[2]])
      ChamferXCube(w=ChamferTop,h=dim[0],d=0.01);

      translate([0,dim[1]/2,dim[2]])
      ChamferXCube(w=ChamferTop,h=dim[0],d=0.01);
    }
    
  }
}


module holder() {
    difference() {
        CenterCube([portal_x_size+holder_wall*2+box_wall, portal_y_size+holder_wall*2, holder_height+box_height-box_floor], ChamferBody=holder_wall);
        
        // portal cut
        translate([-box_wall,0,-0.01])
        CenterCube2([portal_x_size, portal_y_size, (holder_height+box_height)*2], ChamferBodyB=1, ChamferBodyF=6);    
        
        // grap / insert cutout
        translate([-portal_x_size/2,0,-0.01])
        CenterCube([portal_x_size, portal_y_size-holder_grab_overlap, holder_height+box_height*2]);
        
        // lower cutout, basically similar to portal cutout, but also shifted by box_wall
        
        translate([-500,0,-0.01])
        CenterCube([portal_x_size+1000, portal_y_size*2, box_height-box_floor]);    
        
        //translate([-holder_wall,0,-0.01])
        //CenterCube([portal_x_size+holder_wall*2+box_wall, portal_y_size+holder_wall*2+0.02, box_height-box_floor]);
        
        //translate([portal_x_size/2+holder_wall-box_wall-0.01,0,box_height-box_floor])
        translate([portal_x_size/2+snap_extend/2,0,box_height-box_floor])
        rotate([180,0,180])
        TriangularPrism(bottom = [snap_ext_co,portal_y_size+holder_wall*2+0.02], h=snap_ext_co, fh=0, fd=snap_ext_co);    
    }
    
    translate([portal_x_size/2-snap_extend/2,0,0])
    TriangularPrism(bottom = [snap_extend,portal_y_size+holder_wall*2], h=snap_extend, fh=0, fd=snap_extend);
    
}

module box() {
    difference()
    {
        CenterCube([box_x_size+box_wall*2, box_y_size+box_wall*2, box_height], ChamferBody=box_wall);
        
        translate([0,0,box_floor])
        CenterCube([box_x_size, box_y_size, box_height], ChamferBody=box_wall*0.5);
        
        translate([-box_x_size/2-snap_ext_co/2+0.01,0,box_floor])
        TriangularPrism(bottom = [snap_ext_co,portal_y_size+holder_wall*2+0.6], h=snap_ext_co, fh=0, fd=snap_ext_co);
    }

     
    translate([-box_x_size/2+snap_extend/2,0,box_height])
    rotate([180,0,180])
    TriangularPrism(bottom = [snap_extend,portal_y_size+holder_wall*2-snap_extend*2], h=snap_extend, fh=0, fd=snap_extend);
}

rotate([0,0,180])
translate([box_x_size/2 ,0,holder_height+box_height-box_floor])
rotate([0,180,0])
holder();
//translate([box_x_size+snap_extend/2,0])
//box();
