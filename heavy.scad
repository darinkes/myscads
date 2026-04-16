// --- Parameters ---
hws_base_dia = 50;      
coord_base_dia = 25;    
tolerance = 0.5;        
wall_thickness = 2.5;   
floor_thickness = 2;    
lip_height = 4;         

// Magnet Parameters
mag_dia = 5.0 + tolerance;
mag_depth = 1.3;        

// OPTIMIZATION: Smoothing and Bridge Width
// Lowering smooth_radius reduces the "webbing" between slots.
smooth_radius = 5; 
bridge_width = 15; // Width of the connecting paths between slots

$fn = 100; 

// --- Calculations ---
hws_hole = hws_base_dia + tolerance;
coord_hole = coord_base_dia + tolerance;
spacing = hws_hole + wall_thickness;
y_offset = (hws_hole/1.8 + coord_hole/2 + wall_thickness); 

// --- Render ---
difference() {
    // 1. OPTIMIZED BODY (Bone-style structure)
    linear_extrude(height = floor_thickness + lip_height) {
        offset(r = -smooth_radius) 
        offset(r = smooth_radius)  
        union() {
            // The actual slot footprints
            for (c = [0 : 2]) {
                translate([c * spacing, 0]) 
                circle(d = hws_hole + (wall_thickness * 2));
            }
            translate([spacing, y_offset]) 
            circle(d = coord_hole + (wall_thickness * 2));

            // Optimized Bridges (instead of full hulls)
            // Horizontal spine
            translate([0, -bridge_width/2])
            square([spacing * 2, bridge_width]);
            
            // Vertical connector
            translate([spacing - bridge_width/2, 0])
            square([bridge_width, y_offset]);
        }
    }

    // 2. SUBTRACT SLOTS
    for (c = [0 : 2]) {
        // Main Hole
        translate([c * spacing, 0, floor_thickness])
        cylinder(d = hws_hole, h = lip_height + 1);
        
        // Magnet Hole (Floor remains solid around it)
        translate([c * spacing, 0, floor_thickness - mag_depth])
        cylinder(d = mag_dia, h = mag_depth + 0.1, $fn=60);
    }
    
    // Coordinator Hole
    translate([spacing, y_offset, floor_thickness])
    cylinder(d = coord_hole, h = lip_height + 1);
    
    // Coordinator Magnet
    translate([spacing, y_offset, floor_thickness - mag_depth])
    cylinder(d = mag_dia, h = mag_depth + 0.1, $fn=60);
}