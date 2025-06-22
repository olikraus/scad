
/* input parameter */
inner_dia = 5;
wall_width = 2;
loop_dia = 100;

/* internal parameter */
bezier_circle_factor = 0.61;
extra_bottom_height = 1.6;

/* helper functions */
function bezier(t, p0, p1, p2, p3) =
    pow(1-t,3)*p0 + 3*pow(1-t,2)*t*p1 + 3*(1-t)*pow(t,2)*p2 + pow(t,3)*p3;

function bezier_curve(p0, p1, p2, p3, steps=32) = 
    [ for (i = [0:steps-1]) 
        let (t = i/steps) 
        [ bezier(t, p0[0], p1[0], p2[0], p3[0]),
          bezier(t, p0[1], p1[1], p2[1], p3[1]) ] ];

/* semi-circular cross-section */
/* left wall */
c0 = bezier_curve( 
        [0,0], 
        [0,wall_width*bezier_circle_factor], 
        [wall_width,wall_width*bezier_circle_factor], 
        [wall_width,0]);

/* middle part of the track */
c1 = bezier_curve( 
        [wall_width,0], 
        [wall_width,-inner_dia*bezier_circle_factor], 
        [wall_width+inner_dia,-inner_dia*bezier_circle_factor], 
        [wall_width+inner_dia,0]);

/* right wall */
c2 = bezier_curve( 
        [wall_width+inner_dia,0], 
        [wall_width+inner_dia,wall_width*bezier_circle_factor], 
        [wall_width+inner_dia+wall_width,wall_width*bezier_circle_factor], 
        [wall_width+inner_dia+wall_width,0]);
  
/* bottom part */  
c3 = [ [wall_width+inner_dia+wall_width,0],
       [wall_width+inner_dia+wall_width,-inner_dia*bezier_circle_factor-extra_bottom_height],
       [0,-inner_dia*bezier_circle_factor-extra_bottom_height],
       /* [0,0] */ ];

/* concat and flatten */
raw_curve = [for (sublist = [c0, c1, c2, c3]) for (item = sublist) item];

/* translate the curve, so that the lower left corner is at [0, 0], also add the loop radius */
curve = [for (p = raw_curve) [p[0] + loop_dia/2, p[1] + inner_dia*bezier_circle_factor+extra_bottom_height]];

/* loop track */    
//rotate([90,0,0]) linear_extrude(10) polygon(curve);

rotate_extrude(convexity = 10, $fn = 100) polygon(curve);


