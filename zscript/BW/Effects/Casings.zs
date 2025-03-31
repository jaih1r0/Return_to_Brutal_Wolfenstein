Class BW_CasingBase : Actor abstract
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
		//scale 0.09;
		+noblockmap;
		+dropoff;
		+thruactors;
		+movewithsector;
		+forcexybillboard;
		+rollsprite;
		+rollcenter;
        scale 0.2;
		//+usebouncestate;
    }
    int RollDir;
    override void beginplay()
	{
		changestatnum(STAT_CASING);
        RollDir = random(10,40) * randompick(-1,1);
		super.beginplay();
	}

    void DoCasingRoll()
    {
        A_SetRoll(roll + RollDir);
    }

    void FinishRoll()
    {
        A_SetRoll(randompick(-90,90),SPF_INTERPOLATE);
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