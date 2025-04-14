//
//  base class for debris actors, these will be cleaned whenever the nashgore cleaner is used
//
Class BW_Debris : actor abstract
{
    override void beginplay()
    {
        super.beginplay();
        changestatnum(STAT_CASING);
    }
    int rollspd;
}

Class BW_BouncingDebris : BW_Debris
{
    default
	{
		projectile;
		+thruactors;
		+noblockmap;
		damage 0;
		speed 6;
		-nogravity;
		+rollsprite;
		+rollcenter;
		+bounceonwalls;
		+bounceonfloors;
		+bounceonceilings;
		bouncecount 2;
		bouncefactor 0.4;
		radius 3;
		height 3;
        +rollsprite;
        +rollcenter;
	}
    override void postbeginplay()
    {
        super.postbeginplay();
        rollspd = random(15,45) * randompick(-1,1);
    }
    bool died;
    
    override void tick()
    {
        if(isfrozen())
            return;
        if(!died)   //stop ticking after stopping bouncing
			super.tick();
        else
        {
            if(getage() % 5 == 0)
                FindFloorCeiling();
            setz(floorz);
        }
        if(bouncecount <= 0 && !died)
        {
            died = true;
            self.bcorpse = true;
            self.bmissile = false;
            self.bnogravity = false;
            self.bnointeraction = true;
        }
    }
    void rolldebris()
    {
        A_SetRoll(roll + rollspd);
    }
}

Class BW_MetalScrap : BW_BouncingDebris
{
    default
    {
        scale 0.2;
    }
    states
    {
        spawn:
            JNK2 A 0;
            JNK3 A 0;
            JNK1 A 0 {
                string spt = "JNK"..random(1,3);
                sprite = GetSpriteIndex(spt);
            }
        SpawnLoop:
            "####" "#" 1 rolldebris();
            loop;
        Death:
            "####" "#" -1;
            stop;
    }
    override void postbeginplay()
    {
        super.postbeginplay();
        A_Setscale(scale.x + frandom(-0.1,0.1));
    }
}

Class BW_Stonebits : BW_BouncingDebris
{
    default
    {
        scale 0.35;
    }
    states
    {
        spawn:
            D1BS A 0;
        SpawnLoop:
            "####" "#" 1 rolldebris();
            loop;
        Death:
            "####" "#" -1;
            stop;
    }
    override void postbeginplay()
    {
        super.postbeginplay();
        A_Setscale(scale.x + frandom(-0.1,0.1));
    }
}

Class BW_WoodDebris : BW_BouncingDebris
{
    default
    {
        scale 0.9;
    }
    states
    {
        spawn:
            WOOD B 0;
        SpawnLoop:
            "####" "#" 1 rolldebris();
            loop;
        Death:
            "####" "#" -1;
            stop;
    }
    override void postbeginplay()
    {
        super.postbeginplay();
        A_Setscale(scale.x + frandom(-0.1,0.1));
    }
}

Class BW_BoneDebris : BW_BouncingDebris
{
    default
    {

    }
    states
    {
        spawn:
            BNP1 A 0;
        SpawnLoop:
            "####" "#" 1 rolldebris();
            loop;
        Death:
            "####" "#" -1;
            stop;
    }
}

Class BW_BoneHeadDebris : BW_BouncingDebris
{
    default
    {

    }
    states
    {
        spawn:
            XHE6 A 0;
        SpawnLoop:
            "####" "#" 1 rolldebris();
            loop;
        Death:
            "####" "#" -1;
            stop;
    }
}