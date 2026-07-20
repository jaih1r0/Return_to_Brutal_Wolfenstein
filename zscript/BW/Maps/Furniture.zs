Class BW_KnightArmor : BW_ShootableDecoration Replaces ShortGreenColumn
{
    default
    {
        Radius 16;
		Height 56;
        +noblood;
        +dontthrust;
    }
    states
    {
        spawn:
            COL2 A -1;
            stop;
        Death:
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(20,40),25,45);
            TNT1 A 0 A_Spawnitem("BW_AxeAmmo");
            TNT1 A 0 A_NoBlocking();
            CAD1 ABC 2;
            CAD1 C -1;
            stop;
    }
}

Class BW_KnightArmor1 : BW_KnightArmor
{}

//tables

Class  BW_Table1 : BW_ShootableDecoration Replaces TallGreenColumn
{
    default
    {
        health 75;
        deathheight 38;
        Radius 16;
        Height 30;
    }
    states
    {
        spawn:
            TAVV A -1;
            stop;
        
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AA 0 BW_SpawnSmokeFx(random(5,22),25,45,gfx:"DIRPD0");
            TABL D -1;
            stop;
        Death.fire:
            TNT1 A 0 A_NoBlocking();
            TABL D -1;
            stop;
    }
}

Class BW_Table2 : BW_ShootableDecoration Replaces HeartColumn //36 translator dont understand the original name, neither do i
{
    default
    {
        health 75;
        deathheight 38;
        
        Radius 16;
        Height 30;
    }
    states
    {
        spawn:
            DIAN A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AA 0 BW_SpawnSmokeFx(random(10,30),25,45,gfx:"DIRPD0");
            TABL B -1;
            stop;
        Death.fire:
            TNT1 A 0 A_NoBlocking();
            ZA9L B -1;
            stop;
    }
}

Class BW_Stove : BW_ShootableDecoration replaces DeadStick
{
    default
    {
        Health 20;
        Radius 16;
        Height 80;
        damagetype "Explosive";
        damagefactor "kick",    0.1;
        damagefactor "melee",   0.1;
    }
    states
    {
        spawn:
            POL1 A -1;
            stop;
        Death:
            DAMN AB 2;
            TNT1 A 0 A_Scream();
            TNT1 A 0 {BW_MiscEffect.SpawnExplotionImpactFx(pos + (0,0,10));}
            TNT1 A 0 A_Spawnitem("BW_BarrelExplosionFx");
            TNT1 A 0 A_QuakeEx(1,1,1,16,0,400,"",QF_SCALEDOWN);
            TNT1 A 0 A_Explode(400,200,damagetype:"Explosive");
            BEXP Z 1;
            stop;
    }
}



Class BW_Bed : BW_ShootableDecoration replaces HeadCandles
{
    default
    {
        Radius 16;
        Height 30;
        health 50;
        deathheight 38;
    }
    states
    {
        spawn:
            POL3 A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            NOO1 A 1;
            NOO1 B -1;
            stop;
    }
}