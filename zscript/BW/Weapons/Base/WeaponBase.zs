//
//
//	Base class for weapons
//	- default values, overrides, constants and vars
//
Class BaseBWWeapon : DoomWeapon
{
	default
	{
		Weapon.BobRangeX 0.4;
		Weapon.BobRangeY 0.2;
		Weapon.BobSpeed 2.5;
		Weapon.BobStyle "InverseSmooth"; //"Smooth";//"InverseAlpha";
		BaseBWWeapon.FullMag 0;
		BaseBWWeapon.canDual false;
		Weapon.WeaponScaleX 1.2;
		inventory.maxamount 1;
		+dontgib;
	}
	
	mixin BW_CheckFunctionsWeapon;
	
	enum BWWR_Flags {
		BWWF_NoAxe		= 1<<26,
		BWWF_NoGrenade 	= 1<<27,
		BWWF_NoKick 	= 1<<28,
		BWWF_NoSlide 	= 1<<28,
		BWWF_NoTaunt 	= 1<<29,
	};

	enum BW_Overlays {
		PSP_LeftGun = 10,
		PSP_RightGun = 11,
	}
	
	int FullMag;
	property FullMag:FullMag;
	
	protected int BraceTicker;
	bool GunBraced;

	bool canDual;
	property canDual:canDual;
	protected bool Akimboing, firingLeft,firingRight,isReloading;
	class<Ammo> AmmoTypeLeft;
	Ammo AmmoLeft;
	Property AmmoTypeLeft: AmmoTypeLeft;

	protected uint barrelHeat, barrelHeatLeft;

	override void DoEffect()
	{
		super.doeffect();
		let pl = owner.player;
		if (pl && pl.readyweapon)
			pl.WeaponState |= WF_WEAPONBOBBING;
		
	}

	override void attachtoowner(actor other)
	{
		super.attachtoowner(other);
		if(FullMag > 0 && ammotype2)
			other.giveinventory(ammotype2,FullMag);
		if(AmmoTypeLeft) 
			AmmoLeft = AddAmmo(Owner, AmmoTypeLeft, FullMag);
	}
	
	override void Tick()
	{
		Super.Tick();
		let plr = BWPlayer(Owner);
		if (!plr)
		{
			GunBraced = false;
			return;
		}
		
		if (plr.Player.ReadyWeapon != self)
		{
			GunBraced = false;
			return;
		}
		/*
		if (CountInv("ResetZoom") >= 1) {
			A_TakeInventory("ResetZoom", 1);
			A_ZoomFactor(1.0, ZOOM_INSTANT);
		}*/
		
		FLineTraceData dt1, dt2, dt3, dt4, dt5, dt6;
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, offsetside: -plr.Radius / 2, data: dt1);
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95 * 0.75, data: dt2);
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, offsetside: plr.Radius / 2, data: dt3);
		
		plr.LineTrace(plr.Angle + 90, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, data: dt4);
		plr.LineTrace(plr.Angle + 180, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95 * 0.75, data: dt5);
		plr.LineTrace(plr.Angle - 90, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, data: dt6);
		
		bool geometryBrace = dt1.HitType == FLineTraceData.TRACE_HitWall || dt2.HitType == FLineTraceData.TRACE_HitWall || dt3.HitType == FLineTraceData.TRACE_HitWall || dt4.HitType == FLineTraceData.TRACE_HitWall || dt5.HitType == FLineTraceData.TRACE_HitWall || dt6.HitType == FLineTraceData.TRACE_HitWall;
		
		if (!bMELEEWEAPON && (plr.Player.crouchfactor == 0.5 || geometryBrace) && plr.Vel.Length() < 6)
		{
			BraceTicker++;
			if (BraceTicker == 10)
			{
				GunBraced = true;
				plr.A_SetPitch(plr.Pitch - 0.2);
				Owner.A_StartSound("Weapon/Bracing", 19, 0, 0.30);
			}
			if (BraceTicker == 11)
			{
				plr.A_SetPitch(plr.Pitch + 0.2);
			}
		}
		else
		{
			GunBraced = false;
		}

		if (!GunBraced && BraceTicker > 13)
		{
			BraceTicker = 0;
		}
	}

	
}

Class BW_DualWeapon : BaseBWWeapon
{
	default
	{
		BaseBWWeapon.canDual true;
		inventory.maxamount 2;
	}
}


