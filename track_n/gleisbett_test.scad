// --- Globale Standardwerte für den Querschnitt & Auflösung ---
default_w_top      = 20.0;  // Breite Oberkante Gleisbett (mm)
default_w_bottom   = 20.0;  // Breite Unterkante Gleisbett (mm)
default_bed_height = 100.0; // Dicke des Gleisbett-Körpers (mm)
default_steps      = 6;     // Segmente entlang des Gleises
default_extra      = 0.0;   // Überlappung (° bei Bögen, mm bei Geraden)

// --- Kubische Bézier-Höhenfunktion ---
function bezier1D(p0, p1, p2, p3, t) =
    pow(1 - t, 3) * p0 +
    3 * pow(1 - t, 2) * t * p1 +
    3 * (1 - t) * pow(t, 2) * p2 +
    pow(t, 3) * p3;

function z_profile(t, L, z0, z1, m0, m1) =
    bezier1D(
        z0,
        z0 + (m0 * L) / 3.0,
        z1 - (m1 * L) / 3.0,
        z1,
        t
    );

function arc_pt(r, ang, z) = [r * cos(ang), r * sin(ang), z];

// --- Basis-Modul: Gebogenes Gleisbett (Bezug: Oberseite) ---
module gleisbett_bogen(
    radius,
    startwinkel,
    starthoehe,
    startsteigung,
    endwinkel,
    endhoehe,
    endsteigung,
    w_top      = default_w_top,
    w_bottom   = default_w_bottom,
    bed_height = default_bed_height,
    steps      = default_steps
) {
    d_ang   = endwinkel - startwinkel;
    arc_len = radius * abs(d_ang) * PI / 180.0;

    rib = w_bottom / 2;
    rit = w_top / 2;
    rob = w_bottom / 2;
    rot = w_top / 2;

    points = [
        for (i = [0 : steps])
            let(
                t   = i / steps,
                ang = startwinkel + t * d_ang,
                zt  = z_profile(t, arc_len, starthoehe, endhoehe, startsteigung, endsteigung),
                zb  = zt - bed_height
            )
            each [
                arc_pt(radius - rib, ang, zb),
                arc_pt(radius + rob, ang, zb),
                arc_pt(radius + rot, ang, zt),
                arc_pt(radius - rit, ang, zt)
            ]
    ];

    cw = d_ang < 0;

    side_faces = [
        for (i = [0 : steps - 1])
            let(a = i * 4, b = (i + 1) * 4)
            each [
                cw ? [a + 0, a + 1, b + 1, b + 0] : [a + 0, b + 0, b + 1, a + 1],
                cw ? [a + 1, a + 2, b + 2, b + 1] : [a + 1, b + 1, b + 2, a + 2],
                cw ? [a + 2, a + 3, b + 3, b + 2] : [a + 2, b + 2, b + 3, a + 3],
                cw ? [a + 3, a + 0, b + 0, b + 3] : [a + 3, b + 3, b + 0, a + 0]
            ]
    ];

    last = steps * 4;
    start_cap = cw ? [0, 1, 2, 3] : [0, 3, 2, 1];
    end_cap   = cw ? [last + 1, last + 0, last + 3, last + 2] : [last + 1, last + 2, last + 3, last + 0];

    faces = concat(side_faces, [start_cap, end_cap]);

    polyhedron(points = points, faces = faces, convexity = 10);
}

// --- Basis-Modul: Gerades Gleisbett mit absoluten Steigungswerten ---
module gleisbett_gerade(
    laenge,
    starthoehe,
    startsteigung,
    endhoehe,
    endsteigung,
    extra      = default_extra,
    w_top      = default_w_top,
    w_bottom   = default_w_bottom,
    bed_height = default_bed_height,
    steps      = default_steps
) {
    R_GERADE  = 1e7;
    ang_start = (-extra / R_GERADE) * (180.0 / PI);
    ang_end   = ((laenge + extra) / R_GERADE) * (180.0 / PI);

    total_len = (laenge + 2 * extra > 0) ? (laenge + 2 * extra) : 1.0;
    scale_m   = (laenge > 0) ? (total_len / laenge) : 1.0;

    translate([-R_GERADE, 0, 0])
        gleisbett_bogen(
            radius        = R_GERADE,
            startwinkel   = ang_start,
            starthoehe    = starthoehe - startsteigung * extra,
            startsteigung = startsteigung * scale_m,
            endwinkel     = ang_end,
            endhoehe      = endhoehe + endsteigung * extra,
            endsteigung   = endsteigung * scale_m,
            w_top         = w_top,
            w_bottom      = w_bottom,
            bed_height    = bed_height,
            steps         = steps
        );
}

