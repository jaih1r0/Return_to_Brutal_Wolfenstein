
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
            TNT1 A 0 A_QuakeEx(1,1,1,35,0,250,"",QF_SCALEDOWN|QF_SCALEUP);
            TNT1 A 0 A_NoBlocking();
            COLM B -1;
            stop;
    }
    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        if((flags & DMG_EXPLOSION) || mod == 'Explosive' || mod == 'Extreme' || mod == 'LF')
            damage *= 10;
        else
            damage = damage > 1000 ? damage : 1;    //let it be mdk'ed
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}


Class BW_RedColumn : BW_StoneColumn //1310
{
    states
    {
        spawn:
            EPTW A -1;
            stop;
        //couldnt find the red column death sprites

    }
}

Class BW_RedTallColumn : BW_RedColumn //1311
{
    default
    {
        height 128;
    }
    states
    {
        spawn:
            EPTW B -1;
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
            bspecial = false;
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
            A_Startsound("Health/Well");
            toucher.A_log(string.format("You drank from a pit! (+%d health)",giveamt));

            let bwp = BWPlayer(toucher);
            if(bwp)
                bwp.playergothealed(giveamt);
            //A_Startsound();
        }
        super.touch(toucher); //i think this actually does nothing
    }
}

Class BW_HealingWell2 : BW_HealingWell replaces skullcolumn //no wonder it didnt fucking work at first
{}






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

Class BW_Electricity : BW_Decoration //7203
{
    //$Category BW new props
    //$Title Eletricity
    default
    {
        Radius 16;
        Height 64;
        +solid;
    }
    states
    {
        spawn:
            //TNT1 A 0 A_Startsound("Eletric");
            STIC AB 10 bright;
            loop;
        Spawn2:
            STIC C -1;
            stop;
    }
}






Class BW_MutantGlass : BW_Decoration   //7204, easy 7205, easy 7206 hard
{
    states
    {
        Spawn:
            MNTG A -1;
            stop;
            TNT1 A 0 A_jumpif(bdormant,"Spawn"); //man...
            Goto SOURPRISE;
        Sourprise:
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 A_Spawnitem("BW_Mutant");
            MNTG B -1;
            stop;
    }

    override void activate(actor activator)
    {
        setstatelabel("Sourprise");
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

Class BW_EarthQuaker : actor    //7300 7301
{
    states
    {
        Spawn:
            TNT1 A 0;
            TNT1 A random(200,800);
            TNT1 A 3 A_QuakeEx(random(1,3),random(1,3),random(1,3),random(50,100),0,3500,"Nothing",QF_SCALEUP|QF_SCALEDOWN|QF_FULLINTENSITY);
            TNT1 A 1 A_Startsound("Stone/sound",0,0,0.8,ATTN_NONE);
            loop;
    }
}

Class BW_SilentAlarm : actor //7299
{
    default
    {
        //spawnID 34;
        Radius 16;
        Height 54;
        -solid;
        //monster;
        //-countkill;
        +friendly;
        +LOOKALLAROUND
		+FRIENDLY
		+SHOOTABLE;
    }
    states
    {
        spawn:
            TNT1 A 1;
            TNT1 A 0 A_AlertMonsters();
            TNT1 AA 5;
            stop;
            TNT1 A 1;
            TNT1 AA 0 A_AlertMonsters(0,AMF_TARGETEMITTER);
            TNT1 A 1;
            TNT1 AA 0 A_AlertMonsters(0,AMF_TARGETEMITTER);
            TNT1 A 1;
            TNT1 AA 0 A_AlertMonsters(0,AMF_TARGETEMITTER);
            stop;
    }
}

Class BW_ToxicSmokeHandler : Actor
{
    default
    {
        +nointeraction;
        damagetype "Radiation";
        Height 30;
        radius 3;
    }
    int maxlife;
    array<actor> clouds;
    override void postbeginplay()
    {
        super.postbeginplay();
        maxlife = TICRATE * random(1,5);
        for(int i = 0; i < random(5,10);i++)
        {
            actor cl = spawn("BW_ToxicSmoke",(pos + (random(-20,20),random(-20,20),random(5,height))));
            if(cl)
            {
                cl.vel = (frandom(-0.1,0.1),frandom(-0.1,0.1),frandom(0.1,0.1));
                clouds.push(cl);
            }        
        }
        A_AttachLightDef('Lemon','BWRadLight');
    }
    override void tick()
    {
        super.tick();
        if(isfrozen())
            return;
        if(getage() % 5 == 0)
            A_Explode(10,100,0,damagetype:"Radiation");
        if(maxlife)
            maxlife--;
        else
        {
            if(clouds.size() > 0)
            {
                for(int i = 0; i < clouds.size(); i++)
                {
                    clouds[i].bouncecount = 1;
                }
                clouds.clear();
            }
            destroy();
            return;
        }
    }
   
}

Class BW_ToxicSmoke : Actor
{
    default
    {
        renderstyle "add";
        //+missile;
        //+ripper;
        +bright;
        +nointeraction;
        bouncecount 0;
        scale 0.32;
        +rollsprite;
        +rollcenter;
    }
    states
    {
        Spawn:
            DB59 K 1 A_SetRoll(roll + rdir);
            TNT1 A 0 A_jumpif(bouncecount,"Death");
            Loop;
        Death:
            DB59 K 1 {
                A_SetRoll(roll + rdir);
                A_Fadeout(0.05);
            }
            loop;
    }
    override void tick()
    {
        super.tick();
        if(isfrozen())
            return;
        if(!bouncecount)
            A_setscale(scale.x * frandom(1.005,1.01));
    }
    int rdir;
    override void postbeginplay()
    {
        super.postbeginplay();
        rdir = random(3,8) * randompick(-1,1);
    }
    
}