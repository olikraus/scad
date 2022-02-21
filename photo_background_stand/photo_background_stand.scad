

paper_gap = 0.4;
side_wall = 1.2;
bottom_wall = 2;
channel_width = 15;
chamfer = side_wall*0.7;
inner_radius = 40;
extension_length = 40;
fragments=128;

channel_height = side_wall*2+paper_gap;
outer_radius = inner_radius + channel_height;

upoly = [
  [0,0],
  [side_wall*2+paper_gap, 0],
  [side_wall*2+paper_gap, channel_width],
  [side_wall+paper_gap+chamfer, channel_width],
  [side_wall+paper_gap, channel_width-3*chamfer],
  [side_wall+paper_gap, bottom_wall],
  [side_wall, bottom_wall],
  [side_wall, channel_width-3*chamfer],
  [side_wall-chamfer, channel_width],
  [0, channel_width]
];

opoly = [
  [0,0],
  [side_wall*2+paper_gap, 0],
  [side_wall*2+paper_gap, channel_width+0.01],
  [0, channel_width+0.01]
];

module pbs() {
  union() {
    rotate([90,0,0])
    linear_extrude(height = extension_length)
      translate([inner_radius,0,0])
      polygon(upoly);

    rotate_extrude(angle = 90, convexity = 4, $fn=fragments)
      translate([inner_radius,0,0])
      polygon(upoly);

    rotate([0,-90,0])
    linear_extrude(height = extension_length)
      translate([0,inner_radius+channel_height,0])
      rotate([0,0,-90])
      polygon(upoly);

    difference()
    {
      union() {
        translate([outer_radius-side_wall, outer_radius-side_wall, 0])
        rotate([0,0,45])
        translate([0,0,channel_width/2])
        cube([side_wall, side_wall, channel_width], center=true);
          
        translate([outer_radius-side_wall,0.01,0])
        cube([side_wall, outer_radius-0.01, channel_width]);

        translate([0.01,outer_radius,0])
        rotate([0,0,-90])
        cube([side_wall, outer_radius-0.01, channel_width]);
      }
      rotate_extrude(angle = 90, convexity = 4, $fn=fragments)
        translate([inner_radius,0,0])
        polygon(opoly);
    }
  }
}

pbs();
translate([3,-3,0])
rotate([0,0,180])
pbs();
