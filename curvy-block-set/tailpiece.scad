use <curvy_block.scad>;

module tailpiece(
  leg_d = 11,
  pins = 8,
  clearance = 2,
  pin_h = 2.4,
  pin_d = 3.3,
  pin_spacing = 2.4,
  // #6 wood screw:
  screw_d = 3.5052+0.5,
  screw_head_d = 6.6548,
  screw_head_h = 2.1082,
) {
  tailpiece_w = pins*pin_d+(pins+1)*pin_spacing;
  overall_h = pin_d+clearance*2;
  full_pin_h = (leg_d-pin_h)/2+pin_h-pin_d/4;

  translate([0, 0, overall_h/2]) {
    difference() {
      union() {
        // Half-round bar
        translate([0, 0, pin_d/-2]) {
          difference() {
            translate([0, 0, pin_d+clearance]) {
              resize([tailpiece_w+leg_d, leg_d-pin_h, (pin_d+clearance)*2]) {
                rotate([0, 90]) {
                  cylinder(d=1, h=1, center=true);
                }
              }
            }

            translate([0, 0, (pin_d+clearance)*1.5]) {
              cube(size=[tailpiece_w+leg_d+0.02, leg_d-pin_h+0.02, pin_d+clearance], center=true);
            }
          }
        }

        // Pins
        for (i=[(pins-1)/-2:(pins-1)/2]) {
          translate([i*(pin_d+pin_spacing), 0, 0]) {
            rotate([90, 0]) {
              cylinder(d=pin_d, h=full_pin_h);
            }
          }
        }

        // Legs
        for (i=[-2, 2]) {
          translate([(tailpiece_w+leg_d*1.25)/i, pin_h/-2, 0]) {
            rotate(90*i/2) {
              curvy_block(size=[leg_d, leg_d*1.25, overall_h], r1=leg_d/2, r2=leg_d/2, r3=overall_h*2/3, r4=0);
            }
          }
        }
      }

      // Screw holes
      translate([0, pin_h/-2, 0]) {
        for (i=[-2, 2]) {
          translate([(tailpiece_w+leg_d)/i, 0, 0]) {
            translate([0, 0, (overall_h-screw_head_h)/2+0.01]) {
              cylinder(d1=screw_d, d2=screw_head_d, h=screw_head_h, center=true);
            }

            cylinder(d=screw_d, h=overall_h+0.02, center=true);
          }
        }
      }
    }
  }
}

tailpiece();
