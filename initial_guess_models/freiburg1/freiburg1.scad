$fn=100;
//include <MCAD\regular_shapes.scad>

					/////PARAMETERS\\\\\
ceilings = true;
room_x = 5.7;
room_y = 4.55;
room_z = 3;
wall_t = 0.05;
					 /////MODEL\\\\
room(room_x,room_y,room_z);

					/////MODULES\\\\\

module room(x,y,z){
	difference(){
    	cube([x+wall_t,y+wall_t,z+wall_t]);
			if(ceilings){
				translate([wall_t,wall_t,wall_t]) cube([x-wall_t,y-wall_t,z-wall_t]);
			}
			else{
				translate([wall_t,wall_t,wall_t]) cube([x-wall_t,y-wall_t,z+wall_t]);
			}
	}
}