//  Parametric Moddel Rocket Component Library
//  by Jonathan Nobels, 2017
//
//  I dedicate any and all copyright interest in this software to the public domain.
//  I make this dedication for the benefit of the public at large and to the
//  detriment of my heirs and successors. I intend this dedication to be an overt
//  act of relinquishment in perpetuity of all present and future rights to this
//  software under copyright law. See <http://unlicense.org> for more info.
//
//  threads.scad is GPL.  So maybe this is too. INAL.  Consult one.

include <threads.scad>
include <nosecones.scad>

// 1.5" Mailing Tube
//TUBE_ID = 38.2;
//TUBE_OD = 41.2;

// 2.5" Mailing Tube
TUBE_ID = 63.65;
TUBE_OD = 66.9;

// For 3" Mailing Tube
//PARAMETERS
//TUBE_ID = 75.85;          //Tube inner diameter
//TUBE_OD = 78.75;          //Tube outer diameter


MOTOR_OD = 29.75;           //Motor OD.  Include some tolerance here
MOTOR_LEN = 160;            //Motor length.  Total len is MOTOR_LEN+RET_TNK
RET_THK = 3.5;              //Retainer thickness
WALL_THK = 1.5;             //1.5 default
TC_LEN = 20;                //Tail cone length
TC_CUTOFF=12;
THREAD_LEN = 12.5;          //Length of the retainer threads
TOL = .1;                   //Fit tolerance for retainers and cetnering ring
LUG_LEN = 20;               //Launch Lug Length
LL_BASE_OFFSET=5.5;         //Increase/decrease to change the lug base thickness
FIN_THICKNESS = 3.35;       //Fin Thickness
FIN_ANGLES = [0,120,240];   //Fin Angles.  None for no fin guides
FIN_RET_THK = 2.0;          //Fin guide thickness

BOOSTER_ID = 22.0;
BOOSTER_T_ID = 24.0;
BOOSTER_OD = 25.0;
PORT_LEN = 40.0;
MOUNT_LEN=30.0;
THREAD_DIAMETER = MOTOR_OD + 10;


$fn = 180;

//translate([-TUBE_OD*.5,-10,0])launch_lug();
//translate([-TUBE_OD*.5,+10,0])launch_lug();
//launch_lug();

//translate([-TUBE_ID-4, 0, 0]) tail_cone();
//dual_mount();
//engine_mount();
//centering_ring();
//translate([0,30,0])rotate([0,0,-90])motor_retainer_inner();
//translate([0,-30,0])color([1,0,0])motor_retainer_outer();
//booster_port();
//booster_mount();

//Simple sleeve and bulkhead
//payload_adapter();


module engine_mount() 
{
  or = MOTOR_OD/2 + WALL_THK ;
  ir = MOTOR_OD/2;
  length = MOTOR_LEN + RET_THK;
  t = FIN_THICKNESS;
  wt = FIN_RET_THK;
  union() {
    difference() {
      union() {
        intersection() {
          cylinder(h=length, r=TUBE_ID/2, center=false);
          for(angle = FIN_ANGLES)  {    
            rotate([0,0,angle])    
            for(x = [t/2,-t/2-wt]) {    
              translate([x,0,0])
                  cube([wt,TUBE_ID/2,length-25], center=false);
              }
          }
        }
        cylinder(h=length, r=or, center=false);
      }
      translate([0,0,-1])
         cylinder(h=length+2, r=ir, center=false);
    }
    difference() {
      or = TUBE_ID / 2;
      ir = MOTOR_OD/2;
      length = RET_THK;
      cylinder(h=length, r=or, center=false);
      translate([0,0,-1]) 
        cylinder(h=length+2, r=ir, center=false);
    }
    translate([-3,or,0]){ 
    }
  }
}

