/*

  ccm_sorter.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  21 Mar 2021 
    - Bugfix: Added pile gap, updated rail
    - Moved wheel towards eject house (2mm), bigger Archoid
  
 22 Mar 2021
  - sorter rail must be higher --> done
  - sorter rail must be longer --> done
  - add side stripes, similar to funnel --> done
  
 6 Jun 2021
  - Reduce ChamferYCube width in line 387
  
 13 Jun 2021
  - Idea: Create a notch at the top end for the card, so that it can slide 
    better into the target position
  - Increase of the eject gap (sorter_card_slot_height) to 4

 3 Jul 2021
  - Increase of the eject gap (sorter_card_slot_height) to 5 --> DONE
  - Again increase ChamferYCube width in line 387 --> DONE
  - Increase pedestal so that we can add somescrews --> DONE, increased by 1mm
  - Increase the ramp total, maybe add some overlap --> DONE
  - Increase height of the motor (maybe 0.5mm) --> DONE
  - Add ramp to the motor like for the eject house --> DONE
  - Increase side archoid cutout radius 24->26 --> DONE 
  - Add two M3 screw holes for later mounting of the funnel --> DONE

 4 Jul 2021
  - Upper right end of the ramp could still be higher by 3 mm --> DONE
  - Increase notch width to 14 --> DONE
  - Bold text "tcsm" --> DONE

 Instructions:
  1) Ramp and top area must be very clean and smooth
  2) The wheel of the DC motor must be aligned
    horizontally to the top border of the sorter
  3) Check the funnel for any obstacles (for example small
    filament threads)

*/

include <card_compare_machine.scad>;

//translate([-2*card_width, 0,0])
sorter_house(false);



module xSlopeCube(w = 10, l = 35, zs = 20, hs = 10, ze = 50, he = 10) {
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

//SlopeCube();