Class BW_PPSH41 : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 3;
		Weapon.AmmoType "BW_RUPistolAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_PPSH41Mag";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		BaseBWWeapon.FullMag 20;
		tag "PPSh-41";
		Inventory.PickupSound "Generic/Pickup/SMG";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 3] Pistolet-Pulemyot Shpagina-41";
		+weapon.noautofire;
		+weapon.noalert;
	}
	
	bool FireTicker;
	
	action void BW_PPSH41Fire()
	{
		A_AlertMonsters();
		
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("PPSH/Fire",CHAN_AUTO,CHANF_OVERLAP, 1, ATTN_NORM, random(-0.85, -0.95));
		A_Startsound("PPSH/FireAdd",CHAN_AUTO,CHANF_OVERLAP, 0.75);
		A_Startsound("PPSH/FireBass",CHAN_AUTO,CHANF_OVERLAP, 1.0);
		invoker.ammo2.amount--;
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_PPSH41Bullets",0.1,0.1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 2, -0.75, frandom(+1.0, -1.0));//, -5, 0, 0);
			A_ZoomFactor(1.2-0.01);
			BW_SpawnCasing("BW_45ACPCasing",20,3,-5,random(2,5),random(2,5),random(1,3));
		}
		else
		{
			BW_FireBullets("BW_PPSH41Bullets",1,1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 2, -0.75, frandom(+1.0, -1.0));//, -5, 0, 0);
			A_ZoomFactor(1.0-0.01);
			BW_SpawnCasing("BW_45ACPCasing",18,3,-10,random(2,5),random(2,5),random(1,3));
		}
		BW_AddBarrelHeat(10);
		
	}
	
	states
	{
		spawn:
			TM1P A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/SMG/Raise");
			PPSS AB 1;
			TNT1 A 0 A_StartSound("PPSH/Raise", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSS CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_Startsound("PPSH/Lower",CHAN_AUTO,CHANF_OVERLAP);
			PPSS DC 1;
			TNT1 A 0 A_StartSound("Generic/SMG/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSS BA 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			PPSS E 1 {
				BW_GunBarrelSmoke(ofsPos:(22,0,-5));
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3|WRF_ALLOWUSER2);
			}
			loop;
		Ready_ADS:
			2PSA A 1 {
				BW_GunBarrelSmoke(ofsPos:(23,0,-3));
				return BW_WeaponReady(WRF_ALLOWRELOAD);
			}
			loop;
		Fire:
			TNT1 A 0 BW_JumpifAiming("Fire_ADS");
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			PPSF A 1 bright BW_PPSH41Fire();
			PPSF B 1 A_Startsound("PPSH/FireMech",CHAN_AUTO,CHANF_OVERLAP, 0.25);
			TNT1 A 0 A_ZoomFactor(1);
			PPSF C 1 A_ReFire();
			PPSF D 1;
			goto ready;
		Fire_ADS:
			TNT1 A 0 BW_PrefireCheck(1,"Reload_ADS","DryFire_ADS");
			2PSF A 1 bright BW_PPSH41Fire();
			2PSF B 1 A_Startsound("PPSH/FireMech",CHAN_AUTO,CHANF_OVERLAP, 0.25);
			TNT1 A 0 A_ZoomFactor(1.2);
			2PSF C 1 A_ReFire();
			2PSF D 1;
			Goto Ready_ADS;
		
		DryFire:
			TNT1 A 0 A_Startsound("weapon/dryfire",13);
			PPSF C 1;
			goto ready;
		DryFire_ADS:
			TNT1 A 0 A_Startsound("weapon/dryfire",13);
			2PSF B 1;
			goto ready_ADS;
		
		NoAmmo:
			TNT1 A 0 BW_JumpifAiming("NoAmmo_ADS");
			PPSF C 1;
			goto ready;
		NoAmmo_ADS:
			2PSF B 1;
			goto ready_ADS;

		//rechamber too
		Fidget:
			PPSR ABCV 1 BW_Weaponready();
			TNT1 A 0 A_Startsound("PPSH/BoltRelease",CHAN_AUTO,CHANF_OVERLAP,0.7);
			PPSR ZYXW 1 BW_Weaponready();
			PPSR WWW 1 {A_Weaponoffset(-0.35,0.5,WOF_ADD); return BW_Weaponready();}
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("PPSH/BoltCharge",CHAN_AUTO,CHANF_OVERLAP,0.7);
			PPSR WXYZVBA 1 BW_Weaponready();
			PPSF E 1 BW_WeaponReady();
			goto ready;
		
		AltFire:
			TNT1 A 0
			{
				A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
				if(findinventory("AimingToken"))
				{
					A_setinventory("AimingToken",0);
					return resolvestate("StopAim");
				}
				A_setinventory("AimingToken",1);
				return resolvestate(null);
			}
		StartAim:
			TNT1 A 0 A_ZoomFactor(1.2);
			2PSS ABCD 1;
			goto Ready_ADS;
		StopAim:
			TNT1 A 0 A_ZoomFactor(1.0);
			2PSS DCBA 1;
			goto Ready;


		
		KickFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KickFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSS DCB 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSS BBBBBBBBB 1;
			PPSS BCD 1;
			goto ready;
		SlideFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("SlideFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR ABCD 2;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR DDD 1;
			PPSR DDD 1;
			PPSR DDD 1;
			PPSR DDD 1;
			PPSR DDD 1;
			PPSR DDD 1;
		SlideFlashEnd:
			TNT1 A 0 BW_jumpifAkimbo("SlideFlashEnd_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR DDDCBA 1;
			goto ready;
		KnifeGunFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KnifeGunFlash_Akimbo");
			PPSS DCBA 1;	//temporary
			TNT1 A 5;
			PPSS ABCD 1;
			stop;


		
		Reload_ADS:
			TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
			TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			2PSS DCBA 1;
		Reload:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Reload_ADS");
			TNT1 A 0 BW_CheckReload("EmptyReload","Fidget","NoAmmo",71,1);
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR ABCDE 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR FG 2;
			TNT1 A 0 A_startsound("PPSH/MagOut",17);
			PPSR HUTSRQ 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR QQQQQQQ 2;
			PPSR QRSTUH 2;
			TNT1 A 0 A_startsound("PPSH/MagIn",18);
			PPSR GGG 2;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),71,1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR GF 2;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR EDCBA 1;
			goto ready;

		EmptyReload:
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR ABCDE 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR FG 2;
			TNT1 A 0 A_startsound("PPSH/MagOut",17);
			PPSR HIJKLMNOP 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR QQQQQQQ 2;
			PPSR RSTUH 1;
			TNT1 A 0 A_startsound("PPSH/MagIn",18);
			PPSR GGG 2;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),71,1);
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR FEDC 2;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR VW 2;
			TNT1 A 0 A_Startsound("PPSH/BoltCharge",10,CHANF_OVERLAP,0.7);
			PPSR XYZ 1;
			PPSR ZV 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			PPSR CBA 1;
			goto ready;
	}
}

Class BW_PPSH41Mag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 71;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 71;
	}
}