// --- Modul n_gerade(): boolesche Steigungs-Flags & Überlänge extra ---
module n_gerade(
    laenge,
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    avg_slope = (laenge != 0) ? ((endhoehe - starthoehe) / laenge) : 0.0;

    gleisbett_gerade(
        laenge        = laenge,
        starthoehe    = starthoehe,
        startsteigung = startsteigung ? avg_slope : 0.0,
        endhoehe      = endhoehe,
        endsteigung   = endsteigung   ? avg_slope : 0.0,
        extra         = extra,
        w_top         = w_top,
        w_bottom      = w_bottom,
        bed_height    = bed_height,
        steps         = steps
    );
}

// --- Spur-N-Geraden (Minitrix) ---

module n_14903(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_gerade(
        laenge = 17.2, starthoehe = starthoehe, startsteigung = startsteigung,
        endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
        w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

module n_14904(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_gerade(
        laenge = 104.2, starthoehe = starthoehe, startsteigung = startsteigung,
        endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
        w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

module n_14905(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_gerade(
        laenge = 76.3, starthoehe = starthoehe, startsteigung = startsteigung,
        endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
        w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

module n_14906(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_gerade(
        laenge = 54.2, starthoehe = starthoehe, startsteigung = startsteigung,
        endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
        w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

// --- Modul n_bogen(): Startwinkel = 0, boolesche Steigungs-Flags & extra-Overlap ---
module n_bogen(
    radius,
    winkel,
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    sgn       = (winkel >= 0) ? 1 : -1;
    ang_start = -sgn * extra;
    ang_end   = winkel + sgn * extra;
    total_ang = ang_end - ang_start;

    arc_len   = radius * abs(winkel) * PI / 180.0;
    avg_slope = (arc_len > 0) ? ((endhoehe - starthoehe) / arc_len) : 0.0;
    m0        = startsteigung ? avg_slope : 0.0;
    m1        = endsteigung   ? avg_slope : 0.0;

    rib = w_bottom / 2;
    rit = w_top / 2;
    rob = w_bottom / 2;
    rot = w_top / 2;

    points = [
        for (i = [0 : steps])
            let(
                v   = i / steps,
                ang = ang_start + v * total_ang,
                u   = (winkel != 0) ? (ang / winkel) : v,
                zt  = z_profile(u, arc_len, starthoehe, endhoehe, m0, m1),
                zb  = zt - bed_height
            )
            each [
                arc_pt(radius - rib, ang, zb),
                arc_pt(radius + rob, ang, zb),
                arc_pt(radius + rot, ang, zt),
                arc_pt(radius - rit, ang, zt)
            ]
    ];

    cw = total_ang < 0;

    side_faces = [
        for (i = [0 : steps - 1])
            let(a = i * 4, b = (i + 1) * 4)
            each [
                cw ? [a + 0, a + 1, b + 1, b + 0] : [a + 0, b + 0, b + 1, a + 1],
                cw ? [a + 1, a + 2, b + 2, b + 1] : [a + 1, b + 1, b + 2, a + 2],
                cw ? [a + 2, a + 3, b + 3, b + 2] : [a + 2, b + 2, b + 3, a + 3],
                cw ? [a + 3, a + 0, b + 0, b + 3] : [a + 3, b + 3, b + 0, a + 0]
            ]
    ];

    last = steps * 4;
    start_cap = cw ? [0, 1, 2, 3] : [0, 3, 2, 1];
    end_cap   = cw ? [last + 1, last + 0, last + 3, last + 2] : [last + 1, last + 2, last + 3, last + 0];

    faces = concat(side_faces, [start_cap, end_cap]);

    polyhedron(points = points, faces = faces, convexity = 10);
}

// --- Spur-N-Bögen (Minitrix) ---

// Minitrix 14914: R1 = 194.6 mm, 24° (neu ergänzt)
module n_14914_r1_24(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_bogen(
        radius = 194.6, winkel = 24.0, starthoehe = starthoehe,
        startsteigung = startsteigung, endhoehe = endhoehe, endsteigung = endsteigung,
        extra = extra, w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

// Minitrix 14912: R1 = 194.6 mm, 30°
module n_14912_r1_30(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_bogen(
        radius = 194.6, winkel = 30.0, starthoehe = starthoehe,
        startsteigung = startsteigung, endhoehe = endhoehe, endsteigung = endsteigung,
        extra = extra, w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

// Minitrix 14924: R2 = 228.2 mm, 24° (neu ergänzt)
module n_14924_r2_24(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_bogen(
        radius = 228.2, winkel = 24.0, starthoehe = starthoehe,
        startsteigung = startsteigung, endhoehe = endhoehe, endsteigung = endsteigung,
        extra = extra, w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

// Minitrix 14922: R2 = 228.2 mm, 30°
module n_14922_r2_30(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_bogen(
        radius = 228.2, winkel = 30.0, starthoehe = starthoehe,
        startsteigung = startsteigung, endhoehe = endhoehe, endsteigung = endsteigung,
        extra = extra, w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

// Minitrix 14926: R2 = 228.2 mm, 6°
module n_14926_r2_6(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    n_bogen(
        radius = 228.2, winkel = 6.0, starthoehe = starthoehe,
        startsteigung = startsteigung, endhoehe = endhoehe, endsteigung = endsteigung,
        extra = extra, w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

// =========================================================================
// --- Weichen als union() bestehender Module ---
// =========================================================================

// Minitrix 14961: Links-Weiche R1 24° (Gerade 104.2 mm + Bogen R1 24°)
module n_14961(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    R1 = 194.6;
    union() {
        n_14904(
            starthoehe = starthoehe, startsteigung = startsteigung,
            endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
            w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
        );
        translate([-R1, 0, 0])
            n_14914_r1_24(
                starthoehe = starthoehe, startsteigung = startsteigung,
                endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
                w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
            );
    }
}

// Minitrix 14963: Rechts-Weiche R1 24° (gespiegelt über X-Achse)
module n_14963(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    union() {
        mirror([1, 0, 0])
            n_14961(
                starthoehe = starthoehe, startsteigung = startsteigung,
                endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
                w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
            );
    }
}

// Minitrix 14966: Bogenweiche links R1/R2 42°
module n_14966(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    R1 = 194.6;
    R2 = 228.2;
    union() {
        // Innenbogen R1 über 42°
        translate([-R1, 0, 0])
            n_bogen(
                radius = R1, winkel = 42.0,
                starthoehe = starthoehe, startsteigung = startsteigung,
                endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
                w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
            );
        // Außenbogen R2 über 42°
        translate([-R2, 0, 0])
            n_bogen(
                radius = R2, winkel = 42.0,
                starthoehe = starthoehe, startsteigung = startsteigung,
                endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
                w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
            );
    }
}

// Minitrix 14967: Bogenweiche rechts R1/R2 42° (gespiegelt über X-Achse)
module n_14967(
    starthoehe    = 0.0,
    startsteigung = true,
    endhoehe      = 0.0,
    endsteigung   = true,
    extra         = default_extra,
    w_top         = default_w_top,
    w_bottom      = default_w_bottom,
    bed_height    = default_bed_height,
    steps         = default_steps
) {
    union() {
        mirror([1, 0, 0])
            n_14966(
                starthoehe = starthoehe, startsteigung = startsteigung,
                endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
                w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
            );
    }
}

// --- Beispielaufruf ---
// =========================================================================
// --- XTrackCAD-Anlage -> OpenSCAD (nur bestehende n_* Module) ---
// =========================================================================
IN2MM = 25.4;

function rot2D(v, deg) = [
    v[0] * cos(deg) - v[1] * sin(deg),
    v[0] * sin(deg) + v[1] * cos(deg)
];

// Setzt n_gerade so, dass der Startpunkt bei (px, py) liegt und in Richtung dir_deg zeigt
module place_gerade(px_in, py_in, dir_deg, extra = default_extra) {
    px = px_in * IN2MM;
    py = py_in * IN2MM;
    translate([px, py, 0])
        rotate([0, 0, dir_deg - 90.0])
            children();
}

// Setzt n_bogen (mit gegebenem radius) so, dass der Bogenstart (ang=0) bei (px, py) liegt
// und die Start-Tangente in Richtung dir_deg zeigt
module place_bogen_start(px_in, py_in, dir_deg, radius, extra = default_extra) {
    px = px_in * IN2MM;
    py = py_in * IN2MM;
    rz = dir_deg - 90.0;
    p0 = rot2D([radius, 0], rz);
    translate([px - p0[0], py - p0[1], 0])
        rotate([0, 0, rz])
            children();
}

// --- Testgruppe: Gleise 28 bis 33 aus dem XTrackCAD-Plan ---
module test_gleise_28_33(extra = 0.0) {
    R1 = 194.6;
    union() {
        // 28: Straight 17.2mm (14903) von (10.478741, 2.204466) in Richtung 0° (+X) bis (11.155906, 2.204466)
        place_gerade(10.478741, 2.204466, 0.0, extra)
            n_14903(extra = extra);

        // 29: Straight 104.2mm (14904) von (11.155906, 2.204466) in Richtung 0° (+X) bis (15.258268, 2.204466)
        place_gerade(11.155906, 2.204466, 0.0, extra)
            n_14904(extra = extra);

        // 30: R1 30d (14912) ab (15.258268, 2.204466) mit Start-Tangente 0° (+X) -> Ende bei 30°
        place_bogen_start(15.258268, 2.204466, 0.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 31: R1 30d (14912) ab (19.088977, 3.230901) mit Start-Tangente 30° -> Ende bei 60°
        place_bogen_start(19.088977, 3.230901, 30.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 32: R1 30d (14912) ab (21.893251, 6.035174) mit Start-Tangente 60° -> Ende bei 90° (+Y)
        place_bogen_start(21.893251, 6.035174, 60.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 33: Straight 104.2mm (14904) ab (22.919687, 9.865883) in Richtung 90° (+Y) bis (22.919687, 13.968245)
        place_gerade(22.919687, 9.865883, 90.0, extra)
            n_14904(extra = extra);
    }
}

// Erweiterung ausgehend von der funktionierenden Gruppe 28..33
// Wir hängen die anschließende Kette 34..42 an (startet am Ende von Gleis 33 bei 22.919687, 13.968245)

module test_gleise_28_42(extra = 0.0) {
    R1 = 194.6;
    union() {
        // --- Bestehende Gruppe 28..33 (passt bereits) ---
        place_gerade(10.478741, 2.204466, 0.0, extra)
            n_14903(extra = extra);

        place_gerade(11.155906, 2.204466, 0.0, extra)
            n_14904(extra = extra);

        place_bogen_start(15.258268, 2.204466, 0.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(19.088977, 3.230901, 30.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(21.893251, 6.035174, 60.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_gerade(22.919687, 9.865883, 90.0, extra)
            n_14904(extra = extra);

        // --- Nächster Schritt: Kette 34..42 ---
        // 34: Lefthand Switch R1 24d (14961) startet an (22.919687, 13.968245) in Richtung 90° (+Y)
        place_gerade(22.919687, 13.968245, 90.0, extra)
            n_14961(extra = extra);

        // 35: R1 30d (14912) ab (22.919687, 18.070607) mit Start-Tangente 90° (+Y) -> Ende bei 120°
        place_bogen_start(22.919687, 18.070607, 90.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 36: R1 30d (14912) ab (21.893252, 21.901316) mit Start-Tangente 120° -> Ende bei 150°
        place_bogen_start(21.893252, 21.901316, 120.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 37: R1 30d (14912) ab (19.088978, 24.705590) mit Start-Tangente 150° -> Ende bei 180° (-X)
        place_bogen_start(19.088978, 24.705590, 150.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 38: Straight 104.2mm (14904) ab (15.258269, 25.732025) in Richtung 180° (-X) bis (11.155907, 25.732025)
        place_gerade(15.258269, 25.732025, 180.0, extra)
            n_14904(extra = extra);

        // 39: Straight 17.2mm (14903) ab (11.155907, 25.732025) in Richtung 180° (-X) bis (10.478742, 25.732025)
        place_gerade(11.155907, 25.732025, 180.0, extra)
            n_14903(extra = extra);

        // 40: R1 30d (14912) ab (10.478742, 25.732025) mit Start-Tangente 180° (-X) -> Ende bei 210°
        place_bogen_start(10.478742, 25.732025, 180.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 41: R1 30d (14912) ab (6.648033, 24.705590) mit Start-Tangente 210° -> Ende bei 240°
        place_bogen_start(6.648033, 24.705590, 210.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 42: R1 30d (14912) ab (3.843760, 21.901317) mit Start-Tangente 240° -> Ende bei 270° (-Y)
        place_bogen_start(3.843760, 21.901317, 240.0, R1, extra)
            n_14912_r1_30(extra = extra);
    }
}

module test_gleise_28_42_und_unten_links(extra = 0.0) {
    R1 = 194.6;
    union() {
        // --- Bestehende Gruppe 28..42 ---
        place_gerade(10.478741, 2.204466, 0.0, extra)
            n_14903(extra = extra);

        place_gerade(11.155906, 2.204466, 0.0, extra)
            n_14904(extra = extra);

        place_bogen_start(15.258268, 2.204466, 0.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(19.088977, 3.230901, 30.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(21.893251, 6.035174, 60.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_gerade(22.919687, 9.865883, 90.0, extra)
            n_14904(extra = extra);

        place_gerade(22.919687, 13.968245, 90.0, extra)
            n_14961(extra = extra);

        place_bogen_start(22.919687, 18.070607, 90.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(21.893252, 21.901316, 120.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(19.088978, 24.705590, 150.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_gerade(15.258269, 25.732025, 180.0, extra)
            n_14904(extra = extra);

        place_gerade(11.155907, 25.732025, 180.0, extra)
            n_14903(extra = extra);

        place_bogen_start(10.478742, 25.732025, 180.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(6.648033, 24.705590, 210.0, R1, extra)
            n_14912_r1_30(extra = extra);

        place_bogen_start(3.843760, 21.901317, 240.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // --- Linke untere Ecke: 1, 24, 25, 26, 27 ---
        // 1: Righthand Switch R1 24d (14963) – exakter Startpunkt unten bei y = 13.968246 in Richtung 90° (+Y)
        place_gerade(2.817324, 13.968246, 90.0, extra)
            n_14963(extra = extra);

        // 24: Straight 104.2mm (14904) ab (2.817324, 13.968246) in Richtung 270° (-Y)
        place_gerade(2.817324, 13.968246, 270.0, extra)
            n_14904(extra = extra);

        // 25: R1 30d (14912) ab (2.817324, 9.865884) mit Start-Tangente 270° (-Y) -> Ende bei 300°
        place_bogen_start(2.817324, 9.865884, 270.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 26: R1 30d (14912) ab (3.843759, 6.035175) mit Start-Tangente 300° -> Ende bei 330°
        place_bogen_start(3.843759, 6.035175, 300.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 27: R1 30d (14912) ab (6.648032, 3.230901) mit Start-Tangente 330° -> Ende bei 0° (+X)
        place_bogen_start(6.648032, 3.230901, 330.0, R1, extra)
            n_14912_r1_30(extra = extra);
    }
}

module test_abzweig_only(extra = 0.0) {
    R1 = 194.6;
    R2 = 228.2;

    union() {
        // Weiche 1 als Referenz
        //place_gerade(2.817324, 13.968246, 90.0, extra)
        //    n_14963(extra = extra);

        // 2: R2 6d (14926)
        place_bogen_start(3.575750 + 0.33, 17.230352 + 0.69, 240.0, R2, extra)
            n_14926_r2_6(extra = extra);

        // 3: R1 30d (14912)
        place_bogen_start(4.002682 + 2.705, 18.068253 + 2.65, 210.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 4: R1 30d (14912)
        place_bogen_start(6.806956 + 3.73, 20.872527 + 0.87, 180.0, R1, extra)
            n_14912_r1_30(extra = extra);

        // 5: Straight 54.2mm (14906) in Richtung 0.0° (+X)
        place_gerade(10.637664 - 0.10, 21.898962 - 0.181, 0.0, extra)
            n_14906(extra = extra);
    }
}

// Bögen 6, 7, 8 (R2 30d, 14922) – direkt über dir_deg in place_bogen_start gesteuert
module test_abzweig_bis_8(extra = 0.0) {
    R2 = 228.2;

    union() {
        // 6: R2 30d (14922) – Start-Tangente direkt in place_bogen_start setzen (z. B. 90.0 statt 270.0)
        place_bogen_start(12.771522, 21.898962, 90.0, R2, extra)
            n_14922_r2_30(extra = extra);

        // 7: R2 30d (14922) – Start-Tangente direkt in place_bogen_start setzen
        place_bogen_start(17.263649, 20.695301, 120.0, R2, extra)
            n_14922_r2_30(extra = extra);

        // 8: R2 30d (14922) – Start-Tangente direkt in place_bogen_start setzen
        place_bogen_start(20.552113, 17.406837, 150.0, R2, extra)
            n_14922_r2_30(extra = extra);
    }
}

test_abzweig_bis_8(extra = 0.0);

test_abzweig_bis_8(extra = 0.0);
test_abzweig_only(extra = 0.0);
test_gleise_28_42_und_unten_links(extra = 0.0);
test_gleise_28_42(extra = 0.0);
test_gleise_28_33(extra = 0.0);
