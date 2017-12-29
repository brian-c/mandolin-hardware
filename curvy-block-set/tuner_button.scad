use <curvy_block.scad>;

module tuner_button(
  width = 10,
  height = 14,
  wing_t = 2.5,
  center_d = 7,
  shaft = 3.6,
  flat = 2.9,
  screw_head_d = 4.2,
  screw_head_h = 1.7,
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

        intersection() {
          rotate([90]) {
            cylinder(d=shaft, h=height+0.02, center=true);
          }

          cube(size=[shaft+0.02, height+0.02, flat], center=true);
        }

        translate([0, (height-screw_head_h)/2+0.01, 0]) {
          rotate([90]) {
            cylinder(d1=screw_head_d, d2=0, h=screw_head_h, center=true);
          }
        }
      }
    }
  }
}

tuner_button();
