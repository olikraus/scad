/*

  breezy_fruit_fly_trap.scad

  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

*/

/* [basic] */
/* The outside diameter of the bowl on which the trap is placed */
bowl_diameter = 88;

/* [advanced] */
/* input diameter for the trap, 40mm is fine, could be smaller also */
cone_enter_diameter = 40;
/* at least half the cone enter diameter but smaller than the bowl height */
cone_height = 30;
/* should be big enough for the fly to go through */
cone_exit_diameter = 2.8;

/* [expert] */
/* height of the outside lid wall */
lid_protect_height = 4;
/* thickness of the cone wall */
cone_wall_thickness = 1;
/* thickness of the lid, should be multiple of the layer height */
lid_thickness = 1.4;
/* height of air window, should be multiple of the layer height */
air_window_height = 0.4; /* should be multiple of layer height */
/* suggested width of air window (actual width might be different) */
air_window_width = 3;
/* gap between the air windows on the same level */
air_window_pillar_width = 1.5;
/* chamfer for the lid */
chamfer = 0.4;

/* [hidden] */
lid_diameter = bowl_diameter+cone_wall_thickness+chamfer;



points = [
  [cone_enter_diameter/2+chamfer, 0],
  [lid_diameter/2-chamfer, 0],
  [lid_diameter/2, chamfer],
  [lid_diameter/2, lid_protect_height-chamfer],
  [lid_diameter/2-chamfer, lid_protect_height],
  [lid_diameter/2-lid_thickness+chamfer, lid_protect_height],
  [lid_diameter/2-lid_thickness, lid_protect_height-chamfer],
  [lid_diameter/2-lid_thickness, lid_thickness+chamfer],
  [lid_diameter/2-lid_thickness-chamfer, lid_thickness],
  [cone_enter_diameter/2+cone_wall_thickness, lid_thickness],
  [cone_exit_diameter/2+cone_wall_thickness, cone_height],
  [cone_exit_diameter/2, cone_height],
  [cone_enter_diameter/2, lid_thickness],
  [cone_enter_diameter/2, chamfer]
];

difference() {
  rotate_extrude($fn=128)
  polygon(points);
  for(h = [lid_thickness*2:air_window_height*2:cone_height-lid_thickness*2]) { 
    /* calculate the diameter d at the specific height */
    d = ((cone_height-h)*cone_enter_diameter+h*cone_exit_diameter)/cone_height;
    /* 
      there should be so many number of windows, so that
      the window size is larger than air_window_width:
      air_window_width < d*PI/n-air_window_pillar_width
      air_window_width + air_window_pillar_width < d*PI/n
      n < d*PI/(air_window_width+air_window_pillar_width)
    */
    n = floor(d*PI/(air_window_width+air_window_pillar_width));
    /* there should be a minimal number of pillars */
    if ( n >= 4 ) {
      /* calculate the real window width */
      ww = d*PI/n-air_window_pillar_width;
      /* but do the cutout only if the ww is really big enough */
      if ( ww >= air_window_width ) {
        for(i=[0:360/n:360]) {
          rotate([0,0,i])
          translate([-ww/2,0,h])
          cube([ww, cone_enter_diameter,air_window_height]);
        }
      }
    }
  }
}

