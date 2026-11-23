// --- Parameter ---
length      = 300.0; // Streckenlänge in mm
steps       = 60;    // Auflösung entlang der Strecke (höher = glatter)

z_start     = 10.0;  // Höhe am Eingang (mm)
z_end       = 45.0;  // Höhe am Ausgang (mm)
slope_start = 0.0;   // Steigung am Eingang (z.B. 0.03 = 3%, 0 = waagerecht)
slope_end   = 0.0;   // Steigung am Ausgang (z.B. 0.02 = 2%, 0 = waagerecht)

w_top       = 36.0;  // Breite Oberkante Gleisbett (mm)
w_bottom    = 52.0;  // Breite Unterkante Gleisbett (mm)
bed_height  = 8.0;   // Dicke des Gleisbett-Körpers (mm)

// --- Kubische Bézier-Hilfsfunktionen ---
function bezier1D(p0, p1, p2, p3, t) =
    pow(1 - t, 3) * p0 +
    3 * pow(1 - t, 2) * t * p1 +
    3 * (1 - t) * pow(t, 2) * p2 +
    pow(t, 3) * p3;

function z_profile(t, L, z0, z1, m0, m1) =
    let(
        p0 = z0,
        p1 = z0 + (m0 * L) / 3.0,
        p2 = z1 - (m1 * L) / 3.0,
        p3 = z1
    )
    bezier1D(p0, p1, p2, p3, t);

// --- 3D-Gleisbett als Polyhedron aufbauen ---
module bezier_trackbed_straight() {
    n_rings = steps + 1;

    // 4 Eckpunkte pro Querschnitt:
    // 0: hinten-links (unten), 1: hinten-rechts (unten),
    // 2: vorne-rechts (oben), 3: vorne-links (oben)
    points = [
        for (i = [0 : steps])
            let(
                t  = i / steps,
                x  = t * length,
                zb = z_profile(t, length, z_start, z_end, slope_start, slope_end),
                zt = zb + bed_height,
                hb = w_bottom / 2,
                ht = w_top / 2
            )
            each [
                [x, -hb, zb],
                [x,  hb, zb],
                [x,  ht, zt],
                [x, -ht, zt]
            ]
    ];

    // Seitenflächen entlang der Segmente
    side_faces = [
        for (i = [0 : steps - 1])
            let(a = i * 4, b = (i + 1) * 4)
            each [
                [a + 0, b + 0, b + 1, a + 1], // Boden
                [a + 1, b + 1, b + 2, a + 2], // Rechte Böschung
                [a + 2, b + 2, b + 3, a + 3], // Oberseite
                [a + 3, b + 3, b + 0, a + 0]  // Linke Böschung
            ]
    ];

    // Stirnflächen (Anfang und Ende)
    start_cap = [[0, 1, 2, 3]];
    last = steps * 4;
    end_cap   = [[last + 1, last + 0, last + 3, last + 2]];

    faces = concat(side_faces, start_cap, end_cap);

    polyhedron(points = points, faces = faces, convexity = 10);
}

bezier_trackbed_straight();