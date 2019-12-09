
//
// surface_matrix.scad (OpenSCAD)
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
// Name: 
//  surface_matrix(matrix=[[1,1],[1,1]], scale=[1,1,1])
//
// Description:
//  Similar to the "surface" function:
//  Calculate a polyhedron out of a height map, which is given as a
//  matrix (vector of vectors)
//  
// Arguments:
//  matrix: 
//      Vector of vectors with the height information.
//      Values below 0 are treated as 0.
//  scale:
//      A vector with three scale factors for x, y and z. Defaults to [1,1,1]
//      This allows on the fly scaling of the generated polyhedron.
//
// Notes:
//  convexity is fixed to 10
//  "invert" and "center" arguments as known from the "surface" command are not supported
//

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
    
           
    polyhedron( 
        points = hm_to_points(matrix,scale[0],scale[1],scale[2]), 
        faces = hm_to_faces(matrix), 
        convexity=10 );
}

hm = [ for( y=[0:4:360*2] )
 [ for( x=[0:4:360*2] ) sin(y)*cos(x)*40+40+1 ]
 ];
surface_matrix(hm, scale=[1,1,1]);
