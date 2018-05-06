$fn = 40;

for_projection = false;

function inches(mm) = 25.4*mm;

module pickup_cover(
  shell_t = 1.5, // Minimum
  shell_r = 0.5, // Along the top
  plate_h = 38,
  inner_plate_w = 52,
  inner_corner_d = inches(1/8),
  coil_w = 72,
  coil_d = inches(3/4), // Actually ~20, but this is easier to drill.
  coil_h = 16,
  // #6 screws:
  screw_d = 3.46+0.5,
  screw_head_d = 6.8,
  screw_head_h = 2.66,
  screw_coords = [ // From center
    [0, 12.3/-2-6.68-3.61/2],
    [(39.78+3.61)/-2, 12.3/2+7.51+3.61/2],
    [(39.78+3.61)/2, 12.3/2+7.51+3.61/2],
  ],
  for_projection = for_projection,
) {
  module plate() {
    hull() {
      for (i=[-1, 1]) {
        translate([(coil_w-coil_d)/2*i, 0]) {
          circle(d=coil_d);
        }

        for (j=[-1, 1]) {
          translate([(inner_plate_w-inner_corner_d/2)/2*i, (plate_h-inner_corner_d)/2*j]) {
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
      turn = 0; // screw_coord[0] < 0 ? 10 : screw_coord[0] > 0 ? -10 : 0;
      up_or_down = screw_coord[1] > 0 ? 1 : -1;

      translate(screw_coord) {
        rotate(turn) hull() {
          cylinder(d1=screw_d+shell_t*2, d2=screw_head_d+shell_t*2, h=coil_h+shell_t);

          translate([0, screw_head_d*up_or_down, 0]) {
            cylinder(d1=screw_d+shell_t*2, d2=screw_head_d+shell_t*2, h=coil_h+shell_t);
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
            cylinder(d1=screw_d, d2=screw_head_d, h=screw_head_h);
          }
        }
      }
    }
  }

  translate([0, 0, for_projection ? coil_h*-1+0.02 : 0]) {
    %union() {
      plate();

      hull() {
        for (i=[-1, 1]) {
          translate([(coil_w-coil_d)/2*i, 0, coil_h/2]) {
            cylinder(d=coil_d, h=coil_h, center=true);
          }
        }
      }

      screw_h = coil_h+shell_t+inches(1/2);
      echo(str("<b>Screws are about ", floor(screw_h), "mm long.</b>"));
      translate([0, 0, screw_h/2-inches(1/2)]) {
        for (screw_coord=screw_coords) {
          translate(screw_coord) {
            cylinder(d1=screw_d/2, d2=screw_d, h=screw_h, center=true);
          }
        }
      }
    }

    intersection() {
      resize([coil_w+shell_t*2, plate_h+shell_t*2, coil_h+shell_t]) {
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
}

if (for_projection) {
  projection(cut=true) pickup_cover();
} else {
  pickup_cover();
}