Class BW_PenetratorTracer : LineTracer
{
	actor shooter;
	array <TraceInfo> Ti;
	vector3 endpos;
	bool hitsky;
	line hitl;
	sector ss;
	textureID htx;
	int typehit;
	vector3 dirh;
	uint lsd;
	
	override ETraceStatus TraceCallback()
	{
		if(Results.HitType == TRACE_HasHitSky)
		{
			hitsky = true;
			endpos = Results.hitpos;
			ss = Results.HitSector;
			hitl = Results.HitLine;
			htx = Results.HitTexture;
			typehit = Results.hittype;
			dirh = Results.HitVector;
			lsd = Results.Side;
			return TRACE_Stop;
		}
		
		if(Results.hittype == TRACE_HitWall)
		{
			if (Results.Tier == TIER_Middle)
			{
				// Stop on one-sided or hitscan-blocking linedefs.
				if (Results.HitLine.Flags & Line.ML_TWOSIDED == 0 ||Results.HitLine.Flags & Line.ML_BLOCKHITSCAN > 0)
				{
					endpos = Results.hitpos;
					ss = Results.HitSector;
					hitl = Results.HitLine;
					htx = Results.HitTexture;
					typehit = Results.hittype;
					dirh = Results.HitVector;
					lsd = Results.Side;
					return TRACE_Stop;
				}
				return TRACE_Skip; // Pass through two-sided linedefs that don't block hitscans.
			}
			
			if(Results.tier == TIER_FFloor)
			{
				if(Results.ffloor.flags & F3DFloor.FF_SWIMMABLE)
					return TRACE_Skip;
			}
			
			endpos = Results.hitpos;
			ss = Results.HitSector;
			hitl = Results.HitLine;
			htx = Results.HitTexture;
			typehit = Results.hittype;
			dirh = Results.HitVector;
			lsd = Results.Side;
			return TRACE_Stop; // Don't pass through upper, lower, or 3D floors.
		}
		
		if(Results.hittype == TRACE_HitFloor || Results.hittype == TRACE_HitCeiling)
		{
			endpos = Results.hitpos;
			ss = Results.HitSector;
			hitl = Results.HitLine;
			htx = Results.HitTexture;
			typehit = Results.hittype;
			dirh = Results.HitVector;
			lsd = Results.Side;
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
		
		endpos = Results.hitpos;
		ss = Results.HitSector;
		hitl = Results.HitLine;
		htx = Results.HitTexture;
		typehit = Results.hittype;
		dirh = Results.HitVector;
		lsd = Results.Side;
		return TRACE_Stop;
	}
}

Class TraceInfo
{
	actor who;
	vector3 location;

	static TraceInfo create(actor v, vector3 loc)
	{
		TraceInfo n = new("TraceInfo");
		if(n)
		{
			n.who = v;
			n.location = loc;
			return n;
		}
		return null;
	}
}

class AimingToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

Class PlayerMuzzleFlash : Actor
{
	Default
	{
		Speed 0;
		PROJECTILE;
		+NOCLIP;
		+NOGRAVITY;
		+NOINTERACTION;
	}
	
	States
	{
		Spawn:
			TNT1 A 2 BRIGHT;
			Stop;
	}
}

Class PlayerMuzzleFlash_Blue : PlayerMuzzleFlash
{}

Class PlayerMuzzleFlash_Purple : PlayerMuzzleFlash
{}

Class BW_GrenadeAmmo : Ammo	//7082
{
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 5;
		Ammo.BackpackAmount 2;
		Ammo.BackpackMaxAmount 5;
		Inventory.PickupMessage "Picked up a Stielhandgranate!";
	}
	states
	{
		spawn:
			GRND H -1;
			stop;
	}
}

Class BW_Threenades : BW_GrenadeAmmo	//7081
{
	default
	{
		Inventory.Amount 3;
		Inventory.PickupMessage "Picked up a Stielhandgranate bundle!";
	}
	states
	{
		spawn:
			GRN3 A -1;
			stop;
	}
}

Class BW_AxeAmmo : Ammo
{
	Default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 5;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 5;
		Inventory.PickupMessage "Axe";
		inventory.pickupsound "Axe/pickup";
	}
	states
	{
		spawn:
			ACIA B -1;
			stop;
	}
}

Class CanThrowAxe : Powerup
{
	default
	{
		powerup.duration 8;
	}
}

Class BW_ThrowedAxe : Actor
{
	default
	{
		projectile;
		+missile;
		speed 40;
		-nogravity;
		damage (150);
		projectilekickback 200;
		radius 3;
		height 3;
		+bloodsplatter;
	}
	states
	{
		Spawn:
			ZMAX A 1;
			loop;
		Death:
		Crash:
			TNT1 A 0;
			TNT1 A 0 A_Startsound("Axe/HitWall");
			TNT1 A 0 A_Spawnitem("BW_AxeAmmo");
			TNT1 A 0 A_Spawnitem("BW_BulletPuff");
			TNT1 A 1;
			stop;
		Xdeath:
			TNT1 A 0 A_Startsound("Axe/Hit");
			TNT1 A 0 A_Spawnitem("BW_AxeAmmo");
			TNT1 A 1;
			stop;
	}
}