$fn = 32;

function inches(mm) = 25.4*mm;

module pickup_cover(
  shell_t = inches(1/16),
  shell_r = inches(1/32),
  plate_h = inches(1+9/16),
  inner_plate_w = inches(2+1/16),
  inner_corner_d = inches(1/8),
  coil_w = inches(2+7/8),
  coil_d = inches(11/16),
  coil_h = inches(11/16),
  screw_d = inches(0.138),
  screw_head_d = inches(0.262),
  screw_head_h = inches(0.083),
  screw_coords = [ // From center
    [inches(0), inches(-19/32)],
    [inches((1+13/16)/-2), inches(19/32)],
    [inches((1+13/16)/2), inches(19/32)],
  ],
) {
  /* screw_head_h = screw_head_d/((180-82)/45); */

  module plate() {
    hull() {
      for (i=[-1, 1]) {
        translate([(coil_w-coil_d)/2*i, 0]) {
          circle(d=coil_d);
        }

        for (j=[-1, 1]) {
          translate([inner_plate_w/2*i, (plate_h-inner_corner_d)/2*j]) {
            circle(d=inner_corner_d);
          }
        }
      }
    }
  }

  module outer_solid() {
    difference() {
      minkowski() {
        linear_extrude(height=coil_h-shell_r*2) {
          plate();
        }
        sphere(r=shell_r);
      }
      translate([0, 0, (shell_r+0.01)/-2]) {
        cube(size=[coil_w+shell_r*2+0.02, plate_h+shell_r*2+0.02, shell_r+0.01], center=true);
      }
    }
  }

  module shell() {
    difference() {
      /* outer_solid(); */
      translate([0, 0, (coil_h+shell_t)/2]) {
        cube(size=[coil_w+shell_t*3, plate_h+shell_t*3, coil_h+shell_t*3], center=true);
      }

      translate([0, 0, -0.01]) {
        resize([coil_w, plate_h-shell_t*2, coil_h]) {
          outer_solid();
        }
      }
    }
  }

  module bracing() {
    for (screw_coord=screw_coords) {
      turn = screw_coord[0] < 0 ? 30 : screw_coord[0] > 0 ? -30 : 0;
      up_or_down = screw_coord[1] > 0 ? 1 : -1;

      translate(screw_coord) {
        rotate(turn) hull () {
          cylinder(d1=screw_d+shell_t*2, d2=screw_head_d+shell_t*2, h=coil_h+shell_t);

          translate([0, screw_head_d*up_or_down, 0]) {
            cylinder(d1=(screw_d+shell_t)*2, d2=(screw_head_d+shell_t)*2, h=coil_h+shell_t);
          }
        }
      }
    }
  }

  module screw_holes() {
    translate([0, 0, -0.01]) {
      for (screw_coord=screw_coords) {
        translate(screw_coord) {
          cylinder(d=screw_d, h=coil_h+shell_t+0.02);

          translate([0, 0, coil_h+shell_t-screw_head_h+0.02]) {
            cylinder(d1=0, d2=screw_head_d, h=screw_head_h);
          }
        }
      }
    }
  }

  %union() {
    /* plate(); */

    hull() {
      for (i=[-1, 1]) {
        translate([(coil_w-coil_d)/2*i, 0, coil_h/2]) {
          cylinder(d=coil_d, h=coil_h, center=true);
        }
      }
    }

    screw_h = coil_h+shell_t+inches(1/2);
    translate([0, 0, screw_h/2-inches(1/2)]) {
      for (screw_coord=screw_coords) {
        translate(screw_coord) {
          cylinder(d1=screw_d/2, d2=screw_d, h=screw_h, center=true);
        }
      }
    }
  }

  intersection() {
    resize([coil_w+shell_t*2, plate_h, coil_h+shell_t]) {
      outer_solid();
    }

    difference() {
      union() {
        shell();
        bracing();
      }
      screw_holes();
    }
  }
}

pickup_cover();
