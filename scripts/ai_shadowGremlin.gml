///ai_gremlin(state,idle_,jump_sprite,move_sprite,speed,objective,jumpSpeed,attackBox);
var current_state = argument0;
var idle_sprite = argument1;
var jump_sprite = argument2;
var move_sprite = argument3;
var spd = argument4;
var objective = argument5;
var jump_speed = argument6;
var atkBox = (argument7)/2;

var xObjective = objective.x;
var yObjective = objective.y;

var x_previous = round(xprevious);
var _x = round(x);

if instance_exists(objective)
{ var canSeeObjective = !collision_line(x,y,objective.x,objective.y,OBSTA,true,false); } 

//Attack Check --------------------------------------------
if objective.canHurt == true
{
    var nearestNoCol = instance_nearest(x,y,PLR_NOCOL);
    var _xx = x;
    var _yy = y;
    
    if point_in_rectangle(xObjective,yObjective,x-atkBox,y-atkBox+2,x+atkBox,y+atkBox+2)
    {
        with objective  //Hurt the objective.
        {
            var dir = point_direction(x,y,_xx,_yy);
            scr_hurt(other.damage,HURT_LONG,true,6,dir);
        }
        
        state = WANDER;
        stateLock = true;
        alarm[stateLockAlarm] = 30;
    } 
    else if instance_exists(PLR_NOCOL) && point_in_rectangle(nearestNoCol.x,nearestNoCol.y,x-atkBox,y-atkBox+2,x+atkBox,y+atkBox+2)
    {
        with nearestNoCol  //Hurt the objective.
        {
            var dir = point_direction(x,y,_xx,_yy-2);
            scr_hurt(other.damage,HURT_LONG,true,6,dir);
        }
    
        state = WANDER;
        stateLock = true;
        alarm[stateLockAlarm] = 30;
    }
}

//---------PIE CHECKS---------------
if target == obj_pie
{
    if x_previous = obj_pie.x //Do not stand on top of pie.
    {
        state = WANDER;
        stateLock = true;
        alarm[stateLockAlarm] = 60;
    }
}


//----------AI STATES--------------------------

switch current_state
{    
    case MOVE:
    {
        //Direction
        var dir = sign(objective.x-x);
        var vdir = sign(objective.y-(y+16));
        
        //Horizontal Acceleration
        if dir == -1 //Objective is to the right
        { if hAccel > -maxAccel then hAccel -= accelRate; }
        else if dir == 1 { if hAccel < maxAccel then hAccel += accelRate; }
        
        //Vertical Acceleration
        if vdir == -1 //Objective is up
        { if vAccel > -maxAccel then vAccel -= accelRate; }
        else if vdir == 1 { if vAccel < maxAccel then vAccel += accelRate; }
        
        image_xscale = dir*scale;
        
    }
    break;
    
    case WANDER:
    {
        if stateLock == false then state = MOVE;
        image_xscale = sign(hAccel)*scale;
    }
    break;
}


//------------------------------------------------------
//Collision and movement
//#region
var targetPlrTile = noone;
var _stall = 1;

if !place_meeting(x+hAccel,y,OBSTA)
{ x += hAccel; }
else
{
    targetPlrTile = instance_place(x+hAccel,y,PLRTILE);
    
    stateLock = true;
    alarm[stateLockAlarm] = _stall;
    hAccel = -hAccel;
}
if !place_meeting(x,y+vAccel,OBSTA)
{ y += vAccel; }
else
{
    targetPlrTile = instance_place(x,y+vAccel,PLRTILE);
    
    stateLock = true;
    alarm[stateLockAlarm] = _stall;
    vAccel = -vAccel;
}

//#endregion

//Attack a tile.
if state != WANDER && targetPlrTile != noone 
{ 
    var _damage = damage;
    if targetPlrTile.canHurt == true then with targetPlrTile scr_hurt(_damage,DEF_HURT,false,0,0);
    
    state = WANDER;
    stateLock = true;
    alarm[stateLockAlarm] = 30;
}

//Knockback Collision ---------------------------------------------
if ( hspeed != 0 || vspeed != 0 )
{
    if place_meeting(x+hspeed,y,OBSTA)
    {
        var dir = sign(hspeed);
        
        while !place_meeting(x+hspeed,y,OBSTA)
        { x+=dir; }
        hspeed = 0;
    }
    
    if place_meeting(x,y+vspeed,OBSTA)
    {
        var dir = sign(vspeed);
        
        while !place_meeting(x,y+vspeed,OBSTA)
        { y+=dir; }
    
        vspeed = 0;
    }
    
    if place_meeting(x,y+4,OBSTA)
    {
        var positivity = sign(hspeed);
    
        if positivity == 1
        {
            hspeed -= DEF_FRIC;
        } else if positivity == -1
        {
            hspeed += DEF_FRIC;
        }
        
        if abs(hspeed) < 1 then hspeed = 0;
    }
}