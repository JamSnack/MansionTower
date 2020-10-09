///scr_hurt(damage,time,knockback,knockAmt);
var damage = argument0; //Damage dealt
var time = argument1; //Time until it can be hurt again.
var knock = argument2; //Whether or not to apply knockback.
var knockAmt = argument3; // How much knockback to be applied.

//Destroy things that are not the player object when enough damage is dealt.
if hp-damage <= 0
{
    if object_get_name(object_index) == "obj_player"
    {
        dead = true;
    } else instance_destroy();
}

canHurt = false;
alarm[hurtAlarm] = time;
hp -= damage;

if knock == true
{
    hForce += knockAmt*(x-other.x);
    vForce += knockAmt*(y-other.y);
    knockBack = true;
    
    if knockType == "LAND"
    {
        if place_meeting(x+hForce,y,OBSTA)
        {
            hForce = 0;
        }
        
        if place_meeting(x,y+vForce,OBSTA)
        {
            vForce = 0;
        }
    }
}

//--Display pop message--
var c;
if object_index == obj_player then c = c_red else c = c_white;
scr_popMessage(string(damage),global.fnt_menu,0.4,c,x,y);
