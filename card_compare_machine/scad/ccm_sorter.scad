/*

  ccm_sorter.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  21 Mar 2021 Bugfix: Added pile gap

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