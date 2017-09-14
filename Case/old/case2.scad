PLATE_H = 91.437;
PLATE_TH = 53.337;
PLATE_BH = 38.1;
PLATE_W = 115.7;
PLATE_LW = 19.1;
PLATE_RW = 96.6;
PLATE_THICKNESS = 1.5;

SPLATE_H = 47.1;
SPLATE_W = 20.75;

TPLATE_H = 47.1;
TPLATE_W = 39.8;
TPLATE_ANGLE = 16;
TPLATE_ZANGLE = 45;

CASE_H = 25;
CASE_SH = 5;
CASE_BOTTOM_H = 2;
CASE_OUTER_BORDER = 2;
CASE_INNER_BORDER = 1;
CASEHS = CASE_H - 8;


points = [[0,0], [0,PLATE_H], [PLATE_RW,PLATE_H], [PLATE_RW,PLATE_TH], [PLATE_W,PLATE_TH], [PLATE_W, 0] ];


module plate(thickness=PLATE_THICKNESS, offset=0) {
    rotate([0, -9.782, 0]) {
        linear_extrude(height=thickness, twist=0)
        offset(delta = offset) {
            polygon(points);
        }
    }
}

module plateproj() {
    projection(cut=false) {
        plate();
    }
}

module tplate() {
    rotate([-TPLATE_ANGLE, 0, 0]) {
        translate ([-TPLATE_W/2, -TPLATE_H/2, 0]) {
            cube([TPLATE_W, TPLATE_H, PLATE_THICKNESS]);
        }
    }
}

module tplateproj() {
    projection(cut=false) {
        tplate();
    }
}
    
// Main body
difference() {

    // Case
    color([1,0,0])
    linear_extrude(height=CASE_H, twist=0)
    offset(delta = CASE_OUTER_BORDER) {
        plateproj();
    }
    
    // Plate
    color([0,1,0])
    translate ([0, 0, CASE_SH-PLATE_THICKNESS]) {
        plate();
    }
    
    // Depth
    color([0,0,1])
    translate ([0, 0, CASE_BOTTOM_H]) {
        linear_extrude(height=CASE_H - CASE_BOTTOM_H, twist=0)
        offset(delta = -CASE_INNER_BORDER) {
            plateproj();
        }
    }
    
    // Cut
    color([0,0.5,0.5])
    translate ([0, 0, CASE_SH]) {
        plate(30, 20);
    }
}


// Thumb cluster
translate ([PLATE_RW+TPLATE_W/2+2, PLATE_TH+SPLATE_H/2+3, 0]) {
    difference() {
        
        // Case
        color([1,0,0])
        linear_extrude(height=CASE_H, twist=0)
        offset(delta = CASE_OUTER_BORDER) {
            tplateproj();
        }
        
        // Plate
        color([0,1,0])
        translate ([0, 0, CASEHS]) {
            tplate();
        }
        
        // Depth
        color([0,0,1])
        translate ([0, 0, CASE_BOTTOM_H]) {
            linear_extrude(height=CASE_H - CASE_BOTTOM_H, twist=0)
            offset(delta = -CASE_INNER_BORDER) {
                tplateproj();
            }
        }
        
        // Cut
        color([0,0.5,0.5])
        translate ([0, 0, CASEHS + PLATE_THICKNESS]) {
            rotate([-TPLATE_ANGLE, 0, 0]) {
                translate ([-50, -50, 0]) {
                    cube([100, 100, 50]);
                }
            }
        }
    }
}

// Single key
translate ([PLATE_RW+SPLATE_W/2-15.5, PLATE_TH+SPLATE_H/2+SPLATE_H/2+4, 0]) {
    difference() {
        
        // Case
        color([1,0,0])
        translate ([-CASE_OUTER_BORDER, -CASE_OUTER_BORDER, 0]) {
            cube([SPLATE_H+CASE_OUTER_BORDER*2, SPLATE_W+CASE_OUTER_BORDER*2, 11.2]);
        }
        
        // Plate
        color([0,1,0])
        translate ([0, 0, 11.2-PLATE_THICKNESS]) {
            cube([SPLATE_H, SPLATE_W, PLATE_THICKNESS]);
        }
        
        // Depth
        color([0,0,1])
        translate ([CASE_INNER_BORDER, CASE_INNER_BORDER, CASE_BOTTOM_H]) {
            cube([SPLATE_H-CASE_INNER_BORDER*2, SPLATE_W-CASE_INNER_BORDER*2, 11.2]);
        }

    }
}