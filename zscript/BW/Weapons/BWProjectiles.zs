// projectile bullets, based on PB ones
Class BW_Projectile : fastprojectile
{
    default
    {
        speed 300;
        +missile;
        radius 1;
        height 1;
		renderstyle "Add";
		//damage 5;
		damage 0;
		//damagefunction inflictDamage(5);
		//+ripper
		BW_Projectile.ripAmount 0;
		BW_Projectile.projectiledmg 5;
		damagetype "Bullet";
		BW_Projectile.TracerLightColor 0xFFDE59; //  black/0x000000/"" = nolight
    }
	
	states
	{
		spawn:
			TNT1 A 1;
			TRAC A -1 bright;
			stop;
	}
	
	int ripAmount, basedamage;
	property ripAmount:ripAmount;
	property projectiledmg:basedamage;
	
	vector3 initpos;
	actor LastActor;
	int maxrip;
	vector2 lastview;
	color tracerLight;
	property TracerLightColor:tracerLight;
	
	int GetProjectileDamage()
	{
		if(!bripper)
			return basedamage;
		
		double half = basedamage * 0.5;
		double adddmg = half/max(1,maxrip);
		adddmg *= ripAmount + 1;
		return int(half + adddmg);
	}

	override void postbeginplay()
	{
		super.postbeginplay();
		initpos = pos;
		maxrip = ripAmount;
		if(target)
			lastview = (target.angle,target.pitch);
		if(!BW_DisableTracerLights && self.TracerLight != 0x000000)
			A_AttachLight('TracerDynLight',DynamicLight.PointLight,self.TracerLight,20,25);
		
	}
    override void tick()
    {
        BW_bulletTick();
    }
	
	int HitActor(actor victim)
	{
		int dmg = GetProjectileDamage();
		int scaled_damage = victim.GetModifiedDamage(damagetype,dmg,true,self,target);
		
		if(victim.bsolid || victim.bshootable)
		{
			if(victim.bNOBLOOD || victim.bINVULNERABLE || victim.bDORMANT || 
			victim.bREFLECTIVE || (victim.bsolid && ! victim.bShootable))
				SpawnPuff("Bulletpuff", pos, angle, 0, 0, PF_HITTHING);
			else
			{
				victim.SpawnBlood( pos, angle, ceil(scaled_damage) );
				victim.TraceBleed(ceil(scaled_damage), self);
				if(victim is 'BW_MonsterBase')
				{
					if(BW_MonsterBase(victim).HitHead())
					{
						A_StartSound("Bullet/Head", CHAN_AUTO, CHANF_OVERLAP, 0.75);
					}
					else
					{
						A_StartSound("Bullet/Flesh", CHAN_AUTO, CHANF_OVERLAP, 0.75);
					}
				}
				else
				{
					A_StartSound("Bullet/Flesh", CHAN_AUTO, CHANF_OVERLAP, 0.75);
				}
			}
		}
		
		victim.DamageMobj(self,target,scaled_damage,damagetype,0,angle);
		
		if(bRIPPER && victim.bBOSS && bNOBOSSRIP)
			return 0;
		
		return -1;
	}

	//from pb too
	override int SpecialMissileHit(Actor victim)
	{
		if (victim == Target && !bHitOwner  || (!victim.bSHOOTABLE && (target && target.player)))
		{
			return 1; //[inkoalawetrust] //This is default behavior though ?
		}
		
		if (bRIPPER)
		{
			if (ripAmount < 0)
			{
				//console.printf("destroying due to no rips");
				return 0; // [Ace] We must use 0 here or else the projectile will keep ripping. Removing the ripper flag does not take effect until the next tic because of how ripping works.
				
			}
			if (Victim && LastActor != victim)
			{
				ripAmount--;
				//Handle_MissileHit(victim);
				int rs = HitActor(victim);
				LastActor = victim;
				return rs;
				//console.printf("Hitting: %s (%d rips remain)",victim.getclassname(),ripAmount);
			}
			else
			{
				return 1;
			}
		}
		else
		{
			if(victim)
			{
				HitActor(victim);
				return 0;	//idk why it keeps ripping if is not ripper
			}
		}
		Return -1;
	}
	
	
	//
	//
	
	void BW_bulletTick()
	{
		if(isfrozen()) //&& !bnotimefreeze)
			return;
			
		vector3 old = pos;
		
		BW_Bulletinfo trac = BW_Bulletinfo.dotrace(self,vel.unit(),vel.length(),0,blockingmobj);
		TraceResults tr = trac.results;
		
		setorigin(tr.hitpos,true);
		
		vector3 newp = pos;
		
		if(bripper)
		{
			for(int i = 0; i < trac.hits.size(); i++)
			{
				BlockingMobj = trac.hits[i].mo;
				if(!BlockingMobj)
					return;
				setorigin(trac.hits[i].hitpos,false);
				let ret = specialmissilehit(blockingmobj);
				
				if(!ret)
				{
					ExplodeMissile(NULL, BlockingMobj);
					return;
				}
				else if(ret == 1)
					continue;
				LastActor = blockingmobj;
				
			}
		}
		else if(tr.hittype == TRACE_HitActor)
		{
			BlockingMobj = tr.hitactor;
			setorigin(tr.hitpos,false);
			SpecialMissileHit(BlockingMobj);
			ExplodeMissile(NULL, BlockingMobj);
			return;
		}
		
		
		if(tr.hittexture == skyflatnum)
		{
			destroy();
			return;
		}
		
		switch(tr.hittype)
		{
			 case TRACE_HitWall:
				BlockingLine = tr.HitLine;
				SetOrigin(tr.HitPos, false);
				//spawnPuffImpact(tr);
				onProjectileImpact(tr,pos);
				ExplodeMissile(BlockingLine, NULL);
				return;
				break;
			 case TRACE_HitFloor:
				SetOrigin(tr.HitPos, false);
				BlockingFloor = tr.HitSector;
				//spawnPuffImpact(tr);
				onProjectileImpact(tr,pos);
				ExplodeMissile(null,null);
				return;
				break;
			 case TRACE_HitCeiling:
				SetOrigin(tr.HitPos, false);
				BlockingCeiling = tr.HitSector;
				//spawnPuffImpact(tr);
				onProjectileImpact(tr,pos);
				ExplodeMissile(null,null);
				return;
				break;
		}
		
		
		if (!CheckNoDelay())
			return;		// freed itself
		// Advance the state
		if (tics != -1)
		{
			if (tics > 0) tics--;
			while (!tics)
			{
				if (!SetState (CurState.NextState))
				{ // mobj was removed
					return;
				}
			}
		}
	}
	
	//
	//


	static vector2 GetLineNormal(int iSide, Line vLine)
	{
		vector2 lineNormal = (-vLine.delta.y, vLine.delta.x).Unit();

		if(!iSide)
			lineNormal *= -1;

		return lineNormal;
	}

	virtual void onProjectileImpact(TraceResults tr,vector3 endpos)
	{
		string tex = texman.getname(tr.HitTexture);
		if(!tex)	//probably hit sky
		{
			destroy();
			return;
		}
		name mat = BW_StaticHandler.getmaterialname(tex);
		
		if(mat == 'null')
		{
			if(BW_texturesChecker)
				console.printf("\caTexture unknown\c-: \cy%s\c-, at map: \cy%s\c- at pos(%d,%d,%d)",tex,level.Mapname,endpos.x,endpos.y,endpos.z);
			spawn("BW_BulletPuff",endpos);
			destroy();
			return;
		}
		if(BW_texturesChecker)
			console.printf("\cdTexture\c-: \cy%s\c-, Material: \cy%s\c-",tex,mat);
		let puf = BW_impactpuff(spawn("BW_ImpactPuff",endpos));
		if(!puf)
			return;
		puf.tp = mat;
		let sd = BW_StaticHandler.getmaterialSound(tex);
		if(sd)
			puf.A_Startsound(sd);
		switch(tr.HitType)
		{
			case TRACE_HitWall:
				vector2 nrm = GetLineNormal(tr.Side,tr.HitLine);
				double wn = -atan2(nrm.x, nrm.y);
				puf.norm = (RotateVector((0, 1),wn), 0);
				puf.impctDir = tr.HitVector;
				puf.wang = wn;
				puf.impactType = BW_impactpuff.IMP_WALL;
				break;
			case TRACE_HitFloor:
				puf.norm = tr.HitSector.floorplane.normal;
				puf.impctDir = tr.HitVector;
				puf.impactType = BW_impactpuff.IMP_FLOOR;
				break;
			case TRACE_HitCeiling:
				puf.norm = tr.HitSector.ceilingplane.normal;
				puf.impctDir = tr.HitVector;
				puf.impactType = BW_impactpuff.IMP_CEIL;
				break;
		}
	}

}

