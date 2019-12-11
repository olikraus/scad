
//
// terrain_generator.scad (OpenSCAD)
// 
// Copyright 2019 olikraus@gmail.com
// 
// Redistribution and use in source and binary forms, 
// with or without modification, are permitted
// provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain 
// the above copyright notice, this list of conditions 
// and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce 
// the above copyright notice, this list of conditions 
// and the following disclaimer in the documentation 
// and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS 
// AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, 
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
// IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.
//

/*
    
    diamond/square generator:
    https://www.bluh.org/code-the-diamond-square-algorithm/
    

*/


/*
 Name: 
   surface_matrix(matrix=[[1,1],[1,1]], scale=[1,1,1])

 Description:
   Similar to the "surface" function:
   Calculate a polyhedron out of a height map, which is given as a
   matrix (vector of vectors)
  
 Arguments:
  matrix: 
      Vector of vectors with the height information.
      Values below 0 are treated as 0.
  scale:
      A vector with three scale factors for x, y and z. Defaults to [1,1,1]
      This allows on the fly scaling of the generated polyhedron.

 Notes:
  convexity is fixed to 10
    "invert" and "center" arguments as known from the "surface" command are not supported
*/


module surface_matrix(matrix=[[1,1],[1,1]], scale=[1,1,1]) {
    // Get all the z values from the height map and generate
    // a point list out of it.
    // Add the corners of z=0 plane to the end of the list.
    function hm_to_points(m, scalex=1, scaley=1,scalez=1) = [

        // Convert the height map to points.
        // Values below 0 are made 0.
        for( j=[0:len(m)-1] ) 
            for ( i =[0:len(m[0])-1] ) 
                [i*scalex, j*scaley, m[j][i] > 0 ? m[j][i]*scalez : 0 ]
        ,
        // Store the edges with z=0 at the end of the point list
        [0,0,0],
        [(len(m[0])-1)*scalex, 0, 0],
        [0, (len(m)-1)*scaley, 0],
        [(len(m[0])-1)*scalex, (len(m)-1)*scaley, 0] 
    ];

    // get lower left triangle face for a given point
    // width is the width of the heightmap
    function hm_pt_triangle_ll(width,x,y) = [ 
        y*width+x, (y+1)*width+x, (y+1)*width+x+1
    ];

    // get upper right triangle face for a given point
    // width is the width of the heightmap
    function hm_pt_triangle_ur(width,x,y) = [ 
        y*width+x, (y+1)*width+x+1, y*width+x+1
    ];

    // get all faces out of the height map for the polyhedron
    function hm_to_faces(m) = [
        // lower left triangle faces
        for( y=[0:len(m)-2] ) 
            for ( x =[0:len(m[0])-2] ) 
                hm_pt_triangle_ll(len(m[0]), x, y)
        ,
        // upper right triangle faces
        for( y=[0:len(m)-2] ) 
            for ( x =[0:len(m[0])-2] )         
                hm_pt_triangle_ur(len(m[0]), x, y)
        ,
        // all for sides
        [ 
            for( y=[0:len(m)-1] ) (len(m)-1-y)*len(m[0]),
            len(m)*len(m[0])+0,
            len(m)*len(m[0])+2
        ],
        [ 
            for( y=[0:len(m)-1] ) (y+1)*len(m[0])-1,
            len(m)*len(m[0])+3,
            len(m)*len(m[0])+1
        ],
        [ 
            for( x=[0:len(m[0])-1] ) x,
            len(m)*len(m[0])+1,
            len(m)*len(m[0])+0
        ],
        [ 
            for( x=[0:len(m[0])-1] ) len(m)*len(m[0])-1-x,
            len(m)*len(m[0])+2,
            len(m)*len(m[0])+3
        ],
        // buttom face
        [
            len(m)*len(m[0])+0,
            len(m)*len(m[0])+1,
            len(m)*len(m[0])+3,
            len(m)*len(m[0])+2
        ] 

    ];

    /*
    function hm_points_faces(matrix, scale) = [
            hm_to_points(matrix,scale[0],scale[1],scale[2]),
            hm_to_faces(matrix)
        ];
     */
    
    polyhedron( 
        points = hm_to_points(matrix,scale[0],scale[1],scale[2]), 
        faces = hm_to_faces(matrix), 
        convexity=10 );
}

/*
 Name: 
    terrain(l=32, h=5, scale=[1,1,1], hills = [[0,0,0,0]]) {

 Description:
    terrain generator
    generates a quadratic size of a kind of a terrain

 Arguments:
    l: xy size of the generated polyhedron
    h: z-height of the polyhedron with (without scaling and hills)
    scale: scaling vector for x,y and z
    hills: extra hills. this is a list of the following entries:
        [x, y, radius, height]
  
  Note:
    Algorithm is based on the square diamond algorithm

*/
module terrain(l=32, h=5, scale=[1,1,1], hills = [[0,0,0,0]]) {

    tg_random_matrix = rands(0,1,10000, 758);

    function tg_rnd(x,y,w,s) = tg_random_matrix[((y*w+x)*s*17)%10000];

