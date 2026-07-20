Class BW_Tree1 : BW_ShootableDecoration replaces LiveStick
{
    default
    {
        Radius 16;
        Height 80;
        health 400;
        deathheight 40;
        +solid;
    }
    states
    {
        spawn:
            POL6 A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AA 0 BW_SpawnSmokeFx(random(5,22),45,45,gfx:"DIRPC0");
            TNT1 AA 0 BW_SpawnSmokeFx(random(15,40),45,45,gfx:"DIRPD0");
            TRE2 B -1;
            stop;
    }
}

Class BW_Bush : BW_Decoration replaces TallRedColumn
{
    default
    {
        Radius 16;
        Height 54;
        Projectilepassheight -16;
        -SOLID;
    }
    states
    {
        spawn:
            COL3 A -1;
            stop;
    }
}