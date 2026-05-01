// Death Korps Spearhead (Final GW-Fit Edition)
// 5 Reiter (35x60) + 1 Marshal (75x42) mit konischen Taschen und Magneten

/* [Base Dimensionen] */
// GW Reiter Bases sind oben 35x60, aber unten (am Boden) ca. 36.2x61.2
rider_w = 36.2;
rider_l = 61.2;
// Marshal (75x42) ist unten ca. 43.5x76.5
marshal_w = 43.5;
marshal_l = 76.5;

/* [Druck-Einstellungen] */
wall_thickness = 3.0;
floor_thickness = 2.0;
wall_height = 4.5; // Etwas hoeher fuer besseren Halt
model_smoothness = 120;

// Toleranz: 0.4mm "snug", 0.8mm "loose"
fit_tolerance = 0.6;
// Taper oeffnet das Loch nach oben hin fuer die schraege Base-Wand
base_taper = 0.8;

/* [Magnete] */
mag_d = 5.4;
mag_h = 1.2;

/* [Abstaende] */
col_gap = 2.5;
row_gap = -5;

eps = 0.01;

// --- MODUL: Das GW-optimierte Oval ---
module gw_oval(w, l, offset_val = 0) {
    offset(r = offset_val) {
        hull() {
            translate([0,  (l-w)*0.1]) scale([w/l, 0.8]) circle(d = l, $fn = model_smoothness);
            translate([0, -(l-w)*0.1]) scale([w/l, 0.8]) circle(d = l, $fn = model_smoothness);
        }
    }
}

// --- MODUL: Die konische Tasche ---
module negative_base_tapered(w, l) {
    hull() {
        translate([0, 0, -0.1])
            linear_extrude(height = 0.1) gw_oval(w, l, fit_tolerance);
        translate([0, 0, wall_height])
            linear_extrude(height = 0.1) gw_oval(w, l, fit_tolerance + base_taper);
    }
}

// --- Kalkulation der Positionen ---
r_iw = rider_w + fit_tolerance * 2;
r_il = rider_l + fit_tolerance * 2;
m_iw = marshal_w + fit_tolerance * 2;
m_il = marshal_l + fit_tolerance * 2;

back_y = (r_il/2 + row_gap/2);

p3 = [0,                            back_y];
p4 = [(r_iw + col_gap),             back_y];
p5 = [(r_iw * 2 + col_gap * 2),     back_y];
p6 = [-(r_iw/2 + m_iw/2 + col_gap), back_y - (m_il - r_il)/2];
p1 = [r_iw/2 + col_gap/2,           -(r_il/2 + row_gap/2)];
p2 = [r_iw * 1.5 + col_gap * 1.5,   -(r_il/2 + row_gap/2)];

// Each slot: [position, base_w, base_l]
slots = [
    [p1, rider_w,   rider_l],
    [p2, rider_w,   rider_l],
    [p3, rider_w,   rider_l],
    [p4, rider_w,   rider_l],
    [p5, rider_w,   rider_l],
    [p6, marshal_w, marshal_l],
];

// --- FINALER DRUCK-KOERPER ---
difference() {
    // Verbundene Bodenplatte
    linear_extrude(height = floor_thickness + wall_height) {
        offset(r = -4) offset(r = 4) // Glaettung der Uebergaenge
        offset(r = wall_thickness)
        for (s = slots) translate(s[0]) gw_oval(s[1], s[2], fit_tolerance);
    }

    // Aussparungen fuer die Bases
    translate([0, 0, floor_thickness])
    for (s = slots) translate(s[0]) negative_base_tapered(s[1], s[2]);

    // Magnetloecher
    translate([0, 0, floor_thickness - mag_h])
    for (s = slots) translate(s[0]) cylinder(d = mag_d, h = mag_h + eps, $fn = 60);
}
