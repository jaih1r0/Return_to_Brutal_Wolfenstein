// armor related things

Class BW_Helmet : BasicArmorbonus //132
{
    default
    {
        Radius 20;
        Height 8;
        Inventory.PickUpSound "pickup/armorbonus";
        Inventory.PickupMessage "Picked up a stahlhelm.";
        Armor.SavePercent 50;
        Armor.SaveAmount 25;
        Armor.maxSaveAmount 100;
        -INVENTORY.ALWAYSPICKUP;
        Inventory.Icon "BON2A0";
    }
    states
    {
        spawn:
            BON2 A -1;
            stop;
    }
}

Class BW_ArmorBonus : BW_Helmet replaces  ArmorBonus
{
    default
    {
        Armor.SaveAmount 5;
    }
}

Class BW_DroppedHelmet : BW_ArmorBonus
{
    default
    {
        Armor.maxSaveAmount 125;
    }
}

//couldnt find the respective actors in bw
Class BW_GreenArmor : GreenArmor
{}

Class BW_BlueArmor : BlueArmor
{}


Class BW_EnemyHelmethDrop : actor
{
    default
    {
        +missile;
		projectile;
		mass 5;
		height 2;
		radius 2;
		speed 7;
		-nogravity;
		+bounceonceilings;
		+bounceonfloors;
		+bounceonwalls;
		bouncefactor 0.6;
		wallbouncefactor 0.35;
		Bouncecount 3;
		+noblockmap;
		+dropoff;
		+thruactors;
		+movewithsector;
		+forcexybillboard;
		+rollsprite;
		+rollcenter;
        //scale 0.2;
		//+usebouncestate;
    }
    states
    {
        Spawn:
            BON2 A 2 A_SetRoll(roll + frandom(15,30));
            loop;
        Death:
            TNT1 A 0 {
                A_SetRoll(0,SPF_INTERPOLATE);
                A_Stop();
            }
            BON2 A 2;
            TNT1 A 0 A_Spawnitem("BW_DroppedHelmet");
            stop;
    }
    
}