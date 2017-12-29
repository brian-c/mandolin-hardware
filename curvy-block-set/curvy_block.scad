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
