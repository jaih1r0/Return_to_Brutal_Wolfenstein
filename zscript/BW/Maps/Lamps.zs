Class BW_Candleabra1 : BW_CeillingDecoration
{
    default
    {
        +NOGRAVITY
        +NoBlood
        -solid
        +dontfall;
        Radius 26;
        Height 19;
        +SpawnCeiling
    }
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,3,(0.4,0.2),'Yellow',0.75);
            }
            YCAN A -1 bright light("CandelabraLight");
            stop;
        Death:
            TNT1 A 0 killFlare();
            TNT1 A 0 spawnDebris("BW_GoldScrap",(pos.xy,pos.z - height * 0.5),random(4,8),6);
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
            TNT1 A 0 spawnDebris("BW_GoldScrap",(pos.xy,pos.z + height * 0.5),random(8,12),6);
            TNT1 A 1;
            stop;
    }

    void spawnDebris(string type,vector3 spos,int amount = 1,int maxforceXY = 10,int maxforceZ = 10)
	{
		if(amount < 1)
			return;
		for(int i = 0; i < amount; i++)
		{
			actor deb = spawn(type,spos);
			if(deb)
			{
				deb.vel = (random(-maxforceXY,maxforceXY),random(-maxforceXY,maxforceXY),random(-maxforceZ,maxforceZ));
			}
		}
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
            CAN5 ABC 3 bright light("BiggerCandelabraLight");
            loop;
        death:
            TNT1 A 0;
            TNT1 A 0 spawnDebris("BW_GlassDebris",(pos.xy,pos.z - height * 0.5),random(6,10),6);
            CAN5 D -1;
            stop;
    }
}

Class BW_GreyLamp : BW_CeillingDecoration
{
    default
    {
        Radius 19;
        Height 10;
    }
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,3,(0.7,0.35),'white');
            }
            GLOC Z -1 bright light("GreyLampLight");
            stop;
        death:
            TNT1 A 0 killFlare();
            TNT1 A 0 SpawnDyingFlare(gfx:"LENSA0");
            TNT1 A 0 spawnDebris("BW_GlassDebris",(pos.xy,pos.z - height * 0.5),random(6,10),6);
            TNT1 AAAAA 0 SpawnDieSpark(0,1);
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
            GLOC Z -1; //bright;
            stop;
        death:
            TNT1 A 0 spawnDebris("BW_GlassDebris",(pos.xy,pos.z - height * 0.5),random(6,10),6);
            EHI2 A -1;
            stop;
    }
}

Class BW_BlueLamp : BW_GreyLamp2
{
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,2,(0.2,0.075),'Blue');
            }
            BLOC A -1 bright light("BlueLampLight");
            stop;
        Death:
            TNT1 A 0 killFlare();
            TNT1 A 0 spawnDebris("BW_GlassDebris",(pos.xy,pos.z - height * 0.5),random(6,10),6);
            BLOC B -1;
            stop;
    }
}

Class BW_RedLamp : BW_GreyLamp2
{
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,3,(0.5,0.20),'Red');
            }
            RLOC A -1 bright light("RedLampLight");
            stop;
        Death:
            TNT1 A 0 killFlare();
            TNT1 A 0 spawnDebris("BW_GlassDebris",(pos.xy,pos.z - height * 0.5),random(6,10),6);
            RLOC B -1;
            stop;
    }
}

Class BW_LittleLamp : BW_CeillingDecoration //7061
{
    default
    {
        +SpawnCeiling;
        Radius 19;
        Height 13;
        Health 15;
    }
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,2,(0.2,0.075),'Yellow');
            }
            LLLM A -1 bright light("CandelabraLight");
            stop;
        Death:
            TNT1 A 0 killFlare();
            TNT1 A 0 spawnDebris("BW_GlassDebris",(pos.xy,pos.z - height * 0.5),random(6,10),6);
            LLLM B -1;
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
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,38,(0.7,0.35),'white');
            }
            DLMP A -1 bright light("TechLampLight");
            stop;
        Death:
            TNT1 A 0 killFlare();
            TNT1 AA 0 BW_SpawnSmokeFx(random(20,40),25,45,gfx:"DIRPD0");
            TNT1 A 0 {
                spawnDebris("BW_GlassDebris",(pos.xy,pos.z + height * 0.5),random(6,10),8);
                spawnDebris("BW_WoodDebris",(pos.xy,pos.z + height * 0.5),random(6,10),6);
            }
            TNT1 A 0 SpawnDyingFlare(38,35,10,gfx:"LENSA0");
            TNT1 AAAAAA 0 SpawnDieSpark(35,2);
            TNT1 A 0 A_NoBlocking();
            YVAS C 1;
            DLMP E -1;
            stop;
    }
}

Class BW_TechLamp2 : BW_TechLamp1 Replaces BlueTorch
{}

Class BW_Lampf : BW_GreyLamp2 Replaces Candlestick 
{
    /*default
    {
        Radius 16;
        Height 56;
        health 50;
        deathheight 38;
        ProjectilePassHeight -16;
        -solid;
    }
    states
    {
        spawn:
            CAND A -1;
            stop;
    }*/
}