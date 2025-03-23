Class BW_Grenade : Actor
{
    default
    {
        bouncecount 4;
        +bounceonceilings;
		+bounceonfloors;
		+bounceonwalls;
        bouncefactor 0.6;
		wallbouncefactor 0.35;
        +missile;
		projectile;
		mass 5;
		height 2;
		radius 2;
		speed 15;
        damagetype "Explosive";
        +dropoff;
		+movewithsector;
		+forcexybillboard;
		+rollsprite;
		+rollcenter;
        -nogravity;
    }
    states
    {
        spawn:
            GRND H 2 A_setRoll(roll + rolldirspd,SPF_INTERPOLATE);
            loop;
        Death:
            TNT1 A 0 A_explode();
            MISL BCD 2 bright;
            TNT1 A 1;
            stop;
    }
    int rolldirspd;
    override void postbeginplay()
    {
        super.postbeginplay();
        rolldirspd = random(30,60) * randompick(-1,1);
    }
}