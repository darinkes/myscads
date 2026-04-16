// --- Death Korps Spearhead (Updated to Official 40k Sizes) ---

// --- Base Settings ---
// Official Small Oval: 60mm Length, 35mm Width
rider_w = 35.0; 
rider_l = 60.0;

wall_thickness = 2.0; 
floor_thickness = 2;
wall_height = 4.0;
tolerance = 2.0;

// Magnet (5x1mm)
mag_d = 5.4;
mag_h = 1.2;

// Tight Spacing Constants
gap = 2;       // Increased slightly for printing reliability
row_gap = -6;

// Calculations (Internal Pocket Dimensions)
r_iw = rider_w + tolerance;
r_il = rider_l + tolerance;

module oval(w, l) {
    scale([1, l/w, 1]) 
        circle(d=w, $fn=100);
}

// Positions
// Back 3 Riders
p1 = [-(r_iw + gap), 0];           
p2 = [0, 0];                        
p3 = [(r_iw + gap), 0];
// Front 2 Riders
p4 = [-(r_iw + gap)/2, -(r_il + row_gap)];        
p5 = [(r_iw + gap)/2, -(r_il + row_gap)];         

module formation_slots() {
    translate(p1) oval(r_iw, r_il);
    translate(p2) oval(r_iw, r_il);
    translate(p3) oval(r_iw, r_il);
    translate(p4) oval(r_iw, r_il);
    translate(p5) oval(r_iw, r_il);
}

difference() {
    // 1. THE BODY (Internal Holes Filled)
    linear_extrude(height = floor_thickness + wall_height) {
        // "Out-then-In" offset trick fills small internal gaps
        offset(r = -10) 
            offset(r = 10) 
                offset(r = wall_thickness) 
                    formation_slots();
    }

    // 2. THE POCKETS
    translate([0, 0, floor_thickness]) {
        linear_extrude(height = wall_height + 0.1) {
            formation_slots();
        }
    }

    // 3. THE MAGNET PANS
    translate([0, 0, floor_thickness - mag_h]) {
        translate(p1) cylinder(d=mag_d, h=mag_h + 0.1, $fn=40);
        translate(p2) cylinder(d=mag_d, h=mag_h + 0.1, $fn=40);
        translate(p3) cylinder(d=mag_d, h=mag_h + 0.1, $fn=40);
        translate(p4) cylinder(d=mag_d, h=mag_h + 0.1, $fn=40);
        translate(p5) cylinder(d=mag_d, h=mag_h + 0.1, $fn=40);
    }
}