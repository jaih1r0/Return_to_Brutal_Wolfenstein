class BW_Chaingun : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 5;
		scale 0.75;
		Inventory.PickupSound "Generic/Pickup/Rifle";
		weapon.ammotype1 "BW_MGAmmo";//"Clip";
		weapon.ammotype2 "ChaingunAmmoDrum";
		weapon.ammogive1 100;
		+weapon.noautofire;
		BaseBWWeapon.FullMag 200;
		
		Inventory.Pickupmessage "[Slot 5] Chaingun";
		Tag "Chaingun";
	}
	
	states
	{
		Spawn:
			BCGW A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Rifle/Raise");
			BCGU AB 1;
			TNT1 A 0 A_StartSound("MG42/Raise", 0, CHANF_OVERLAP, 1);
			BCGU CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 A_Stopsound(42);
			TNT1 A 0 A_Startsound("MG42/Drop",5,CHANF_OVERLAP);
			BCGU FG 1;
			TNT1 A 0 A_StartSound("Generic/Rifle/Holster", 0, CHANF_OVERLAP, 1);
			BCGU HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			BCGT A 1 {
				BW_GunBarrelSmoke(ofsPos:(30,0,-7));
				return BW_WeaponReady(WRF_ALLOWUSER3|WRF_ALLOWRELOAD);
			}
			loop;
		
		Fire:
			TNT1 A 0 BW_PrefireCheck(1,"DryFire","DryFire");
			BCGS ABCD 1;
		FireLoop1:
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 BW_PrefireCheck(1,"DryFireFast","DryFireFast");
			BCGF A 1 bright fireChaingun();
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount <= 0, "DryFireFast");
			
			TNT1 A 0 A_Weaponoffset(0 + random(-2,2),32 + random(-1,-2));
			BCGF B 1 bright fireChaingun(true);
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount <= 0, "DryFireFast");
			
			TNT1 A 0 A_refire("FireLoop2");
			goto FireEnd;
		
		FireLoop2:
			TNT1 A 0 A_Weaponoffset(0 + random(-2,2),32 + random(-1,-2));
			BCGF C 1 bright fireChaingun();
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount <= 0, "DryFireFast");
			
			TNT1 A 0 A_Weaponoffset(0,32);
			BCGF D 1 bright fireChaingun(true);
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount <= 0, "DryFireFast");
			
			TNT1 A 0 A_refire("FireLoop1");
			goto FireEnd;
			
		FireEnd:
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_StopSound(42);
			BCGS ABCD 1;
			BCGT ACEG 1;
		FireSlowEnd:
			TNT1 A 0 A_StopSound(42);
			BCGT ABCDEFGH 1 BW_WeaponReady(WRF_ALLOWUSER3|WRF_ALLOWRELOAD);
			BCGT ABCDEFGH 2 BW_WeaponReady(WRF_ALLOWUSER3|WRF_ALLOWRELOAD);
			TNT1 A 0 A_StopSound(42);
			goto ready;
		
		DryFire:
			TNT1 A 0 A_StopSound(42);
			BCGT ABCDEFGH 1 BW_WeaponReady(WRF_ALLOWUSER3|WRF_ALLOWRELOAD);
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount > 0, "FireLoop1");
			TNT1 A 0 A_refire("DryFire");
			goto ready;
		DryFireFast:
			TNT1 A 0 A_StopSound(42);
			BCGS ABCD 1 BW_WeaponReady(WRF_ALLOWUSER3|WRF_ALLOWRELOAD);
			TNT1 A 0 A_JumpIf(invoker.ammo2.amount > 0, "FireLoop1");
			TNT1 A 0 A_refire("DryFireFast");
			goto FireEnd;
		NoAmmo:
			BCGT A 1;
			goto ready;
		
		Reload:
			TNT1 A 0 BW_CheckReload(null,"Ready","NoAmmo",200,1);
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",0);
			BCGK ABCD 1;
			TNT1 A 0 A_Startsound("MG42OPEN",CHAN_AUTO);
			BCGK EFGH 1;
			BCGK H 5;
			BCGK H 10;
			TNT1 A 0 A_Startsound("MG42Bul",32);
			BCGK H 2 offset(0,33);
			BCGK H 2 offset(0,35);
			BCGK H 26 offset(-1,37);
			BCGK H 2 offset(-2,38);
			TNT1 A 0 A_Startsound("MG42Close",CHAN_AUTO);
			BCGK H 2 offset(-1,37);
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),200,1);
			BCGK H 2 offset(-2,36);
			BCGK H 2 offset(-1,34);
			BCGK H 2 offset(0,33);
			BCGK H 2 offset(0,32);
			BCGK FEDCBA 1;
			goto ready;
		
		PrepareKnifeLayer:
		PrepareLedgeGrab:
			TNT1 A 0 A_Stopsound(42);
			TNT1 A 1;
			stop;
			
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BCGK ABC 1;
			BCGK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			BCGK GHHHG 1;
			BCGK FEDCBA 1;
			goto ready;	
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BCGK ABCD 1;
			BCGK EFGH 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			BCGK HHH 1;
			BCGK HHH 1;
			BCGK HHH 1;
			BCGK HHH 1;
			BCGK HHH 1;
			BCGK HHH 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BCGK FEDCBA 1;
			goto ready;
		MuzzleFlash:
			TNT1 A 0 A_OverlayFlags(overlayID(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
			BCGM A 1 bright {
				let ps = player.findPSprite(overlayID());
				if(ps)
					ps.frame = random(0,3);
			}
			BCGM E 1 bright {
				let ps = player.findPSprite(overlayID());
				if(ps)
					ps.frame = random(4,7);
			}
			stop;
	}
	
	action void fireChaingun(bool second = false)
	{
		BW_FireBullets("BW_MGBullets",5.0,5.0,-1,35,"Bulletpuff","Machinegun",0,0,0);
		if(second)
		{
			A_Overlay(-7,"MuzzleFlash");
			A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
			BW_SpawnCasing("BW_792Casing",20,2,-12,random(2,5),random(3,6),random(1,4));
		}
		
		BW_HandleWeaponFeedback(4, 3, -1.2, frandom(+0.70, -0.70));
		A_StartSound("MG42Fire", CHAN_AUTO, CHANF_OVERLAP,0.85);
		A_StartSound("MG42/FireBass", CHAN_AUTO, CHANF_OVERLAP,0.75);
		A_StartSound("MG42Mech", CHAN_AUTO, CHANF_OVERLAP,1);
		A_StartSound("MG42Loop",42,CHANF_LOOPING, CHANF_NOSTOP, 0.9);
		
		BW_AddBarrelHeat(16);
		
		invoker.ammo2.amount--;
	}
}

Class ChaingunAmmoDrum : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 200;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 200;
	}
}