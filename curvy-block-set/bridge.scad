$fn = 40;

use <curvy_block.scad>;

for_projection = false;

shinkage_correction = 1.05;
slip_allowance = 0.25*shinkage_correction;

module bridge(
  saddle_w = 44/3*4*shinkage_correction,
  saddle_t = 6.35*shinkage_correction+slip_allowance, // 1/4"
  post_h = 8.88,
  post_d = 5.88*shinkage_correction+slip_allowance,
  post_rim_h = 1.66+slip_allowance,
  post_rim_d = 10*shinkage_correction+slip_allowance,
  stud_rim_d = 13.56*shinkage_correction+slip_allowance,
  for_projection = for_projection,
) {
  total_h = post_h+post_rim_h;
  bottom_t = post_rim_h;

  translate([0, 0, for_projection ? 0 : total_h/2]) {
    difference() {
      union() {
        // Side pieces
        for (i=[-1, 1]) {
          translate([(saddle_w+stud_rim_d*1.25)/2/i, 0]) {
            rotate([0, 0, 90*i]) {
              curvy_block(size=[stud_rim_d, stud_rim_d*1.25, total_h], r1=stud_rim_d/2, r2=stud_rim_d/2, r3=total_h/2, r4=total_h/2);
            }
          }
        }

        difference() {
          // Bar
          cube(size=[saddle_w+stud_rim_d, stud_rim_d, total_h], center=true);

          // Saddle slot
          translate([0, 0, bottom_t]) {
            cube(size=[saddle_w+stud_rim_d, saddle_t, total_h], center=true);
          }

          // Scoop
          if (!for_projection) {
            translate([0, 0, total_h/2]) {
              resize([saddle_w+stud_rim_d, stud_rim_d+0.02, total_h*2-bottom_t*4]) {
                rotate([90]) {
                  cylinder(d=1, h=1, center=true);
                }
              }
            }
          }
        }
      }

      // Post holes
      for (i=[-1, 1]) {
        translate([(saddle_w+stud_rim_d)/2/i, 0]) {
          cylinder(d=post_d, h=total_h+0.02, center=true);

          translate([0, 0, (total_h-post_rim_h)/-2]) {
            cylinder(d=post_rim_d, h=post_rim_h+0.01, center=true);
          }
        }
      }
    }
  }
}

if (for_projection) {
  projection(cut=true) bridge();
} else {
  bridge();
}
