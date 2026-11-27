// --- Globale Standardwerte für den Querschnitt & Auflösung ---
default_w_top      = 20.0;  // Breite Oberkante Gleisbett (mm)
default_w_bottom   = 20.0;  // Breite Unterkante Gleisbett (mm)
default_bed_height = 100.0; // Dicke des Gleisbett-Körpers (mm)
default_steps      = 4;     // Segmente entlang des Gleises
default_extra      = 0.0;   // Überlappung (° bei Bögen, mm bei Geraden)


module door(width = 30, height = 30, depth = 20) {
    union() {
        translate([0,0,height/2])
        cube([width,depth,height], center=true);
        translate([0,0,height])
        rotate([90,0,0])
        cylinder(d=width,h=depth, center=true);
    }
}

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


// --- Basis-Modul: Gerades Gleisbett (direkte Polyhedron-Implementierung) ---
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
    x_start = -extra;
    x_end   = laenge + extra;
    dx_span = x_end - x_start;

    yb = w_bottom / 2;
    yt = w_top / 2;

    points = [
        for (i = [0 : steps])
            let(
                v  = i / steps,
                x  = x_start + v * dx_span,
                u  = (laenge != 0) ? (x / laenge) : v,
                zt = z_profile(u, laenge, starthoehe, endhoehe, startsteigung, endsteigung),
                zb = zt - bed_height
            )
            each [
                [x, -yb, zb], // 0: unten, -Y
                [x,  yb, zb], // 1: unten, +Y
                [x,  yt, zt], // 2: oben,  +Y
                [x, -yt, zt]  // 3: oben,  -Y
            ]
    ];

    side_faces = [
        for (i = [0 : steps - 1])
            let(a = i * 4, b = (i + 1) * 4)
            each [
                [a + 0, b + 0, b + 1, a + 1], // Unterseite
                [a + 1, b + 1, b + 2, a + 2], // +Y Seite
                [a + 2, b + 2, b + 3, a + 3], // Oberseite
                [a + 3, b + 3, b + 0, a + 0]  // -Y Seite
            ]
    ];

    last = steps * 4;
    start_cap = [1, 2, 3, 0]; // [0, 3, 2, 1];
    end_cap   = [last + 3, last + 2, last + 1, last + 0]; // [last + 1, last + 2, last + 3, last + 0];

    faces = concat(side_faces, [start_cap, end_cap]);

    polyhedron(points = points, faces = faces, convexity = 10);
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

    rotate([0,0,90])
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


module n_14907(
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
        laenge = 50.0, starthoehe = starthoehe, startsteigung = startsteigung,
        endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
        w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}

module n_14908(
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
        laenge = 27.9, starthoehe = starthoehe, startsteigung = startsteigung,
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
                arc_pt(radius - rit, ang, zt),
                arc_pt(radius + rot, ang, zt),
                arc_pt(radius + rob, ang, zb),
                arc_pt(radius - rib, ang, zb)
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
    start_cap = cw ? [0, 3, 2, 1] : [0, 1, 2, 3];
    end_cap   = cw ? [last + 1, last + 2, last + 3, last + 0] : [last + 1, last + 0, last + 3, last + 2];

    faces = concat(side_faces, [start_cap, end_cap]);

    polyhedron(points = points, faces = faces, convexity = 10);
}

// --- Spur-N-Bögen (Minitrix) ---


module n_14916_r1_6(
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
    translate([-194.6,0,0])
    n_bogen(
        radius = 194.6, winkel = 6.0, starthoehe = starthoehe,
        startsteigung = startsteigung, endhoehe = endhoehe, endsteigung = endsteigung,
        extra = extra, w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
    );
}


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
    translate([-194.6,0,0])
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
    translate([-194.6,0,0])
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
    translate([-228.2,0,0])
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
    translate([-228.2,0,0])
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
    translate([-228.2,0,0])
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

// Minitrix 14961 + 14926: Links-Weiche R1 24° mit angehängtem R2 6°-Bogen am Abzweig
module n_14961_14916(
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
    R1      = 194.6;
    abz_ang = 24.0;
    x_end   = R1 * (cos(abz_ang) - 1);
    y_end   = R1 * sin(abz_ang);

    union() {
        n_14961(
            starthoehe = starthoehe, startsteigung = startsteigung,
            endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
            w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
        );
        translate([x_end, y_end, 0])
            rotate([0, 0, abz_ang])
                n_14916_r1_6(
                    starthoehe = starthoehe, startsteigung = startsteigung,
                    endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
                    w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
                );
    }
}

