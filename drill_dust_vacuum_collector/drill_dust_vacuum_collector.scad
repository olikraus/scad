/*

    drill dust vacuum dollector
    

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  use "hose_dia" below to adapt this device to your vacuum cleaner

*/


$fn=16;

arch_dist = 20;
arch_dia = 14;
arch_wall = arch_dist-arch_dia;
arch_h = 8;    // must be > arch_dia/2

vac_x_size = arch_dist*3;
vac_y_size = arch_dist*5;

frame_insulation_wall = 4;
frame_insulation_width = 10;
frame_insulation_height = 4;
frame_w = frame_insulation_wall*2+frame_insulation_width;

hose_dia = 34.6;
hose_wall = 3;
hose_h = 40; 

lid_h = 2;

drill_collector_dia = 42;   // outer dia of the drill collector
drill_collector_wall = 3;
drill_collector_inner_dia = 30; // must be <= drill_collector_dia-2*drill_collector_wall
drill_collector_insert_height = 0.41;

tube_dia = 11;  // 10
tube_inner_dia = tube_dia*0.7;   // 0.7


module SquareFrustum(bottom=[10,10], top=[0,0], h=10, ChamferBody=0) {
  c = ChamferBody/2;
  lx = bottom[0]-2*c;
  ly = bottom[1]-2*c;
  ux = top[0]-2*c;
  uy = top[1]-2*c;
  p = [
    [ -lx/2-c, -ly/2+c,  0 ],  //0 / 0, 0
    [ -lx/2+c, -ly/2-c,  0 ],  //0 / 1, 1
  
    [ lx/2-c,  -ly/2-c,  0 ],  //1 / 0, 2
    [ lx/2+c,  -ly/2+c,  0 ],  //1 / 1, 3
  
    [ lx/2+c,  ly/2-c,  0 ],  //2 / 0, 4
    [ lx/2-c,  ly/2+c,  0 ],  //2 / 1, 5
  
    [ -lx/2+c,  ly/2+c,  0 ],  //3 / 0, 6
    [ -lx/2-c,  ly/2-c,  0 ],  //3 / 1, 7
  
    [ -ux/2-c, -uy/2+c,  h ],  //4 / 0, 8
    [ -ux/2+c, -uy/2-c,  h ],  //4 / 1, 9
  
    [ ux/2-c,  -uy/2-c,  h ],  //5 / 0, 10
    [ ux/2+c,  -uy/2+c,  h ],  //5 / 1, 11
 
    [ ux/2+c,  uy/2-c,  h ],  //6 / 0, 12
    [ ux/2-c,  uy/2+c,  h ],  //6 / 1, 13
    
    [ -ux/2+c,  uy/2+c,  h ], //7 / 0, 14
    [ -ux/2-c,  uy/2-c,  h ]]; //7 / 1, 15
    
  f = [
    [0,1,2,3,4,5,6,7],  // bottom
    [8,9,1,0], // front left
    [9,10,2,1],  // front 
    [10,11,3,2], // front right
    [15,14,13,12,11,10,9,8],  // top
    [11,12,4,3],  // right
    [12,13,5,4],  // back right
    [13,14,6,5],  // back
    [14,15,7,6], // back left
    [15,8,0,7]]; // left
  polyhedron( p, f );
}

module CopyMirror(vec=[0,1,0]) {
    children();
    mirror(vec) 
    children();
}

/*
  ChamferZCube(w=1,h=10)

  A cube, which can be used to chamfer along the z axis

  Args:
    w: The width of the cube is sqrt(2)*w
    h: Height of the cube
    d: The cube has a descent below z=0 plane and an ascent beyond h by this value
  Notes:
    The cube is centered around z-axsis and placed on z=0 plane.

*/
module ChamferZCube(w=1,h=10, d=0) {
  translate([0,0,h/2])
  rotate([0,0,45])
  cube([sqrt(2)*w,sqrt(2)*w,h+2*d], center=true);
}

module ChamferXCube(w=1,h=10, d=0) {
  rotate([45,0,0])
  cube([h+2*d,sqrt(2)*w,sqrt(2)*w], center=true);
}

module ChamferYCube(w=1,h=10, d=0) {
  rotate([0,45,0])
  cube([sqrt(2)*w,h+2*d,sqrt(2)*w], center=true);
}

