/*

  winston_freer.scad

  Winston Freer Tile Puzzle
  
    
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
    
  
  Part 2:
  start_area = x-size * (large side + small side)/2 = tx *  ts * ( 5*ts + ts ) /2  = tx *ts*ts * 3
  swap_area = x-size * (large side + 2*extend + small side + 2*extend)/2 = tx * ts * ( 5*ts+ 2*ts*extend + ts + 2*ts*extend)/2 = tx * ts * ( 6 + 4*extend) / 2 = tx*ts*ts*(3+2*extend)
  swap_area = start_area + 3*ts*ts;
  ==> 	tx*ts*ts*(3+2*extend) = tx *ts*ts * 3 + 3*ts*ts
		tx*(3+2*extend) =  3*tx + 3;
		3*tx + 2*tx*extend = 3*tx + 3
		  2*tx*extend = 3
		  extend = 3/(2*tx)
  
  
*/


//================================
// The following variables can be modified

ts=19.85;	// size in mm of one quadratic tile.
tw=19.85;	// size in x direction

height=17.6; // height of the inner body of the tile in mm
ledge_height=1.2;	// upper and lower ledge of a tile in mm. The total height of a puzzle piece is height+2*ledge_height

gapw=4.0;			// width of one grid line in mm. This value should be small compared to ts. It must be smaller than ts/2
gaph=1.2;			// depth of the grid into the ledge. This value should be lesser or equal to ledge_height

frame_gap=0.8;		// gap (mm) between puzzle and frame or box. 1.2 is very loose
frame_wall=3;		// wall size of the frame or box

is_bottom_mesh = true;   // whether the grid is printed on the bottom of the parts (except for part 2, which always as the grid on top AND bottom) 

//================================
// The following constants should not be modified

$fn=32;

fontsize=8*ts/17;	// font size, could be changed, but the current value will grow/srink with ts

tx=7;	// x-size of the puzzle in tile size. real size in mm is tx*ts. This value is fixed and must not be modified.
ty=9;	// y-size of the puzzle in tile size. real size in mm is ty*ts. This value is fixed and must not be modified.
extend=3/(2*tx);	// extend of part 2 in tile size. This has to be multiplied with ts to get the real size, value is 0.21428

echo("slope: ", atan(extend*ts/height));

echo(str("total size: ", tx*tw, " x ", ty*ts));

//================================


module p2(lh=1,d=0) {
    p= 
[
 [ tw*tx+d, ts/2, height/2+lh+d ],
 [ tw*tx+d, ts/2, height/2+d],
 [ tw*tx+d, ts/2+extend*ts, -height/2-d],
 [ tw*tx+d, ts/2+extend*ts, -height/2-lh-d],

 [ tw*tx+d, -ts/2-extend*ts, -height/2-lh-d],
 [ tw*tx+d, -ts/2-extend*ts, -height/2-d],
 [ tw*tx+d, -ts/2, height/2+d],
 [ tw*tx+d, -ts/2, height/2+lh+d],

 [ 0-d, 5*ts/2, height/2+lh+d ],
 [ 0-d, 5*ts/2, height/2+d],
 [ 0-d, 5*ts/2+extend*ts, -height/2-d],
 [ 0-d, 5*ts/2+extend*ts, -height/2-lh-d],

 [ 0-d, -5*ts/2-extend*ts, -height/2-lh-d],
 [ 0-d, -5*ts/2-extend*ts, -height/2-d],
 [ 0-d, -5*ts/2, height/2+d],
 [ 0-d, -5*ts/2, height/2+lh+d]
];
  f =  [ 
    [1, 0, 8, 9],
    [3, 2, 10, 11],
    [2, 1, 9, 10],
    
    [12, 13, 5, 4],
    [14, 15, 7, 6],
    [13, 14, 6, 5],
    
    [0, 1, 2, 3, 4, 5, 6, 7],
    [15, 14, 13, 12, 11, 10, 9, 8],
    [0, 7, 15, 8],
    [3, 11, 12, 4]
  ];
  translate([0, 6*ts, 0])
  polyhedron(points=p, faces=f, convexity=5);
}

module p1(lh=1) {
    difference() {
        translate([0,6*ts,-(height+2*lh)/2])
        cube([tx*tw,3*ts,height+2*lh]);
        p2(lh, 0.01);
    }
}

module p3(lh=1) {
    difference() {
        translate([0,0,-(height+2*lh)/2])
        cube([2*tw,5*ts,height+2*lh]);
        p2(lh, 0.01);
    }
}

module p4(lh=1) {
    difference() {
        translate([2*tw,ts,-(height+2*lh)/2])
        cube([tw,5*ts,height+2*lh]);
        p2(lh, 0.01);
    }
}

module p5(lh=1) {
    difference() {
        translate([3*tw,ts,-(height+2*lh)/2])
        cube([3*tw,5*ts,height+2*lh]);
        p2(lh, 0.01);
    }
}

