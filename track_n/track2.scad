// --- Parameter ---
radius      = 420.0; // Bogenradius bis Gleismitte (mm)
angle_start = 0.0;   // Startwinkel in Grad
angle_end   = 45.0;  // Endwinkel in Grad (auch < angle_start möglich)
steps       = 60;    // Segmente entlang des Bogens

z_start     = 10.0;  // Höhe am Startwinkel (mm)
z_end       = 45.0;  // Höhe am Endwinkel (mm)
slope_start = 0.0;   // Steigung am Startwinkel (dz / ds, z.B. 0.03 = 3%)
slope_end   = 0.0;   // Steigung am Endwinkel (dz / ds)

w_top       = 36.0;  // Breite Oberkante Gleisbett (mm)
w_bottom    = 52.0;  // Breite Unterkante Gleisbett (mm)
bed_height  = 8.0;   // Dicke des Gleisbett-Körpers (mm)

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

// --- 3D-Bogen-Gleisbett als Polyhedron ---
module bezier_trackbed_arc() {
    d_ang = angle_end - angle_start;
    arc_len = radius * abs(d_ang) * PI / 180.0;

    rib = w_bottom / 2;
    rit = w_top / 2;
    rob = w_bottom / 2;
    rot = w_top / 2;

    // 4 Punkte pro Querschnitt:
    // 0: innen-unten, 1: außen-unten, 2: außen-oben, 3: innen-oben
    points = [
        for (i = [0 : steps])
            let(
                t   = i / steps,
                ang = angle_start + t * d_ang,
                zb  = z_profile(t, arc_len, z_start, z_end, slope_start, slope_end),
                zt  = zb + bed_height
            )
            each [
                arc_pt(radius - rib, ang, zb),
                arc_pt(radius + rob, ang, zb),
                arc_pt(radius + rot, ang, zt),
                arc_pt(radius - rit, ang, zt)
            ]
    ];

    // Flächenorientierung anpassen, falls im Uhrzeigersinn (d_ang < 0)
    cw = d_ang < 0;

    side_faces = [
        for (i = [0 : steps - 1])
            let(a = i * 4, b = (i + 1) * 4)
            each [
                cw ? [a + 0, a + 1, b + 1, b + 0] : [a + 0, b + 0, b + 1, a + 1], // Boden
                cw ? [a + 1, a + 2, b + 2, b + 1] : [a + 1, b + 1, b + 2, a + 2], // Außenflanke
                cw ? [a + 2, a + 3, b + 3, b + 2] : [a + 2, b + 2, b + 3, a + 3], // Oberseite
                cw ? [a + 3, a + 0, b + 0, b + 3] : [a + 3, b + 3, b + 0, a + 0]  // Innenflanke
            ]
    ];

    last = steps * 4;
    start_cap = cw ? [0, 1, 2, 3] : [0, 3, 2, 1];
    end_cap   = cw ? [last + 1, last + 0, last + 3, last + 2] : [last + 1, last + 2, last + 3, last + 0];

    faces = concat(side_faces, [start_cap, end_cap]);

    polyhedron(points = points, faces = faces, convexity = 10);
}

bezier_trackbed_arc();