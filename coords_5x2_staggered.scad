// 10x 25mm base holder, 5 cols x 2 rows, staggered so rows nest into each other,
// with 5x1mm magnet pockets. Staggered (hex) variant of coords_5x2.scad.

/* [Sizes] */
base_dia = 25;
tolerance = 0.5;

/* [Layout] */
cols = 5;
rows = 2;

/* [Walls] */
wall_thickness = 2.5;
floor_thickness = 2;
lip_height = 4;
smooth_radius = 5;

/* [Magnet] */
mag_dia = 5.0 + tolerance;
mag_depth = 1.0;

/* [Quality] */
$fa = 4;
$fs = 0.4;

eps = 0.01;

// --- Calculations ---
hole_dia = base_dia + tolerance;
spacing = hole_dia + wall_thickness;
row_off = spacing * sin(60);   // staggered (hex) row offset -> rows nest, no voids

// --- Modules ---
module slot_footprint(d) {
    circle(d = d + 2 * wall_thickness);
}

module slot_subtract(d) {
    translate([0, 0, floor_thickness])
    cylinder(d = d, h = lip_height + eps);

    translate([0, 0, floor_thickness - mag_depth])
    cylinder(d = mag_dia, h = mag_depth + eps, $fn = 60);
}

module for_each_slot() {
    // Odd rows shift half a pitch in x and nest into the notches of the row below.
    for (r = [0 : rows - 1], c = [0 : cols - 1])
        translate([c * spacing + (r % 2) * spacing / 2, r * row_off])
        children();
}

// --- Render ---
difference() {
    linear_extrude(height = floor_thickness + lip_height) {
        offset(r = -smooth_radius)
        offset(r = smooth_radius)
        for_each_slot() slot_footprint(hole_dia);
    }

    for_each_slot() slot_subtract(hole_dia);
}
