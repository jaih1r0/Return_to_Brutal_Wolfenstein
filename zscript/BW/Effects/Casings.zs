Class BW_CasingBase : Actor abstract
{
	string BounceSound;
    property BounceSound:BounceSound;
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
		//scale 0.09;
		+noblockmap;
		+dropoff;
		+thruactors;
		+movewithsector;
		+forcexybillboard;
		+rollsprite;
		+rollcenter;
        scale 0.2;
		+usebouncestate;
        BW_CasingBase.BounceSound "Casing/Brass";
    }
    int RollDir;
    override void beginplay()
	{
		changestatnum(STAT_CASING);
        RollDir = random(10,40) * randompick(-1,1);
		super.beginplay();
	}

    override void tick()
    {
        super.tick();
        if(waterlevel > 1 && vel.length() > 0)
        {
            bBOUNCEONWALLS = bBOUNCEONFLOORS = bBOUNCEONCEILINGS = false;
            vel *= 0.95;
            rolldir = clamp(rolldir * 0.95,3,40);
        }
    }

    void DoCasingRoll()
    {
        A_SetRoll(roll + RollDir);
    }

    void FinishRoll()
    {
        if(waterlevel < 1)
            A_SetRoll(randompick(-90,90),SPF_INTERPOLATE);
    }

    void playbouncesound()
    {
        if(BounceSound)
            A_Startsound(sound(bouncesound),8,attenuation:ATTN_STATIC);
    }

    states
    {
        Bounce:
            TNT1 A 0 playbouncesound();
            TNT1 A 0 A_jump(256,"Spawn");
            stop;
    }
    
}

Class BW_9MMCasing : BW_CasingBase
{
    states
    {
        spawn:
            9MCS A 2 DoCasingRoll();
            loop;
        Death:
            TNT1 A 0 FinishRoll();
            9MCS A -1;
            stop;
    }
}

Class BW_ShellCasing : BW_CasingBase
{
    states
    {
        spawn:
            CAS2 A 2 DoCasingRoll();
            loop;
        Death:
            TNT1 A 0 FinishRoll();
            CAS2 A -1;
            stop;
    }
}

Class BW_792Casing : BW_CasingBase
{
    states
    {
        spawn:
            72CS A 2 DoCasingRoll();
            loop;
        Death:
            TNT1 A 0 FinishRoll();
            72CS A -1;
            stop;
    }
}