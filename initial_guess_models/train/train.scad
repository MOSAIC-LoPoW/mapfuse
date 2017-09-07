$fn=100;
//include <MCAD\regular_shapes.scad>

                    /////VISIBLE FEATURES\\\\\
showTank = true;
showChassis = true;
showPlate = true;            

					/////PARAMETERS\\\\\
tank_radius = 1.218;
tank_length = 6;
tank_t = 0.1;
tank_end = 0.15;
tank_plate_height = 0.1;

basePlate_height = 0.30;
basePlate_length = 8;
basePlate_width = 2.3;
bumper_length = 0.577;
bumper_radius = 0.125;

wheel_radius = 0.465;
wheel_t = 0.2;
axis_length = 1.361;
axis_radius = 0.05;
dist_between_wheels = 4.225;


					/////MODULES\\\\\    
module tank(){
    difference() {
		cylinder(h=tank_length, r1=tank_radius, r2=tank_radius, center=false);
		translate([0,0,-tank_t])cylinder(h=tank_length+tank_t*2, r1=tank_radius-tank_t, r2=tank_radius-tank_t, center=false);
	}
	difference(){
		scale([1,1,tank_end])sphere(tank_radius,false);
		cylinder(h=tank_length+tank_t*2, r1=tank_radius+tank_t, r2=tank_radius+tank_t, center=false);
	}
	difference(){
		translate([0,0,tank_length])scale([1,1,tank_end])sphere(tank_radius,false);
		cylinder(h=tank_length-tank_t, r1=tank_radius+tank_t, r2=tank_radius+tank_t, center=false);
	}
    translate([-(tank_radius+tank_t*2),-tank_radius/2,tank_length])rotate([0,90,0])cube([tank_length,tank_radius,tank_plate_height],false);
}

module basePlate(){
	difference(){
		cube([basePlate_length,basePlate_width,basePlate_height],false);
		translate([0.2,0.2,-0.15])cube([basePlate_length-0.4,basePlate_width-0.4,0.3],false);
	}
    
    //BUMPERS
    translate([0,basePlate_width-0.2,basePlate_height/2])rotate([0,-90,0])bumper();
    translate([0,0.2,basePlate_height/2])rotate([0,-90,0])bumper();
    translate([basePlate_length,basePlate_width-0.2,basePlate_height/2])rotate([0,90,0])bumper();
    translate([basePlate_length,0.2,basePlate_height/2])rotate([0,90,0])bumper();
}

module bumper(){
    cylinder(h=bumper_length, r1=bumper_radius, r2=bumper_radius, center=false);
    translate([0,0,bumper_length-0.025])cube([0.35,0.35,0.05],true);
}

module chassis(){
    rotate([0,-90,0])wheel();
    translate([axis_length/2+wheel_t/2,0,0])rotate([0,90,0])cylinder(h=axis_length, r1=axis_radius, r2=axis_radius, center=true);
    translate([axis_length+wheel_t,0,0])rotate([0,90,0])wheel();
}
module wheel(){
    cylinder(h=wheel_t, r1=wheel_radius, r2=wheel_radius, center=true);
    translate([0,0,wheel_t])cube(wheel_t,true);
}

module wagon(){
    if(showPlate) basePlate();
        
    if(showTank) translate([0,basePlate_width/2,tank_radius+tank_t])translate([bumper_length,0,0])rotate([0,90,0])tank();
        
    if(showChassis) translate([bumper_length*2,basePlate_width/6,-(wheel_radius+0.05)])rotate([0,0,90])chassis();
    if(showChassis) translate([bumper_length*1.5+dist_between_wheels+wheel_radius*1.5,basePlate_width/6,-(wheel_radius+0.05)])rotate([0,0,90])chassis();
}

translate([bumper_length,0,wheel_radius*2+0.05])wagon();



//chassis();