module centering_ring()
{
  or = MOTOR_OD/2 + WALL_THK ;
  ir = MOTOR_OD/2;
  length = MOTOR_LEN + RET_THK;
  difference() {
    or = TUBE_ID / 2;
    ir = MOTOR_OD/2 + WALL_THK+TOL;
    cylinder(h=RET_THK, r=or, center=false);
    translate([0,0,-1]) {
      cylinder(h=RET_THK+2, r=ir, center=false);
      cube(size = [ir*2 + 4, 6, RET_THK+8], center=true);
    }
  } 
}

module dual_mount() 
{
  or = MOTOR_OD/2 + WALL_THK ;
  ir = MOTOR_OD/2;
  length = MOTOR_LEN - MOTOR_EXT + RET_THK;
  union() {
    difference() {
      union() {
        translate([-or-2,0,0])
          cylinder(h=length, r=or, center=false);
        translate([or+2,0,0])
          cylinder(h=length, r=or, center=false);
        translate([-3,-3,0])
          cube([6,6,length*.8],center=false);
      }
      union() {
        translate([-or-2,0,-1])
          cylinder(h=length+2, r=ir, center=false);
        translate([or+2,0,-1])
          cylinder(h=length+2, r=ir, center=false);
      }
    }

    difference() {
      orr = TUBE_ID / 2;
      irr = MOTOR_OD/2 - 2;
      length = RET_THK;
      cylinder(h=length, r=orr, center=false);
      translate([or+2,0,-1]) 
        cylinder(h=length+2, r=irr, center=false);
      translate([-or-2,0,-1]) 
        cylinder(h=length+2, r=irr, center=false);
    }
  }
  //Centering Ring
  translate([TUBE_ID+4, 0, 0]) {
    difference() {
      or = TUBE_ID / 2;
      ir = MOTOR_OD/2 + WALL_THK;
      length = RET_THK;
      union() {
          cylinder(h=length, r=or, center=false);
      }
      translate([-ir-2,0,-1]) {
        cylinder(h=length+2, r=ir, center=false);
          //cube(size = [ 6,ir*2 + 4, RET_THK+8], center=true);
      }
      translate([ir+2,0,-1]) {
        cylinder(h=length+2, r=ir, center=false);
          //cube(size = [ 6, ir*2 + 4, RET_THK+8], center=true);
      }
    } 
  } 
}



module tail_cone() 
{ 
    module tc() {
    difference() {
      or = TUBE_OD / 2;
      ir = MOTOR_OD/2 + WALL_THK + TOL;
      mr = MOTOR_OD/2 + WALL_THK;
      length = TC_LEN;
      cylinder(h=TC_LEN, r1=or, r2 = ir, center=false);
      translate(0,0,-1) {
        cylinder(h=length+2, r=mr, center=false);
        cube(size = [ir*2-3 , 6, TC_LEN*2+2], center=true);
      }
      translate([0,0,TC_CUTOFF*2]) 
        cube([or*2,or*2, TC_CUTOFF*2], center= true);
      } 
    }
    tc();
}

module motor_retainer_inner() 
{
  or = MOTOR_OD/2 + WALL_THK + 10;
  ir = MOTOR_OD/2 + WALL_THK + TOL;
  difference() {
    //2.5 mm differene between this diameter and the other
    metric_thread (diameter=THREAD_DIAMETER, pitch=2.2, 
                   length=THREAD_LEN, groove=false);
    cylinder(h=THREAD_LEN*2+5, r=ir, center = true);  
  }
}

module motor_retainer_outer() 
{
  ir = MOTOR_OD/2 + WALL_THK + TOL;
  length = THREAD_LEN+6;
  startAngle = 0;
  angleInc = 360/15;
  union() {
    difference() {
      cylinder(h=length, r=MOTOR_OD/2+8, center = false);  
      metric_thread (diameter=THREAD_DIAMETER+2.5, pitch=2.2, 
                     length=length+1, groove=true);
      for(i=[0:14]) {
          angle = angleInc * i;
          rotate([0,0,angle])
          translate([MOTOR_OD/2+8.1,0,0])
            cube([2,4,60],center = true);
      }
    }
    translate([0,0,0]) difference() {
           cylinder(h=3, r=MOTOR_OD/2+7, center = false); 
           cylinder(h=15, r=ir-3.2, center = true);  
    }
  }
}

