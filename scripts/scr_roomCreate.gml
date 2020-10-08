///scr_roomCreate();
//generate a room.
var roomWidth = 32;
var roomHeight = 24;
var ox = 32;
var oy = 32;


//magic number: for some unknown reason, roomWidth amount of tiles are lost at the end of
//generation. +roomWidth fills in the gaps.
for (i=0;i<=(roomWidth*roomHeight)+roomWidth;i++)
{
    var column = floor(i/roomWidth);
    
    instance_create(i*16-(column*16*roomWidth)+ox,(column*16)+oy,OBSTA);
}

//Spawn some enemieios
repeat(3+irandom(6))
{ instance_create(irandom_range(ox+16,roomWidth-16)*16,irandom_range(oy-16,roomHeight-16)*16,obj_skull); }

//Camera point
//instance_create(roomWidth/2,roomHeight/2,obj_cameraPoint);
camera.view_zoom = 0.82;