// Minitrix 14963 + 14926: Rechts-Weiche R1 24° mit angehängtem R2 6°-Bogen (gespiegelt)
module n_14963_14916(
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
    mirror([1, 0, 0])
        n_14961_14916(
            starthoehe = starthoehe, startsteigung = startsteigung,
            endhoehe = endhoehe, endsteigung = endsteigung, extra = extra,
            w_top = w_top, w_bottom = w_bottom, bed_height = bed_height, steps = steps
        );
}


module n_r1_60(
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
    dh = endhoehe - starthoehe;
    h1 = starthoehe + dh / 2.0;

    union() {
        // Segment 1 (0°..30°)
        n_14912_r1_30(
            starthoehe    = starthoehe,
            startsteigung = startsteigung,
            endhoehe      = h1,
            endsteigung   = true,
            extra         = extra,
            w_top         = w_top,
            w_bottom      = w_bottom,
            bed_height    = bed_height,
            steps         = steps
        );

        // Segment 2 (30°..60°)
        translate([R1 * (cos(30) - 1), R1 * sin(30), 0])
            rotate([0, 0, 30])
                n_14912_r1_30(
                    starthoehe    = h1,
                    startsteigung = true,
                    endhoehe      = endhoehe,
                    endsteigung   = endsteigung,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );
    }
}



// Dreiersatz R1 (3x 30° = 90°) auf Basis von n_14912_r1_30()
module n_r1_90(
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
    dh = endhoehe - starthoehe;
    h1 = starthoehe + dh / 3.0;
    h2 = starthoehe + 2.0 * dh / 3.0;

    union() {
        // Segment 1 (0°..30°)
        n_14912_r1_30(
            starthoehe    = starthoehe,
            startsteigung = startsteigung,
            endhoehe      = h1,
            endsteigung   = true,
            extra         = extra,
            w_top         = w_top,
            w_bottom      = w_bottom,
            bed_height    = bed_height,
            steps         = steps
        );

        // Segment 2 (30°..60°)
        translate([R1 * (cos(30) - 1), R1 * sin(30), 0])
            rotate([0, 0, 30])
                n_14912_r1_30(
                    starthoehe    = h1,
                    startsteigung = true,
                    endhoehe      = h2,
                    endsteigung   = true,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );

        // Segment 3 (60°..90°)
        translate([R1 * (cos(60) - 1), R1 * sin(60), 0])
            rotate([0, 0, 60])
                n_14912_r1_30(
                    starthoehe    = h2,
                    startsteigung = true,
                    endhoehe      = endhoehe,
                    endsteigung   = endsteigung,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );
    }
}


module n_r1_120(
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
    dh = endhoehe - starthoehe;
    h1 = starthoehe + dh / 4.0;
    h2 = starthoehe + 2.0 * dh / 4.0;
    h3 = starthoehe + 3.0 * dh / 4.0;

    union() {
        // Segment 1 (0°..30°)
        n_14912_r1_30(
            starthoehe    = starthoehe,
            startsteigung = startsteigung,
            endhoehe      = h1,
            endsteigung   = true,
            extra         = extra,
            w_top         = w_top,
            w_bottom      = w_bottom,
            bed_height    = bed_height,
            steps         = steps
        );

        // Segment 2 (30°..60°)
        translate([R1 * (cos(30) - 1), R1 * sin(30), 0])
            rotate([0, 0, 30])
                n_14912_r1_30(
                    starthoehe    = h1,
                    startsteigung = true,
                    endhoehe      = h2,
                    endsteigung   = true,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );

        // Segment 3 (60°..90°)
        translate([R1 * (cos(60) - 1), R1 * sin(60), 0])
            rotate([0, 0, 60])
                n_14912_r1_30(
                    starthoehe    = h2,
                    startsteigung = true,
                    endhoehe      = h3,
                    endsteigung   = true,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );

        // Segment 4 (90°..120°)
        translate([R1 * (cos(90) - 1), R1 * sin(90), 0])
            rotate([0, 0, 90])
                n_14912_r1_30(
                    starthoehe    = h3,
                    startsteigung = true,
                    endhoehe      = endhoehe,
                    endsteigung   = endsteigung,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );
    }
}

