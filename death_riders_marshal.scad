// Death Korps Spearhead (with Marshal) — Updated to Official 40k Sizes

/* [Bases] */
// Official Small Oval: 60mm Length, 35mm Width
rider_w = 35.0;
rider_l = 60.0;
marshal_w = 42.0;
marshal_l = 75.0;
tolerance = 2.0;

/* [Walls] */
wall_thickness = 2.0;
floor_thickness = 2;
wall_height = 4.0;
model_smoothness = 120;

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
m_iw = marshal_w + tolerance;
m_il = marshal_l + tolerance;

module oval(w, l) {
    scale([1, l/w, 1]) circle(d = w, $fn = 100);
}

module marshal_oval(w, l, offset_val = 0) {
    offset(r = offset_val) {
        hull() {
            translate([0,  (l-w)*0.12]) scale([w/l, 0.88]) circle(d = l, $fn = model_smoothness);
            translate([0, -(l-w)*0.12]) scale([w/l, 0.88]) circle(d = l, $fn = model_smoothness);
        }
    }
}

module marshal_hole(w, l) {
    hull() {
        translate([0, 0, -0.1])
            linear_extrude(height = 0.1) marshal_oval(w, l, tolerance);
        translate([0, 0, wall_height])
            linear_extrude(height = 0.1) marshal_oval(w, l, tolerance + 0.8);
    }
}

// Riders: back row of 3, front row of 2
p1 = [-(r_iw + gap), 0];
p2 = [0, 0];
p3 = [(r_iw + gap), 0];
p4 = [-(r_iw + gap)/2, -(r_il + row_gap)];
p5 = [(r_iw + gap)/2,  -(r_il + row_gap)];
// Marshal off to the right
p6 = [(r_iw + gap)*2 + (gap*3), 0];

rider_positions = [p1, p2, p3, p4, p5];
all_positions   = [p1, p2, p3, p4, p5, p6];

module formation_slots() {
    for (p = rider_positions) translate(p) oval(r_iw, r_il);
}

difference() {
    // Body — closing offset fills internal gaps
    linear_extrude(height = floor_thickness + wall_height) {
        offset(r = -10) offset(r = 10)
        offset(r = wall_thickness)
        union() {
            formation_slots();
            translate(p6) marshal_oval(m_iw, m_il, tolerance);
        }
    }

    // Pockets
    translate([0, 0, floor_thickness]) {
        linear_extrude(height = wall_height + eps) formation_slots();
        translate(p6) marshal_hole(marshal_w, marshal_l);
    }

    // Magnet pans
    translate([0, 0, floor_thickness - mag_h])
    for (p = all_positions)
        translate(p) cylinder(d = mag_d, h = mag_h + eps, $fn = model_smoothness);
}
