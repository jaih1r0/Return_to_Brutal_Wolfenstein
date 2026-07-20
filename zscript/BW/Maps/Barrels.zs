
Class BW_ExplosiveBarrel : BW_ShootableDecoration replaces explosiveBarrel
{
    default
    {
        DamageType "Explosive";
        Health 20;
        Radius 10;
        Height 34;
        Mass 200;
        -dontthrust;
        +pushable;
        damagefactor "kick",    0.1;
        damagefactor "melee",   0.1;
    }
    states
    {
        spawn:
            GEBL ABCD 4;
            loop;
        Death:
            GEBL AB 1;
            BEXP CD 2;
            TNT1 A 0 A_QuakeEx(1,1,1,16,0,400,"",QF_SCALEDOWN);
            TNT1 A 0 A_Startsound("Barrel/Explosion");
            TNT1 A 0 A_NoBlocking();
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(10,40),45,50,gfx:"SMO1A0");
            TNT1 A 0 {BW_MiscEffect.SpawnExplotionImpactFx(pos + (0,0,10));}
            TNT1 A 0 A_Spawnitem("BW_BarrelExplosionFx");
            TNT1 A 0 A_Explode(400,200,damagetype:"Explosive");
            MP1C A -1;
            stop;
    }
}



//wooden barrels

Class BW_WoodenBarrel : BW_ShootableDecoration  //7022
{
    default
    {
        Mass 200;
        Height 30;
        radius 16;
        deathheight 38;
        health 40;
    }
    states
    {
        spawn:
            COL4 A -1;
            stop;
        Death:
            TNT1 A 0 bw_woodenbarrelDiefx();
            TNT1 A 0 A_NoBlocking();
            WBDT A -1;
            stop;
    }
    void bw_woodenbarrelDiefx()
    {
        BW_SpawnSmokeFx(10,20,80,gfx:"DIRPD0");
        BW_SpawnSmokeFx(25,20,80,gfx:"DIRPD0");
    }

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        int pz= 0;
        if(inflictor)
            pz = inflictor.pos.z;
        else
            pz = random(5,height); 
        for(int i = 0; i < random(3,7); i++)  
            BW_SpawnStickFx(pz,7); //doesnt look really good, but works for now
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}

Class BW_FoodBarrel : BW_WoodenBarrel   //7024
{
    states
    {
        spawn:
            WB1T C -1;
            stop;
        Death:
            TNT1 A 0 bw_woodenbarrelDiefx();
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Spawnitem("StimPack");
            WBDT A -1;
            stop;
    }
}

Class BW_MP40Barrel : BW_WoodenBarrel   //7023
{
    states
    {
        spawn:
            WB1T B -1;
            stop;
        Death:
            TNT1 A 0 bw_woodenbarrelDiefx();
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Spawnitem("BW_MP40");
            WBDT A -1;
            stop;
    }
}

Class BW_GrenadeBarrel : BW_WoodenBarrel //7025
{
    default
    {
        DamageType "Explosive";
        damagefactor "kick",    0.1;
        damagefactor "melee",   0.1;
    }
    states
    {
        spawn:
            WB1T A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_QuakeEx(1,1,1,16,0,400,"",QF_SCALEDOWN);
            TNT1 A 0 A_Startsound("Barrel/Explosion");
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(10,40),45,50,gfx:"SMO1A0");
            TNT1 A 0 {BW_MiscEffect.SpawnExplotionImpactFx(pos + (0,0,10));}
            TNT1 A 0 A_spawnitem("BW_BarrelExplosionFx");
            TNT1 A 0 A_Explode(400,200,damagetype:"Explosive");
            WBDT A -1;
            stop;
    }
}

Class BW_PoisonBarrel : BW_ShootableDecoration  //7202
{
    default
    {
        Radius 16;
        Height 25;
        health 20;
        damagefactor "Radiation",20;
    }
    states
    {
        Spawn:
            YLBR A -1;
            stop;
        Death:
            //TNT1 A 0 spawn toxic smoke
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Explode(5,100,0,damagetype:"Radiation");
            TNT1 A 0 A_Spawnitem("BW_ToxicSmokeHandler");
            //TNT1 A 0 SpawnDebris("BW_ToxicSmoke",(pos + (0,0,height)),random(3,6),3,0.5);
            //TNT1 AAAAA 0 A_Spawnprojectile("BW_ToxicSmoke",18,0,angle:random(0,360),flags:CMF_AIMDIRECTION,pitch:random(-40,40));
            YLBR B -1;
            stop; 
    }
}