    function tg_init(w,h,size) = [
        for( y = [0:h-1] ) [ 
            for( x = [0:w-1] ) 
                (y % size) == 0 && (x % size) == 0 ?
                tg_rnd(x,y,w,1) :
                0
        ]
    ];

    function tg_init_zero(w,h, seed) = [
        for( y = [0:h-1] ) [ for( x = [0:w-1] ) 0 ] 
    ]; 
        
    function tg_get_val(m, x, y) =
        let( yy = (y+len(m)) % len(m), xx = (x+len(m[yy])) % len(m[yy]) )
        m[yy][xx];

    function tg_set_val(m, x, y, val) = [ 
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) yy==y && xx==x ? val : m[yy][xx]
        ]
    ];
        
    function tg_square(m, x, y, size, val) = 
        let(hs=size/2, 
            a=tg_get_val(m, x-hs, y-hs), 
            b=tg_get_val(m, x+hs, y-hs), 
            c=tg_get_val(m, x-hs, y+hs), 
            d=tg_get_val(m, x+hs, y+hs)
        )
        (a+b+c+d)/4+val;

    function tg_diamond(m, x, y, size, val) = 
        let(hs=size/2, 
            a=tg_get_val(m, x-hs, y), 
            b=tg_get_val(m, x+hs, y), 
            c=tg_get_val(m, x, y-hs), 
            d=tg_get_val(m, x, y+hs)
        )
        (a+b+c+d)/4+val;
            
    function tg_square_all(m, size, k) = [
        let(hs = floor(size/2), r = rands())
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) 
                ((yy+hs) % size) == 0 && ((xx+hs) % size) == 0 ? 
                    tg_square(m,xx,yy,size,tg_rnd(xx,yy,len(m[0]),size)*k) : 
                    m[yy][xx]
        ]
    ];
            
    function tg_diamond_a1(m, size, k) = [
        let(hs = floor(size/2))
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) 
                floor(yy % size) == 0 && floor((xx+hs) % size) == 0 ?
                    tg_diamond(m,xx,yy,size,tg_rnd(xx,yy,len(m[0]),size)*k) :
                    m[yy][xx]
        ]
    ];

    function tg_diamond_a2(m, size, k) = [
        let(hs = floor(size/2))
        for(yy=[0:len(m)-1]) [ 
            for(xx=[0:len(m[yy])-1]) 
                (floor((yy+hs)%size) == 0) && (floor(xx%size) == 0) ? 
                    tg_diamond(m,xx,yy,size,tg_rnd(xx,yy,len(m[0]),size)*k) : 
                    m[yy][xx]
        ]
    ];


    function tg_diamond_square(m, size, k) = 
            tg_diamond_a2(
                tg_diamond_a1(
                    tg_square_all(m, size, k),
                size, k), 
            size, k);

    function tg_min(m) = min([ for (a = m) for (b = a) b ]);
        
    function tg_max(m) = max([ for (a = m) for (b = a) b ]);
        
    function tg_norm(m, scale) = [
        let( min = tg_min(m), max=tg_max(m) )
        for( y = [0:len(m)-1] ) [ 
            for( x = [0:len(m[y])-1] ) (m[y][x]-min)*scale/(max-min) 
        ] 
    ]; 

    // add an extra hill to a hight map
    // xx,yy position
    // r base radius of the hull
    // h height of the hill
    function tg_hill(m, xx, yy, r, h=1) = [
        for( y = [0:len(m)-1] ) [ 
            for( x = [0:len(m[y])-1] ) 
                m[y][x] +
                (abs(xx-x) < r && abs(yy-y) < r ? 
                (cos((x-xx)*180/r)+1)*(cos((y-yy)*180/r)+1)*h/4 : 
                0)
        ]
    ];

            
    function sum(list, cnt=0) = 
            cnt<len(list)-1 ? list[cnt] + sum(list, cnt+1) : list[cnt];

    //xx, yy, r, h=1
    function tg_multi_hill(m, vv) = [
        for( y = [0:len(m)-1] ) [ 
            for( x = [0:len(m[y])-1] ) 
                m[y][x] + 
                sum([for( v=vv )
                    (abs(v[0]-x) < v[2] && abs(v[1]-y) < v[2] ? 
                    (cos((x-v[0])*180/v[2])+1)*(cos((y-v[1])*180/v[2])+1)*v[3]/4 : 
                    0)
                ])
        ]
    ];

    function tg_recur(m, size, k) =
        size <= 1 ? 
        tg_diamond_square(m, size, k) :
        tg_recur(tg_diamond_square(m, size, k), floor(size/2), k/2.0);
            
    
    m = tg_init(l+1, l+1, l+1);
    mm = tg_norm(tg_recur(m, l+1, 1.0), h);
    mmm = tg_multi_hill(mm, hills);
    surface_matrix(mmm, scale);
}

terrain(32, 10, [1,1,1], [ 
    [0, 0, 32, 20],
    [0, 32, 32, 20],
    [32, 32, 32, 20]
]);

