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
n_14961();