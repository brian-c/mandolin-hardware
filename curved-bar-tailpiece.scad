$fn = 96;

curve_r = 45;
bar_r = 6;
leg_d = 18;
clearance = 2;
side_space = 1.5;
bevel = 1.2;

strings = 8;
pin_d = 3.2;
pin_h = 2.4;
pin_gap = 1.6;

screw_hole_d = 4;
screw_head_d = 8;
screw_head_h = 2.5;

leg_h = bar_r+clearance;

pin_arc = strings*pin_d+(strings-1)*pin_gap;
pin_angle = pin_arc/(curve_r+bar_r+pin_d)*180/PI;

screws_arc = pin_arc+leg_d+side_space*2;
screws_r = curve_r+leg_d/2-bar_r;
screws_angle = screws_arc/screws_r*180/PI;

%square(size=[72, 18], center=true); // Pickup

%difference() {
  square(size=[54, 40], center=true); // Existing Screw spread
  square(size=[35, 41], center=true); // String spread
}

color("gold")
translate([0, curve_r, leg_h]) difference() {
  union() {
    // Main bar
    intersection() {
      rotate_extrude($fn=$fn*2) translate([curve_r, 0, 0]) circle(r=bar_r);
      translate([0, (screws_r-curve_r)/-2, bar_r*-1]) hull($fn=3) {
        cylinder(d=1, h=bar_r);
        for (i=[0:strings]) {
          angle = 180+screws_angle*i/strings-screws_angle/2;
          x = sin(angle)*(curve_r+leg_d);
          y = cos(angle)*(curve_r+leg_d);
          translate([x, y, 0]) cylinder(d=1, h=bar_r);
        }
      }
    }

    // Pins
    translate([0, 0, bar_r*-1+pin_d/2]) {
      intersection() {
        for (i=[0:strings-1]) {
          angle = 180+pin_angle*i/(strings-1)-pin_angle/2;
          x = sin(angle)*(curve_r+bar_r+pin_h);
          y = cos(angle)*(curve_r+bar_r+pin_h);
          translate([x, y, 0]) rotate([90, 0, angle*-1]) cylinder(d=pin_d, h=bar_r+pin_h);
        }
        d_at_pin_ends = (curve_r+bar_r+pin_h)*2;
        translate([0, 0, pin_d/4]) resize([d_at_pin_ends, d_at_pin_ends, pin_d*5]) sphere(d=1, $fn=$fn*2);
      }
    }

    // Legs
    for (i=[-1:2:1]) {
      x = sin(180-screws_angle/2*i)*screws_r;
      y = cos(180-screws_angle/2*i)*screws_r;
      translate([x, y, 0]) {
        intersection() {
          resize([leg_d, leg_d, leg_h*2]) sphere(d=leg_d);
          translate([0, 0, leg_h/-2]) cube(size=[leg_d, leg_d, leg_h], center=true);
        }
        translate([0, 0, leg_h/-1]) cylinder(d1=bar_r*2, d2=bar_r/2, h=leg_h);
      }
    }
  }

  // Slots
  for (i=[0:strings-1]) {
    angle = 180+pin_angle*i/(strings-1)-pin_angle/2;
    x = sin(angle)*(curve_r);
    y = cos(angle)*(curve_r);

    translate([x, y, 0]) rotate([0, 45, angle*-1]) cube(size=[bevel, bar_r*2+0.01, bevel], center=true);
  }

  // Screw holes
  for (i=[-1:2:1]) {
    x = sin(180-screws_angle/2*i)*screws_r;
    y = cos(180-screws_angle/2*i)*screws_r;
    translate([x, y, 0]) {
      translate([0, 0, leg_h/-2]) cylinder(d=screw_hole_d, h=leg_h+0.01, center=true);
      translate([0, 0, screw_head_h/-2]) cylinder(d=screw_head_d, h=screw_head_h+0.01, center=true);

      // Leg bevels
      rotate_extrude() translate([leg_d/2, 0, 0]) rotate(45) square(size=[bevel, bevel], center=true);
      rotate_extrude() translate([screw_head_d/2, 0, 0]) rotate(45) square(size=[bevel, bevel], center=true);

    }
  }

  // Front bevel
  rotate_extrude() translate([curve_r-bar_r, 0, 0]) rotate(45) square(size=[bevel, bevel], center=true);
}
