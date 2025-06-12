Class BW_Grenade : Actor
{
    const FuseDuration = thinker.TICRATE * 2;   //2 seconds
    default
    {
        bouncecount 3;
        +bounceonceilings;
		+bounceonfloors;
		+bounceonwalls;
        +EXPLODEONWATER;
        //+ALLOWBOUNCEONACTORS;
        //+BOUNCEONACTORS;
        bouncefactor 0.4;
		wallbouncefactor 0.35;
        +missile;
		projectile;
		mass 5;
		height 2;
		radius 2;
		speed 20;
        damagetype "Explosive";
        +extremedeath;
        +dropoff;
		+movewithsector;
		+forcexybillboard;
		+rollsprite;
		+rollcenter;
        -nogravity;
        +dontsplash;
        +usebouncestate;
    }

    int Fuse;
    int rolldirspd, endroll;
    bool exploded, unbounce;

    states
    {
        spawn:
            GRND H 2 A_setRoll(roll + rolldirspd,SPF_INTERPOLATE);
            loop;
        SpawnStop:
            GRND H 3 A_SetRoll(endroll,SPF_INTERPOLATE);
        WaitLoop:
            GRND H 1 A_jumpif(!fuse,"Explode");
            loop;
        Death:
            TNT1 A 0 {
                A_Stop();
                A_SetRoll(endroll,SPF_INTERPOLATE);
                bBOUNCEONWALLS = bBOUNCEONFLOORS = bBOUNCEONCEILINGS = false;
            }
            TNT1 A 0 A_jumpif(fuse,"WaitLoop");
        Explode:
            TNT1 A 0 
            {
                A_SetRoll(endroll,SPF_INTERPOLATE);
                A_AlertMonsters();
                if(target && waterlevel > 1 && target.waterlevel < 1) //in water, player is out of water
                    A_Startsound("Grenade/Explosion/Water",10);
                else
                    A_Startsound("Grenade/Explosion",10);
                if(pos.z < floorz < 20)
                    spawn("BW_GroundFireFx",(pos.xy,floorz));
            }
            TNT1 A 0 A_Explode(300,100);
            TNT1 A 0 A_spawnitem("BW_BarrelExplosionFx");
            TNT1 A 5;
            TNT1 AAAAA 1 spawnFxSmokeBasic();
            stop;
        Bounce:
            TNT1 A 0 A_jumpif(unbounce,"SpawnStop");
            TNT1 A 0 A_Startsound("Grenade/Bounce",11); //it needs a better sound
            TNT1 A 0 {rolldirspd * 0.5;}
            goto spawn;
        Bounce.Actor:
            TNT1 A 0 A_Stop();
            TNT1 A 0 {
                unbounce = true;
                bouncefactor = 0;
                rolldirspd = 0;
                fuse *= 0.5;
            }
            goto spawnstop;
        
    }
    

    override void tick()
    {
        super.tick();
        if(isfrozen())
            return;
        if(fuse-- < 1 && !exploded)
        {
            exploded = true;
            bBOUNCEONWALLS = bBOUNCEONFLOORS = bBOUNCEONCEILINGS = false;
            setstatelabel("Explode");
        }
    }

    override void postbeginplay()
    {
        super.postbeginplay();
        Fuse = FuseDuration;
        rolldirspd = random(20,30) * randompick(-1,1);
        endroll = 90 * randompick(-1,1);
    }

    void spawnFxSmokeBasic()
	{
		FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = pos + (random(-20,20),random(-20,20),random(0,45));
        WTFSMK.Texture = TexMan.CheckForTexture("SMO1C0");
		WTFSMK.Color1 = 0xFFFFFF;
		WTFSMK.Style = STYLE_Translucent;
		WTFSMK.Flags = SPF_ROLL;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = random(-5,5);
		WTFSMK.StartAlpha = 0.5;
		WTFSMK.Size = random(60,75);
		WTFSMK.SizeStep = 3;
		WTFSMK.Lifetime = Random(20,35); 
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		WTFSMK.Vel = (frandom[bscsmk](-1.5,1.5),frandom[bscsmk](-1.5,1.5),frandom[bscsmk](-1.5,1.5));
		if(CeilingPic == SkyFlatNum)
			WTFSMK.accel = getwinddir();
		Level.SpawnParticle (WTFSMK);
	}

    vector3 getwinddir()
	{
		if(!level)
			return (0,0,0);
		switch(level.levelnum % 4)
		{
			case 0:	return (0.05,0.05,0.03);	break;
			case 1:	return (-0.05,0.05,0.03);	break;
			case 2:	return (0.05,-0.05,0.03);	break;
			case 3:	return (-0.05,-0.05,0.03);	break;
		}
		return (0,0,0);
	}
}