class BW_Bulletinfo : linetracer
{
	array <BW_hitinfo> hits;
	actor source,target;
	static BW_Bulletinfo dotrace(actor source, vector3 dir, double dist, int traceflags, actor ignore)
	{
		let trac = new("BW_Bulletinfo");
		if(trac)
		{
			trac.source = source;
			trac.target = source.target;
			trac.trace(trac.source.pos,trac.source.cursector,dir,dist,traceflags,0x01000000,false,ignore);
		}
		return trac;
	}
	
	override ETraceStatus TraceCallback()
	{
		if(results.HitType == TRACE_HitActor)
		{
			if(results.hitactor == target && !source.bHitOwner)
				return TRACE_Skip;
			
			if(results.hitactor.bshootable)
			{
				if(source.bripper)
				{
					hits.push(BW_hitinfo.create(results.hitactor,results.hitpos));
					return TRACE_Continue;
				}
				else
					return TRACE_Stop;
			}
			
			return TRACE_Skip;
		}
		return TRACE_Continue;
	}
	
}

Class BW_hitinfo
{
	actor mo;
	vector3 hitpos;
	static BW_hitinfo create(actor mo, vector3 hitp)
	{
		let n = new("BW_hitinfo");
		if(n)
		{
			n.mo = mo;
			n.hitpos = hitp;
		}
		return n;
	}
}