// Dreiersatz R2 (3x 30° = 90°) auf Basis von n_14922_r2_30()
module n_r2_90(
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
    R2 = 228.2;
    dh = endhoehe - starthoehe;
    h1 = starthoehe + dh / 3.0;
    h2 = starthoehe + 2.0 * dh / 3.0;

    union() {
        // Segment 1 (0°..30°)
        n_14922_r2_30(
            starthoehe    = starthoehe,
            startsteigung = startsteigung,
            endhoehe      = h1,
            endsteigung   = true,
            extra         = extra,
            w_top         = w_top,
            w_bottom      = w_bottom,
            bed_height    = bed_height,
            steps         = steps
        );

        // Segment 2 (30°..60°)
        translate([R2 * (cos(30) - 1), R2 * sin(30), 0])
            rotate([0, 0, 30])
                n_14922_r2_30(
                    starthoehe    = h1,
                    startsteigung = true,
                    endhoehe      = h2,
                    endsteigung   = true,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );

        // Segment 3 (60°..90°)
        translate([R2 * (cos(60) - 1), R2 * sin(60), 0])
            rotate([0, 0, 60])
                n_14922_r2_30(
                    starthoehe    = h2,
                    startsteigung = true,
                    endhoehe      = endhoehe,
                    endsteigung   = endsteigung,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );
    }
}


// Minitrix 14967 + 14926 + 14966:
// Ursprung (0, 0) = Ende des engeren Radius R1 von n_14966
// Ende von n_14926_r2_6 -> Start von n_14966
// Start von n_14967 -> Start von n_14926_r2_6 (mit 180 + rot_14926 = 174°)
module n_14967_14926_14966(
    hoehe      = 0.0,
    extra      = default_extra,
    w_top      = default_w_top,
    w_bottom   = default_w_bottom,
    bed_height = default_bed_height,
    steps      = default_steps
) {
    R1 = 194.6;
    R2 = 228.2;

    ang_14966_r1 = 42.0;
    ang_14926    = 6.0;

    // Ende des R1-Bogens von n_14966 (relativ zum Start von n_14966)
    p_14966_r1_end_x = R1 * (cos(ang_14966_r1) - 1);
    p_14966_r1_end_y = R1 * sin(ang_14966_r1);

    // Translation für n_14966, sodass dessen R1-Ende bei (0, 0) liegt
    t_14966_x = -p_14966_r1_end_x;
    t_14966_y = -p_14966_r1_end_y;

    // Start von n_14966 im Zielkoordinatensystem
    p_14966_start_x = t_14966_x;
    p_14966_start_y = t_14966_y;

    // Ende von n_14926_r2_6 (relativ zum eigenen Start bei (0, 0))
    p_14926_end_x = R2 * (cos(ang_14926) - 1);
    p_14926_end_y = R2 * sin(ang_14926);

    // Drehung von n_14926_r2_6 (-6°), damit sein Ende tangential an n_14966 anschließt
    rot_14926 = -ang_14926;
    p_14926_end_rot_x = p_14926_end_x * cos(rot_14926) - p_14926_end_y * sin(rot_14926);
    p_14926_end_rot_y = p_14926_end_x * sin(rot_14926) + p_14926_end_y * cos(rot_14926);

    // Translation für n_14926_r2_6, sodass sein Ende am Start von n_14966 liegt
    t_14926_x = p_14966_start_x - p_14926_end_rot_x;
    t_14926_y = p_14966_start_y - p_14926_end_rot_y;

    // Gegenrichtung inklusive Drehung von n_14926_r2_6 (180 - 6 = 174°)
    rot_14967 = 180.0 + rot_14926;

    rotate([0,0,-42.5]) // kleine korrektur mit 0.5 grad, so dass der kreis zusammenpasst
    union() {
        // 1. n_14966: R1-Ende liegt bei (0, 0)
        translate([t_14966_x, t_14966_y, 0])
            n_14966(
                starthoehe = hoehe, startsteigung = true,
                endhoehe   = hoehe, endsteigung   = true,
                extra = extra, w_top = w_top, w_bottom = w_bottom,
                bed_height = bed_height, steps = steps
            );

        // 2. n_14926_r2_6: Ende liegt am Start von n_14966
        translate([t_14926_x, t_14926_y, 0])
            rotate([0, 0, rot_14926])
                n_14926_r2_6(
                    starthoehe = hoehe, startsteigung = true,
                    endhoehe   = hoehe, endsteigung   = true,
                    extra = extra, w_top = w_top, w_bottom = w_bottom,
                    bed_height = bed_height, steps = steps
                );

        // 3. n_14967: Start liegt am Start von n_14926_r2_6, gedreht um (180 - 6)°
        translate([t_14926_x, t_14926_y, 0])
            rotate([0, 0, rot_14967])
                n_14967(
                    starthoehe = hoehe, startsteigung = true,
                    endhoehe   = hoehe, endsteigung   = true,
                    extra = extra, w_top = w_top, w_bottom = w_bottom,
                    bed_height = bed_height, steps = steps
                );
    }
}



