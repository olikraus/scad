/*

  ccm_eject.scad
  
  (c) olikraus@gmail.com

  This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.


  Problems 7 Mar 2021
  - Wheel is too high   --> fixed by 1 mm
  - Card gap is too small --> fixed by 1 mm
  - Both arcs are brocken --> fixed with some additional edge corner
  - motor holder block mount screw diameter too small --> fixed by 0.1mm
  - Reduced height of the motor holder (for faster printing)  --> done
  - Leave gap at the lower end of the rail --> done
  14 Mar 2021
  - Both arcs are still brocken --> reduced edge corner (because of sorter rail), added outer support
  
  21 Mar 2021
  - Bugfix: Added pile_gap --> done
  - Added slope to motor mount block --> done
  
   22 Mar 2021
  - Motor must be higher --> 10m --> done
  - lower the support towards sorter house --> done

   24 Mar 2021
   - Increased eject house height to 125 (130 with pile holder)

*/


include <card_compare_machine.scad>;

eject_house(false);

