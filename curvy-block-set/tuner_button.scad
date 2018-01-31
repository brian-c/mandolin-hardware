use <curvy_block.scad>;

slip = 0.15;

module tuner_button(
  width = 9,
  height = 12,
  wing_t = 3,
  center_d = 7,
  shaft_h = 5.4+1,
  shaft_d = 4+slip,
  shaft_flat = 3.5+slip,
  screw_d = 2.5,
  screw_head_d = 4.4,
  screw_head_h = 1.33,
) {
  translate([0, 0, height/2]) {
    rotate([90, 0, 0]) {
      difference() {
        union() {
          rotate([90]) {
            cylinder(d=center_d, h=height, center=true);
          }

          for (i=[0, 1]) {
            rotate([180*i, 0, 90]) {
              translate([0, width/2, (center_d-wing_t)/-2+0.01]) {
                curvy_block(size=[height, width, wing_t], r1=height/2, r2=height/2, r3=0, r4=0);
              }
            }
          }
        }

        translate([0, (height-screw_head_h)/2+0.01, 0]) {
          rotate([90]) {
            cylinder(d=screw_d, h=height+0.02, center=true);
            cylinder(d1=screw_head_d, d2=screw_d, h=screw_head_h, center=true);
          }
        }

        translate([0, (height-shaft_h)/-2, 0]) {
          intersection() {
            rotate([90]) {
              cylinder(d=shaft_d, h=shaft_h+0.02, center=true);
            }

            cube(size=[shaft_d+0.02, shaft_h+0.01, shaft_flat], center=true);
          }
        }
      }
    }
  }
}

tuner_button();
