// Parametric Haack Series Nose Cone
// 2 or 3 piece with removable tip and sleeve
//
//  by Jonathan Nobels, 2017
//
//  I dedicate any and all copyright interest in this software to the public domain.
//  I make this dedication for the benefit of the public at large and to the
//  detriment of my heirs and successors. I intend this dedication to be an overt
//  act of relinquishment in perpetuity of all present and future rights to this
//  software under copyright law. See <http://unlicense.org> for more info.
//


$fn=120;

// 1.5" Mailing Tube
//TUBE_ID = 38.2;
//TUBE_OD = 41.2;

// 2.5" Mailing Tube
TUBE_ID = 63.65;
TUBE_OD = 66.90;    

/* 3.0" Mailing Tube */
//TUBE_ID = 75.75;
//TUBE_OD = 78.75;


LENGTH = 180;              //Overall length
TIP_LEN=60;                //Length of the removable tip 
SHOULDER_LENGTH = 60;      //Length of the insert 

 //The radii and lengths here have to be customized for each length/od
 //Deriving the raduis at a given z position is left as an exercise for
 //the reader.
SLEEVE_OR=18;               //Tip inserr sleeve outer radius
SLEEVE_IR=13;               //Tip insert sleeve inner radius
SLEEVE_LEN=30;              //Tip sleeve length
    
WALL_THICKNESS = 3.0;       //Cone and sleeve wall thickness


//Build the components

translate([0,0,0])
  cone_bottom();
translate([TUBE_OD/2 + 40,0,0])
  cone_tip();
translate([-TUBE_OD - 20,0,0])
  simple_insert();



// Components

module simple_insert()
{
  union(){
    difference() {
      cylinder(r=TUBE_ID/2, h=SHOULDER_LENGTH, center=false);
      cylinder(r=TUBE_ID/2-WALL_THICKNESS, h=(SHOULDER_LENGTH)*2.1, center=true);
    }
  }  
}

module solid_cone()
{
  cone_haack(R = TUBE_OD/2, L = LENGTH, s = 200);   
}

module shelled_cone() 
{
  difference() {
    cone_haack(R = TUBE_OD/2, L = LENGTH, s = 200);
    cone_haack(R = TUBE_OD/2 - WALL_THICKNESS, L = LENGTH-WALL_THICKNESS, s = 200);
    cylinder(r=TUBE_ID/2, h = 20, center=true);
  }
}

module cone_bottom()
{  
  difference() {
    union() {
      shelled_cone();
      translate([0,0,LENGTH-TIP_LEN-SLEEVE_LEN]) difference(){
        cylinder(r=SLEEVE_OR,h=SLEEVE_LEN*2, center=false);
        cylinder(r=SLEEVE_IR,h=SLEEVE_LEN*4, center=true);
      }
    }
    translate([-SLEEVE_OR,-SLEEVE_OR,LENGTH-TIP_LEN])cube([SLEEVE_OR*2,SLEEVE_OR*2,TIP_LEN*2]);
  }
}

module cone_tip()
{ 
  translate([0,0,-(LENGTH-TIP_LEN-SLEEVE_LEN)])
  union() {
  difference() {
    solid_cone();
    translate([-TUBE_OD,-TUBE_OD,0])cube([TUBE_OD*2,TUBE_OD*2,LENGTH-TIP_LEN]);
  }
  translate([0,0,LENGTH-TIP_LEN-SLEEVE_LEN])
    cylinder(r=SLEEVE_IR,h=SLEEVE_LEN, center=false);
  }
}

module cone_haack(C = 0, R = 5, L = 10, s = 100)
{
  // SEARS-HAACK BODY NOSE CONE:
  //
  // Parameters:
  // C = 1/3: LV-Haack (minimizes supersonic drag for a given L & V)
  // C = 0: LD-Haack (minimizes supersonic drag for a given L & D), also referred to as Von Kármán
  //
  // Formulae (radians):
  // theta = acos(1 - (2 * x / L));
  // y = (R / sqrt(PI)) * sqrt(theta - (sin(2 * theta) / 2) + C * pow(sin(theta),3));

  echo(str("SEARS-HAACK BODY NOSE CONE"));
  echo(str("C = ", C)); 
  echo(str("R = ", R)); 
  echo(str("L = ", L)); 
  echo(str("s = ", s)); 

  TORAD = PI/180;
  TODEG = 180/PI;

  inc = 1/s;

  rotate_extrude(convexity = 10, $fn = s)
    for (i = [1 : s]){
        x_last = L * (i - 1) * inc;
        x = L * i * inc;

        theta_last = TORAD * acos((1 - (2 * x_last/L)));
        y_last = (R/sqrt(PI)) * sqrt(theta_last - (sin(TODEG * (2*theta_last))/2) + C * pow(sin(TODEG * theta_last), 3));

        theta = TORAD * acos(1 - (2 * x/L));
        y = (R/sqrt(PI)) * sqrt(theta - (sin(TODEG * (2 * theta)) / 2) + C * pow(sin(TODEG * theta), 3));

        rotate([0, 0, -90]) polygon(points = [[x_last - L, 0], [x - L, 0], [x - L, y], [x_last - L, y_last]], convexity = 10);
    }
  }