// Dreiviertelkreis R1 (3x 90° = 270°) auf Basis von n_r1_90()
module n_r1_270(
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
    dh = endhoehe - starthoehe;
    h1 = starthoehe + dh / 3.0;
    h2 = starthoehe + 2.0 * dh / 3.0;

    union() {
        // 1. Viertelkreis (0°..90°): Start im Koordinatenursprung (0, 0)
        n_r1_90(
            starthoehe    = starthoehe,
            startsteigung = startsteigung,
            endhoehe      = h1,
            endsteigung   = true,
            extra         = extra,
            w_top         = w_top,
            w_bottom      = w_bottom,
            bed_height    = bed_height,
            steps         = steps
        );

        // 2. Viertelkreis (90°..180°): Start am Ende des ersten n_r1_90()
        translate([-R1, R1, 0])
            rotate([0, 0, 90])
                n_r1_90(
                    starthoehe    = h1,
                    startsteigung = true,
                    endhoehe      = h2,
                    endsteigung   = true,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );

        // 3. Viertelkreis (180°..270°): Start am Ende des zweiten n_r1_90()
        translate([-2 * R1, 0, 0])
            rotate([0, 0, 180])
                n_r1_90(
                    starthoehe    = h2,
                    startsteigung = true,
                    endhoehe      = endhoehe,
                    endsteigung   = endsteigung,
                    extra         = extra,
                    w_top         = w_top,
                    w_bottom      = w_bottom,
                    bed_height    = bed_height,
                    steps         = steps
                );
    }
}

// =========================================================================
// --- Beispiele für alle n_xyz()-Module ---
// =========================================================================

/*
// Geraden
translate([0,    0, 0]) n_14903();
translate([50,   0, 0]) n_14904();
translate([100,  0, 0]) n_14907();
translate([150,  0, 0]) n_14908();

// Bögen
translate([200, 0, 0]) n_14912_r1_30();
translate([250, 0, 0]) n_14916_r1_6();
translate([300, 0, 0]) n_14922_r2_30();
translate([350, 0, 0]) n_14926_r2_6();

// Weichen
translate([ 800, 0, 0]) n_14961();
translate([ 900, 0, 0]) n_14963();
translate([1000, 0, 0]) n_14966();
translate([1100, 0, 0]) n_14967();

translate([1200, 0, 0]) n_14961_14916();
translate([1300, 0, 0]) n_14963_14916();


translate([1400, 0, 0]) n_r1_90();
translate([1500, 0, 0]) n_r2_90();
translate([1600, 0, 0]) n_r1_120();
*/



h = 48;

/*
difference()
{
    translate([0, 0, 20]) n_14904();
    translate([0,0,-100])
    cube([400,400,200], center=true);
}
*/

