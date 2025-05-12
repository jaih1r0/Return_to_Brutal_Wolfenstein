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
        LightProjectileTick();
		//BW_PJTick();
    }
	
	void HitActor(actor victim)
	{
		int dmg = GetProjectileDamage();
		int scaled_damage = victim.GetModifiedDamage(damagetype,dmg,true,self,target);
		
		if(victim.bsolid || victim.bshootable)
		{
			if(victim.bNOBLOOD || victim.bINVULNERABLE || victim.bDORMANT || 
			victim.bREFLECTIVE || (victim.bsolid && ! victim.bShootable))
				SpawnPuff("Bulletpuff", pos, angle, 0, 0, PF_HITTHING);
			else
				victim.SpawnBlood( pos, angle, ceil(scaled_damage) );
		}
		
		victim.DamageMobj(self,target,scaled_damage,damagetype,0,angle);
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
				HitActor(victim);
				LastActor = victim;
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

    void BW_PJTick ()
	{
		ClearInterpolation();
		double oldz = pos.Z;
		if (isFrozen())
			return;

		// [RH] Ripping is a little different than it was in Hexen
		FCheckPosition tm;
		tm.DoRipping = bRipper;

		int count = 8;
		if (radius > 0)
		{
			while (abs(Vel.X) >= radius * count || abs(Vel.Y) >= radius * count)
			{
				// we need to take smaller steps.
				count += count;
			}
		}

		if (height > 0)
		{
			while (abs(Vel.Z) >= height * count)
			{
				count += count;
			}
		}

		// Handle movement
		bool ismoved = Vel != (0, 0, 0)
			// Check Z position set during previous tick.
			// It should be strictly equal to the argument of SetZ() function.
			|| (   (pos.Z != floorz           ) /* Did it hit the floor?   */
				&& (pos.Z != ceilingz - Height) /* Did it hit the ceiling? */ );

		if (ismoved)
		{
			// force some lateral movement so that collision detection works as intended.
			if (bMissile && Vel.X == 0 && Vel.Y == 0 && !IsZeroDamage())
			{
				VelFromAngle(MinVel);
			}

			Vector3 frac = Vel / count;
			int changexy = frac.X != 0 || frac.Y != 0;
			int ripcount = count / 8;
			for (int i = 0; i < count; i++)
			{
				if (changexy)
				{
					if (--ripcount <= 0)
					{
						tm.ClearLastRipped();	// [RH] Do rip damage each step, like Hexen
					}
					
					if (!TryMove (Pos.XY + frac.XY, true, false, tm))
					{ // Blocked move
						if (!bSkyExplode)
						{
							let l = tm.ceilingline;
							if (l &&
								l.backsector &&
								l.backsector.GetTexture(sector.ceiling) == skyflatnum)
							{
								let posr = PosRelative(l.backsector);
								if (pos.Z >= l.backsector.ceilingplane.ZatPoint(posr.XY))
								{
									// Hack to prevent missiles exploding against the sky.
									// Does not handle sky floors.
									Destroy ();
									return;
								}
							}
							// [RH] Don't explode on horizon lines.
							if (BlockingLine != NULL && BlockingLine.special == Line_Horizon)
							{
								Destroy ();
								return;
							}
						}
						BW_SpawnImpact(TRACE_HitWall,CurSector,BlockingLine);
                        ExplodeMissile (BlockingLine, BlockingMobj);
						return;
					}
				}
				AddZ(frac.Z);
				UpdateWaterLevel ();
				oldz = pos.Z;
				if (oldz <= floorz)
				{ // Hit the floor

					if (floorpic == skyflatnum && !bSkyExplode)
					{
						// [RH] Just remove the missile without exploding it
						//		if this is a sky floor.
						Destroy ();
						return;
					}
					
					BW_SpawnImpact(TRACE_HitFloor,CurSector,BlockingLine);
                    SetZ(floorz);
					HitFloor ();
                    Destructible.ProjectileHitPlane(self, SECPART_Floor);
					ExplodeMissile (NULL, NULL);
					return;
				}
				if (pos.Z + height > ceilingz)
				{ // Hit the ceiling

					if (ceilingpic == skyflatnum && !bSkyExplode)
					{
						Destroy ();
						return;
					}
					
					BW_SpawnImpact(TRACE_HitCeiling,CurSector,BlockingLine);
                    SetZ(ceilingz - Height);
                    Destructible.ProjectileHitPlane(self, SECPART_Ceiling);
					ExplodeMissile (NULL, NULL);
					return;
				}
				CheckPortalTransition();
				if (changexy && ripcount <= 0) 
				{
					ripcount = count >> 3;

					// call the 'Effect' method.
					Effect();
				}
			}
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

	//TRACE_HitWall,TRACE_HitCeiling,TRACE_HitFloor
    void BW_SpawnImpact(int type = 0, sector hitsector = null,line hitline = null)
    {
        if(bRipper && ripAmount < 0)	//was destroying after ripping enough enemies, stop here to avoid errors
			return;
		name mat = 'default';
		string tex;
		vector3 normal;
		int impc = 0;
		double wallAng;
		vector3 hitdir = levellocals.vec3diff(initpos,pos).unit();
		//setorigin((pos - hitdir),false);
		FLineTraceData t;
		bool hit = self.linetrace(lastview.x,10,lastview.y,TRF_THRUACTORS,1,-2,0,t);	//probably the easier approach
		

		tex = texman.getname(t.HitTexture);
        mat = BW_StaticHandler.getmaterialname(tex);
		//console.printf("Hit TYpe: %d",t.HitType);
		switch(t.HitType)
        {
            case TRACE_HitWall: //wall
				if(!t.HitLine)
				{
					console.printf("Error: no line found!");
					return;
					
				}

				//int sd = levellocals.PointOnLineSide(target.pos.xy,t.HitLine,true);
				
				//TextureID tx = PB_GetLineTex(t.HitLine,t.LineSide,t.hitlocation.z);
				//tex = texman.getname(t.HitTexture);
               // mat = BW_StaticHandler.getmaterialname(tex);
				vector2 nrm = GetLineNormal(t.LineSide,t.HitLine);
				double wn = -atan2(nrm.x, nrm.y);
				normal = (RotateVector((0, 1),wn), 0);
				wallAng = wn;
				impc = BW_impactpuff.IMP_WALL;
                break;

            case TRACE_HitCeiling: //ceilling
				if(!t.HitSector)
				{
					console.printf("Error: no sector found!");
					return;
				}
				//tex	= texman.getname(t.HitTexture);//texman.getname(ceilingpic);//ceilingpic
				//mat = BW_StaticHandler.getmaterialname(tex);
				normal = t.HitSector.ceilingplane.normal;
				impc = BW_impactpuff.IMP_CEIL;
                break;
            case TRACE_HitFloor: //floor 
				if(!t.HitSector)
				{
					console.printf("Error: no sector found!");
					return;
				}
				//tex = texman.getname(t.HitTexture);//texman.getname(floorpic);//floorpic
				//mat = BW_StaticHandler.getmaterialname(tex);
				normal = t.hitsector.floorplane.normal;
				impc = BW_impactpuff.IMP_FLOOR;
				break;
			default:
			case TRACE_HitNone:
				break;
        }

		if(mat != 'null')
		{
			let puff =  BW_impactpuff(spawn("BW_impactpuff",t.hitlocation - hitdir));
			if(puff)
			{
				puff.tp = mat;
				puff.norm = normal;
				puff.impctDir = hitdir;
				puff.wang = wallAng;
				puff.impactType = impc;
				//console.printf("spawned the fucking puff");
				//if(!levellocals.ispointinlevel(puff.pos))
				//	return;
				let sd = BW_StaticHandler.getmaterialSound(tex);
				if(sd)
					A_Startsound(sd);	//looks like this kinda avoids the sound at (NAN) error
			}
		}
		else
		{
			if(!tex)
				return;
			//console.printf("[\caBW Materials\c-]: texture \cd"..tex.."\c- not found in level \cd"..level.Mapname.."\c- at pos \cd"..pos.."\c-");
			let pf = spawn("BulletPuff",pos - hitdir,ALLOW_REPLACE);
			if(pf)
				pf.A_Spraydecal("BulletChip",30,(0,0,0),hitdir);
		}

    }

	//this comes from PB, 
	TextureID PB_GetLineTex(Line refLine, bool lineSide, double zPos)
	{
		sector backsec, frontsec;
		TextureID surfaceTexId;

		// [gng] ideally front would be the only side i need, but
		// some maps have weird lines where the front faces the back
		if(lineSide == 0)
		{
			backsec = BlockingLine.backsector;
			frontsec = BlockingLine.frontsector;
		}
		else
		{
			backsec = BlockingLine.frontsector;
			frontsec = BlockingLine.backsector;
		}

		side refSide = refLine.sidedef[lineSide];

		if(refSide)
		{
			if(!backsec)
				surfaceTexId = refSide.GetTexture(refSide.mid);
			else if(backsec.floorplane.ZAtPoint(pos.xy) >= zPos)
				surfaceTexId = refSide.GetTexture(refSide.bottom);
			else if (backsec.ceilingplane.ZAtPoint(pos.xy) <= zPos)
				surfaceTexId = refSide.GetTexture(refSide.top);
		}

		return surfaceTexId;
	}

	static vector2 GetLineNormal(int iSide, Line vLine)
	{
		vector2 lineNormal = (-vLine.delta.y, vLine.delta.x).Unit();

		if(!iSide)
			lineNormal *= -1;

		return lineNormal;
	}

	//projectile moving with linetracers instead of fastprojectile steps
	//similar to generic's implementation in pb projectiles
	void LightProjectileTick()
	{
		if(isfrozen())
			return;
		if(!target)
			return;
		
		Vector3 dir = (AngleToVector(lastview.x, cos(lastview.y)), -sin(lastview.y));
		let tr = BW_ProjectileTraveler.dotrace(pos,vel.unit(),target,vel.length(),self);
		vector3 endpos = tr.results.hitPos - dir;
		if(!tr)
			return;
		
		bool stopped;
		vector3 lastpos = pos;
		if(tr.ti.size() > 0)
		{
			if(bRipper)
			{
				for(int i = 0; i < tr.ti.size(); i++)
				{
					if(ripAmount >= 0)
					{
						if(!tr.ti[i].who)
							continue;
						setorigin(tr.ti[i].location,false);
						HitActor(tr.ti[i].who);
						ripAmount--;
					}
					else
					{
						stopped = true;	
						break;
					}
				}
			}
			else
			{
				setorigin(tr.ti[0].location,false);
				hitactor(tr.ti[0].who);
				stopped = true;
			}
		}
		string ty;
		switch(tr.results.hittype)
		{
			case TRACE_HasHitSky:
				ty = "Sky";	break;
			case TRACE_HitWall:
				ty = "Wall";	break;
			case TRACE_HitCeiling:
				ty = "Ceil";	break;
			case TRACE_HitFloor:
				ty = "Floor";	break;
		}

		setorigin(endpos,true);
		
		if(stopped || tr.results.HitType == TRACE_HasHitSky || tr.hitsky || tr.results.hittexture == skyflatnum)
		{
			destroy();
			return;
		}
        
		if(tr.results.HitType == TRACE_HitWall || tr.results.HitType == TRACE_HitCeiling || tr.results.HitType == TRACE_HitFloor)
		{
			onProjectileImpact(tr,endpos);
			destroy();
		}

		if (!CheckNoDelay())
			return;

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

	virtual void onProjectileImpact(BW_ProjectileTraveler tr,vector3 endpos)
	{
		string tex = texman.getname(tr.results.HitTexture);
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
		switch(tr.results.HitType)
		{
			case TRACE_HitWall:
				vector2 nrm = GetLineNormal(tr.results.Side,tr.results.HitLine);
				double wn = -atan2(nrm.x, nrm.y);
				puf.norm = (RotateVector((0, 1),wn), 0);
				puf.impctDir = tr.results.HitVector;
				puf.wang = wn;
				puf.impactType = BW_impactpuff.IMP_WALL;
				break;
			case TRACE_HitFloor:
				puf.norm = tr.results.HitSector.floorplane.normal;
				puf.impctDir = tr.results.HitVector;
				puf.impactType = BW_impactpuff.IMP_FLOOR;
				break;
			case TRACE_HitCeiling:
				puf.norm = tr.results.HitSector.ceilingplane.normal;
				puf.impctDir = tr.results.HitVector;
				puf.impactType = BW_impactpuff.IMP_CEIL;
				break;
		}
	}

}

Class BW_ProjectileTraveler : linetracer
{
	actor shooter;
	array <TraceInfo> Ti;
	bool hitsky;
	//vector3 dirh;

	static BW_ProjectileTraveler DoTrace(vector3 start,vector3 dir, actor shooter, int dist, actor miss)
	{
		let tr = new("BW_ProjectileTraveler");
		if(!tr)
			return null;
		dir.z = clamp(dir.z,-0.995,0.995);
		tr.shooter = shooter;
		tr.Trace(start, miss.CurSector, dir, dist, TRACE_HitSky);
		return tr;
	}
	
	override ETraceStatus TraceCallback()
	{
		//dirh = Results.HitVector;
		if(Results.HitType == TRACE_HasHitSky)
		{
			hitsky = true;
			return TRACE_Stop;
		}
		
		if(Results.hittype == TRACE_HitWall)
		{
			if (Results.Tier == TIER_Middle)
			{
				// Stop on one-sided or hitscan-blocking linedefs.
				if (Results.HitLine.Flags & Line.ML_TWOSIDED == 0 ||Results.HitLine.Flags & Line.ML_BLOCKHITSCAN > 0)
				{
					return TRACE_Stop;
				}
				return TRACE_Skip; // Pass through two-sided linedefs that don't block hitscans.
			}
			
			if(Results.tier == TIER_FFloor)
			{
				if(Results.ffloor.flags & F3DFloor.FF_SWIMMABLE)
					return TRACE_Skip;
			}
			
			return TRACE_Stop; // Don't pass through upper, lower, or 3D floors.
		}
		
		if(Results.hittype == TRACE_HitFloor || Results.hittype == TRACE_HitCeiling)
		{
			return TRACE_Stop;
		}
		
		if (Results.HitType == TRACE_HitActor)
		{
			// Ignore source
			if(Results.HitActor && Results.hitactor.bshootable)
			{
				if(shooter && results.hitactor == shooter)
					return TRACE_Skip;
				let inf = TraceInfo.create(Results.HitActor,Results.HitPos);
				if(inf)
					Ti.push(inf);
				return TRACE_Skip;
			}
			
			return TRACE_Skip;
		}
		
		return TRACE_Stop;
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
		BW_Projectile.ripAmount 0;
		damagetype "Pistol";
	}
}

Class BW_MP40Bullets : BW_Projectile
{
	default
	{
		BW_Projectile.projectiledmg 25;
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