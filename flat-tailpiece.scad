$fn = 128;

width = 72;
height = 18;
walls = 2;
legs = 4;
strings = 8;
pin_height = 2.5;
pin_d = 3;
screw_head_height = 4;
screw_hole_d = 5;

module tube(od, id, h, center) {
  offset = center ? 0 : -0.005;

  difference() {
    cylinder(d=od, h=h, center=center);
    translate([0, 0, offset]) cylinder(d=id, h=h+0.01, center=center);
  }
}

module plate() {
  translate([0, 0, walls/4]) cube([width-height, height, walls/2], center=true);
  translate([0, walls/4, walls/-4+0.01]) cube([width-height, height-walls/2, walls/2+0.02], center=true);
  translate([0, height/-2+walls/2, 0]) rotate([0, 90, 0]) cylinder(d=walls, h=width-height, center=true);
}

module leg() {
  difference() {
    translate([0, 0, -1*legs]) difference() {
      cylinder(d=height, h=walls+legs);
      translate([0, 0, -0.01]) cylinder(d=height-walls*2, h=legs);
    }
    translate([-height/2, 0, legs/-1]) resize([height-walls, height, legs*2]) rotate([90, 0, 0]) cylinder(d=10, h=10, center=true);
  }
  translate([0, 0, -1*legs]) cylinder(d=screw_hole_d+walls*2, h=legs+0.01);
  translate([0, 0, legs/-2]) cube([walls, height, legs+0.01], center=true);
}

module pin() {
  hull() {
    cylinder(d=pin_d*0.95, h=0.01);
    translate([0, pin_d/10, (-1*pin_height)]) cylinder(d=pin_d, h=0.01);
    translate([0, height/-4, 0]) cube([0.01, 0.01, 0.01], center=true);
  }
}

module screw_hole() {
  translate([0, 0, -1*legs-0.01]) cylinder(d=screw_hole_d, h=walls+legs+0.02);
}

module tailpiece() {
  difference() {
    union() {
      translate([0, 0, walls/2]) plate();
      translate([(width-height)/2, 0, 0]) leg();
      translate([(width-height)/-2, 0, 0]) rotate([0, 0, 180]) leg();

      translate([0, 0, 0.01]) for (i=[(strings-1)/-2:(strings-1)/2]) {
        index = ((strings-1)-(i*-2))/2;
        position = (width-height*2)/strings;
        pin_x = i*position;
        is_even = index%2 == 0;
        pin_y = height/2-pin_d*(is_even ? 1 : 2);

        translate([pin_x, pin_y, 0]) pin();
      }
    }

    translate([(width-height)/2, 0, 0]) screw_hole();
    translate([(width-height)/-2, 0, 0]) screw_hole();
    /*translate([0, 0, -1*legs-0.01]) cube([width/2+0.02, height/2+0.02, walls+legs+0.02]);*/
  }
}

rotate([180, 0, 0]) scale(1.00) tailpiece();
