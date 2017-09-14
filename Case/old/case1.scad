CASE_H = 91.437;
CASE_W = 115.7;
CASE_TILT = 10;
CASE_DEPTH = 40;
CASE_TOP_H = 53.337;
CASE_BOTTOM_H = 38.1;
CASE_LEFT_W = 19.1;
CASE_RIGHT_W = 96.6;
CASE_BOTTOM_HEIGHT = 3;
PLATE_THICKNESS = 1.5;
PLATE_OUTER_BORDER = 2;
PLATE_INNER_BORDER = 1;

PILLAR_WIDTH = 13;
PILLAR_HEIGHT = 10;
HOLE_RADIUS = 1;
HOLE_MARGIN = 6.25;
SP_HOLE_MARGIN_H = 4.25;

SIDE_PLATE_W = 20.7;
SIDE_PLATE_H = 47.1;
SP_ALIGN_OFFSET = 2;

SUPPORT_H = SIDE_PLATE_H - CASE_BOTTOM_H + 2*PLATE_OUTER_BORDER - SP_ALIGN_OFFSET;
SUPPORT_W = CASE_RIGHT_W + 2*PLATE_OUTER_BORDER;



// Case
difference() {
    union() {
        points = [[0,0], [0,CASE_H], [CASE_RIGHT_W,CASE_H], [CASE_RIGHT_W,CASE_TOP_H], [CASE_W,CASE_TOP_H], [CASE_W, 0] ];
        
        // Bottom
        color([0,1,0])
        linear_extrude(height=CASE_BOTTOM_HEIGHT, twist=0)
        polygon(points);
        
        color([0,1,1])
        // Border wall
        linear_extrude(height=CASE_DEPTH + PLATE_THICKNESS, twist=0) {
            difference() {
                 offset(delta = PLATE_OUTER_BORDER) {
                     polygon(points);
                 }
                 polygon(points);
            }
        }
        
        color([1,0.6,0.5])
        // Support wall
        linear_extrude(height=CASE_DEPTH, twist=0) {
            difference() {
                 polygon(points);
                 offset(delta = -PLATE_INNER_BORDER) {
                     polygon(points);
                 }
            }
        }
        
        // Pillars
        color([1,1,1])
        union() {
            cube([PILLAR_WIDTH, PILLAR_HEIGHT, CASE_DEPTH]);
            translate ([CASE_W - PILLAR_WIDTH, 0, 0]) {
                cube([PILLAR_WIDTH, PILLAR_HEIGHT, CASE_DEPTH]);
            }
            translate ([0, CASE_H - PILLAR_HEIGHT, 0]) {
                cube([PILLAR_WIDTH, PILLAR_HEIGHT, CASE_DEPTH]);
            }
            translate ([CASE_RIGHT_W - PILLAR_WIDTH, CASE_H - PILLAR_HEIGHT, 0]) {
                cube([PILLAR_WIDTH, PILLAR_HEIGHT, CASE_DEPTH]);
            }
        }
        
        // Support
        color([1,0.1,1])
        translate ([-PLATE_OUTER_BORDER, CASE_H, 0]) {
            cube([SUPPORT_W, SUPPORT_H, CASE_DEPTH]);
        }
    }
        
    // Cut tilted for inner support
    color([1,0,0])
    union() {
        hull() {
            points1 = [[0,0], [0,CASE_H], [CASE_RIGHT_W,CASE_H], [CASE_RIGHT_W,0]];
            translate([0, 0, CASE_DEPTH - PLATE_THICKNESS - 11]) {
                rotate([0, -5.91, 0]) {
                    linear_extrude(height=PLATE_THICKNESS, twist=0)
                    polygon(points1);
                }
            }

            translate([0, 0, CASE_DEPTH*2]) {
                linear_extrude(height=PLATE_THICKNESS, twist=0)
                polygon(points1);
            }
        }
        
        hull() {
            points2 = [[0,0], [0,CASE_TOP_H], [CASE_W,CASE_TOP_H], [CASE_W,0]];
            translate([0, 0, CASE_DEPTH - PLATE_THICKNESS - 11]) {
                rotate([0, -5.91, 0]) {
                    linear_extrude(height=PLATE_THICKNESS, twist=0)
                    polygon(points2);
                }
            }

            translate([0, 0, CASE_DEPTH*2]) {
                linear_extrude(height=PLATE_THICKNESS, twist=0)
                polygon(points2);
            }
        }
    }

    // Cut tilted for outer border
    color([0,0,1])
    union() {
        translate([0,0,PLATE_THICKNESS]) {
            hull() {
                points1 = [[0,0], [0,CASE_H], [CASE_RIGHT_W,CASE_H], [CASE_RIGHT_W,0]];
                translate([0, 0, CASE_DEPTH - PLATE_THICKNESS - 11]) {
                    rotate([0, -5.91, 0]) {
                        linear_extrude(height=PLATE_THICKNESS, twist=0)
                        offset(delta=14) {
                            polygon(points1);
                        }
                    }
                }

                translate([0, 0, CASE_DEPTH*2]) {
                    linear_extrude(height=PLATE_THICKNESS, twist=0)
                    offset(delta=14) {
                        polygon(points1);
                    }
                }
            }
            
            hull() {
                points2 = [[0,0], [0,CASE_TOP_H], [CASE_W,CASE_TOP_H], [CASE_W,0]];
                translate([0, 0, CASE_DEPTH - PLATE_THICKNESS - 11]) {
                    rotate([0, -5.91, 0]) {
                        linear_extrude(height=PLATE_THICKNESS, twist=0)
                        offset(delta=14) {
                            polygon(points2);
                        }
                    }
                }

                translate([0, 0, CASE_DEPTH*2]) {
                    linear_extrude(height=PLATE_THICKNESS, twist=0)
                    offset(delta=14) {
                        polygon(points2);
                    }
                }
            }
        }
    }

    
    // Holes
    color([1,0,1])
    union() {
        translate([HOLE_MARGIN, HOLE_MARGIN, CASE_BOTTOM_HEIGHT+10]) {
            cylinder(h=CASE_DEPTH*2, r1=HOLE_RADIUS, r2=HOLE_RADIUS, $fn=15);
        }
        
        translate([CASE_W-HOLE_MARGIN, HOLE_MARGIN, CASE_BOTTOM_HEIGHT+10]) {
            cylinder(h=CASE_DEPTH*2, r1=HOLE_RADIUS, r2=HOLE_RADIUS, $fn=15);
        }
        
        translate([HOLE_MARGIN, CASE_H-HOLE_MARGIN, CASE_BOTTOM_HEIGHT+10]) {
            cylinder(h=CASE_DEPTH*2, r1=HOLE_RADIUS, r2=HOLE_RADIUS, $fn=15);
        }
        
        translate([CASE_RIGHT_W-HOLE_MARGIN, CASE_H-HOLE_MARGIN, CASE_BOTTOM_HEIGHT+10]) {
            cylinder(h=CASE_DEPTH*2, r1=HOLE_RADIUS, r2=HOLE_RADIUS, $fn=15);
        }
        
        translate([CASE_RIGHT_W-PILLAR_WIDTH, CASE_H+SUPPORT_H-PLATE_OUTER_BORDER-SP_HOLE_MARGIN_H, CASE_DEPTH-PLATE_OUTER_BORDER-SIDE_PLATE_W/2]) {
            rotate([0,90,0]) {
                cylinder(h=PILLAR_WIDTH, r1=HOLE_RADIUS, r2=HOLE_RADIUS, $fn=15);
            }
        }
        
    }
    
    // Side plate
    translate([CASE_RIGHT_W-PLATE_INNER_BORDER-0.01, CASE_TOP_H+PLATE_OUTER_BORDER-SP_ALIGN_OFFSET, CASE_DEPTH-PLATE_OUTER_BORDER-SIDE_PLATE_W]) {
        cube([PLATE_OUTER_BORDER+PLATE_INNER_BORDER+0.1, SIDE_PLATE_H, SIDE_PLATE_W]);
    }
    
    // Cut pillar
    translate([CASE_RIGHT_W-11, CASE_TOP_H+24, CASE_DEPTH-PLATE_OUTER_BORDER-SIDE_PLATE_W]) {
        rotate([0,0,-54]) {
        cube([5, 20, SIDE_PLATE_W]);
        }
    }
}
