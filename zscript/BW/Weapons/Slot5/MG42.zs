Class BW_MG42 : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 5;
		weapon.ammotype1 "BW_MGAmmo";
		weapon.ammotype2 "MG42Ammo";
		weapon.ammogive1 50;
		Tag "MG42";
		Inventory.Pickupmessage "[Slot 5] Maschinengewehr 42";
		Inventory.PickupSound "Generic/Pickup/LMG";
		BaseBWWeapon.FullMag 50;
	}
	int timesFired;	//player.refire wasnt reliable for this
	states
	{
		Spawn:
			HBUS D -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Rifle/Raise");
			TNT1 A 0 addfired(0,true);
			BMGU AB 1;
			TNT1 A 0 A_StartSound("MG42/Raise", 0, CHANF_OVERLAP, 1);
			BMGU CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 A_Stopsound(42);
			TNT1 A 0 A_Startsound("MG42/Drop",5,CHANF_OVERLAP);
			BMGU FG 1;
			TNT1 A 0 A_StartSound("Generic/Rifle/Holster", 0, CHANF_OVERLAP, 1);
			BMGU HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			BMGU E 1 {
				BW_GunBarrelSmoke(ofsPos:(30,0,-7));
				if(invoker.ammo2.amount < 4)	//just change the sprite instead of jumping to readyempty
					BW_ChangePsprite("BMGE");
				addfired(0,true);
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
			}
			loop;
		Fire:
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			BMGF A 1 bright FireMG42();
			TNT1 A 0 A_Weaponoffset(0 + random(-2,2),32 + random(-1,-2));
			BMGF B 1 bright;
			BMGF C 1;
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_JumpIf(CountInv("MG42Ammo") == 0, "FireEnd");
			TNT1 A 0 A_refire();
		FireEnd:
			TNT1 A 0 A_Startsound("MG42Tail",CHAN_AUTO,CHANF_OVERLAP,0.7);
			TNT1 A 0 {
				if(getfiredTimes() >= 40)
					A_Startsound("MG42/Overheat",43);
				addfired(0,true);
			}
			BMGF D 1;
			TNT1 A 0 A_StopSound(42);
			goto ready;
		DryFire:
			TNT1 A 0 A_Stopsound(42);
			BMGE E 1;
			goto ready;
		NoAmmo:
			TNT1 A 0 A_Stopsound(42);
			BMGU E 1;
			goto ready;
			
			
		Reload:
			TNT1 A 0 BW_CheckReload("EmptyReload","Fidget","NoAmmo",50,1);
			BMGU EEE 1 A_Weaponoffset(-0.35,0.2,WOF_ADD);	//moving hand to open it
			BMGU EE 1 A_Weaponoffset(0.4,-0.3,WOF_ADD);
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",0);
			MGR4 ABCDEF 1;
			TNT1 A 0 A_Startsound("MG42OPEN",CHAN_AUTO);
			MGR4 GHIJKLMNOOOOOOOOOO 1;
			MGR4 PQRST 1;
			TNT1 A 0 A_Startsound("MG42BeltOut",32);
			TNT1 A 0 A_Startsound("MG42/MagOut",CHAN_AUTO);
			MGR4 UVWXYZ 1;
			TNT1 A 0 A_Startsound("Generic/Ammo/MagFoleyDrum",0);
			MGR1 ABCDEEEEEEEEEEFGH 1;
			TNT1 A 0 A_Startsound("MG42/MagIn",CHAN_AUTO);
			MGR1 IJKLMNOPQQ 1;
			MGR1 RRRRRRRRR 1 A_Weaponoffset(-0.3,0.1,WOF_ADD);
			MGR1 R 1;
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",0);
			MGR1 ST 1 A_Weaponoffset(0.75,-0.25,WOF_ADD);
			TNT1 A 0 A_Startsound("MG42Bul",32);
			MGR1 U 1;
			MGR1 VV 1 A_Weaponoffset(-1,1,WOF_ADD);
			MGR1 V 1;
			MGR1 VVWX 1 A_Weaponoffset(0.25,-0.25,WOF_ADD);
			TNT1 A 0 A_weaponoffset(0,32,WOF_INTERPOLATE);
			MGR1 YZ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),50,1);
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",0);
			MGR2 ABCDE 1;
			TNT1 A 0 A_Startsound("MG42Close",CHAN_AUTO);
			MGR2 FGHIJK 1;
			goto ready;
			
		EmptyReload:
			BMGE EEE 1 A_Weaponoffset(-0.35,0.2,WOF_ADD);	//moving hand to open it
			BMGE EE 1 A_Weaponoffset(0.4,+0.3,WOF_ADD);
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",0);
			MGR0 ABCDEFG 1;
			TNT1 A 0 A_Startsound("MG42OPEN",CHAN_AUTO);
			MGR0 HIJKLMNOOOOOOOOOO 1;
			MGR0 PQRST 1;
			TNT1 A 0 A_Startsound("MG42/MagOut",CHAN_AUTO);
			MGR0 UVWXYZ 1;
			TNT1 A 0 A_Startsound("Generic/Ammo/MagFoleyDrum",0);
			MGR1 ABCDEEEEEEEEEEFGH 1;
			TNT1 A 0 A_Startsound("MG42/MagIn",CHAN_AUTO);
			MGR1 IJKLMNOPQQ 1;
			MGR1 RRRRRRRRR 1 A_Weaponoffset(-0.3,0.1,WOF_ADD);
			MGR1 R 1;
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",0);
			MGR1 ST 1 A_Weaponoffset(0.75,-0.25,WOF_ADD);
			TNT1 A 0 A_Startsound("MG42Bul",CHAN_AUTO);
			MGR1 U 1;
			MGR1 VV 1 A_Weaponoffset(-1,1,WOF_ADD);
			MGR1 V 1;
			MGR1 VVWX 1 A_Weaponoffset(0.25,-0.25,WOF_ADD);
			TNT1 A 0 A_weaponoffset(0,32,WOF_INTERPOLATE);
			MGR1 YZ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),50,1);
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",0);
			MGR2 ABCDE 1;
			TNT1 A 0 A_Startsound("MG42Close",CHAN_AUTO);
			MGR2 FGHIJKK 1;
		Rechamber:
			MGR3 AABCDE 1;
			TNT1 A 0 A_Startsound("MG42/rechamber",CHAN_AUTO);
			MGR3 FGHIJJJJJJJJJKLMN 1;
			MGR3 EDCBA 1;
			goto ready;
		
		//little animation that plays when you press reload but the gun is already reloaded
		Fidget:
			MGR3 ABCDE 1 BW_WeaponReady();
			TNT1 A 0 A_Startsound("MG42/rechamber",CHAN_AUTO);
			MGR3 FGHIJJJJJJJJJKLMN 1 BW_WeaponReady();
			MGR3 EDCBA 1 BW_WeaponReady();
			goto ready;
			
		PrepareKnifeLayer:
		PrepareLedgeGrab:
			TNT1 A 0 A_Stopsound(42);
			TNT1 A 1;
			stop;
			
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BMGK ABC 1;
			BMGK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			BMGK GHHHG 1;
			BMGK FEDCBA 1;
			goto ready;	
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BMGK ABCD 1;
			BMGK EFGH 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			BMGK HHH 1;
			BMGK HHH 1;
			BMGK HHH 1;
			BMGK HHH 1;
			BMGK HHH 1;
			BMGK HHH 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BMGK FEDCBA 1;
			goto ready;
		MuzzleFlash:
			TNT1 A 0 A_OverlayFlags(overlayID(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
			BMGM A 1 bright {
				let ps = player.findPSprite(overlayID());
				if(ps)
					ps.frame = random(0,2);
			}
			BMGZ A 1 bright {
				let ps = player.findPSprite(overlayID());
				if(ps)
					ps.frame = random(0,2);
			}
			stop;
		LoadSprites:
			BMGE E 0;
			stop;
	}
	
	action void FireMG42()
	{
		BW_FireBullets("BW_MGBullets",3.0,3.0,-1,35,"Bulletpuff","Machinegun",0,0,0);
		A_Overlay(-7,"MuzzleFlash");
		BW_HandleWeaponFeedback(4, 3, -1.2, frandom(+0.70, -0.70));
		A_StartSound("MG42Fire", CHAN_AUTO, CHANF_OVERLAP,0.85);
		A_StartSound("MG42Mech", CHAN_AUTO, CHANF_OVERLAP,1);
		A_StartSound("MG42Loop",42,CHANF_LOOPING, CHANF_NOSTOP, 0.9);
		BW_SpawnCasing("BW_792Casing",20,2,-12,random(2,5),random(3,6),random(1,4));
		BW_AddBarrelHeat(16);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		invoker.ammo2.amount--;
		addfired();
	}
	
	action void addfired(int add = 1,bool set = false)
	{
		if(set)
			invoker.timesFired = add;
		else
			invoker.timesFired += add;
	}
	action int getfiredTimes()
	{
		return invoker.timesFired;
	}
}

Class MG42Ammo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 50;
	}
}

