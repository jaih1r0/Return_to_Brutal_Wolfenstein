Class BWPlayer : PlayerPawn//zmoveplayer//PlayerPawn
{
	double StillRangeMulti, slideAngle;
	double 	ssup;
	vector2 finalbob;

	double YscaleFix;	//port this over from monsters

	uint bloodtics;
	bool sliding;

	bool blockedGun, blockedbyUsable;
	int blockedDist, blockedTics;
	actor lookedActor;

	override void tick()
	{
		super.tick();
		UpdateBlockView();
			
		//[Pop] CHECK THIS LATER, for some reason its alternating true/false really fast when sliding
		//A_LogInt(self.sliding);
	}

	override void CheckWeaponChange ()
    {
        let player = self.player;

        let bwwp = BaseBWWeapon(player.readyweapon);
        if(bwwp && bwwp.BW_IsReloading())
        {
            player.weaponstate |= WF_WEAPONSWITCHOK;
        }
        super.CheckWeaponChange();
    }

	override void playerthink()
	{
		super.playerthink();

		if(bloodtics)
		{
			if(health <= 20)
			{
				if(level.time % 5 == 0)
					bloodtics--;
			}
			else
				bloodtics--;
		}

		bool wasOnGround = player.onGround;
		//stick player to the frond when going downstairs
		if (wasOnGround && !player.onGround && pos.z - GetZAt() < maxDropOffHeight && vel.z <= 0)
         {
 			ssup = max(0,(pos.z-floorz));
 			SetOrigin(Vec2OffsetZ(0,0,floorz),true);
            player.onGround = true;
			player.viewz += ssup;
 			ssup = max(0,(ssup*0.7)-0.25);
         }

	}
	
	override Vector2 BobWeapon(double ticFrac)
	{
		vector2 offset = super.BobWeapon(ticFrac);
		if(vel.xy.length() > 0)
		{
			stillrangemulti = 0;
			return offset;
		}
		//this comes from zmovement :D
		StillRangeMulti = min(StillRangeMulti + 0.001, 1);
		offset.Y = StillRangeMulti * sin(Level.maptime / 120. * 360.) + StillRangeMulti;
		
		return (offset);
	}
	
	action bool PressingCrouch()
	{
		return player.cmd.buttons & BT_CROUCH;
	}
	
	action bool JustReleased(int which)
    {
        return !(player.cmd.buttons & which) && player.oldbuttons & which;
    }
		
	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
	{
		//[Pop] because FUCK leaky floors, even by WW2 standards
		PlayerInfo plyr = Self.Player;
		if(!plyr || plyr.mo != Self) return 0;
		/*if(plyr.mo.CountInv("MO_PowerInvul") == 1)
		{
			A_StartSound("powerup/invul_damage",3);
		}*/
		int dam = super.DamageMobj(inflictor, source, damage, mod, flags, angle);
		player.damagecount = Clamp(player.damagecount, 0, 5);	//reduced red flash
		self.bloodtics += clamp(dam,0,105); //we dont want to add 9999999 tics to this
		return dam;
	}

	void playergothealed(int healamt = 0) //getting healed reduces the blood flash faster
	{
		double mult = BW_Statics.linearmap(healamt,0,100,0.9,0.1,true);
		bloodtics = int(bloodtics * mult); 
	}
	
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		if(StringTable.Localize("$OPTVAL_MBF21STRICT") != "OPTVAL_MBF21STRICT")	//only triggered when loaded in gzdoom 4.13
		{
			YscaleFix = scale.y * level.pixelstretch;	//should look good in gzdoom 4.13+
			A_SetScale(scale.x,YscaleFix);
		}
		else
			YscaleFix = scale.y;
	}

	//get whatever is blocking the player view
	void UpdateBlockView()
	{
		Vector3 direction = (Actor.AngleToVector(self.Angle),sin(-self.Pitch));
		let trac = BW_PlayerInteractTracer.dotrace(self,direction, 64, 0,self);
		let res = trac.results;
		switch(res.hittype)
		{
			default:
				blockedGun = false;
				blockedbyUsable = false;
				lookedActor = null;
				blockedDist = 0;
				blockedTics = 0;
				break;

			case TRACE_HitActor:
				lookedActor = res.hitactor;
				blockedGun = true;
				blockedDist = res.distance;
				blockedbyUsable = (lookedActor is "inventory");
				blockedTics++;
				break;

			case TRACE_HitWall:	case TRACE_HitFloor:	case TRACE_HitCeiling:
				if(res.hittexture == skyflatnum)
				{
					blockedGun = false;
					blockedbyUsable = false;
					lookedActor = null;
					blockedDist = 0;
					blockedTics = 0;
					break;
				}
				blockedGun = true;
				lookedActor = null;
				blockedDist = res.distance;
				blockedbyUsable = (res.hittype == TRACE_HitWall && (res.hitline.activation & SPAC_Use) != 0);
				blockedTics++;
				break;
		}
		//BW_Statics.SpawnIndicator(res.hitpos);
	}
	
	Default
	{
		//Player.StartItem "BW_Luger", 1;
		Player.StartItem "BW_PistolAmmo", 8;
		Player.startItem "BW_Fists";
		
		//Player.StartItem "QuickKick", 1;
		
		//+STRETCHPIXELS;
		+ROLLSPRITE;
		
		Player.AttackZOffset 15; //this was so high it made the enemy hitboxes feel inaccurate
		Player.ViewBobSpeed 15;
		Player.ViewHeight 42;// player feels too big for the maps
		Scale 1.0;
		Player.SoundClass "BWPlayer";
		Player.Face "STF";
		Player.DisplayName "William J. Blazkowicz";
		height 48; //to avoid getting stuck in random stairs
	}

	override void GiveDefaultInventory()
	{
		super.GiveDefaultInventory();
		//might need to add a way to support custom campaigns and non bw campaign levels with specific starter items
		int ep = -1;
		string bwepis = level.mapname.left(2);
		if(bwepis != "BW")
		{
			//not a base episode
		}
		else
		{
			string episInt = level.mapname.Mid(2,1); //BW[#] <-
			int episodeNum = episInt.toInt();
			ep = episodeNum;
		}
		switch(ep)
		{
			
			case 2:
				GiveInventoryType("BW_MP40");
				break;
			
			case 6:
			case 4:
				GiveInventoryType("BW_M1911");
			case 3:
				GiveInventoryType("BW_M1Thompson");
				break;
			
			case 5:
				GiveInventoryType("BW_Kar98K"); //m1 garand
				break;
			
			case 7:
				GiveInventoryType("BW_M1911");
				break;
			case 1:
			case -1:
			default:
				GiveInventoryType("BW_Luger");
				break;
		}
	}

	override void PlayerLandedMakeGruntSound(Actor onmobj)
	{
		
		if(onmobj || waterlevel > 1)
		{
			if(onmobj && onmobj.bismonster && onmobj.health > 0)
			{
				name dmgt = (abs(vel.z) > 9) ? 'stomp' : 'kick';
				onmobj.DamagemObj(self,self,abs(vel.z) * 2,dmgt,DMG_USEANGLE,angle);
			}
			super.PlayerLandedMakeGruntSound(onmobj);	//ummmh
			return;
		}

		name landtex = BW_StaticHandler.getmaterialname(texman.getname(floorpic));
		sound landsnd = sound("land/concrete");
		bool spawnsplash;
		switch(landtex)
		{
			case 'carpet':
			case 'Wood':	landsnd = sound("land/wood");		break;
			case 'Stone':	landsnd = sound("land/concrete");	break;
			case 'Marble':	landsnd = sound("land/tile");		break;

			case 'grass':	case 'gravel':
			case 'Dirt':	landsnd = sound("land/dirt");		break;
			
			case 'slime': case 'purplewater': case 'blood':	case 'lava':
			case 'Water': case 'Acid':	spawnsplash = true;
				landsnd = sound("land/water");		break;
			case 'Metal':	landsnd = sound("land/metal");		break;
			case 'sky':		landsnd = sound("step/none");		break;
		}
		A_Startsound(landsnd,10,CHANF_OVERLAP,pitch:frandom[landng](0.9,1.1));
		
		if(spawnsplash)
			BW_StepActor.spawnfootstepFx(self,pos,landtex,true);

	}
	
	States
	{
		Spawn3:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Spawn2");
			BLAS ABACA 10;
		Spawn:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Spawn2");
			BLAS A 5;
			TNT1 A 0 A_Jump(32, "Spawn3");
			Loop;	
		Spawn2:
			TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 0, "Spawn");
			BLAZ E 10;
			Loop;
		See:
			BLAZ ABCD 3;
			Loop;
		Missile:
			BLAZ E 6;
			Goto Spawn;
		Melee:
			BLAZ F 4 BRIGHT;
			Goto Missile;
		Pain:
			BLAZ G 2 A_Pain;
			Goto Spawn;
		Death:
		XDeath:
			BLAZ H 2;
			BLAZ I 2 A_PlayerScream;
			BLAZ J 2 A_NoBlocking;
			BLAZ KL 2;
			BLAZ L -1;
			Stop;
	}
}

