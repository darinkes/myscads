/* [Sizes] */
hws_base_dia = 50;
coord_base_dia = 25;
tolerance = 0.5;

/* [Walls] */
wall_thickness = 2.5;
floor_thickness = 2;
lip_height = 4;
smooth_radius = 5;
bridge_width = 15;

/* [Magnet] */
mag_dia = 5.0 + tolerance;
mag_depth = 1.3;

/* [Quality] */
$fa = 4;
$fs = 0.4;

eps = 0.01;

// --- Calculations ---
hws_hole = hws_base_dia + tolerance;
coord_hole = coord_base_dia + tolerance;
spacing = hws_hole + wall_thickness;

coord_x = spacing / 2;
// Empirical diagonal placement; not a Pythagorean tangent calc
y_offset = (hws_hole/3 + coord_hole/2 + wall_thickness);

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

// --- Render ---
difference() {
    // Closing offset (dilate then erode) fillets concave junctions
    linear_extrude(height = floor_thickness + lip_height) {
        offset(r = -smooth_radius)
        offset(r = smooth_radius)
        union() {
            for (c = [0 : 2])
                translate([c * spacing, 0]) slot_footprint(hws_hole);

            translate([coord_x, y_offset]) slot_footprint(coord_hole);

            // Spine fully spans the leftmost and rightmost big footprints
            translate([-hws_hole/2, -bridge_width/2])
            square([spacing * 2 + hws_hole, bridge_width]);

            translate([coord_x - bridge_width/2, 0])
            square([bridge_width, y_offset]);
        }
    }

    for (c = [0 : 2])
        translate([c * spacing, 0]) slot_subtract(hws_hole);

    translate([coord_x, y_offset]) slot_subtract(coord_hole);
}
