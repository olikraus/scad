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
  
  24 Mar 2021
  - added slope to the base towards eject house --> DONE
  - Roof archoid towards eject house for more stability --> DONE
  - increased funnel height --> DONE
  
  25 Mar 2021
  - funnel should be higher --> 8mm Done
  - higher roof pile holder --> 4mm Done
  
  5 Apr 2021
  - towards the eject house, the added slope is not long enough
    It interferes with the inner chamfer --> DONE (also increased the slope by 8 Degree)
  - On the other side, the window could be taller and wider
    so that we could light also from the other side --> DONE
  - Add grove 2x1 motor driver holder --> DONE
    
*/

include <card_compare_machine.scad>;



funnel();
