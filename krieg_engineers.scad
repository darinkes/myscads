// Astra Militarum: Krieg Combat Engineers (2025) — 5x 25mm engineers + 1x 40mm remote mine
// Staggered pack: back row of 3x 25mm, front row of 2x 25mm nested in the notches,
// with the 40mm mine nestled against the right-hand edge. 5x1mm magnet pockets under every base.

/* [Sizes] */
small_base_dia = 25;
big_base_dia = 40;
tolerance = 0.5;

/* [Walls] */
wall_thickness = 2.5;
floor_thickness = 2;
lip_height = 4;
smooth_radius = 5;

/* [Magnet] */
mag_dia = 5.0 + tolerance;
mag_depth = 1.3;

/* [Quality] */
$fa = 4;
$fs = 0.4;

eps = 0.01;

// --- Calculations ---
small_hole = small_base_dia + tolerance;
big_hole = big_base_dia + tolerance;

spacing = small_hole + wall_thickness;   // 25mm grid pitch
row_off = spacing * sin(60);             // staggered (hex) row offset -> rows nest, no voids

// Five 25mm slots: back row of 3, front row of 2 nested in the notches.
small_pos = [
    [0,             row_off],
    [spacing,       row_off],
    [2 * spacing,   row_off],
    [spacing / 2,   0],
    [spacing * 1.5, 0],
];

// 40mm mine nestled against the two right-edge bases at one wall of clearance,
// so it fuses flush to the formation with no gap.
nb = small_pos[2];   // back-right 25mm
nf = small_pos[4];   // front-right 25mm
mine_reach = small_hole / 2 + big_hole / 2 + wall_thickness;   // centre-to-centre at one wall
half = norm(nb - nf) / 2;
perp = [nb[1] - nf[1], nf[0] - nb[0]] / (2 * half);            // unit perpendicular, pointing right
mine_pos = (nb + nf) / 2 + sqrt(mine_reach * mine_reach - half * half) * perp;

// Each slot: [ [x, y], diameter ]
slots = concat(
    [ for (p = small_pos) [p, small_hole] ],
    [ [mine_pos, big_hole] ]
);

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
    linear_extrude(height = floor_thickness + lip_height) {
        offset(r = -smooth_radius)
        offset(r = smooth_radius)
        for (s = slots) translate(s[0]) slot_footprint(s[1]);
    }

    for (s = slots) translate(s[0]) slot_subtract(s[1]);
}
