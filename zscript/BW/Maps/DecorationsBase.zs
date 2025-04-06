Class BW_Decoration : Actor abstract
{
    bool dorandomflipX;
    property randomflipX:dorandomflipX;
    default
    {
        BW_Decoration.randomflipX true;
    }
    override void postbeginplay()
    {
        super.postbeginplay();
        if(self.dorandomflipX)
            self.bXFLIP = random(0,1);
    }
    BW_Flare flare;
    void killFlare()
    {
        if(flare)
            flare.destroy();
    }
}

Class BW_BJYeah : BW_Decoration
{
	Default
	{
        //Monster;
        //+FRIENDLY;
        //-COUNTKILL;
        Radius 8;
        Height 8;
        -Solid;
        //ProjectilePassHeight 0.16;
	}
	
	States
	{
		Spawn:
			BJVT A 1;
			Goto Move;
		Move:
			TNT1 A 0 A_Recoil(-5);
			BJVT AB 4;
			TNT1 A 0 A_Recoil(-5);
			BJVT CD 4;
			TNT1 A 0 A_Recoil(-5);
			BJVT AB 4;
			TNT1 A 0 A_Recoil(-5);
			BJVT CD 4;
			TNT1 A 0 A_Recoil(-5);
			BJVT AB 4;
			TNT1 A 0 A_Recoil(-5);
			BJVT CD 4;
			Goto Yeah;
		Yeah:
			BJVT EF 5;
			TNT1 A 0 A_StartSound("ohyeah");
			BJVT GH 6;
			BJVT HHHHHHHHHHHHHHH 600;
			Stop;
	}
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

    Void BW_SpawnSmokeFx(int zofs = 10,int life = 10,int size = 30, double initialAlpha = 0.5,string gfx = "SM7CA0")
	{
		FSpawnParticleParams Smkfx;
		Smkfx.Texture = TexMan.CheckForTexture (gfx);
		Smkfx.Color1 = "FFFFFF";
		Smkfx.Style = STYLE_Translucent;
		Smkfx.Flags = SPF_ROLL;
		Smkfx.Vel = (frandom[BWSDEC](0.3,-0.3),frandom[BWSDEC](0.3,-0.3),frandom[BWSDEC](0.5,0.5)); 
		Smkfx.Startroll = random(0,360);
		Smkfx.RollVel = random(3,3);
		Smkfx.StartAlpha = initialAlpha;
        Smkfx.Lifetime = life;
		Smkfx.FadeStep = initialAlpha/life;
		Smkfx.Size = size;
		Smkfx.SizeStep = 1.5;
		Smkfx.Pos = vec3offset(0,0,zofs);
		Level.SpawnParticle (Smkfx);
	}

    void BW_SpawnStickFx(int zoffset = 10,int size = 20)
    {
        FSpawnParticleParams StickFX;
		StickFX.Texture = TexMan.CheckForTexture ("WOODB0");
		StickFX.Color1 = "FFFFFF";
		StickFX.Style = STYLE_Translucent;
		StickFX.Flags = SPF_ROLL;
		StickFX.Vel = (FRandom (-5.1,5.1),FRandom (-5.1,5.1),FRandom (2.5,5.2)); 
		StickFX.accel = (0,0,frandom(-0.5,-1.0));
		StickFX.Startroll = random(0,360);
        StickFX.RollVel = (random(-20,20));
        StickFX.StartAlpha = 1.0;
		StickFX.FadeStep = 0.1;
		StickFX.Size = size;
		StickFX.SizeStep = 0;
		StickFX.Lifetime = random(10,15); 
		StickFX.Pos = vec3offset(random(-radius,radius),random(-radius,radius),zoffset);
		Level.SpawnParticle (StickFX);
    }

    void SpawnDieSpark(int zofs = 0,int sidethrust = 3)
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("SPKOA0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_Add;
		PUFSPRK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		PUFSPRK.Vel = (random(-sidethrust,sidethrust),random(-sidethrust,sidethrust),random(-2,3));
		PUFSPRK.accel = (0,0,frandom(-1.75,-0.75));
		PUFSPRK.Startroll = randompick(0,90,180,270,360);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = 0.075;
		PUFSPRK.Size = random(8,14);
		PUFSPRK.SizeStep = -0.5;
		PUFSPRK.Lifetime = random(12,18); 
		PUFSPRK.Pos = pos + (0,0,zofs);
		Level.SpawnParticle(PUFSPRK);
	}

    void SpawnDyingFlare(int zofs = 0,int startsize = 28, int life = 35, double startalpha = 0.7, string gfx = "LENYA0")
	{
		FSpawnParticleParams FLARPUF;
		FLARPUF.Texture = TexMan.CheckForTexture(gfx);
		FLARPUF.Style = STYLE_ADD;
		FLARPUF.Color1 = "FFFFFF";
		FLARPUF.Flags =SPF_FULLBRIGHT;
		FLARPUF.StartRoll = 0;
		FLARPUF.StartAlpha = startalpha;
		FLARPUF.Size = startsize;
		FLARPUF.Lifetime = life; 
        FLARPUF.SizeStep = -startsize / life + 1;
        FLARPUF.FadeStep = startalpha/life;
		FLARPUF.Pos = pos + (0,0,zofs);
		Level.SpawnParticle(FLARPUF);
	}
}

