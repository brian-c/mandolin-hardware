$fn = 50;

plate_height = 13;
plate_thickness = 3;
plate_radius = 90;

screw_hole_radius = 1.3;

// This should be about 32 total.
courses = 4;
course_spacing = 6;
strings = 2;
string_spacing = 3;

peg_length = 3;
peg_radius = 1;

nut_height = 13;
nut_radius = 2;

function to_deg(distance) = ((distance / plate_radius) * 180) / PI;
function space_out(index, total, spacing) = to_deg(spacing * (index - ((total + 1) / 2)));
function course_angle(index) = space_out(index, courses, course_spacing);
function string_angle(course, index) = course_angle(course) + space_out(index, strings, string_spacing);

translate([0, plate_radius-(plate_thickness/2), 0]) {
  // Plate
  intersection() {
    // Ring
    difference() {
      cylinder(h=plate_height, r=plate_radius+plate_thickness, center=true, $fn=100); // Outer ring
      cylinder(h=plate_height+2, r=plate_radius, center=true); // Inner ring cut-out
      // Screw holes
      rotate([90, 0, 0]) {
        rotate([0, course_angle(-1), 0])
          cylinder(h=plate_radius+plate_thickness+1, r=screw_hole_radius);
        rotate([0, course_angle(courses + 2), 0])
          cylinder(h=plate_radius+plate_thickness+1, r=screw_hole_radius);
      }
    }

    // Ring intersection
    for (course = [-2:0.25:courses+3])
      rotate([0, 0, course_angle(course)])
        translate([0, -1*(plate_radius-plate_thickness), 0])
          rotate ([90, 0, 0])
            cylinder(r=plate_height, h=plate_thickness*3);
  }

  // Pegs
  for (course = [1:courses])
    for (string = [1:strings])
      rotate([0, 0, string_angle(course, string)])
        translate([0, -1*(plate_radius+(plate_thickness/1.2)), 0])
          rotate([100, 0, 0]) {
            cylinder(h=peg_length, r=peg_radius);
            translate([0, 0 * peg_radius, peg_length]) scale([1, 1, 0.5]) sphere(r=peg_radius);
          }

  // Nut posts
  for (bar = [0,courses+1])
    rotate([0, 0, course_angle(bar)])
      translate([0, -1*(plate_radius+(plate_thickness/2)), plate_height/2.2]) {
        cylinder(r=plate_thickness/2.2, h=nut_height);
        translate([0, 0, nut_height])
          sphere(r=nut_radius);
      }

  // Nut
  hull()
    for (bar = [0,courses+1])
      rotate([0, 0, course_angle(bar)])
        translate([0, -1*(plate_radius+(plate_thickness/2)), plate_height/2.2])
          translate([0, 0, nut_height])
            rotate([0, 90, 0])
              cylinder(r=nut_radius, h=0.01);
}
