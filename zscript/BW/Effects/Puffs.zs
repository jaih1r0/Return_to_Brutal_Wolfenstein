

Class BW_BulletPuff : Actor replaces bulletpuff
{
	default
	{
		height 1;
		radius 1;
		+noblockmap;
		+nogravity;
		scale 0.1;
	}
	states
	{
		spawn:
            TNT1 A 0 nodelay SpawnPuffFlare(pos);
			FX33 A 1 bright;
            TNT1 A 0 {
                for(int i = 0; i < random(2,5); i++)
                    SpawnPuffSpark(pos);
					spawnFxSmokeBasic();
            }
            FX33 BCDEFGHIJK 1 bright light("BWPuffLight");
			stop;
	}

    void SpawnPuffSpark(vector3 position)
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("SPKOA0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_Add;
		PUFSPRK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		PUFSPRK.Vel = (random(-5,5),random(-5,5),random(-2,9));
		PUFSPRK.accel = (0,0,frandom(-1.75,-0.75));
		PUFSPRK.Startroll = randompick(0,90,180,270,360);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = 0.075;
		PUFSPRK.Size = random(8,14);
		PUFSPRK.SizeStep = -0.5;
		PUFSPRK.Lifetime = random(12,18); 
		PUFSPRK.Pos = position;
		Level.SpawnParticle(PUFSPRK);
	}

    void SpawnPuffFlare(vector3 position)
	{
		FSpawnParticleParams FLARPUF;
		FLARPUF.Texture = TexMan.CheckForTexture("LENYA0");
		FLARPUF.Style = STYLE_ADD;
		FLARPUF.Color1 = "FFFFFF";
		FLARPUF.Flags =SPF_FULLBRIGHT;
		FLARPUF.StartRoll = 0;
		FLARPUF.StartAlpha = 1.0;
		FLARPUF.FadeStep = 0.25;
		FLARPUF.Size = random(20,25);
		FLARPUF.SizeStep = 1; //random(2,4);
		FLARPUF.Lifetime = 4; 
		FLARPUF.Pos = position;
		Level.SpawnParticle(FLARPUF);
	}

	void spawnFxSmokeBasic(string gfx = "PUF2U0", color col = 0xFFFFFF)
	{
		FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = pos;
        WTFSMK.Texture = TexMan.CheckForTexture(gfx);
		WTFSMK.Color1 = col;
		WTFSMK.Style = STYLE_Translucent;
		WTFSMK.Flags = SPF_ROLL;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = random(-5,5);
		WTFSMK.StartAlpha = 0.4;
		WTFSMK.Size = random(20,30);
		WTFSMK.SizeStep = 2;
		WTFSMK.Lifetime = Random(10,18); 
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		WTFSMK.Vel = (frandom[bscsmk](-0.5,0.5),frandom[bscsmk](-0.5,0.5),frandom[bscsmk](-0.5,0.5));
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

class BW_dmgpuff : BW_BulletPuff
{
	default
	{
		height 1;
		radius 1;
		+noblockmap;
	}
	states
	{
		spawn:
			TNT1 A 1;
			stop;
	}
}



class BW_impactpuff : BW_BulletPuff
{
	vector3 norm;
	name tp;
	vector3 impctDir;
	int impactType;
	double wang;
	default
	{
		+noblockmap;
		+nointeraction;
		height 1;
		radius 1;
		scale 0.1;
	}
	states
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 1 a_spawnimpact();
			TNT1 A 0;
			stop;
	}
	
	enum Puff_ImpactType {
		IMP_WALL = 0,
		IMP_FLOOR = 1,
		IMP_CEIL = 2,
	}
	
	void a_spawnimpact()
	{
		//A_SprayDecal("BulletChip",10,(0,0,0),impctDir);
		DoDecal();
		if(waterlevel > 0)
		{
			SpawnPx_Bubbles();
			return;
		}
		
		switch(tp)
		{
			case 'Crystal':
			case 'Carpet':	SpawnImpact_Carpet();	spawnMainPuff();	break;
			case 'Marble':
			case 'PurpleStone':
			case 'Gravel':
			case 'BurnStone':
			case 'Stone':	SpawnPuffFlare(pos);
            SpawnImpact_Stone();	spawnMainPuff();	break;
			case 'Electric':
			case 'Metal':	//SpawnPuffFlare(pos);
            SpawnImpact_Metal();	spawnMainPuff();	break;
			case 'Wood':	SpawnImpact_Wood();	spawnMainPuff();		break;
			case 'Dirt':	SpawnImpact_Dirt();	spawnMainPuff();		break;

			case 'Water':	SpawnImpact_water(0x98A6C5);	spawnMainPuff();	break;
			case 'Slime':	SpawnImpact_water(0x956730,"SLIMC0");	spawnMainPuff();	break;
			case 'PurpleWater': SpawnImpact_water(0xC098C7,"PSPHB0");	spawnMainPuff();	break;
			case 'Blood': SpawnImpact_water(0xFF0000);	spawnMainPuff();	break;
			case 'Flesh': SpawnImpact_water(0xFF0000);	spawnMainPuff();	break;
			case 'Acid': SpawnImpact_water(0x5FB534);	spawnMainPuff();	break;
            case 'Lava': spawnimpact_Lava();	spawnMainPuff();	break;
			case 'Sky':	break;
		}
	}
	
	void DoDecal()
	{
		
		if(impactType == IMP_WALL)
		{
			string typ = "Impact_Stone";
			switch(tp)
			{
				case 'Carpet':	typ = "BulletChip";	break;
				case 'Dirt':
				case 'PurpleStone':
				case 'Gravel':
				case 'Marble':
				case 'Stone':	typ = "Impact_Stone";	break;
				case 'Crystal':	typ = "Impact_Crystal";	break;
				case 'Electric':
				case 'Metal':	typ = "Impact_Metal";	break;
				case 'Wood':	typ = "Impact_Wood";		break;
				case 'Blood':
                case 'Acid':
				case 'Water':	
				case 'Slime':	
				case 'PurpleWater': 
				case 'Lava':
				case 'Sky':	typ = "noDec";	break;
			}
			if(typ == "noDec")
				return;
			A_SprayDecal(typ,10,(0,0,0),impctDir);
		}
		else
		{
			double zfx = (impactType == IMP_FLOOR) ? self.floorz : self.ceilingz;
			double newpitch = atan2(norm.z,norm.x);
			string typ = "FlatDecal_Concrete";
			switch(tp)
			{
				case 'Carpet':	typ = "FlatDecal_Concrete";	break;
				case 'Dirt':
				case 'PurpleStone':
				case 'Gravel':
				case 'Marble':
				case 'Stone':	typ = "FlatDecal_Concrete";	break;
				case 'Crystal':	typ = "FlatDecal_Concrete";	break;
				case 'Electric':
				case 'Metal':	typ = "FlatDecal_Metal";	break;
				case 'Wood':	typ = "FlatDecal_Wood";		break;
				case 'Blood':
				case 'Lava':
				case 'Water':	
				case 'Slime':	
				case 'Acid':
                case 'PurpleWater': 
				case 'Sky':	typ = "noDec";	break;
			}
			if(typ == "noDec")
				return;
			actor fd = spawn(typ,(pos.xy,zfx));
			if(fd)
			{
				if(norm.z == -1.0 || norm.z == 1.0)
				{
					if(impactType == IMP_CEIL)
						fd.pitch = 180;
					else
						fd.pitch = 0;
					return;
				}
				Vector2 norm_p1 = (norm.X != 0 || norm.Y != 0) ? (norm.X, norm.Y).Unit() : (0, 0);
				Vector2 norm_p2 = ((norm.X, norm.Y).Length(), norm.Z);
				double dang = fd.Angle;
				double fang = atan2(norm_p1.Y, norm_p1.X);
				double fpitch = atan2(norm_p2.X, norm_p2.Y);
				double ddiff1 = sin(fang - (dang));
				double ddiff2 = cos(fang - dang);
				fd.Pitch = (fpitch * ddiff2);
				fd.Roll = -fpitch * ddiff1;
				fd.Angle = dang;
			}
		}
	}

	void spawnMainPuff()
	{
		if(random[PUFFX]() < 200)
			spawn("BW_PuffHit",pos);
	}

    void spawnFxSmoke(name type = 'default',string gfx = "PUF2U0", color col = 0xFFFFFF)
	{
		FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = pos;
        WTFSMK.Texture = TexMan.CheckForTexture(gfx);
		WTFSMK.Color1 = col;
		WTFSMK.Style = STYLE_Translucent;
		WTFSMK.Flags = SPF_ROLL;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = random(-5,5);
		WTFSMK.StartAlpha = 0.65;
		WTFSMK.Size = random(20,40);
		WTFSMK.SizeStep = 2;
		WTFSMK.Lifetime = Random(10,18); 
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		WTFSMK.Vel = norm * frandom[bwsmk](0.55,0.80);
        switch(tp)  //add adjustments here
        {
            case 'Dirt':    WTFSMK.Size = random(15,20);     break;
            case 'Acid':   case 'Lava': 
            WTFSMK.Style = STYLE_Add;
            WTFSMK.Flags |= SPF_FULLBRIGHT;
            case 'Blood':
			case 'Slime': case 'PurpleWater': case 'Water':
            WTFSMK.Size = random(15,20);    break;
        }
		if(CeilingPic == SkyFlatNum)
			WTFSMK.accel = getwinddir();
		Level.SpawnParticle (WTFSMK);
	}
	
	void SpawnImpact_Stone()
	{
        color cl = 0xFFFFFF;
        switch(random(1,3))
		{
			case 1:	cl = 0x5B5B5B;	break;
			case 2:	cl = 0x939393;	break;
			case 3:	cl = 0xFFFFFF;	break;
		}
        spawnFxSmoke(tp,"PUF2U0",cl);
		return;
        FSpawnParticleParams Smkfx;
		//vector3 ofs = levellocals.vec3offset(pos,norm * frandom(0.5,1.75);
		Smkfx.Pos = pos; //+ ofs;
		Smkfx.Texture = TexMan.CheckForTexture("PUF2U0");//("SMK1I0");
		switch(random(1,3))
		{
			case 1:	Smkfx.Color1 = 0x5B5B5B;	break;
			case 2:	Smkfx.Color1 = 0x939393;	break;
			case 3:	Smkfx.Color1 = 0xFFFFFF;	break;
		}
		Smkfx.Style = STYLE_Translucent;
		Smkfx.Flags = SPF_ROLL;
		
		Smkfx.Startroll = random(0,360);
		Smkfx.RollVel = frandom(-5,5);
		Smkfx.StartAlpha = 0.65;
		Smkfx.Size = frandom(18,40);
		Smkfx.SizeStep = 1.5;
		Smkfx.Lifetime = Random(10,18); 
		Smkfx.FadeStep = Smkfx.StartAlpha / Smkfx.Lifetime;
		//spawnPx_Stone();
		for(int i = 0; i < random(1,2); i++)
		{
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			
			Smkfx.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			Level.SpawnParticle (Smkfx);
		}
	}
	
	void SpawnImpact_Metal()
	{
		SpawnFlare(pos);
		FSpawnParticleParams MetalFx;
		MetalFx.Texture = TexMan.CheckForTexture("SPKOA0");//("SMK1I0");
		MetalFx.Color1 = "FFFFFF";
		MetalFx.Style = STYLE_ADD;
		MetalFx.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		MetalFx.Startroll = random(0,360);
		MetalFx.RollVel = frandom(-5,5);
		MetalFx.StartAlpha = 0.75;
		MetalFx.Size = frandom(3,8);
		MetalFx.SizeStep = -0.2;
		MetalFx.Lifetime = Random(6,10); 
		MetalFx.FadeStep = 0.1;
		MetalFx.Pos = pos;
		vector3 tofs = (0,0,0);
		for(int i = 0; i < random(2,4); i++)
		{
			
			MetalFx.accel = (0,0,frandom(-0.85,-0.3));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				tofs = (rotatevector((frandom(-2.5,2.5),frandom(-0.5,0.5)),wang),frandom(-0.5,0.75));
				MetalFx.Pos = pos + tofs;
				//fs = (norm.x * frandom(0.5,1.25),norm.y * frandom(0.5,1.25),norm.z * frandom(0.5,1.5));
                fs = (rotatevector((frandom(-4.5,4.5),frandom(-1.5,1.5)),wang),frandom(-0.5,1.5));
            }
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-3.5,3.5),norm.y + frandom(-3.5,3.5),norm.z * frandom(2.5,6.2));//(norm.x * frandom(-1.5,1.5),norm.y * frandom(-1.5,1.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));//(norm.x * frandom(-1.5,1.5),norm.y * frandom(-1.5,1.5),norm.z * frandom(0.2,0.5));
			}
			MetalFx.Vel = norm + fs; //* random(2,5)) + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			Level.SpawnParticle (MetalFx);
		}
	}
	
	void SpawnImpact_Wood()
	{
		spawnFxSmoke(tp,"PUF2U0",0xCA9B7A);
        spawnPx_Wood();
        return;
        FSpawnParticleParams WoodFx;
		WoodFx.Pos = pos;
		WoodFx.Texture = TexMan.CheckForTexture("PUF2U0");//("SMK1I0");
		WoodFx.Color1 = "CA9B7A";
		WoodFx.Style = STYLE_Translucent;
		WoodFx.Flags = SPF_ROLL;
		WoodFx.Startroll = random(0,360);
		WoodFx.RollVel = frandom(-5,5);
		WoodFx.StartAlpha = 0.65;
		WoodFx.Size = frandom(20,40);
		WoodFx.SizeStep = 1.5;
		WoodFx.Lifetime = Random(10,18); 
		WoodFx.FadeStep = WoodFx.StartAlpha / WoodFx.Lifetime;
		spawnPx_Wood();
		for(int i = 0; i < random(1,3); i++)
		{
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			WoodFx.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			Level.SpawnParticle (WoodFx);
		}
	}
	
	void SpawnImpact_Dirt()
	{
		//spawnFxSmoke(tp,"PUF2U0",0xCA9B7A);
        spawnFxSmoke(tp,"DIRPC0",0xFFFFFF);
        return;
        FSpawnParticleParams WoodFx;
		WoodFx.Pos = pos;
		WoodFx.Texture = TexMan.CheckForTexture("PUF2U0");//("SMK1I0"); DIRPC0
		WoodFx.Color1 = "CA9B7A";
		WoodFx.Style = STYLE_Translucent;
		WoodFx.Flags = SPF_ROLL;
		WoodFx.Startroll = random(0,360);
		WoodFx.RollVel = frandom(-5,5);
		WoodFx.StartAlpha = 0.65;
		WoodFx.Size = frandom(20,40);
		WoodFx.SizeStep = 1.5;
		WoodFx.Lifetime = Random(10,18); 
		WoodFx.FadeStep = WoodFx.StartAlpha / WoodFx.Lifetime;
		for(int i = 0; i < random(1,3); i++)
		{
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			WoodFx.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			Level.SpawnParticle (WoodFx);
		}
	}
	
	void SpawnImpact_Carpet()
	{
        spawnFxSmoke(tp,"PUF2U0",0xFFFFFF);
		return;

        FSpawnParticleParams Smkfx;
		Smkfx.Pos = pos;
		Smkfx.Texture = TexMan.CheckForTexture("PUF2U0");//("SMK1I0");
		Smkfx.Color1 = "FFFFFF";
		Smkfx.Style = STYLE_Translucent;
		Smkfx.Flags = SPF_ROLL;
		
		Smkfx.Startroll = random(0,360);
		Smkfx.RollVel = frandom(-5,5);
		Smkfx.StartAlpha = 0.45;
		Smkfx.Size = frandom(20,40);
		Smkfx.SizeStep = 1.5;
		Smkfx.Lifetime = Random(10,16); 
		Smkfx.FadeStep = Smkfx.StartAlpha / Smkfx.Lifetime;
		//spawnPx_Stone();
		for(int i = 0; i < random(1,3); i++)
		{
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			Smkfx.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			Level.SpawnParticle (Smkfx);
		}
	}
	
	void SpawnImpact_water(color col = 0xFFFFFF, string splashsprite = "WSPHC0")
	{
		
		spawnFxSmoke(tp,"PUF2U0",col);
		FSpawnParticleParams WTRPX;
		
		WTRPX.Texture = TexMan.CheckForTexture(splashsprite);
		WTRPX.Color1 = col;//0xFFFFFF;
		WTRPX.Style = STYLE_Translucent;
		WTRPX.Flags = SPF_ROLL;
		WTRPX.Startroll = random(0,360);
		WTRPX.RollVel = frandom(-15,15);
		WTRPX.StartAlpha = 1.0;
		
		WTRPX.SizeStep = -2;
		WTRPX.Pos = pos;
		WTRPX.FadeStep = 0.075;
		vector3 tofs = (0,0,0);
        switch(tp)
        {
            case 'Acid':   case 'Lava': 
            WTRPX.Flags |= SPF_FULLBRIGHT;
			case 'Slime':  case 'Blood': 
            WTRPX.Style = STYLE_Add;
            break;
            //case 'PurpleWater': case 'Water':
        }
		for(int i = 0; i < random(2,5); i++)
		{
			WTRPX.Size = frandom(18,26);
			WTRPX.Lifetime = Random(5,8); 
			WTRPX.accel = (0,0,frandom(-0.75,-0.4));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				tofs = (rotatevector((frandom(-2.5,2.5),frandom(-0.5,0.5)),wang),frandom(-0.5,0.5));
				WTRPX.Pos = pos + tofs;
				//fs = (norm.x * frandom(0.75,2.5),norm.y * frandom(0.75,2.5),norm.z * frandom(0.5,1.1));
				fs = (rotatevector((frandom(-2.5,2.5),frandom(-1.5,1.5)),wang),frandom(-0.5,1.5));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.0,2.0),norm.y + frandom(-2.0,2.0),norm.z * frandom(1.5,3.0));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			WTRPX.Vel = norm + fs;//(norm * random(2,3));	
			Level.SpawnParticle (WTRPX);
		}
	}

    void spawnimpact_Lava()
    {
        /*FSpawnParticleParams LVSMK;
		LVSMK.Pos = pos;
		LVSMK.Texture = TexMan.CheckForTexture("PUF2U0");
		LVSMK.Color1 = 0xE49801;
		LVSMK.Style = STYLE_Translucent;
		LVSMK.Flags = SPF_ROLL;
		LVSMK.Startroll = random(0,360);
		LVSMK.RollVel = frandom(-5,5);
		LVSMK.StartAlpha = 0.65;
		LVSMK.Size = frandom(20,40);
		LVSMK.SizeStep = 1.5;
		LVSMK.Lifetime = Random(10,18); 
		LVSMK.FadeStep = LVSMK.StartAlpha / LVSMK.Lifetime;
		LVSMK.Vel = norm * 0.5;
		Level.SpawnParticle (LVSMK);*/

        spawnFxSmoke(tp,"PUF2U0",0xE49801);
        FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = pos;
		WTFSMK.Texture = TexMan.CheckForTexture("FRPRC0");
		WTFSMK.Color1 = 0xFFFFFF;
		WTFSMK.Style = STYLE_ADD;
		WTFSMK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = frandom(-5,5);
		WTFSMK.StartAlpha = 0.75;
		
		WTFSMK.SizeStep = 1;
		
		
        for(int i = 0; i < random(1,3); i++)
		{
			vector3 fs = (0,0,0);
            WTFSMK.Size = frandom(15,30);
            WTFSMK.Lifetime = Random(8,12); 
		    WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(-0.75,0.75),norm.y * frandom(-0.75,0.75),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
            
			WTFSMK.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			Level.SpawnParticle (WTFSMK);
		}
		
    }
	
	
	void SpawnFlare(vector3 position, bool bigger = false)
	{
		FSpawnParticleParams FFLAR;
		FFLAR.Texture = TexMan.CheckForTexture("LENYA0");
		FFLAR.Color1 = "FFFFFF";
		FFLAR.Style = STYLE_ADD;
		FFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FFLAR.Vel = (0,0,0);
		FFLAR.Startroll = random(0,360);
		FFLAR.RollVel = frandom(-3,3);
		FFLAR.StartAlpha = 0.85;
		FFLAR.FadeStep = bigger ? 0.15 : 0.25;
		FFLAR.Size = random(24,28);
		FFLAR.SizeStep = 2;
		FFLAR.Lifetime = bigger ? random(3,6): 1; 
		FFLAR.Pos = position;
		Level.SpawnParticle(FFLAR);
	}
	
	void SpawnPx_Bubbles()
	{
		
		FSpawnParticleParams BUBBLEPX;
		BUBBLEPX.Pos = pos;
		BUBBLEPX.Texture = TexMan.CheckForTexture("BUBLA0");//("SMK1I0");
		BUBBLEPX.Color1 = "FFFFFF";//"CA9B7A";
		BUBBLEPX.Style = STYLE_Translucent;
		BUBBLEPX.Flags = SPF_ROLL;
		BUBBLEPX.Startroll = random(0,360);
		BUBBLEPX.RollVel = frandom(-5,5);
		BUBBLEPX.StartAlpha = 0.75;
		
		BUBBLEPX.SizeStep = 0.1;
		
		BUBBLEPX.FadeStep = 0.15;
		vector3 tofs = (0,0,0);
		for(int j = 0; j < random(2,4); j++)
		{
			BUBBLEPX.Lifetime = Random(5,8); 
			BUBBLEPX.Size = frandom(10,20);
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				tofs = (rotatevector((frandom(-2.5,2.5),frandom(-0.5,0.5)),wang),frandom(-0.5,0.5));
				BUBBLEPX.Pos = pos + tofs;
				fs = (norm.x * frandom(0.5,1.75),norm.y * frandom(0.5,1.75),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			BUBBLEPX.Vel = norm + fs;
			Level.SpawnParticle (BUBBLEPX);
		}
	}
	
	void spawnPx_Wood()
	{
		FSpawnParticleParams WOODPX;
		WOODPX.Pos = pos;
		WOODPX.Texture = TexMan.CheckForTexture("WSPXA0");//("SMK1I0");
		WOODPX.Color1 = "FFFFFF";
		WOODPX.Style = STYLE_Translucent;
		WOODPX.Flags = SPF_ROLL;
		WOODPX.Startroll = random(0,360);
		WOODPX.RollVel = frandom(-5,5);
		WOODPX.StartAlpha = 1.0;
		WOODPX.Size = frandom(3,8);
		WOODPX.SizeStep = -0.2;
		WOODPX.Lifetime = Random(7,10); 
		WOODPX.FadeStep = 0.1;
		for(int i = 0; i < random(1,2); i++)
		{
			WOODPX.accel = (0,0,frandom(-0.6,-0.1));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.5,1.75),norm.y * frandom(0.5,1.75),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			WOODPX.Vel = norm + fs;//(norm * random(2,7));	
			Level.SpawnParticle (WOODPX);
		}
	}
	
	void spawnPx_Stone()
	{
		FSpawnParticleParams STNPX;
		STNPX.Pos = pos;
		STNPX.Texture = TexMan.CheckForTexture("D1BSA0");//("SMK1I0");
		STNPX.Color1 = "FFFFFF";
		STNPX.Style = STYLE_Translucent;
		STNPX.Flags = SPF_ROLL;
		STNPX.Startroll = random(0,360);
		STNPX.RollVel = frandom(-5,5);
		STNPX.StartAlpha = 1.0;
		STNPX.Size = frandom(3,5);
		STNPX.SizeStep = 0;
		STNPX.Lifetime = Random(5,7); 
		STNPX.FadeStep = 0.15;
		for(int i = 0; i < random(1,2); i++)
		{
			STNPX.accel = (0,0,frandom(-0.9,-0.35));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.5,1.75),norm.y * frandom(0.5,1.75),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			STNPX.Vel = norm + fs;	
			Level.SpawnParticle (STNPX);
		}
	}
	
}

Class BW_KickPuff : BW_BulletPuff
{
	default
	{
		projectilekickback 200;
	}
	states
	{
		spawn:
			TNT1 A 0; 
			TNT1 AAA 0 spawnFxSmokeBasic();//A_SpawnItemEx("GraySmoke",0,0,0,frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5));
			TNT1 A 1;
			stop;
	}
}