Class BW_CeillingDecoration : BW_ShootableDecoration abstract
{
    default
    {
        +NOGRAVITY
        +NoBlood
        -solid
        +dontfall;
        +SpawnCeiling;
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
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(20,40),25,45);
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
            YCAN A -1 bright;
            stop;
        Death:
            TNT1 A 0 killFlare();
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
        Radius 19;
        Height 10;
    }
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,3,(0.7,0.35),'white');
            }
            GLOC Z -1 bright;
            stop;
        death:
            TNT1 A 0 killFlare();
            TNT1 A 0 SpawnDyingFlare(gfx:"LENSA0");
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
            BLOC A -1 bright;
            stop;
        Death:
            TNT1 A 0 killFlare();
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
            RLOC A -1 bright;
            stop;
        Death:
            TNT1 A 0 killFlare();
            RLOC B -1;
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
            TNT1 A 0 {
                BW_SpawnSmokeFx(10,20,80);
                BW_SpawnSmokeFx(20,20,50);
                BW_SpawnSmokeFx(35,20,40);
                BW_SpawnSmokeFx(50,20,40);
            }
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
            TNT1 AA 0 BW_SpawnSmokeFx(random(15,30),25,30);
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
            TNT1 AA 0 BW_SpawnSmokeFx(random(5,22),25,45,gfx:"DIRPC0");
            TNT1 AA 0 BW_SpawnSmokeFx(random(15,40),25,45,gfx:"DIRPD0");
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
            TNT1 AA 0 BW_SpawnSmokeFx(random(5,22),25,45,gfx:"DIRPC0");
            BVA1 C -1;
            stop;
    }
}

Class BW_vasePlant1 : BW_ShootableDecoration    //7059
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
            PLNT A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AA 0 BW_SpawnSmokeFx(random(5,30),25,45,gfx:"DIRPC0");
            PLNT C -1;
            stop;
    }
}

Class BW_vasePlant2 : BW_vasePlant1 //7060
{
    states
    {
        spawn:
            PLMT A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AA 0 BW_SpawnSmokeFx(random(5,30),25,45,gfx:"DIRPC0");
            PLMT C -1;
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
            TNT1 AAA 0 BW_SpawnSmokeFx(random(10,40),25,45,gfx:"DIRPD0");
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
            TNT1 A 0 nodelay {
                flare = BW_Flare.NewFlare(self,38,(0.7,0.35),'white');
            }
            DLMP A -1 bright;
            stop;
        Death:
            TNT1 A 0 killFlare();
            TNT1 AA 0 BW_SpawnSmokeFx(random(20,40),25,45,gfx:"DIRPD0");
            TNT1 A 0 SpawnDyingFlare(38,35,10,gfx:"LENSA0");
            TNT1 AAAAAA 0 SpawnDieSpark(0,2);
            TNT1 A 0 A_NoBlocking();
            YVAS C 1;
            DLMP E -1;
            stop;
    }
}

Class BW_TechLamp2 : BW_TechLamp1 Replaces BlueTorch
{}


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
            toucher.A_Setblend(0x98F5F9,0.1,7);
            A_Startsound("misc/health_pkup");
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
    }
    states
    {
        spawn:
            WB1T A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Startsound("Barrel/Explosion");
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(10,40),45,50,gfx:"SMO1A0");
            TNT1 A 0 A_spawnitem("BW_BarrelExplosionFx");
            TNT1 A 0 A_Explode(400,200,damagetype:"Explosive");
            WBDT A -1;
            stop;
    }
}

//skeletons
Class BW_Skeleton1 : BW_ShootableDecoration replaces HangTSkull
{
    default
    {
        Radius 16;
        Height 64;
        health 50;
        deathheight 38;
    }
    states
    {
        spawn:
            HDB4 A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(20,40),35,45);
            SKPO B -1;
            stop;
    }
}


//
Class BW_WashBasin : BW_ShootableDecoration Replaces HangTLookingUp 
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
            HDB5 A -1;
            stop;
        death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AA 0 BW_SpawnSmokeFx(random(10,40),35,45);
            LAVA C -1;
            stop;
    }
}

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

Class BW_WaterLeakage : BW_Decoration replaces RedTorch
{
    default
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
            TRED ABCD 4;
            loop;
    }
}

