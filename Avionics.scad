//  Parametric Avionics Bay
//  by Jonathan Nobels, 2017
//
//  I dedicate any and all copyright interest in this software to the public domain.
//  I make this dedication for the benefit of the public at large and to the
//  detriment of my heirs and successors. I intend this dedication to be an overt
//  act of relinquishment in perpetuity of all present and future rights to this
//  software under copyright law. See <http://unlicense.org> for more info.
//


// 1.5" Mailing Tube
//TUBE_ID = 38.2;
//TUBE_OD = 41.2;

// 2.5" Mailing Tube w 29mm motor.
TUBE_ID = 63.65;
TUBE_OD = 66.9;


// For 3" Mailing Tube
//TUBE_ID = 75.85;          //Tube inner diameter
//TUBE_OD = 78.75;          //Tube outer diameter


LENGTH = 120;
CAP_INSET=8;
PLATE_RET_OD = 10;
WALL_THICKNESS = 1.6;

$fn=180;
translate([0,0,3])
  av_tube();
av_bulkhead();
  translate([0,0,6])

//This prints very weak and requires a glued in cardboard sleeve
module av_tube()
{
  RING_THK = WALL_THICKNESS*2;
  union(){       
    difference() {
      union() {
        translate([0,0,LENGTH/2]){
          cylinder(r=TUBE_OD/2, h=25, center=true);
        }  
        cylinder(r=TUBE_ID/2, h=LENGTH, center=false);
      }
      cylinder(r=TUBE_ID/2-WALL_THICKNESS, h=(LENGTH)*2.1, center=true);
    }  
  }
}


module av_bulkhead()
{
  difference() {
    union(){
        cylinder(r=TUBE_ID/2, h=3.5, center=false);
        cylinder(r=TUBE_ID/2-WALL_THICKNESS-.1, h=6.0, center=false);
    }
    cylinder(r=1.5, h=20, center=true);
    for(x = [-TUBE_ID/2+8, TUBE_ID/2-8]) {
      translate([x,0,0]) {
       cylinder(r=3.0, h=20, center=true);
      }
    }
  }
}



