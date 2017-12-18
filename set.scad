$fn = 32;

module quarter_cylinder(
  r = 1,
  h = 1,
  q = 0
) {
  intersection() {
    cylinder(r=r, h=h, center=true);

    translate([0, 0, h/-2]) {
      rotate(90*q) {
        cube(size=[r, r, h]);
      }
    }
  }
}

module curvy_block(
  size=[1, 1, 1],
  r1 = 0,
  r2 = 0,
  r3 = 0,
  r4 = 0,
) {
  hull() {
    translate([size[0]/-2+r1, size[1]/2-r1, 0]) {
      quarter_cylinder(r=max(0.01, r1), h=size[2], q=1);
    }

    translate([size[0]/2-r2, size[1]/2-r2, 0]) {
      quarter_cylinder(r=max(0.01, r2), h=size[2], q=0);
    }

    translate([0, size[1]/-2+r3, size[2]/2-r3]) {
      rotate([0, 90, 0]) {
        quarter_cylinder(r=max(0.01, r3), h=size[0], q=2);
      }
    }

    translate([0, size[1]/-2+r4, size[2]/-2+r4]) {
      rotate([0, 90, 0]) {
        quarter_cylinder(r=max(0.01, r4), h=size[0], q=3);
      }
    }
  }
}

module bridge(
  saddle_w = 44/3*4,
  saddle_t = 6.4,
  base_t = 1.5,
  post_h = 10.3,
  post_d = 6,
  post_rim_h = 1.5,
  post_rim_d = 10.4,
  stud_d = 13.5,
) {
  translate([0, 0, post_h/2]) {
    difference() {
      union() {
        // Side pieces
        for (i=[-1, 1]) {
          translate([(saddle_w+stud_d*1.25)/2/i, 0]) {
            rotate([0, 0, 90*i]) {
              curvy_block(size=[stud_d, stud_d*1.25, post_h], r1=stud_d/2, r2=stud_d/2, r3=post_h/2, r4=post_h/2);
            }
          }
        }

        difference() {
          // Bar
          cube(size=[saddle_w+stud_d, stud_d, post_h], center=true);

          // Saddle slot
          translate([0, 0, base_t]) {
            cube(size=[saddle_w+stud_d, saddle_t, post_h], center=true);
          }

          // Scoop
          translate([0, 0, post_h/2]) {
            resize([saddle_w+stud_d, stud_d+0.02, post_h*2-base_t*4]) {
              rotate([90]) {
                cylinder(d=1, h=1, center=true);
              }
            }
          }
        }
      }

      // Post holes
      for (i=[-1, 1]) {
        translate([(saddle_w+stud_d)/2/i, 0]) {
          cylinder(d=post_d, h=post_h+0.02, center=true);

          translate([0, 0, (post_h-post_rim_h)/-2]) {
            cylinder(d=post_rim_d, h=post_rim_h+0.01, center=true);
          }
        }
      }
    }
  }
}

module tailpiece(
  leg_d = 11,
  pins = 8,
  clearance = 2,
  pin_h = 2.4,
  pin_d = 3.3,
  pin_spacing = 2.4,
  pin_sphere = 1/4,
  // #6 wood screw:
  screw_d = 4,
  screw_head_d = 7.1,
) {
  tailpiece_w = pins*pin_d+(pins+1)*pin_spacing;
  overall_h = pin_d+clearance*2;
  full_pin_h = (leg_d-pin_h)/2+pin_h-pin_d/4;
  screw_head_h = screw_head_d/(82/45);

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

            translate([0, full_pin_h/-1]) {
              scale([1, pin_sphere, 1]) {
                sphere(d=pin_d);
              }
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
              cylinder(d1=0, d2=screw_head_d, h=screw_head_h, center=true);
            }

            cylinder(d=screw_d, h=overall_h+0.02, center=true);
          }
        }
      }
    }
  }
}

color("silver") {
  translate([0, 10, 0]) {
    bridge();
  }

  translate([0, -10, 0]) {
    tailpiece();
  }
}

%color("lime", 0.25) {
  difference() {
    cube(size=[44+1/2, 44*2+1/2, 1], center=true);
    cube(size=[44-1/2, 44*2-1/2, 1+0.02], center=true);
  }

  difference() {
    cube(size=[44/3+1/2, 44*2+1/2, 1], center=true);
    cube(size=[44/3-1/2, 44*2-1/2, 1+0.02], center=true);
  }
}
