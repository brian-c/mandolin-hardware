$fn = 64;

use <bridge.scad>;
use <tailpiece.scad>;
use <tuner_button.scad>;

module support(
  start=[0, 0],
  end=[0, 0],
  d = 1+2/3,
) {
  translate([0, 0, d/2]) {
    hull() {
      translate(start) sphere(d=d);
      translate(end) sphere(d=d);
    }
  }
}

bridge();

for (i=[-1:1]) {
  support(start=[32*i, -6], end=[32*i, -10]);
}

translate([0, -14, 2+3.3+2]) {
  rotate([0, 180, 0]) {
    tailpiece();
  }
}

translate([0, 18, 0]) {
  for (x=[-7/2:7/2]) {
    flip = -1; // For CW/CCW, depending on the side: x < 0 ? -1 : 1;

    translate([x*11, 0, 0]) {
      support(start=[2*flip, -2], end=[2*flip, -12]);

      scale([1, flip, 1]) {
        rotate(90) {
          tuner_button();
        }
      }
    }
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