module p6(lh=1) {
    difference() {
        translate([6*tw,2*ts,-(height+2*lh)/2])
        cube([tw,4*ts,height+2*lh]);
        p2(lh, 0.01);
    }
}

module p7(lh=1) {
        translate([2*tw,0,-(height+2*lh)/2])
        cube([3*tw,ts,height+2*lh]);
}

module p8(lh=1) {
        translate([5*tw,0,-(height+2*lh)/2])
        cube([tw,ts,height+2*lh]);
}

module p9(lh=1) {
        translate([6*tw,0,-(height+2*lh)/2])
        cube([tw,ts,height+2*lh]);
}

module p10(lh=1) {
        translate([6*tw,ts,-(height+2*lh)/2])
        cube([tw,ts,height+2*lh]);
}

module mesh() {
        for( x=[0:tx]) {
            translate([x*tw-gapw/2,-gapw/2,-gaph/2])
            cube([gapw, ty*ts+gapw, gaph]);
        }
        for( y=[0:ty]) {
            translate([0,y*ts-gapw/2,-gaph/2])
            cube([tx*tw, gapw, gaph]);
        }
}


module part1() {
    difference() {
        p1();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([4*tw+tw/2, 
            8*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("1", halign="center", 
                valign="center", size=fontsize);
    }
}

module part2pre() {
    difference() {
        p2();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
        translate([1*tw+tw/2, 
            6*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("2", halign="center", 
                valign="center", size=fontsize);
    }
}

module part2() {
    difference()
    {
        translate([0,5.894*ts,0])
        rotate([180,0,0])
        translate([0,-5.894*ts,0])
        part2pre();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
        translate([1*tw+tw/2, 
            6*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("2", halign="center", 
                valign="center", size=fontsize);
    }
}

module part3() {
    difference() {
        p3();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([0*tw+tw/2, 
            1*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("3", halign="center", 
                valign="center", size=fontsize);
    }
}

module part4() {
    difference() {
        p4();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([2*tw+tw/2, 
            2*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("4", halign="center", 
                valign="center", size=fontsize);
    }
}

module part5() {
    difference() {
        p5();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([4*tw+tw/2, 
            2*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("5", halign="center", 
                valign="center", size=fontsize);
    }
}

module part6() {
    difference() {
        p6();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([6*tw+tw/2, 
            3*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("6", halign="center", 
                valign="center", size=fontsize);
    }
}

module part7() {
    difference() {
        p7();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([3*tw+tw/2, 
            0*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("7", halign="center", 
                valign="center", size=fontsize);
    }
}

module part8() {
    difference() {
        p8();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([5*tw+tw/2, 
            0*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("8", halign="center", 
                valign="center", size=fontsize);
    }
}

module part9() {
    difference() {
        p9();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
	}
        translate([6*tw+tw/2, 
            0*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("9", halign="center", 
                valign="center", size=fontsize);
    }
}

module part10() {
    difference() {
        p10();
        translate([0,0,height/2+ledge_height-gaph/2+0.01])
        mesh();
	if ( is_bottom_mesh ) {
	  translate([0,0,-height/2-ledge_height+gaph/2-0.01])
	  mesh();
        }
        translate([6*tw+tw/2-0.5, 
            1*ts+ts/2, 
            height/2+ledge_height-gaph]) 
            linear_extrude(gaph+0.01) 
            text("10", halign="center", 
                valign="center", spacing=0.8, size=fontsize);
    }
}

module frame() {
    //translate([0,0,-height/2-ledge_height])
    gap=frame_gap;
    difference() {
        translate([-frame_wall, -frame_wall, 0])
        cube([tx*tw+frame_wall*2, ty*ts+frame_wall*2, height+ledge_height*2]);
        translate([-gap/2,-gap/2,-0.01])
        cube([tx*tw+gap, ty*ts+gap, height+ledge_height*2+0.02]);

        translate([0,0,height+2*ledge_height-gaph/2+0.01])
        mesh();

    }
}


module box() {
    bh=0.8;
    gap=frame_gap;
    //translate([0,0,-height/2-ledge_height])
    difference() {
        translate([-frame_wall, -frame_wall, 0])
        cube([tx*tw+frame_wall*2, ty*ts+frame_wall*2, height+ledge_height*2+bh]);
        translate([-gap/2,-gap/2,bh-0.01])
        cube([tx*tw+gap, ty*ts+gap, height+ledge_height*2+0.02]);	
	
        translate([0,0,height+2*ledge_height-gaph/2+bh+0.01])
        mesh();
    }
}

module lid() {
    bh=0.8;
    gap=frame_gap;
    //translate([0,0,-height/2-ledge_height])
    difference() {
        translate([-frame_wall*2, -frame_wall*2, 0])
        cube([tx*tw+frame_wall*4, ty*ts+frame_wall*4, height+ledge_height*2+2*bh]);
    
        translate([-frame_wall-gap/2, -frame_wall-gap/2, bh+0.01])
        cube([tx*tw+frame_wall*2+gap, ty*ts+frame_wall*2+gap, height+ledge_height*2+bh]);
    }
}