//custominventory nomore
class Z_NashMove : inventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.AUTOACTIVATE
	}

	// How much to reduce the slippery movement.
	// Lower number = less slippery.
	const DECEL_MULT = 0.8; //0.8

	//===========================================================================
	//
	//
	//
	//===========================================================================

	bool bIsOnFloor(void)
	{
		return (Owner.Pos.Z == Owner.FloorZ) || (Owner.bOnMObj);
	}

	bool bIsInPain(void)
	{
		State PainState = Owner.FindState('Pain');
		if (PainState != NULL && Owner.InStateSequence(Owner.CurState, PainState))
		{
			return true;
		}
		return false;
	}

	double GetVelocity (void)
	{
		return Owner.Vel.Length();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void DoEffect()
	{
		Super.DoEffect();
		if (Owner && Owner is "PlayerPawn")
		{
			if (bIsOnFloor())
			{
				
				// bump up the player's speed to compensate for the deceleration
				// TO DO: math here is shit and wrong, please fix
				double s = 0.7 + (1.1 - DECEL_MULT); //1.0
				double mod = 1.5;
				
				//[Pop] Initialize the base value
				s *= 2;
				
				//[Pop] Handle movement boosts here at some point if needed. IE Stims, holsters gun, etc.
				
				//[Pop] This is the main magic with handling how fast players can move with weapons.
				//If not a BaseBWWeapon, is ignored.
				if(Owner.Player.ReadyWeapon)
				{
					let wpn = BaseBWWeapon(Owner.Player.ReadyWeapon);
					if(wpn)
					{
						//mod = wpn.GunSpeedMod;
					}
				}
				
				Owner.A_SetSpeed(s * mod);
				//Owner.A_SetSpeed(s);
				
				Owner.vel.x *= DECEL_MULT;
				Owner.vel.y *= DECEL_MULT;
				// make the view bobbing match the player's movement
				PlayerPawn(Owner).ViewBob = GetVelocity() / 24;//DECEL_MULT / 2;
			}
		}
		
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================
}

class Kicking : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

class Sliding : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

Class BW_PlayerInteractTracer : LineTracer
{
	actor shooter;

	static BW_PlayerInteractTracer dotrace(actor source, vector3 dir, double dist, int traceflags, actor ignore)
	{
		let trac = new("BW_PlayerInteractTracer");
		if(trac)
		{
			double vz = source.player.viewz - source.pos.z;
			trac.shooter = source;
			trac.trace(trac.shooter.pos + (0,0,vz),trac.shooter.cursector,dir,dist,traceflags,0x01000000,false,ignore);
		}
		return trac;
	}

	override ETraceStatus TraceCallback()
	{
		if(results.HitType == TRACE_HitActor)
		{
			if(results.hitactor == shooter)
				return TRACE_Skip;
			
			if(results.hitactor.bsolid || results.hitactor.bspecial)
				return TRACE_Stop;
			
			
			return TRACE_Skip;
		}
		return TRACE_Continue;
	}
}