/*
  CenterCube(dim, ChamferBody = 0, ChamferBottom=0, ChamferTop=0)

  A cube which is centered along z axis but is placed on z=0 plane
  Optionally allows chamfer along z axis.

  Args:
    dim: Same as for cube(dim)
    ChamferBody: The amount to chamfer for edges parallel to z axis
    ChamferBottom: The amount to chamfer for edges in z=0 plane
    ChamferTop: The amount to chamfer for edges in z=dim[2] plane
  Example:
    CenterCube([10, 20, 5]);

    // create a rectangle bowl
    // thanks to chamfer no support is required with 3d print
    difference() {  
      wallthickness=2;
      xwidth = 10;
      ywidth = 20;
      height = 5;
      CenterCube( 
        [xwidth+2*wallthickness, ywidth+2*wallthickness, height], 
        ChamferBottom = wallthickness);
      translate([0,0,wallthickness])
      CenterCube([xwidth,ywidth,height]);
    }

*/

module CenterCube(dim, ChamferBody = 0, ChamferBottom=0, ChamferTop=0) {
  difference() {
    translate([0,0,dim[2]/2])
    cube(dim, center=true);

    if ( ChamferBody > 0 ) {
      translate([dim[0]/2,dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);
      
      translate([-dim[0]/2,dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);

      translate([-dim[0]/2,-dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);

      translate([dim[0]/2,-dim[1]/2,0])
      ChamferZCube(w=ChamferBody,h=dim[2],d=0.01);
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


// Custom Geometric Smiley (with Hair) + "K" Logo Module
module smiley_k_logo(text_size = 14) {
    union() {
        // 1. Custom 2D Smiley (Replaces 'O')
        translate([-text_size * 0.65, 0]) {
            // Main Face & Expression
            difference() {
                // Head outline
                circle(r = text_size / 2, $fn = 32);
                
                // Eyes
                translate([-text_size * 0.21, text_size * 0.17]) 
                circle(r = text_size * 0.09, $fn = 16);
                translate([ text_size * 0.21, text_size * 0.17]) 
                circle(r = text_size * 0.09, $fn = 16);
                
                // Smile Arc
                difference() {
                    circle(r = text_size * 0.3, $fn = 32);
                    circle(r = text_size * 0.22, $fn = 32);
                    translate([-text_size, -0.8]) square([text_size * 2, text_size]); // Cut top half
                }
            }
            
            // 3 Hair Strands (Attached to top of head)
            hair_w = text_size * 0.05;
            hair_h = text_size * 0.25;
            head_r = text_size / 2;
            
            // Middle Hair
            translate([0, head_r - 0.1])
                square([hair_w, hair_h], center = true);
                
            // Left Hair (Angled)
            translate([-text_size * 0.15, head_r - 0.2])
                rotate([0, 0, 25])
                square([hair_w, hair_h], center = true);
                
            // Right Hair (Angled)
            translate([text_size * 0.15, head_r - 0.2])
                rotate([0, 0, -25])
                square([hair_w, hair_h], center = true);
        }
        
        // 2. The Uppercase "K"
        translate([text_size * 0.35, 0]) {
            text("K", size = text_size, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
        }
    }
}

module tube() {
    translate([drill_collector_inner_dia/2*0.8-tube_inner_dia/2,0,tube_dia/2+arch_h+lid_h-(tube_dia-tube_inner_dia)*0.5])
    rotate([-90,0,0])
    difference() {
        union() {
            cylinder(d=tube_dia,h=vac_y_size/2+frame_w+drill_collector_dia/2, $fn=64);
            translate([0,tube_dia/4,0])
            CenterCube([tube_dia,tube_dia/2,vac_y_size/2+frame_w+drill_collector_dia/2]);
        }
        translate([0,0,-0.01])
        cylinder(d=tube_inner_dia,h=vac_y_size/2+frame_w+drill_collector_dia/2+0.02, $fn=64);
    }
}

module inner_tube() {
    translate([drill_collector_inner_dia/2*0.8-tube_inner_dia/2,0,tube_dia/2+arch_h+lid_h-(tube_dia-tube_inner_dia)*0.5])
    rotate([-90,0,0])
        cylinder(d=tube_inner_dia,h=vac_y_size/2+frame_w+drill_collector_dia/2+0.02, $fn=64);
}


module arch_hall($fn=$fn) {
    difference() {
        union() {
            intersection()
            {
                CenterCube([vac_x_size, vac_y_size,arch_h]);            
                union() {
                    for( i = [ 0 : vac_y_size/arch_dist/2 ] ) {
                        CopyMirror([0,1,0])
                        translate([0, i*arch_dist+arch_dist/2, 0])
                        CenterCube([vac_x_size,arch_wall,arch_h]);
                    }
                    for( i = [ 0 : vac_x_size/arch_dist/2 ] ) {
                        CopyMirror([1,0,0])
                        translate([i*arch_dist+arch_dist/2, 0, 0])
                        CenterCube([arch_wall, vac_y_size,arch_h]);
                    }
                }
            }
        }

        for( i = [ 0 : vac_x_size/arch_dist/2 ] ) {
            CopyMirror([1,0,0])
            translate([i*arch_dist, vac_y_size/2+0.01, 0])
            rotate([90,0,0])
            cylinder( d=arch_dia, h = vac_y_size+0.02 );
        }

        for( i = [ 0: vac_y_size/arch_dist/2 ] ) {
            CopyMirror([0,1,0])
            translate([-vac_x_size/2-0.01, i*arch_dist, 0])
            rotate([0,90,0])
            cylinder( d=arch_dia, h = vac_x_size+0.02 );
        }
    }
}

module arch_frame() {
    difference() {
        CenterCube([vac_x_size+2*frame_w, vac_y_size+2*frame_w,arch_h], ChamferBody=3);

        translate([0,0,-0.01])
        CenterCube([vac_x_size-0.02, vac_y_size-0.02, arch_h+0.02]);
        
        CopyMirror([0,1,0])
        translate([0,(vac_y_size+frame_w)/2,-0.01])
        CenterCube([vac_x_size+2*frame_w-2*frame_insulation_wall, frame_insulation_width,frame_insulation_height]);

        CopyMirror([1,0,0])
        translate([(vac_x_size+frame_w)/2,0,-0.01])
        CenterCube([frame_insulation_width,vac_y_size+2*frame_w-2*frame_insulation_wall, frame_insulation_height]);
          
    }
}


//translate([0,0,arch_h+2]);
module lid($fn=$fn) {
    translate([0,0,arch_h])
    union() {
        difference() {
            CenterCube([vac_x_size+2*frame_w, vac_y_size+2*frame_w,lid_h], ChamferBody=3);
            translate([0,0,-0.01])
            CenterCube([arch_dist-arch_wall, arch_dist-arch_wall,lid_h+0.02]);
            
            /*
            translate([-vac_x_size/3, vac_y_size/2, lid_h - 1.5 + 0.01]) {
                linear_extrude(height = 1.6) {
                    smiley_k_logo(text_size = 14);
                }
            }
            */
            
        }
        difference()
        {
            union() {
                cylinder(d=hose_dia+hose_wall*2, h=hose_h);
                cylinder(d1=hose_dia+hose_wall*2+8*2, d2=hose_dia+hose_wall*2, h=8);
                translate([0,0,-arch_h])
                scale([1,0.5,1])
                tube();
            }
            translate([0,0,-0.01])
            cylinder(d=hose_dia, h=hose_h+0.02);
            translate([0,0,-arch_h])
            scale([1,0.5,1])
            inner_tube();
        }
    }
}

module drill_collector() {
    difference() {
        translate([0,(vac_y_size+2*frame_w)/2+drill_collector_dia/2,0])
        union() {
            difference() {
                union() {
                    cylinder(d=drill_collector_dia, h=arch_h+lid_h, $fn=128);
                    translate([0,-drill_collector_dia/2,(arch_h+lid_h)/2])
                    rotate([-90,0,0])
                    SquareFrustum(bottom=[drill_collector_dia*1.4,arch_h+lid_h], top=[drill_collector_dia,arch_h+lid_h], h=drill_collector_dia*0.50);
                }
               
                translate([0,0,arch_h+lid_h])
                rotate([0,90,0])
                cylinder(d=3, h=arch_h*10, center=true, $fn=4);
                
                rotate([0,0,90])
                translate([0,0,arch_h+lid_h])
                rotate([0,90,0])
                cylinder(d=3, h=arch_h*10, center=true, $fn=4);
                
                cylinder(d=drill_collector_inner_dia, h=(arch_h+lid_h)*10, center=true, $fn=128);
            }

            translate([0,0,arch_h+lid_h-2])
            difference() {
                union()
                {
                    translate([0,-((vac_y_size+2*frame_w)/2+drill_collector_dia/2),-(arch_h+lid_h-2)])
                    translate([0,(vac_y_size/2+frame_w+drill_collector_dia/2)/2,0])
                    scale([1,0.5,1])
                    tube();
                    
                    sphere(d = drill_collector_inner_dia+drill_collector_wall*2, $fn=128);
                }
                sphere(d = drill_collector_inner_dia, $fn=128);
                translate([0,0,-drill_collector_inner_dia])
                CenterCube([drill_collector_dia*2, drill_collector_dia*2, drill_collector_inner_dia]);
                
                translate([0,0,drill_collector_inner_dia*drill_collector_insert_height])
                CenterCube([drill_collector_dia*2, drill_collector_dia*2, drill_collector_inner_dia]);

            }
        }
        translate([0,(vac_y_size/2+frame_w+drill_collector_dia/2)/2,0])
        scale([1,0.5,1])
        inner_tube();
    }
}



arch_hall($fn=4);
arch_frame();
lid($fn=128);
drill_collector();