difference() 
{
translate([00,0,5])
union()
{
translate([289.3,10,0])
// innenring
union() {
    translate([0, 0, h*3.5/12]) n_14967_14926_14966();
    translate([0, 0, h*3.5/12]) n_r1_270();    // innerster kreis
    translate([8.9, 22.2, 0]) n_r2_90(
            starthoehe    = h*3.5/12,
            startsteigung = true,
            endhoehe      = h*7.2/12,
            endsteigung   = true
    
    );
    
    translate([1550.4-2000, 24.5, 0]) rotate([0,0,180]) n_r2_90(
            starthoehe    = h*0/12,
            startsteigung = false,
            endhoehe      = h*3.5/12,
            endsteigung   = true
    );
    
    translate([-449.6, 24.5, 0]) n_14904();  // anschluss am linken ende, null-neveau    
    
    translate([-449.6, 24.5+104.2, 0]) // 120 grad bogen am obigen n_14904
        mirror([1,0,0]) n_r1_120(
            starthoehe    = h*0/12,
            startsteigung = false,
            endhoehe      = h*2.8/12,
            endsteigung   = true
   );
}




translate([20,170,0])
// aussenring
union() {

    difference() {

    union() {
        /* linke seite mit abzweigung nach rechts in den innenring */
        translate([-194.6, -104.2, h]) n_14963_14916();  // weiche nach rechts
        translate([-194.6, -104.2-104.2, h]) 
            n_14904(
            );  // gerade unter der weiche    
        translate([0,-104.2,0])         // fortfuehrung der weiche nach rechts 
        rotate([0,0,-30])
        translate([-194.6,0,0])
        mirror([1,0,0])
        n_r1_60(
                starthoehe    = h*12/12,
                startsteigung = false,
                endhoehe      = h*8/12,
                endsteigung   = true
        
            );                      // ended dann horizontal
        translate([0,90.4,0])
        rotate([0,0,-90])  // ursprung von 14907 ist dann links, führt n_r1_60() weiter
        n_14907(
                starthoehe    = h*8/12,
                startsteigung = true,
                endhoehe      = h*7.2/12,
                endsteigung   = true
        );   
        
        /* oberer halbkreis */
        translate([0,194.6,0])
        rotate([0,0,90]) {
            translate([0, 0, 0]) n_r1_90(
                        starthoehe    = h*9/12,
                        startsteigung = true,
                        endhoehe      = h*12/12,
                        endsteigung   = true
            );
            translate([0, -17.2, 0])n_14903(
                        starthoehe    = h*8.8/12,
                        startsteigung = true,
                        endhoehe      = h*9/12,
                        endsteigung   = true
            );
            translate([0, -17.2-104.2, 0]) n_14904(
                        starthoehe    = h*8/12,
                        startsteigung = true,
                        endhoehe      = h*8.8/12,
                        endsteigung   = true
            );
            translate([0, -17.2-104.2, 0]) mirror([0,1,0]) n_r1_90(
                        starthoehe    = h*8/12,
                        startsteigung = true,
                        endhoehe      = h*5/12,
                        endsteigung   = false
            );
        }
        
        /* unterer halbkreis */
        translate([0,-104.2-104.2,0])
        mirror([0,1,0])
        translate([0,194.6,0])
        rotate([0,0,90]) {
            translate([0, 0, 0]) n_r1_90(
                        starthoehe    = h*9/12,
                        startsteigung = true,
                        endhoehe      = h*12/12,
                        endsteigung   = false
            );
            translate([0, -17.2, 0])n_14903(
                        starthoehe    = h*8.8/12,
                        startsteigung = true,
                        endhoehe      = h*9/12,
                        endsteigung   = true
            );
            translate([0, -17.2-104.2, 0]) n_14904(
                        starthoehe    = h*8/12,
                        startsteigung = true,
                        endhoehe      = h*8.8/12,
                        endsteigung   = true
            );
            translate([0, -17.2-104.2, 0]) mirror([0,1,0]) n_r1_90(
                        starthoehe    = h*8/12,
                        startsteigung = true,
                        endhoehe      = h*5/12,
                        endsteigung   = false
            );
        }
        
        
        
    }
        translate([-179, -90, -0.01])
        door(depth=280);

    }

    
    /* rechte seite mit weiche */
    translate([17.2+104.2+194.6, -104.2, h*5/12]) 
        n_14961_14916();  // weiche nach links
    translate([17.2+104.2+194.6, -104.2-104.2, h*5/12]) n_14904(
    );  // gerade unter der weiche
    
    translate([290,-7,0])       // fortführung der linksweiche
    rotate([0,0,30])
    n_14908(
                    starthoehe    = h*5/12,
                    startsteigung = false,
                    endhoehe      = h*4.8/12,
                    endsteigung   = true
    );
    
    translate([107.6,-80.2,0])      // fortführung der gerade nach der linksweiche
    rotate([0,0,30])
    translate([194.6,0,0])       
    n_14912_r1_30(
                    starthoehe    = h*4.8/12,
                    startsteigung = true,
                    endhoehe      = h*3.8/12,
                    endsteigung   = true
    );
    
    translate([204.2,88.6,0]) // verbindung zwischen innen und aussen ring
    rotate([0,0,62.2])      // passt nicht 100% eigentlich haetten es 60 grad sein sollen
    n_14904(extra=2,
        starthoehe    = h*3.8/12,
        startsteigung = true,
        endhoehe      = h*2.8/12,
        endsteigung   = true
    );       // auch die laenge passt nicht 100%

    
}

}  // overall union
translate([0,0,-100])
cube([1000,1000,200], center=true);
}  // difference