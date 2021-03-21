/*

  ccm_funnel.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

  21 Mar 2021
  - Bugfix: Added pile_gap
  - Fixed chamfer 
  - Added support rail
  - Moved funnel max down
  - added extra y space for the cards 
  

*/

include <card_compare_machine.scad>;

/*
translate([-80,0,0])
sorter_house(false);
*/

funnel();

