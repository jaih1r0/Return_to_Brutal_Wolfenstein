Class BW_Decoration : Actor abstract
{
}

Class BW_ShootableDecoration : BW_Decoration abstract
{
    default
    {
        health 100;
        +shootable;
        +solid;
        +dontthrust;
        +noblood;
    }
}

Class BW_CeillingDecoration : BW_ShootableDecoration abstract
{
    default
    {
        +SpawnCeiling
        +NOGRAVITY
        +NoBlood
        -solid
        +dontfall;
        health 20;
    }
    override void postbeginplay()
    {
        super.postbeginplay();
        setz(ceilingz - height);
    }
}


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
            TNT1 A 0 A_NoBlocking();
            CAD1 ABC 2;
            CAD1 C -1;
            stop;
    }
}

Class BW_KnightArmor1 : BW_KnightArmor
{}

Class BW_Candleabra1 : BW_CeillingDecoration
{
    default
    {
        +SpawnCeiling
        +NOGRAVITY
        +NoBlood
        -solid
        +dontfall;
        Radius 26;
        Height 19;
    }
    states
    {
        spawn:
            YCAN A -1 bright;
            stop;
        Death:
            YCAN B 1;
            TNT1 A 0 A_Spawnitem("FallingCandelabra");
            YCAN D -1;
            stop;
    }
    
}

Class BW_CandelabraY : BW_Candleabra1 Replaces FloatingSkull
{}

Class BW_CandelabraX : BW_Candleabra1 Replaces Column
{}

Class FallingCandelabra : Actor
{
    default
    {
        Radius 26;
        damagetype "Candelabra";
    }
    states
    {
        Spawn:
            YCAN B 1 A_jumpif(pos.z <= floorz + 2,"Death");
            loop;
        Death:
            TNT1 A 0 A_Explode(30,10);
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Startsound("DSBOTTLE");
            YCAN C -1;
            stop;
    }
}

Class BW_Candelabra3 : BW_CeillingDecoration
{
    default
    {
        +SpawnCeiling
        +NOGRAVITY
        +NoBlood
        -solid
        Radius 26;
        Height 60;
        +DontFall
    }
    states
    {
        spawn:
            CAN5 ABC 3 bright;
            loop;
        death:
            TNT1 A 0;
            CAN5 D -1;
            stop;
    }
}

Class BW_GreyLamp : BW_CeillingDecoration
{
    default
    {

    }
    states
    {
        spawn:
            GLOC Z 2 bright;
            loop;
        death:
            EHI2 A -1;
            stop;
    }
}

Class BW_GreyLamp1 : BW_GreyLamp replaces candlestick
{}

Class BW_GreyLamp2 : BW_GreyLamp replaces nonsolidmeat2
{
    states
    {
        spawn:
            GLOC Z 2; //bright;
            loop;
        death:
            EHI2 A -1;
            stop;
    }
}

//columns

Class BW_StoneColumn : BW_ShootableDecoration replaces techpillar
{
    default
    {
        Radius 16;
        Height 64;
        +FORCEYBILLBOARD;
        deathheight 38;
        health 50;
    }
    states
    {
        Spawn:
            ELEC A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            COLM B -1;
            stop;
    }
    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        if((flags & DMG_EXPLOSION) || mod == 'Explosive' || mod == 'Extreme')
            damage *= 10;
        else
            damage = 0;
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}

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
            TABL B -1;
            stop;
        Death.fire:
            TNT1 A 0 A_NoBlocking();
            ZA9L B -1;
            stop;
    }
}

//vase
Class BW_vase1 : BW_ShootableDecoration Replaces HeadsOnAStick 
{
    default
    {
        health 15;
        deathheight 38;
        Radius 16;
        Height 30;
    }
    states
    {
        spawn:
            POL2 A -1;
            stop;
        death:
            TNT1 A 0 A_NoBlocking();
            BVAS C -1;
            stop;
    }
}

Class BW_vase2 : BW_ShootableDecoration Replaces BigTree 
{
    default
    {
        health 20;
        deathheight 38;
        Radius 16;
        Height 54;
    }
    states
    {
        spawn:
            TRE2 A -1;
            stop;
        death:
            TNT1 A 0 A_NoBlocking();
            YVAS C -1;
            stop;
    }
}

Class BW_vase3 : BW_ShootableDecoration Replaces Stalagtite
{
    default
    {
        health 20;
        deathheight 38;
        Radius 16;
        Height 54;
    }
    states
    {
        spawn:
            SMIT A -1;
            stop;
        death:
            TNT1 A 0 A_NoBlocking();
            BVA1 C -1;
            stop;
    }
}

//flags

Class BW_ThirdReachFlag : BW_ShootableDecoration replaces HeadOnAStick
{
    default
    {
        health 25;
        deathheight 38;
        Radius 16;
        Height 64;
    }
    states
    {
        spawn:
            POL4 A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            1OL4 A -1;
            stop;
    }
}

//Lamps
Class BW_TechLamp1 : BW_ShootableDecoration Replaces Candelabra //35
{
    default
    {
        health 20;
        deathheight 38;
        Radius 16;
        Height 54;
    }
    states
    {
        spawn:
            DLMP A -1 bright;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            YVAS C 1;
            DLMP E -1;
            stop;
    }
}




Class BW_Well1 : BW_ShootableDecoration replaces evileye
{
    default
    {
        health 300;
        deathheight 38;
        Radius 16;
        Height 30;
    }
    states
    {
        spawn:
            DIOC A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            PITW C -1;
            stop;

    }
}

Class BW_HealingWell : BW_Well1
{
    default
    {
        +SPECIAL;
    }
    states
    {
        spawn:
            COL6 A -1;
            stop;
        Used:
            DIOC A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            PITW C -1;
            stop;
    }

    bool UsedWeel;

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        if(!UsedWeel)
            damage = 0;
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }

    override void Touch (Actor toucher)
    {
        if(toucher && toucher.player && toucher.health < 100 && !UsedWeel)
        {
            UsedWeel = true;
            int giveamt = 100;
            int skil = G_SkillPropertyInt (SKILLP_SpawnFilter);
            switch(skil)
            {
                case 1: giveamt = 100;  break;
                case 2: giveamt = 100;  break;
                case 4: giveamt = 75;   break;
                case 8: giveamt = 50;   break;
                case 16: giveamt = 25;   break;
            }
            toucher.givebody(giveamt); 
            setstatelabel("Used");
            toucher.A_log(string.format("You drank from a pit! (+%d health)",giveamt));
            //A_Startsound();
        }
        super.touch(toucher); //i think this actually does nothing
    }
}

Class BW_HealingWell2 : BW_HealingWell replaces skullcolumn //no wonder it didnt fucking work at first
{}


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
            TNT1 A 0 A_NoBlocking();
            WBDT A -1;
            stop;
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
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Spawnitem("BW_MP40");
            WBDT A -1;
            stop;
    }
}

Class BW_GrenadeBarrel : BW_WoodenBarrel //7025
{
    states
    {
        spawn:
            WB1T A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Explode();
            WBDT A -1;
            stop;
    }
}


//not really a shootable, not really a decoration
Class BW_StairsHitBox : actor   
{
    //this thing is really spammed in some maps, needs to be replaces with one with a bigger radius
    //so a smalled amount is needed
    //also probably make it change its radius in postbeginplay based on its args[] setted in the map editor
    default
    {   Radius 4;
        Height 32;
        +SOLID;
        +nogravity;
        ProjectilePassHeight 1;
    }
    states
    {
        spawn:
            TNT1 A -1;
            stop;
    }
}