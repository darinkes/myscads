// Death Korps Spearhead — 5x oval riders, 3+2 formation (official 40k 35x60mm)

/* [Bases] */
rider_w = 35.0;
rider_l = 60.0;
tolerance = 2.0;

/* [Walls] */
wall_thickness = 2.0;
floor_thickness = 2;
wall_height = 4.0;

/* [Magnet] */
mag_d = 5.4;
mag_h = 1.2;

/* [Spacing] */
gap = 2;
row_gap = -6;

/* [Quality] */
$fa = 4;
$fs = 0.4;

eps = 0.01;

// --- Calculations (Internal Pocket Dimensions) ---
r_iw = rider_w + tolerance;
r_il = rider_l + tolerance;

module oval(w, l) {
    scale([1, l/w, 1]) circle(d = w);
}

// Back row of 3, front row of 2 staggered
positions = [
    [-(r_iw + gap), 0],
    [0, 0],
    [(r_iw + gap), 0],
    [-(r_iw + gap)/2, -(r_il + row_gap)],
    [(r_iw + gap)/2, -(r_il + row_gap)],
];

module formation_slots() {
    for (p = positions) translate(p) oval(r_iw, r_il);
}

difference() {
    // Body — closing offset fills internal gaps and fillets junctions
    linear_extrude(height = floor_thickness + wall_height) {
        offset(r = -10)
        offset(r = 10)
        offset(r = wall_thickness)
        formation_slots();
    }

    // Pockets
    translate([0, 0, floor_thickness])
    linear_extrude(height = wall_height + eps) formation_slots();

    // Magnet pans
    translate([0, 0, floor_thickness - mag_h])
    for (p = positions)
        translate(p) cylinder(d = mag_d, h = mag_h + eps, $fn = 40);
}