module launch_lug()
{
  ll_size = 4.8;  //1/4"
  ll_width = ll_size + 2;
  ll_base = 5;
  difference() {
    union() {
      cylinder(h=LUG_LEN, r=ll_width/2, center = false);
      translate([-ll_width/2,-ll_width/2,0])
          cube([ll_width, ll_width/2,LUG_LEN]);
      difference() {
          //translate([-ll_width/2-ll_base,-ll_width/2-2,0])
              //cube([ll_width+ll_base*2, 4,LUG_LEN]);
      }
    }
    cylinder(h=LUG_LEN*2.2, r=ll_size/2, center = true);
    translate([0,-TUBE_OD/2-LL_BASE_OFFSET,0])
        cylinder(h=LUG_LEN*2.2, r = TUBE_OD/2, center=true);
  }
}


module booster_port()
{
  translate([0,0,12]){
  difference(){
    union() {
        translate([-12,0,0])cube([24,18,PORT_LEN], center = false);
        cylinder(r = BOOSTER_OD/2, h = PORT_LEN, center = false);
        translate([0,0,-12])cylinder(r = BOOSTER_T_ID/2, h = PORT_LEN, center = false);
        translate([0,0,PORT_LEN])cone_ogive_tan_blunted(R_nose = 4, R = BOOSTER_OD*.5, 
                                                        L = PORT_LEN*1.1, s = 100);
        translate([-10,0,3])cube([20,30,PORT_LEN*1.0], center = false);
      }
      cylinder(r = BOOSTER_ID/2, h = PORT_LEN*2.1, center = true);
      translate([-10,0,3])cube([20,30,PORT_LEN*.7], center = false);
      translate([0,TUBE_OD+16,0])cylinder(r = TUBE_OD, h = PORT_LEN*2.2, center=true);
      translate([0,0,PORT_LEN])
      cone_ogive_tan_blunted(R_nose = 4, R = BOOSTER_OD*.45, 
                             L = PORT_LEN*1.0, s = 100);
    }  
    difference() {
      translate([-10,15,3])cube([20,10,PORT_LEN*.7], center = false);
      translate([-8,0,5])cube([16,28,PORT_LEN*.6], center = false);
    }
  }
}

module booster_mount()
{
  translate([0,0,0]){
  difference(){
    union() {
      translate([-12,0,0])cube([24,18,PORT_LEN], center = false);
      cylinder(r = BOOSTER_OD/2+6, h = PORT_LEN, center = false);
      translate([0,0,-12])cylinder(r = BOOSTER_T_ID/2, h = PORT_LEN, center = false);
      translate([0,0,PORT_LEN])
          cone_ogive_tan_blunted(R_nose = 4, R = BOOSTER_OD*.5+6,
                                 L = 32, s = 100);
      }
      cylinder(r = BOOSTER_OD/2, h = PORT_LEN*5, center = true);
      translate([0,TUBE_OD+16,0])cylinder(r = TUBE_OD, h = PORT_LEN*4.2, center=true);
    }  
  }
        
}

module payload_adapter()
{
  WALL_THICKNESS = 1.6;
  PLATE_THICKNESS = 3.5;
  LENGTH = 70;
  union(){
    difference() {
        cylinder(r=TUBE_ID/2, h=LENGTH, center=false);
        cylinder(r=TUBE_ID/2-WALL_THICKNESS, h=(LENGTH)*2.1, center=true);
    }
    difference() {
      translate([0,0,6])
              cylinder(r=TUBE_ID/2, h=PLATE_THICKNESS, center=true);
      cylinder(r=2,h=30,center=true);
    }
  }
}

