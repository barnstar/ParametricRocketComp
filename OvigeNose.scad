//  Parametric Tangent Ovive Nosecone
//  by Jonathan Nobels, 2017
//
//  I dedicate any and all copyright interest in this software to the public domain.
//  I make this dedication for the benefit of the public at large and to the
//  detriment of my heirs and successors. I intend this dedication to be an overt
//  act of relinquishment in perpetuity of all present and future rights to this
//  software under copyright law. See <http://unlicense.org> for more info.
//

// 1.5" Mailing Tube
TUBE_ID = 38.2;
TUBE_OD = 41.2;

// 2.5" Mailing Tube
//TUBE_ID = 63.65;
//TUBE_OD = 66.90;

/* 3.0" Mailing Tube */
//TUBE_ID = 75.75;
//TUBE_OD = 78.75;


LENGTH = 140;
SHOULDER_LENGTH = 50;
TIP_RAD = 2;

WALL_THICKNESS = 1.0;
CROSS_BAR_SIZE = 0;

$fn=180;


translate([0,0,0])
  cone();
translate([0,TUBE_OD+20,0])
  insert();


module cone() 
{
  difference() {
    cone_ogive_tan_blunted(R_nose = TIP_RAD, R = TUBE_OD/2, L = LENGTH, s = 500);
    cone_ogive_tan_blunted(R_nose = TIP_RAD*1.1, R = TUBE_OD/2 - WALL_THICKNESS, L = LENGTH-WALL_THICKNESS, s = 200);
    cylinder(r=TUBE_ID/2, h = 20, center=true);
  }
}

module insert()
{
 union() {
    difference() {
      cylinder(r=TUBE_ID/2, h=SHOULDER_LENGTH+20, center=false);
      cylinder(r=TUBE_ID/2-WALL_THICKNESS, h=(SHOULDER_LENGTH+20)*2.1, center=true);
    }
    translate([0,0,CROSS_BAR_SIZE/2]) {
      cube([TUBE_ID-WALL_THICKNESS*.5,CROSS_BAR_SIZE,CROSS_BAR_SIZE], center=true);
      rotate([0,0,90])cube([TUBE_ID-WALL_THICKNESS*.5,CROSS_BAR_SIZE,CROSS_BAR_SIZE], center=true);
    }  
  }
}

module cone_ogive_tan_blunted(R_nose = 10, R = 66.9, L = 120, s = 500){
  // SPHERICALLY BLUNTED TANGENT OGIVE
  //
  //

  echo(str("SPHERICALLY BLUNTED TANGENT OGIVE"));    
  echo(str("R_nose = ", R_nose)); 
  echo(str("R = ", R)); 
  echo(str("L = ", L)); 
  echo(str("s = ", s)); 

  rho = (pow(R,2) + pow(L,2)) / (2*R);

  x_o = L - sqrt(pow((rho - R_nose), 2) - pow((rho - R), 2));
  x_a = x_o - R_nose;
  y_t = (R_nose * (rho - R)) / (rho - R_nose);
  x_t = x_o - sqrt(pow(R_nose, 2)- pow(y_t, 2));

  TORAD = PI/180;
  TODEG = 180/PI;
  
  inc = 1/s;
  
  s_x_t = round((s * x_t) / L);

  alpha = TORAD * atan(R/L) - TORAD * acos(sqrt(pow(L,2) + pow(R,2)) / (2*rho));

  rotate_extrude(convexity = 10, $fn = s) union() {
    for (i=[s_x_t:s]){

      x_last = L * (i - 1) * inc;
      x = L * i * inc;

      y_last = sqrt(pow(rho,2) - pow((rho * cos(TODEG * alpha) - x_last),2)) + (rho * sin(TODEG * alpha));

      y = sqrt(pow(rho,2) - pow((rho * cos(TODEG * alpha) - x),2)) + (rho * sin(TODEG * alpha));

      rotate([0,0,-90])polygon(points = [[x_last-L,0],[x-L,0],[x-L,y],[x_last-L,y_last]], convexity = 10);
    }

    translate([0, L - x_o, 0]) difference() {
      circle(R_nose, $fn = s);
      translate([-R_nose, 0, 0]) square((2 * R_nose), center = true);
    }
  }
}

