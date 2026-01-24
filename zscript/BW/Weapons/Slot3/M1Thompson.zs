Class BW_M1Thompson : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 3;
		Weapon.AmmoType "BW_USAPistolAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_M1ThompsonMag";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		BaseBWWeapon.FullMag 20;
		tag "M1 Thompson";
		Inventory.PickupSound "Generic/Pickup/SMG";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 3] M1A1 Thompson Sub-Machinegun";
		+weapon.noautofire;
		+weapon.noalert;
	}
	
	action void BW_M1ThompsonFire()
	{
		A_AlertMonsters();
		
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("M1Tom/Fire",CHAN_AUTO,CHANF_OVERLAP);
		A_Startsound("M1Tom/FireAdd",CHAN_AUTO,CHANF_OVERLAP, 0.90);
		A_Startsound("M1Tom/FireTail",CHAN_AUTO,CHANF_OVERLAP, 0.60);
		A_Startsound("M1Tom/FireBass",CHAN_AUTO,CHANF_OVERLAP, 0.75);
		invoker.ammo2.amount--;
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_M1ThompsonBullets",0.1,0.1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30));//, -5, 0, 0);
			A_ZoomFactor(1.2-0.01);
			BW_SpawnCasing("BW_45ACPCasing",20,3,-5,random(2,5),random(2,5),random(1,3));
		}
		else
		{
			BW_FireBullets("BW_M1ThompsonBullets",1,1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30));//, -5, 0, 0);
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
			TMS1 AB 1;
			TNT1 A 0 A_StartSound("M1Tom/Raise", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMS1 CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_Startsound("M1Tom/Lower",CHAN_AUTO,CHANF_OVERLAP);
			TMS1 DC 1;
			TNT1 A 0 A_StartSound("Generic/SMG/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMS1 BA 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			TMF1 A 1 {
				BW_GunBarrelSmoke(ofsPos:(22,0,-5));
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3|WRF_ALLOWUSER2);
			}
			loop;
		Ready_ADS:
			TMF2 A 1 {
				BW_GunBarrelSmoke(ofsPos:(23,0,-3));
				return BW_WeaponReady(WRF_ALLOWRELOAD);
			}
			loop;
		Fire:
			TNT1 A 0 BW_JumpifAiming("Fire_ADS");
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			TMF1 B 1 bright BW_M1ThompsonFire();
			TMF1 C 1;
			TNT1 A 0 A_ZoomFactor(1);
			TMF1 D 1 A_Startsound("M1Tom/FireMech",CHAN_AUTO,CHANF_OVERLAP, 0.8);
			TMF1 C 1 A_Refire();
			goto ready;
		Fire_ADS:
			TNT1 A 0 BW_PrefireCheck(1,"Reload_ADS","DryFire_ADS");
			TMF2 B 1 bright BW_M1ThompsonFire();
			TMF2 C 1;
			TNT1 A 0 A_ZoomFactor(1.2);
			TMF2 D 1 A_Startsound("M1Tom/FireMech",CHAN_AUTO,CHANF_OVERLAP, 0.8);
			TMF2 C 1 A_Refire();
			Goto Ready_ADS;
		
		DryFire:
			TNT1 A 0 A_Startsound("weapon/dryfire",13);
			TMF1 A 1;
			goto ready;
		DryFire_ADS:
			TNT1 A 0 A_Startsound("weapon/dryfire",13);
			TMF2 A 1;
			goto ready_ADS;
		
		NoAmmo:
			TNT1 A 0 BW_JumpifAiming("NoAmmo_ADS");
			TMF1 A 1;
			goto ready;
		NoAmmo_ADS:
			TMF2 A 1;
			goto ready_ADS;

		//rechamber too
		Fidget:
			MP4C ABCDE 1 BW_Weaponready();
			TNT1 A 0 A_Startsound("MP40/BoltBack",CHAN_AUTO,CHANF_OVERLAP,0.7);
			MP4C FGHI 1 BW_Weaponready();
			MP4C III 1 {A_Weaponoffset(-0.35,0.5,WOF_ADD); return BW_Weaponready();}
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("MP40/BoltRelease",CHAN_AUTO,CHANF_OVERLAP,0.7);
			MP4C JKLMNA 1 BW_Weaponready();
			MP4U E 1 BW_WeaponReady();
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
			TMS2 ABCD 1;
			goto Ready_ADS;
		StopAim:
			TNT1 A 0 A_ZoomFactor(1.0);
			TMS2 DCBA 1;
			goto Ready;


		
		KickFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KickFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			TM1K ABC 1;
			TM1K DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			TM1K GGG 1;
			TM1K FEDCBA 1;
			goto ready;
		SlideFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("SlideFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			TM1K ABCD 1;
			TM1K EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			TM1K GGG 1;
			TM1K GGG 1;
			TM1K GGG 1;
			TM1K GGG 1;
			TM1K GGG 1;
			TM1K GGG 1;
		SlideFlashEnd:
			TNT1 A 0 BW_jumpifAkimbo("SlideFlashEnd_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			TM1K FEDCBA 1;
			goto ready;
		KnifeGunFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KnifeGunFlash_Akimbo");
			TMS1 DCBA 1;	//temporary
			TNT1 A 5;
			TMS1 ABCD 1;
			stop;


		
		ReloadADS:
			TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
			TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			TMS2 DCBA 1;
		Reload:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "ReloadADS");
			TNT1 A 0 BW_CheckReload("EmptyReload","Fidget","NoAmmo",20,1);
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR1 ABCDEFGHI 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR1 JKLMNNNNN 2;
			TNT1 A 0 A_startsound("M1Tom/MagOut",17);
			TMR1 OPQRSTUVW 2;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR1 XXXXXYZ 2;
			TMR2 ABCD 2;
			TNT1 A 0 A_startsound("M1Tom/MagIn",18);
			TMR1 NNN 2;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),20,1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR1 MLKJ 2;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR1 IHGFEDCBA 1;
			goto ready;

		EmptyReload:
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMS1 DC 2;
			TMR3 ABCDEFGHHH 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR3 IJKLLL 2;
			TNT1 A 0 A_startsound("M1Tom/MagOutEmpty",17);
			TMR3 MNOPQRS 2;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR3 TUVWXY 2;
			TNT1 A 0 A_startsound("M1Tom/MagInEmpty",18);
			TMR3 LLL 2;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),20,1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR3 K 2;
			TNT1 A 0 A_Startsound("M1Tom/Bolt",10,CHANF_OVERLAP,0.7);
			TMR3 Z 2;
			TMR4 ABBB 2;
			TMR3 H 2;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			TMR3 GFEDCBA 1;
			goto ready;
	}
}

Class BW_M1ThompsonMag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 20;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 20;
	}
}