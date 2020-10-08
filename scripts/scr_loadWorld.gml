///scr_loadWorld();
randomize();
var sizeX = 64; //64x30 target world size. Repeated on the other side of the flat lands.
var sizeY = 30;

var xx = 0;
var yy = room_height/2-48; //-48 includes 3 rows of tiles inside the room.

for(i=0;i<floor(flatLandTotal);i++)
{
    //Raid boundaries defined inside the worldControl object.
    var column = floor(i/_flatX);
    
    if i == 0 then RAIDBOUND_Lower = xx+(16*sizeX)-(8);
    if i == 0 then RAIDBOUND_Upper = (16*sizeX)+(_flatX*16)-(8);
    
    //Spawn flatland blocks.
    instance_create(xx+(16*sizeX)+(16*i)-(column*16*_flatX),yy+(16*column),FLATLAND);
}


//Total amount of positions to iterate through.
var worldLandTotal = ((sizeX*sizeY)*2)+flatLandTotal;


//Dirt and Stone layer
for(i=0;i<160;i++)
{   
    var xInterval = (xx+(i*16)); //The x coordinate
    var c = floor(i/string_length(heightSeed));
    var heightIndex = real(string_char_at(heightSeed,(i-(c*string_length(heightSeed)))))*16;
    var heightDirection = real(string_char_at(heightNegativeSeed,(i-(c*string_length(heightNegativeSeed)))));
    
    //Interpret heightNegativity
    // - Figure out whether or not to negate the number.
    if heightDirection == 0 then heightDirection = -1;
    
    //Create a column using the currently selected hight value.
    for (j=0;j<(heightIndex/16)+(sizeY);j++)
    {
        if j > (heightIndex/16)+irandom_range(6,10) then tileType = obj_stone else tileType = obj_dirt;
        var inst = instance_create(xInterval,yy+(16*j)-(heightIndex*heightDirection)+16,tileType);
        
        if inst.x > RAIDBOUND_Lower && inst.x < RAIDBOUND_Upper && inst.y < stoneLayer
        { with inst instance_destroy(); }
    }
        
}