Class BW_TorchTree1 : BW_Decoration replaces TorchTree
{
    default
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
            TRE1 A -1;
            stop;
    }
}

Class BW_Pots1 : BW_Decoration replaces HangNoGuts
{
    default
    {
        Radius 16;
        Height 88;
        health 50;
        deathheight 38;
        ProjectilePassHeight -16;
        -solid;
        +NOGRAVITY
        +SPAWNCEILING
    }
    states
    {
        spawn:
            HDB1 A -1;
            stop;
    }
}

Class BW_Pots2 : BW_Pots1 replaces HangBNoBrain
{
    states
    {
        spawn:
            HDB2 A -1;
            stop;
    }
}

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
    }
    states
    {
        spawn:
            GEBL ABCD 4;
            loop;
        Death:
            GEBL AB 1;
            BEXP CD 2;
            TNT1 A 0 A_Startsound("Barrel/Explosion");
            TNT1 A 0 A_NoBlocking();
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(10,40),45,50,gfx:"SMO1A0");
            TNT1 A 0 A_Spawnitem("BW_BarrelExplosionFx");
            TNT1 A 0 A_Explode(400,200,damagetype:"Explosive");
            MP1C A -1;
            stop;
    }
}

Class BW_BloodPool : BW_Decoration Replaces HangTNoBrain
{
    default
    {
        scale 0.5;
    }
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                frame = random(0,7);
                scale *= frandom(0.9,1.5);
            }
            NGMV # -1;
            stop;
    }
} 

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

Class BW_CagedSkelly : BW_ShootableDecoration replaces HangTLookingDown
{
    default
    {
        Radius 16;
        Height 54;
        health 15;
        deathheight 38;
    }
    states
    {
        spawn:
            HDB3 A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(20,40),35,45);
            GAB1 ABC 3;
            GAB1 D -1;
            stop;
    }
}

Class BW_Cage : BW_CagedSkelly replaces meat3
{
    states
    {
        spawn:
            SUIN E -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(20,40),35,45);
            GAB1 ABC 3;
            GAB1 D -1;
            stop;
    }
}

//the same as the two above, but spawn in ceilling
Class BW_Cage2 : BW_Cage //7050
{
    default
    {
        +nogravity;
        +SpawnCeiling;
    }
    /*override void postbeginplay()
    {
        super.postbeginplay();
        setz(ceilingz - height);
    }*/
}

Class BW_CagedSkelly2 : BW_CagedSkelly //7051
{
    default
    {
        +nogravity;
        +SpawnCeiling;
    }
    /*override void postbeginplay()
    {
        super.postbeginplay();
        setz(ceilingz - height);
    }*/
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

Class BW_Stove : BW_ShootableDecoration replaces DeadStick
{
    default
    {
        Health 20;
        Radius 16;
        Height 80;
        damagetype "Explosive";
    }
    states
    {
        spawn:
            POL1 A -1;
            stop;
        Death:
            DAMN AB 2;
            TNT1 A 0 A_Scream();
            TNT1 A 0 A_Spawnitem("BW_BarrelExplosionFx");
            TNT1 A 0 A_Explode(400,200,damagetype:"Explosive");
            BEXP Z 1;
            stop;
    }
}

Class BW_BoneStack : BW_ShootableDecoration replaces ColonGibs
{
    default
    {
        Radius 16;
        Height 20;
        health 150;
        deathheight 38;
        -solid;
    }
    states
    {
        spawn:
            POB1 A -1;
            stop;
        Death:
            TNT1 AA 0 BW_SpawnSmokeFx(5,35,30);
            TNT1 A 1;
            stop;
    }
}

Class BW_BloodyBoneStack : BW_BoneStack replaces Meat4
{
    states
    {
        spawn:
            HDB6 A -1;
            stop;
    }
    
}

Class BW_BloodyBoneStack2 : BW_BloodyBoneStack replaces nonsolidmeat4
{}

Class BW_Skelly : BW_BoneStack replaces BrainStem
{
    states
    {
        spawn:
            BRS1 A -1;
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
            TNT1 A 1;
            stop;
    }
}


Class BW_DustPile1 : BW_Decoration Replaces ShortBlueTorch   //55
{
    default
    {
        Radius 16;
        Height 56;
        ProjectilePassHeight -16;
        -SOLID;
    }
    States
    {
        Spawn:
            SMBT B -1;
            Stop;
    }
}

Class BW_DustPile2 : BW_DustPile1 replaces ShortRedTorch //57
{
    States
    {
        Spawn:
            SMRT B -1;
            Stop;
    }
}

Class BW_DustPile3 : BW_DustPile1 replaces ShortGreenTorch //56
{
    States
    {
        Spawn:
            SMGT B -1;
            Stop;
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