Class BW_STG44 : BW_DualWeapon replaces supershotgun
{
	default
	{
		weapon.slotnumber 3;
		tag "STG44";
		weapon.ammotype2 "STG44Mag";
		weapon.ammotype1 "BW_STGAmmo"; 
		BaseBWWeapon.AmmoTypeLeft "STG44MagLeft";
		Inventory.PickupSound "Generic/Pickup/SMG";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 3] Sturmgewehr 44";
		weapon.ammogive1 10;
		BaseBWWeapon.FullMag 31;
		scale 0.7;
		+weapon.noautofire;
		+weapon.noalert;
	}
	
	action void BW_STG44Fire()
	{
		A_AlertMonsters();
		
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("STG/Fire", CHAN_AUTO, CHANF_OVERLAP, 0.65); //Slightly reduced so the low bitrate isnt too obvious
		A_Startsound("STG/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_Startsound("STG/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		
		//[pop] These are a test, probably wont stay
		//[pop] Theyre staying, its sex
		A_Startsound("STG/FireBass", CHAN_AUTO, CHANF_OVERLAP, 0.75);
		A_Startsound("STG/FireSubWoof", CHAN_AUTO, CHANF_OVERLAP, 0.75);
		invoker.ammo2.amount--;
		
		if(BW_IsAiming())
		{
			BW_FireBullets("BW_STG44Bullets",0.75,0.65,-1,40,"Bulletpuff","Bullet",0,0,0);
			BW_SpawnCasing("BW_9MMCasing",23,6,-8,random(2,5),random(2,5),random(1,3));
		}
		else
		{
			BW_FireBullets("BW_STG44Bullets",2,1,-1,40,"Bulletpuff","Bullet",0,0,0);
			BW_SpawnCasing("BW_9MMCasing",29,3,-10,random(2,5),random(2,5),random(1,3));
		}
		BW_HandleWeaponFeedback(2, 3, -0.8, frandom(+0.40, -0.40));//, -5, 0, 0);
		BW_AddBarrelHeat(20);
		
	}
	
	action void BW_DualSTGFire(bool isLeft = false)
	{
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("STG/Fire", CHAN_AUTO, CHANF_OVERLAP, 0.65); //Slightly reduced so the low bitrate isnt too obvious
		A_Startsound("STG/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_Startsound("STG/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		
		//[pop] These are a test, probably wont stay
		//[pop] Theyre staying, its sex
		A_Startsound("STG/FireBass", CHAN_AUTO, CHANF_OVERLAP, 0.75);
		A_Startsound("STG/FireSubWoof", CHAN_AUTO, CHANF_OVERLAP, 0.75);
		
		if(isLeft)
		{
			invoker.AmmoLeft.amount--;
			BW_FireBullets("BW_STG44Bullets",4,4,-1,25,"Bulletpuff","Machinegun",0,0,-3);
			//probably making the stg44 mutants drop their armor as an upgrade
			//reducing a lot the recoil from dualwielding this thing
			BW_HandleWeaponFeedback(4, 3, -1.7, frandom(0.5,1.32),d2:-6);
			BW_SpawnCasing("BW_9MMCasing",29,-12,-10,random(2,5),random(2,5),random(1,3));
			BW_AddBarrelHeat(20,false,true);
		}
		else
		{
			invoker.ammo2.amount--;
			BW_FireBullets("BW_STG44Bullets",4,4,-1,25,"Bulletpuff","Machinegun",0,0,3);
			BW_HandleWeaponFeedback(4, 3, -1.7, frandom(-1.32,-0.5),d2:6);
			BW_SpawnCasing("BW_9MMCasing",27,15,-10,random(2,5),random(2,5),random(1,3));
			BW_AddBarrelHeat(20,false,false);
		}
	}
	
	states
	{
		spawn:
			STGI A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/SMG/Raise");
			TNT1 A 0 BW_jumpifAkimbo("Select_Dual");
			ST4U AB 1;
			TNT1 A 0 A_StartSound("STG/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4U CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 A_Startsound("STG/Lower",CHAN_AUTO,CHANF_OVERLAP);
			TNT1 A 0 BW_jumpifAkimbo("Deselect_Dual");
			ST4U FG 1;
			TNT1 A 0 A_StartSound("Generic/SMG/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4U HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			TNT1 A 0 BW_jumpifAkimbo("Ready_Dual");
			ST4U E 1 {
				BW_GunBarrelSmoke(ofsPos:(22,0,-5));
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3|WRF_ALLOWUSER2);
			}
			loop;
		
		Ready_ADS:
			ST4A E 1 {
				BW_GunBarrelSmoke(ofsPos:(23,0,-3));
				return BW_WeaponReady(WRF_ALLOWRELOAD);
			}
			loop;
		
		Fire:
			TNT1 A 0 BW_JumpifAiming("Fire_ADS");
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			ST4F A 1 bright BW_STG44Fire();
			ST4F B 1 bright;
			ST4F C 1;
			ST4F E 1;
			TNT1 A 0 A_Refire();
			ST4F F 1;
			goto ready;
		Fire_ADS:
			TNT1 A 0 BW_PrefireCheck(1,"ReloadADS","DryFire_ADS");
			ST4I A 1 bright BW_STG44Fire();
			ST4I B 1 bright;
			ST4I C 1;
			ST4I E 1;
			TNT1 A 0 A_Refire();
			ST4I F 1;
			goto ready_ADS;
			
		DryFire:
			TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
			ST4U E 1;
			goto ready;
		DryFire_ADS:
			TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
			ST4A E 1;
			goto ready_ADS;
		NoAmmo:
			ST4U E 1;
			goto ready;
		NoAmmo_ADS:
			ST4A E 1;
			goto ready_ADS;
		
		
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
			ST4A ABCD 1;
			goto Ready_ADS;
		StopAim:
			TNT1 A 0 A_ZoomFactor(1.0);
			ST4A DCBA 1;
			goto Ready;
			
		ReloadADS:
			TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
			TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			ST4A DCBA 1;
		Reload:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_JumpifAiming("ReloadADS");
			TNT1 A 0 BW_CheckReload(null,"Ready","NoAmmo",31,1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4R ABCDE 1;
			TNT1 A 0 A_Startsound("STG/MagOut",CHAN_AUTO);
			ST4R FGHHHHHIJKLMNNNNNNN 1;
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",CHAN_AUTO);
			ST4R OPQRST 1;
			TNT1 A 0 A_Startsound("Generic/Ammo/MagFoley",CHAN_AUTO);
			ST4R UVWWWX 1;
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			ST4R YZ 1;
			TNT1 A 0 A_Startsound("STG/MagIn",CHAN_AUTO);
			ST4S ABBB 1;
			TNT1 A 0 A_Startsound("Generic/Rattle/Medium",CHAN_AUTO);
			ST4S CDEFG 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),31,1);
			TNT1 A 0 A_Startsound("Generic/Cloth/Medium",CHAN_AUTO);
			ST4R LKJIHGFEDCBA 1;
			goto ready;
		
		Reload_Dual:
			TNT1 A 0 BW_ClearDualOverlays();
			//go single
			ST4T JIHGFEDCBA 1;
			TNT1 A 0 A_jumpif(invoker.ammo2.amount > 30,"Reload_Left");
		ReloadRight:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4R ABCDE 1;
			TNT1 A 0 A_Startsound("STG/MagOut",CHAN_AUTO);
			ST4R FGHHHHHIJKLMNNNNNNN 1;
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",CHAN_AUTO);
			ST4R OPQRST 1;
			TNT1 A 0 A_Startsound("Generic/Ammo/MagFoley",CHAN_AUTO);
			ST4R UVWWWX 1;
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			ST4R YZ 1;
			TNT1 A 0 A_Startsound("STG/MagIn",CHAN_AUTO);
			ST4S ABBB 1;
			TNT1 A 0 A_Startsound("Generic/Rattle/Medium",CHAN_AUTO);
			ST4S CDEFG 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),31,1);
			ST4R LKJIHGFEDCBA 1;
			goto FinishedRight;
			
		FinishedRight:
			TNT1 A 0 A_jumpif(invoker.ammoleft.amount > 30 || invoker.ammo1.amount < 1,"EndDualReload");
		//lower right
		Reload_Left:
			ST4U FGHI 1;
			TNT1 A 1;
		//raise left
			ST4U ABCD 1;
		doReloadLeft:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			ST4R ABCDE 1;
			TNT1 A 0 A_Startsound("STG/MagOut",CHAN_AUTO);
			ST4R FGHHHHHIJKLMNNNNNNN 1;
			TNT1 A 0 A_Startsound("Generic/Rattle/Small",CHAN_AUTO);
			ST4R OPQRST 1;
			TNT1 A 0 A_Startsound("Generic/Ammo/MagFoley",CHAN_AUTO);
			ST4R UVWWWX 1;
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			ST4R YZ 1;
			TNT1 A 0 A_Startsound("STG/MagIn",CHAN_AUTO);
			ST4S ABBB 1;
			TNT1 A 0 A_Startsound("Generic/Rattle/Medium",CHAN_AUTO);
			ST4S CDEFG 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammoLeft.getclassname(),invoker.ammotype1.getclassname(),31,1);
			ST4R LKJIHGFEDCBA 1;
		FinishedLeft:
		//lower left
			ST4U FGHI 1;
			TNT1 A 1;
		//raise right
			ST4U ABCD 1;
		//back to dual
		EndDualReload:
			ST4T ABCDEFGHIJK 1;
			goto ready_Dual;
			
		//dual wield states
		User2:
		GoDual:
			TNT1 A 0 {
				if(!BW_CangoDual())
				{
					if((player.cmd.buttons & BT_USER2) && !(player.oldbuttons & BT_USER2))	//print it only once per tap
						A_log("you need 2 "..invoker.gettag().." to dual wield.");
					BW_SetAkimbo(false);
					return resolvestate("Ready");
				}
				if(BW_CheckAkimbo())
				{
					BW_SetAkimbo(false);
					BW_ClearDualOverlays();
					return resolvestate("GoSingle");
				}
				BW_SetAkimbo(true);
				return resolvestate(null);
			}
			TNT1 A 0 A_Startsound("Generic/ADS",CHAN_AUTO);
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			ST4T ABCDEFGHIJK 1;
			goto ready_Dual;
		GoSingle:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_Startsound("Generic/ADS",CHAN_AUTO);
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			ST4T JIHGFEDCBA 1;
			goto ready;

		Select_Dual:
			STDU ABCD 1;
			goto Ready_Dual;
		Deselect_Dual:
			TNT1 A 0 BW_ClearDualOverlays();
			STDU FGHI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;

		StartDual:
		Ready_Dual:
			TNT1 A 1 {
				A_Overlay(PSP_LeftGun,"Dual_Left",true);
				A_Overlay(PSP_RightGun,"Dual_Right",true);
				BW_Weaponready(WRF_NOFIRE|WRF_ALLOWUSER2|WRF_ALLOWUSER3);	//allow weapon changes
				if(pressingButton(BT_RELOAD) && !BW_isFiring(true) && !BW_isFiring(false)
				&& invoker.ammo1.amount > 0 && (invoker.ammo2.amount < invoker.FullMag || invoker.Ammoleft.amount < invoker.FullMag))
				{
					BW_SetReloading(true);
					return resolvestate("Reload_Dual");
				}
				if(invoker.amount < 2)
				{
					BW_ClearDualOverlays();
					BW_SetAkimbo(false);
					return resolvestate("goSingle");
				}
				return resolvestate(null);
			}
			loop;

		Dual_Left:
			STLF A 1 {
				BW_GunBarrelSmoke(ofsPos:(22,-7,-5),left:true);
				return BW_DualReady(true,"Dual_Left_Fire");
			}
			loop;
		Dual_Right:
			STRF A 1 {
				BW_GunBarrelSmoke(ofsPos:(22,7,-5));
				return BW_DualReady(false,"Dual_Right_Fire");
			}
			loop;
			
		Dual_Left_Fire:
			TNT1 A 0 BW_DualPrefire("Dual_Left_DryFire",true);
			TNT1 A 0 BW_SetFiring(true,false);
			STLF B 1 bright BW_DualSTGFire(true);
			STLF C 1 bright;
			STLF D 1;
			STLF E 1;
			TNT1 A 0 BW_SetFiring(false,false);
			STLF G 1 BW_QuickRefire("Dual_Left_Fire",BT_ATTACK,false);
			goto Dual_Left;
		Dual_Left_DryFire:
			TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
			STLF A 1;
			goto Dual_Left;
			
		Dual_Right_Fire:
			TNT1 A 0 BW_DualPrefire("Dual_Right_DryFire",false);
			TNT1 A 0 BW_SetFiring(true,true);
			STRF B 1 bright BW_DualSTGFire();
			STRF C 1 bright;
			STRF D 1;
			STRF E 1;
			TNT1 A 0 BW_SetFiring(false,true);
			STRF G 1 BW_QuickRefire("Dual_Right_Fire",getRightfirebutton(),false);
			goto Dual_Right;
		Dual_Right_DryFire:
			TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
			STRF A 1;
			goto Dual_Right;
			
			
			
			
		
		KickFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KickFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4K ABC 1;
			ST4K DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4K GGG 1;
			ST4K FEDCBA 1;
			goto ready;
		SlideFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("SlideFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4K ABCD 1;
			ST4K EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4K GGG 1;
			ST4K GGG 1;
			ST4K GGG 1;
			ST4K GGG 1;
			ST4K GGG 1;
			ST4K GGG 1;
		SlideFlashEnd:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("SlideFlashEnd_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			ST4K FEDCBA 1;
			goto ready;
		KnifeGunFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KnifeGunFlash_Akimbo");
			ST4U FGHI 1;	//temporary
			TNT1 A 5;
			ST4U ABCD 1;
			stop;
		
		KickFlash_Akimbo:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			STDK ABC 1;
			STDK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			STDK GGG 1;
			STDK FEDCBA 1;
			goto ready;
		KnifeGunFlash_Akimbo:
			STDU FGHI 1;	//temporary
			TNT1 A 5;
			STDU ABCD 1;
			stop;
		
		SlideFlash_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			STDK ABCD 1;
			STDK EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			STDK GGG 1;
			STDK GGG 1;
			STDK GGG 1;
			STDK GGG 1;
			STDK GGG 1;
			STDK GGG 1;
		SlideFlashEnd_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			STDK FEDCBA 1;
			goto ready;
		
	}
}

Class STG44Mag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 31;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 31;
	}
}

Class STG44MagLeft : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 31;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 31;
	}
}