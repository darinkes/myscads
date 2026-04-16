// --- Death Korps Spearhead (Updated to Official 40k Sizes) ---

// --- Base Settings ---
// Official Small Oval: 60mm Length, 35mm Width
rider_w = 35.0; 
rider_l = 60.0;
marshal_w = 42.0; 
marshal_l = 75.0;

wall_thickness = 2.0; 
floor_thickness = 2;
wall_height = 4.0;
tolerance = 2.0;
model_smoothness = 120; 

// Magnet (5x1mm)
mag_d = 5.4;
mag_h = 1.2;

// Tight Spacing Constants
gap = 2;       // Increased slightly for printing reliability
row_gap = -6;

// Calculations (Internal Pocket Dimensions)
r_iw = rider_w + tolerance;
r_il = rider_l + tolerance;
m_iw = marshal_w + tolerance;
m_il = marshal_l + tolerance;

module oval(w, l) {
    scale([1, l/w, 1]) 
        circle(d=w, $fn=100);
}

module marshal_oval(w, l, offset_val = 0) {
    offset(r = offset_val) {
        hull() {
            translate([0, (l-w)*0.12]) scale([w/l, 0.88]) circle(d = l, $fn=model_smoothness);
            translate([0, -(l-w)*0.12]) scale([w/l, 0.88]) circle(d = l, $fn=model_smoothness);
        }
    }
}

module marshal_hole(w, l) {
    hull() {
        translate([0,0,-0.1])
            linear_extrude(height = 0.1) 
                marshal_oval(w, l, tolerance);       
        translate([0,0,wall_height])
            linear_extrude(height = 0.1) 
                marshal_oval(w, l, tolerance + 0.8);
    }
}

// Positions
// Back 3 Riders
p1 = [-(r_iw + gap), 0];           
p2 = [0, 0];                        
p3 = [(r_iw + gap), 0];
// Front 2 Riders
p4 = [-(r_iw + gap)/2, -(r_il + row_gap)];        
p5 = [(r_iw + gap)/2, -(r_il + row_gap)];
// Marshal
p6 = [(r_iw + gap)*2 + (gap*3), 0]; 

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
                    union() {
                        formation_slots();
                        translate(p6) marshal_oval(m_iw, m_il, tolerance);
                    }
    }

    // 2. THE POCKETS
    translate([0, 0, floor_thickness]) {
        linear_extrude(height = wall_height + 0.1) {
            formation_slots();
        }
        translate(p6) marshal_hole(marshal_w, marshal_l);
    }

    // 3. THE MAGNET PANS
    translate([0, 0, floor_thickness - mag_h]) {
        translate(p1) cylinder(d=mag_d, h=mag_h + 0.1, $fn=model_smoothness);
        translate(p2) cylinder(d=mag_d, h=mag_h + 0.1, $fn=model_smoothness);
        translate(p3) cylinder(d=mag_d, h=mag_h + 0.1, $fn=model_smoothness);
        translate(p4) cylinder(d=mag_d, h=mag_h + 0.1, $fn=model_smoothness);
        translate(p5) cylinder(d=mag_d, h=mag_h + 0.1, $fn=model_smoothness);
        translate(p6) cylinder(d=mag_d, h=mag_h + 0.1, $fn=model_smoothness);
    }
}