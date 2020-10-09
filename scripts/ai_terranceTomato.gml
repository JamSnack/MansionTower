///ai_gremlin();
var xObjective = objective.x;
var yObjective = objective.y;

var x_previous = round(xprevious);
var _x = round(x);

if instance_exists(objective)
{ var canSeeObjective = !collision_line(x,y,objective.x,objective.y,OBSTA,true,false); } 

//Attack Check --------------------------------------------
if objective.canHurt == true
{
    var _xx = x;
    var _yy = y;
    
    if point_in_rectangle(xObjective,yObjective,x-atkBox,y-atkBox+2,x+atkBox,y+atkBox+2)
    {
        with objective  //Hurt the objective.
        {
            var dir = point_direction(x,y,_xx,_yy);
            scr_hurt(other.damage,30,true,0.1);
        }
        
        state = "WANDER";
        stateLock = true;
        alarm[stateLockAlarm] = 30;
    }
}


//----------AI STATES--------------------------

switch state
{    
    case "MOVE":
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
        
        image_angle+=hAccel*4;
        
    }
    break;
    
    case "WANDER":
    {
        if stateLock == false then state = MOVE;
        image_xscale = sign(hAccel)*scale;
    }
    break;
}


//------------------------------------------------------
//Collision and movement
//#region
var _stall = 6;

if !place_meeting(x+hAccel,y,OBSTA)
{ x += hAccel+hForce; }
else
{   
    stateLock = true;
    alarm[stateLockAlarm] = _stall;
    hAccel = -(hAccel+hForce);
}

if !place_meeting(x,y+vAccel,OBSTA)
{ y += vAccel+vForce; }
else
{
    stateLock = true;
    alarm[stateLockAlarm] = _stall;
    vAccel = -(vAccel+vForce);
}

//#endregion

//Knockback Collision ---------------------------------------------
if ( hForce != 0 || vForce != 0 )
{
    if place_meeting(x+hForce,y,OBSTA)
    {
        var dir = sign(hForce);
        
        while !place_meeting(x+hForce,y,OBSTA)
        { x+=dir; }
        hForce = 0;
    }
    
    if place_meeting(x,y+vForce,OBSTA)
    {
        var dir = sign(vForce);
        
        while !place_meeting(x,y+vForce,OBSTA)
        { y+=dir; }
    
        vForce = 0;
    }
    
    if place_meeting(x,y+4,OBSTA)
    {
        hForce = approach(hForce,0,1);
    }
}
