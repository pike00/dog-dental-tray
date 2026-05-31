// Dog dental station tray
// Holds a Virbac C.E.T. 2.5 oz toothpaste tube in a rounded cradle and props
// four silicone finger toothbrushes mouth-down on tapered drying pegs so they
// dry inside and out. Parametric: measure your tube + brushes and edit below.
//
//   just build       -> export/dog-dental-tray.stl
//   just preview     -> images/preview.png

$fn = 64;  // drop to ~24 while iterating; 64 is for the final export

/* ===== Toothpaste cradle (Virbac C.E.T. 2.5 oz tube, lying on its side) ===== */
tube_len     = 140;  // tube length incl. cap, mm        << MEASURE yours
tube_dia     = 36;   // widest tube diameter, mm         << MEASURE yours
cradle_clear = 3;    // air gap around the tube, mm
floor_thk    = 2;    // solid material below the valley, mm
grip         = -3;   // wall top vs. tube centerline: + = hugs/secure, - = easy lift, mm

/* ===== Finger-toothbrush drying pegs (4-pack silicone caps) ===== */
// Each peg is a set of radial FINS that share a conical envelope coming to a
// point. The fins are wider (across) than the brush opening, so the brush rim
// catches partway up and stays propped above the floor. Crucially the open
// channels between fins mean the brush interior never seals: air flows in and
// water drains straight down and out -> dries inside and out. A solid cone
// would seal a closed pocket at the rim and trap water; fins fix that.
peg_count_x  = 4;    // brushes in a row...
peg_count_y  = 1;    // ...a single row running longways beside the cradle
peg_base_dia = 22;   // fin envelope base dia, mm  (set a few mm > brush inner dia)
peg_tip_dia  = 2;    // blunt tip dia, mm  (lower toward ~1 for a sharper point)
peg_height   = 30;   // peg height, mm
peg_pitch    = 34;   // peg center-to-center spacing, mm
peg_fins     = 4;    // radial blades (even number); gaps between = drain/air channels
fin_thk      = 3;    // blade thickness, mm

/* ===== Tray shell ===== */
wall     = 3;   // cradle / rim wall thickness, mm
base_t   = 3;   // base plate thickness, mm
rim_h    = 6;   // outer catch-rim height above the base, mm
corner_r = 6;   // outer corner radius, mm
gap      = 10;  // open floor between cradle and peg zone, mm
margin   = 5;   // peg-to-edge margin, mm

/* ---- derived geometry (don't edit) ---- */
rc            = tube_dia/2 + cradle_clear;       // valley radius
cradle_wall_h = floor_thk + rc + grip;           // cradle wall height above base top
capsule_z     = base_t + floor_thk + rc;         // valley (capsule) center height
cap_span      = tube_len + 2*cradle_clear - 2*rc;// span between capsule end-spheres

cradle_outer_len = tube_len + 2*cradle_clear + 2*wall;
cradle_outer_w   = tube_dia + 2*cradle_clear + 2*wall;

pgx          = (peg_count_x - 1) * peg_pitch;
pgy          = (peg_count_y - 1) * peg_pitch;
peg_zone_len = pgx + peg_base_dia + 2*margin;
peg_zone_w   = pgy + peg_base_dia + 2*margin;

total_len = max(cradle_outer_len, peg_zone_len);
total_w   = cradle_outer_w + gap + peg_zone_w;

cradle_cy = total_w/2 - cradle_outer_w/2;  // cradle center Y (back)
peg_cy    = -total_w/2 + peg_zone_w/2;     // peg-zone center Y (front)

module rrect(l, w, r) { offset(r=r) square([l - 2*r, w - 2*r], center=true); }
module slab(l, w, h, r) { linear_extrude(height=h) rrect(l, w, r); }

module base_tray() {
    slab(total_len, total_w, base_t, corner_r);            // base plate
    translate([0, 0, base_t - 0.01])                        // outer catch rim
        difference() {
            slab(total_len, total_w, rim_h, corner_r);
            translate([0, 0, -0.5])
                slab(total_len - 2*wall, total_w - 2*wall, rim_h + 1,
                     max(0.5, corner_r - wall));
        }
}

module cradle() {
    difference() {
        translate([0, cradle_cy, 0])
            slab(cradle_outer_len, cradle_outer_w, base_t + cradle_wall_h, corner_r);
        translate([0, cradle_cy, capsule_z])               // valley capsule cut
            hull() {
                translate([-cap_span/2, 0, 0]) sphere(r=rc);
                translate([ cap_span/2, 0, 0]) sphere(r=rc);
            }
    }
}

// Finned drying peg: the conical envelope (point on top) intersected with a set
// of crossing slabs, leaving `peg_fins` blades with open channels between them.
module peg() {
    slabs = max(1, floor(peg_fins / 2));   // each diametric slab = 2 fins
    intersection() {
        cylinder(h=peg_height, d1=peg_base_dia, d2=peg_tip_dia);
        union() {
            for (i = [0 : slabs - 1])
                rotate([0, 0, i * 180 / slabs])
                    translate([-peg_base_dia, -fin_thk/2, -0.1])
                        cube([2 * peg_base_dia, fin_thk, peg_height + 0.2]);
        }
    }
}

module pegs() {
    translate([0, peg_cy, base_t - 0.01])
        for (ix = [0 : peg_count_x - 1], iy = [0 : peg_count_y - 1])
            translate([(ix - (peg_count_x - 1)/2) * peg_pitch,
                       (iy - (peg_count_y - 1)/2) * peg_pitch, 0])
                peg();
}

union() {
    base_tray();
    cradle();
    pegs();
}