Class PlayerDecorativeTracer : fastprojectile	//no fancy behavior needed here
{
	default
	{
		speed 200;
		radius 2;
		height 2;
		+bright;
		renderstyle "Add";
		damage 0;
	}
	states
	{
		spawn:
			TNT1 A 1;
			TRAC A -1;
			stop;
	}
}

Class BW_LugerBullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 25;
		BW_Projectile.ripAmount 1;
		damagetype "Pistol";
	}
}

Class BW_M1911Bullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 30;
		BW_Projectile.ripAmount 0;
		damagetype "Pistol";
	}
}

Class BW_MP40Bullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 25;
		BW_Projectile.ripAmount 1;
		damagetype "SMG";
	}
}

Class BW_M1ThompsonBullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 30;
		BW_Projectile.ripAmount 0;
		damagetype "SMG";
	}
}

Class BW_STG44Bullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 40;
		BW_Projectile.ripAmount 0;
		damagetype "SMG";
	}
}

Class BW_Kar98Bullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 160; //80; most enemies receive at least x2 damage from this
		BW_Projectile.ripAmount 5;
		damagetype "Rifle";
		+ripper;
	}
}

Class BW_12GABullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 25;	//why was this weaker than the luger?
		BW_Projectile.ripAmount 0;
		damagetype "Shotgun";
	}
}

Class BW_MGBullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 35;
		BW_Projectile.ripAmount 1;
		damagetype "MachineGun";
	}
}



