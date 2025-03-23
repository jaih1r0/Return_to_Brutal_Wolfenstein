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
{}


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
            COLM B -1;
            stop;
    }
    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        console.printf("receiving damagetype: %s",mod);
        if((flags & DMG_EXPLOSION) || mod == 'Explosive' || mod == 'Extreme')
            damage *= 10;
        else
            damage = 0;
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}