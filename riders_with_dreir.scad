// --- Death Korps Spearhead (Final GW-Fit Edition) ---

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
wall_height = 4.5; // Etwas höher für besseren Halt
model_smoothness = 120; 

// Toleranz: 0.4mm ist "snug" (fest), 0.8mm ist "loose" (locker)
fit_tolerance = 0.6; 
// Der Taper öffnet das Loch nach oben hin, damit die schräge Base-Wand reinpasst
base_taper = 0.8;    

/* [Magnete] */
mag_d = 5.4;
mag_h = 1.2;

/* [Abstände] */
col_gap = 2.5;  
row_gap = -5;  

// --- MODUL: Das GW-optimierte Oval ---
// Erzeugt eine Form, die zwischen Stadium und Ellipse mittelt
module gw_oval(w, l, offset_val = 0) {
    offset(r = offset_val) {
        hull() {
            // Ein leichtes "Stretching" im Zentrum macht es passgenauer für GW
            translate([0, (l-w)*0.1]) scale([w/l, 0.8]) circle(d = l, $fn=model_smoothness);
            translate([0, -(l-w)*0.1]) scale([w/l, 0.8]) circle(d = l, $fn=model_smoothness);
        }
    }
}

// --- MODUL: Die konische Tasche ---
module negative_base_tapered(w, l) {
    hull() {
        // Unten (Sitz der Base)
        translate([0,0,-0.1])
            linear_extrude(height = 0.1) 
                gw_oval(w, l, fit_tolerance);
        
        // Oben (Einführhilfe & Platz für die Schräge der Base)
        translate([0,0,wall_height])
            linear_extrude(height = 0.1) 
                gw_oval(w, l, fit_tolerance + base_taper);
    }
}

// --- Kalkulation der Positionen ---
r_iw = rider_w + fit_tolerance * 2;
r_il = rider_l + fit_tolerance * 2;
m_iw = marshal_w + fit_tolerance * 2;
m_il = marshal_l + fit_tolerance * 2;

back_y = (r_il/2 + row_gap/2);

p3 = [0,                           back_y]; 
p4 = [(r_iw + col_gap),            back_y]; 
p5 = [(r_iw * 2 + col_gap * 2),    back_y]; 
p6 = [-(r_iw/2 + m_iw/2 + col_gap), back_y - (m_il - r_il)/2]; 

p1 = [r_iw/2 + col_gap/2,          -(r_il/2 + row_gap/2)]; 
p2 = [r_iw * 1.5 + col_gap * 1.5,  -(r_il/2 + row_gap/2)]; 

all_points = [p1, p2, p3, p4, p5]; // Rider points

// --- FINALER DRUCK-KÖRPER ---
difference() {
    // 1. Die verbundene Bodenplatte
    linear_extrude(height = floor_thickness + wall_height) {
        offset(r = -4) offset(r = 4) // Glättung der Übergänge
        offset(r = wall_thickness) {
            union() {
                for(pos = all_points) translate(pos) gw_oval(rider_w, rider_l, fit_tolerance);
                translate(p6) gw_oval(marshal_w, marshal_l, fit_tolerance);
            }
        }
    }

    // 2. Aussparungen für die Bases
    translate([0, 0, floor_thickness]) {
        for(pos = all_points) translate(pos) negative_base_tapered(rider_w, rider_l);
        translate(p6) negative_base_tapered(marshal_w, marshal_l);
    }

    // 3. Magnetlöcher
    translate([0, 0, floor_thickness - mag_h]) {
        for (pos = [p1,p2,p3,p4,p5,p6])
            translate(pos) cylinder(d=mag_d, h=mag_h + 0.1, $fn=60);
    }
}