Class BW_Rocket : Actor
{
	default
	{
		speed 40;
		damage 35;
		+missile;
		projectile;
		radius 3;
		height 3;
		damagetype "Explosive";
	}
	states
	{
		Spawn:
			MISL A 1 spawnFirespark(pos + (0,0,5));
			loop;
		Death:
			TNT1 A 0;
			TNT1 A 0 spawnrocketimpact();
			TNT1 A 0 A_QuakeEx(1,1,1,12,0,300,"");
            TNT1 A 0 A_Startsound("Barrel/Explosion");
            //TNT1 A 0 A_spawnitem("BW_BarrelExplosionFx");
            TNT1 A 0 A_Explode(400,200,damagetype:"Explosive");
			TNT1 A 1;
			stop;
	}
	vector2 startangles;
	override void postbeginplay()
	{
		super.postbeginplay();
		if(target)
		{
			startangles.x = target.angle;
			startangles.y = target.pitch;
		}
	}

	void spawnrocketimpact()
	{
		FLineTraceData t;
		linetrace(startangles.x,32,startangles.y,0,1,-4,data:t);
		string tex = texman.getname(t.HitTexture);
		name mat = BW_StaticHandler.getmaterialname(tex);
		vector3 safepos = t.hitlocation - t.hitdir - t.hitdir;
		
		if(safepos.z < floorz+1)
			safepos.z = floorz + 1;
		if(safepos.z > ceilingz - 1)
			safepos.z = ceilingz - 1;
		switch(mat)
		{
			case 'Metal': case 'Electronic':
				spawnDebris("BW_MetalScrap",safepos,random(3,7));
				break;
			case 'Stone': case 'Marble': case 'Gravel':
				spawnDebris("BW_Stonebits",safepos,random(3,7));
				break;
			case 'Wood': case 'Carpet':
				spawnDebris("BW_WoodDebris",safepos,random(3,7));
				break;
			case 'Water':	SpawnImpact_water(mat,0x98A6C5,trac:t);					break;
			case 'Slime':	SpawnImpact_water(mat,0x956730,"SLIMC0",t);				break;
			case 'PurpleWater': SpawnImpact_water(mat,0xC098C7,"PSPHB0",t);			break;
			case 'Blood': SpawnImpact_water(mat,0xFF0000,trac:t);					break;
			case 'Flesh': SpawnImpact_water(mat,0xFF0000,trac:t);					break;
			case 'Acid': SpawnImpact_water(mat,0x5FB534,trac:t);					break;
			case 'Lava': SpawnImpact_water(mat,0xFE9900,trac:t);					break;
		}
		DoDecal(mat,t);
		spawnFxSmokeBasic();
		spawnFxSmokeBasic();
		spawnFxSmokeBasic();		
		spawn("BW_RocketExplosionFx",safepos);
		if(pos.z < floorz + 20)
			spawn("BW_GroundFireFx",(safepos.xy,floorz));
	}

	void spawnDebris(string type,vector3 spos,int amount = 1,int maxforce = 10)
	{
		if(amount < 1)
			return;
		for(int i = 0; i < amount; i++)
		{
			actor deb = spawn(type,spos);
			if(deb)
			{
				deb.vel = (random(-maxforce,maxforce),random(-maxforce,maxforce),random(-maxforce*0.5,maxforce));
			}
		}
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

	void spawnFirespark(vector3 position)
	{
		FSpawnParticleParams DBSPK;
		DBSPK.Texture = TexMan.CheckForTexture("SPKOA0");
		DBSPK.Color1 = "FFFFFF";//"FF8400";
		DBSPK.Style = STYLE_ADD;
		DBSPK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		DBSPK.Vel = (frandom(-1,1),frandom(-1,1),frandom(-1,1)); 
		DBSPK.Startroll = random(0,360);
		DBSPK.RollVel = frandom(-15,15);
		DBSPK.StartAlpha = 0.85;
		DBSPK.Size = random(12,20);
		DBSPK.SizeStep = -2;
		DBSPK.Lifetime = random(4,8); 
		DBSPK.Pos = position;
		Level.SpawnParticle(DBSPK);
	}

	void SpawnImpact_water(name tp,color col = 0xFFFFFF, string splashsprite = "WSPHC0", FLineTraceData trac = null)
	{
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
        switch(trac.hittype)
        {
            case 'Acid':   case 'Lava': 
            WTRPX.Flags |= SPF_FULLBRIGHT;
			case 'Slime':  case 'Blood': 
            WTRPX.Style = STYLE_Add;
            break;
            //case 'PurpleWater': case 'Water':
        }
		double wang;
		vector3 norm;
		switch(trac.hittype)
		{
			case TRACE_HitWall:
				vector2 nrm = BW_Projectile.GetLineNormal(trac.LineSide,trac.HitLine);
				wang = -atan2(nrm.x, nrm.y);
				norm = (RotateVector((0, 1),wang), 0);
				break;
			case TRACE_HitFloor:
				norm =  trac.hitsector.floorplane.normal;
				break;
			case TRACE_HitCeiling:
				norm = trac.hitsector.ceilingplane.normal;
				break;
		}

		for(int i = 0; i < random(7,15); i++)
		{
			WTRPX.Size = frandom(38,62);
			WTRPX.Lifetime = Random(7,12); 
			WTRPX.accel = (0,0,frandom(-0.75,-1.4));
			vector3 fs = (0,0,0);
			if(trac.hittype == TRACE_HitWall)
			{
				tofs = (rotatevector((frandom(-5.5,5.5),frandom(-0.5,0.5)),wang),frandom(-1.5,1.5));
				WTRPX.Pos = pos + tofs;
				//fs = (norm.x * frandom(0.25,5.5),norm.y * frandom(0.25,5.5),frandom(0.8,7.0)); //,norm.z * frandom(9.5,22.1)); i was wondering why the multiplier didnt worked lol
				fs = (rotatevector((frandom(-4.5,4.5),frandom(-1.5,1.5)),wang),frandom(0.5,7.5));
			}
			else if(trac.hittype == TRACE_HitFloor)
			{
				fs = (norm.x + frandom(-5.0,5.0),norm.y + frandom(-5.0,5.0),norm.z * frandom(5.5,12.0));
			}
			else if(trac.hittype == TRACE_HitCeiling)
			{
				fs = (norm.x + frandom(-5.5,5.5),norm.y + frandom(-5.5,5.5),norm.z * frandom(0.2,0.5));
			}
			WTRPX.Vel = norm + fs;
			Level.SpawnParticle (WTRPX);
		}
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
	void DoDecal(name tp,FLineTraceData t)
	{
		int impactType = t.hittype;
		vector3 impctDir = t.hitdir;
		if(impactType == TRACE_HitWall)
		{
			string typ = "Impact_Stone";
			switch(tp)
			{
				case 'Carpet':	typ = "Scorch";	break;
				case 'Dirt':
				case 'PurpleStone':
				case 'Gravel':
				case 'Marble':
				case 'Stone':	typ = "Scorch";	break;
				case 'Crystal':	typ = "Scorch";	break;
				case 'Electric':
				case 'Metal':	typ = "Scorch";	break;
				case 'Wood':	typ = "Scorch";		break;
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
			vector3 norm = (impactType == TRACE_HitFloor) 	? 
			t.HitSector.floorplane.normal : t.HitSector.ceilingplane.normal;

			double zfx = (impactType == TRACE_HitFloor) ? self.floorz : self.ceilingz;
			double newpitch = atan2(norm.z,norm.x);
			string typ = "FlatDecal_Scorch";
			switch(tp)
			{
				case 'Carpet':	typ = "FlatDecal_Scorch";	break;
				case 'Dirt':
				case 'PurpleStone':
				case 'Gravel':
				case 'Marble':
				case 'Stone':	typ = "FlatDecal_Scorch";	break;
				case 'Crystal':	typ = "FlatDecal_Scorch";	break;
				case 'Electric':
				case 'Metal':	typ = "FlatDecal_Scorch";	break;
				case 'Wood':	typ = "FlatDecal_Scorch";		break;
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
					if(impactType == TRACE_HitCeiling)
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

	
}





Class BW_BFGBALL : BFGBall replaces BFGBAll
{
	default
	{
		speed 200;
		damagetype "Purpleish";
		translation "0:255=%[0.20,0.00,1.00]:[2.00,0.5,1.50]";//"0:255=#[128,0,255]";
		+bright;
		renderstyle "add";
		damagetype "LF";
		damage 50;
		+ripper;
	}
	override int DoSpecialDamage (Actor victim, int damage, Name damagetype)
	{
		if(victim.health < damage && !(victim is "CommanderKeen") && !victim.player)
		{
			victim.A_Giveinventory("LFedToken",1);
			inventory fc = victim.findinventory("LFedToken");
			if(fc)
				fc.tracer = target;
			victim.bbuddha = true;
		}
		return damage;
	}
	states
	{
		Death:
			TNT1 A 0 A_QuakeEx(2,2,2,15,0,400,"",QF_RELATIVE|QF_SCALEDOWN);
			BFE1 AB 3 Bright;
			BFE1 C 3 Bright A_Explode(200,300,XF_THRUSTLESS);
			BFE1 DEF 3 Bright;
			Stop;
	}
}


Class LFedToken : inventory
{
	uint origTrans;
	int floatTimer;
	bool brighty;
	override void attachtoowner(actor other)
	{
		super.attachtoowner(other);
		other.bnogravity = true;
		other.vel = (frandom(-2.0,2.0),frandom(-2.0,2.0),frandom(0.4,2.0));
		origTrans = other.translation;
		other.A_SetTranslation("BW_LFed");
		brighty = other.bBright;
		other.bbright = true;
		floatTimer = frandom(1,3.5) * TICRATE;
		other.bthruactors = true;
		other.bdropoff = true;
	}
	override void doeffect()
	{
		if(!owner)
			return;
		if(owner.health > 0)
			owner.tics = -1;	//keep it freeze if alive
		if(isfrozen())
			return;
		if(floatTimer > 0)
			floatTimer--;
		else
		{
			owner.bnogravity = false;
			if((owner.pos.z <= owner.floorz + 1 || owner.waterlevel > 2) && owner.health > 0)
			{
				owner.translation = origTrans;

				if(owner)
					owner.A_Explode(clamp(owner.mass,10,40),owner.radius);

				if(tracer)	//keep track of the player for correct kill credits
					owner.damagemobj(tracer,tracer,1000,'LF',DMG_FOILBUDDHA);
				else
					owner.damagemobj(owner,owner,1000,'LF',DMG_FOILBUDDHA);	//harakiri

				owner.bBright = brighty;
				owner.bbuddha = false;
				if(owner.bismonster)
				{
					if(owner.resolvestate("LeanDeath"))
						owner.setstatelabel("LeanDeath");
					else
					{
						actor hb = spawn("BW_BoneHeadDebris",owner.pos + (0,0,owner.height));
						if(hb)
							hb.vel = (frandom(-10.0,10.0),frandom(-10.0,10.0),frandom(1.5,10.0));
						int bones = owner.mass / 10;
						spawnFxSmokeBasic();
						spawnFxSmokeBasic();
						spawnFxSmokeBasic();
						for(int i = 0; i < bones; i++)
						{
							actor b = spawn("BW_BoneDebris",owner.pos + (0,0,owner.height));
							if(b)
								b.vel = (frandom(-10.0,10.0),frandom(-10.0,10.0),frandom(1.5,10.0));
						}
						owner.destroy();
					}
				}
			}
		}
	}

	override void detachfromowner()
	{
		owner.translation = origTrans;
		owner.bBright = brighty;
		owner.bbuddha = false;
	}

	void spawnFxSmokeBasic()
	{
		FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = owner.pos + (random(-20,20),random(-20,20),random(10,45));
        WTFSMK.Texture = TexMan.CheckForTexture("SM7CA0");
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
		Level.SpawnParticle (WTFSMK);
	}
}