Class BW_GrenadeSlow : BW_Grenade
{
    default
    {
        speed 5;
        bouncecount 1;
    }
}

//man, those are hard to see
Class BW_enemyGrenade : BW_Grenade
{
    states
    {
        spawn:
            GRND H 2 light("EnemyGrenade") A_setRoll(roll + rolldirspd,SPF_INTERPOLATE);
            loop;
        SpawnStop:
            GRND H 3 light("EnemyGrenade") A_SetRoll(endroll,SPF_INTERPOLATE);
        WaitLoop:
            GRND H 1 light("EnemyGrenade") A_jumpif(!fuse,"Explode");
            loop;
    }
}

Class BW_SmokeGrenade : BW_Grenade
{
	states
	{
		spawn:
            GRND H 2 light("EnemySmokeGrenade") A_setRoll(roll + rolldirspd,SPF_INTERPOLATE);
            loop;
        SpawnStop:
            GRND H 3 light("EnemySmokeGrenade") A_SetRoll(endroll,SPF_INTERPOLATE);
        WaitLoop:
            GRND H 1 light("EnemySmokeGrenade") A_jumpif(!fuse,"Explode");
            loop;
		Explode:
			TNT1 A 0 A_Startsound("Grenade/Explosion",10);
			TNT1 AAAAA 0 spawnSmokeGrenadeFx(true);
			TNT1 AAA 7 spawnSmokeGrenadeFx(false);
			TNT1 AA 0 spawnSmokeGrenadeFx(true);
			TNT1 AAA 7 spawnSmokeGrenadeFx(false);
			TNT1 AA 0 spawnSmokeGrenadeFx(true);
			TNT1 AAA 7 spawnSmokeGrenadeFx(false);
			TNT1 AA 0 spawnSmokeGrenadeFx(true);
			TNT1 AAAAA 7 spawnSmokeGrenadeFx(false);
			TNT1 AA 0 spawnSmokeGrenadeFx(true);
            stop;
	}
	
	
	void spawnSmokeGrenadeFx(bool starting = false)
	{
		FSpawnParticleParams WTFSMK;
		
        WTFSMK.Texture = TexMan.CheckForTexture("SMO1C0");//("X102A0"); 
		WTFSMK.Color1 = 0xFFFFFF;
		WTFSMK.Style = STYLE_Translucent;
		WTFSMK.Flags = SPF_ROLL;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = random(-5,5);
		WTFSMK.StartAlpha = 0.5;
		WTFSMK.Size = random(80,105);
		WTFSMK.SizeStep = 1;
		
		if(starting)
		{
			WTFSMK.Size = random(60,85);
			WTFSMK.Lifetime = random(14,21);
			WTFSMK.Pos = pos + (0,0,5);
			WTFSMK.Vel = (frandom[bscsmk](-3,3),frandom[bscsmk](-3,3),frandom[bscsmk](-0.2,3));
		}
		else
		{
			WTFSMK.StartAlpha = 0.75;
			WTFSMK.Lifetime = Thinker.TICRATE * Random(4,7); 
			WTFSMK.Pos = pos + (random(-20,20),random(-20,20),random(0,32));
			WTFSMK.Vel = (frandom[bscsmk](-0.25,0.25),frandom[bscsmk](-0.25,0.25),frandom[bscsmk](-0.15,0.25));
		}
		
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		
        if(CeilingPic == SkyFlatNum)
			WTFSMK.accel = (getwinddir() * 0.2);

		Level.SpawnParticle (WTFSMK);
	}
	
}