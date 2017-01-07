$fn = 96/2;

middle_d = 100;
bar_d = 8;
leg_d = 12;
bevel = sqrt(2)/2;
clearance = 2.25;
extra_inner = 2;

strings = 8;
pin_d = 2.5;
pin_h = 2;
pin_gap = 2;

screw_hole_d = 3.5;
screw_head_h = 2.5;
screw_head_d = 8;

outer_d = middle_d+bar_d;
screw_d = outer_d+leg_d-bar_d*2;
leg_h = bar_d/2+clearance;

inner_length = strings*pin_d+(strings-1)*pin_gap;
pin_angle=360*inner_length/(2*PI*outer_d/2); // TODO: This is the angle if we know the arc, but we only know the chord.

screw_length = inner_length+leg_d+extra_inner;
screw_angle=360*screw_length/(2*PI*outer_d/2); // TODO: This is the angle if we know the arc, but we only know the chord.

/*color("silver")*/
difference() {
  union() {
    // Main bar
    translate([0, middle_d/2, 0]) {
      difference() {
        intersection() {
          rotate_extrude($fn=$fn*2) translate([middle_d/2, 0, 0]) circle(d=bar_d);
          translate([0, outer_d/-4, bar_d/-2]) cube(size=[outer_d, outer_d/2, bar_d], center=true);
          hull() {
            cylinder(d=1, h=bar_d, center=true, $fn=3);
            for (i=[-1:2:1]) {
              translate([sin(180+screw_angle*i/-2)*middle_d*2, cos(180+screw_angle*i/-2)*middle_d*2, 0]) cylinder(d=1, h=bar_d, center=true, $fn=3);
            }
          }
        }
        rotate_extrude() translate([(middle_d-bar_d)/2, 0, 0]) rotate(45) square(size=[bevel, bevel], center=true);
      }
    }

    // Pins
    translate([0, middle_d/2, (bar_d-pin_d)/-2]) {
      intersection() {
        for (i=[(strings-1)/-2:(strings-1)/2]) {
          rotate([90, 0, i*(pin_angle/strings)]) translate([0, 0, middle_d/2]) cylinder(d=pin_d, h=pin_h+bar_d/2);
        }
        translate([0, 0, pin_h/4]) resize([outer_d+pin_h*2, outer_d+pin_h*2, bar_d*1.5]) sphere(d=1, $fn=$fn*2);
      }
    }

    // Legs
    translate([0, middle_d/2, 0]) for (i=[-1:2:1]) {
      translate([sin(180-screw_angle/2*i)*screw_d/2, cos(180-screw_angle/2*i)*screw_d/2, leg_h/-2]) {
        union() {
          intersection() {
            translate([0, 0, leg_d/4]) sphere(d=leg_d);
            cube(size=[leg_d, leg_d, leg_h], center=true);
          }
          cylinder(d1=bar_d, d2=bar_d/1.5, h=leg_h, center=true);
        }
      }
    }
  }

  // Slots
  translate([0, middle_d/2, 0]) for (i=[(strings-1)/-2:(strings-1)/2]) {
    rotate([90, 45, i*(pin_angle/strings)]) translate([0, 0, middle_d/2]) rotate([90, 0, 0]) cube(size=[bevel, bar_d+0.01, bevel], center=true);
  }

  // Screw holes
  translate([0, middle_d/2, 0]) for (i=[-1:2:1]) {
    translate([sin(180-screw_angle/2*i)*screw_d/2, cos(180-screw_angle/2*i)*screw_d/2, 0]) {
      translate([0, 0]) rotate_extrude() translate([(leg_d)/2, 0, 0]) rotate(45) square(size=[bevel, bevel], center=true);
      translate([0, 0, leg_h/-2]) cylinder(d=screw_hole_d, h=leg_h+0.01, center=true);
      translate([0, 0, screw_head_h/-2]) cylinder(d=screw_head_d, h=screw_head_h+0.01, center=true);
    }
  }
}
