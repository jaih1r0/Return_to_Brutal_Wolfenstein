Class BW_MP40 : BW_DualWeapon Replaces Shotgun
{
	default
	{
		weapon.slotnumber 3;
		Weapon.AmmoType "BW_PistolAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_MP40Mag";
		BaseBWWeapon.AmmoTypeLeft "BW_MP40MagLeft";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		BaseBWWeapon.FullMag 32;
		tag "MP40";
		Inventory.PickupSound "Generic/Pickup/SMG";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 3] Maschinenpistole 40";
		+weapon.noautofire;
		+weapon.noalert;
	}
	
	action void BW_MP40Fire()
	{
		A_AlertMonsters();
		
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("MP40/Fire",5,CHANF_OVERLAP);
		A_Startsound("MP40/FireAdd",5,CHANF_OVERLAP, 0.70);
		invoker.ammo2.amount--;
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_MP40Bullets",0.1,0.1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30));//, -5, 0, 0);
			A_ZoomFactor(1.2-0.01);
			BW_SpawnCasing("BW_9MMCasing",20,3,-5,random(2,5),random(2,5),random(1,3));
		}
		else
		{
			BW_FireBullets("BW_MP40Bullets",1,1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30));//, -5, 0, 0);
			A_ZoomFactor(1.0-0.01);
			BW_SpawnCasing("BW_9MMCasing",29,3,-10,random(2,5),random(2,5),random(1,3));
		}
		BW_AddBarrelHeat(10);
		
	}

	action void BW_DualMP40Fire(bool isLeft = false)
	{
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("MP40/Fire",5,CHANF_OVERLAP);
		A_Startsound("MP40/FireAdd",5,CHANF_OVERLAP, 0.70);
		
		if(isLeft)
		{
			invoker.AmmoLeft.amount--;
			BW_FireBullets("BW_MP40Bullets",2,2,-1,25,"Bulletpuff","Bullet",0,0,-3);
			BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30),d2:-6);
			BW_SpawnCasing("BW_9MMCasing",29,-12,-10,random(2,5),random(2,5),random(1,3));
			BW_AddBarrelHeat(10,false,true);
		}
		else
		{
			invoker.ammo2.amount--;
			BW_FireBullets("BW_MP40Bullets",2,2,-1,25,"Bulletpuff","Bullet",0,0,3);
			BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30),d2:6);
			BW_SpawnCasing("BW_9MMCasing",29,12,-10,random(2,5),random(2,5),random(1,3));
			BW_AddBarrelHeat(10,false,false);
		}
	}
	
	states
	{
		spawn:
			MP4W A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/SMG/Raise");
			TNT1 A 0 BW_jumpifAkimbo("Select_Dual");
			MP4U AB 1;
			TNT1 A 0 A_StartSound("MP40/raise", 0, CHANF_OVERLAP, 1);
			MP4U CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_Startsound("MP40/Lower",5,CHANF_OVERLAP);
			TNT1 A 0 BW_jumpifAkimbo("Deselect_Dual");
			MP4U FG 1;
			TNT1 A 0 A_StartSound("Generic/SMG/Holster", 0, CHANF_OVERLAP, 1);
			MP4U HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			TNT1 A 0 BW_jumpifAkimbo("Ready_Dual");
			MP4U E 1 {
				BW_GunBarrelSmoke(ofsPos:(22,0,-5));
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3|WRF_ALLOWUSER2);
			}
			loop;
		Ready_ADS:
			MP4T E 1 {
				BW_GunBarrelSmoke(ofsPos:(23,0,-3));
				return BW_WeaponReady(WRF_ALLOWRELOAD);
			}
			loop;
		Fire:
			TNT1 A 0 BW_JumpifAiming("Fire_ADS");
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			MP4F A 1 bright BW_MP40Fire();
			MP4F B 1 bright;
			TNT1 A 0 A_ZoomFactor(1);
			MP4F C 1 A_Startsound("MP40/FireMech",5,CHANF_OVERLAP, 0.8);
			MP4F D 1;
			MP4U E 1 A_Refire();
			goto ready;
		Fire_ADS:
			TNT1 A 0 BW_PrefireCheck(1,"Reload_ADS","DryFire_ADS");
			MP4A A 1 bright BW_MP40Fire();
			MP4A B 1;
			TNT1 A 0 A_ZoomFactor(1.2);
			MP4A C 1 A_Startsound("MP40/FireMech",5,CHANF_OVERLAP, 0.8);
			MP4A D 1;
			MP4T E 1 A_Refire();
			Goto Ready_ADS;
		
		DryFire:
			MP4U E 1;
			goto ready;
		DryFire_ADS:
			MP4T E 1;
			goto ready_ADS;
		
		NoAmmo:
			TNT1 A 0 BW_JumpifAiming("NoAmmo_ADS");
			MP4U E 1;
			goto ready;
		NoAmmo_ADS:
			MP4T E 1;
			goto ready_ADS;

		//rechamber too
		Fidget:
			MP4C ABCDE 1 BW_Weaponready();
			TNT1 A 0 A_Startsound("MP40/BoltBack",10,CHANF_OVERLAP,0.7);
			MP4C FGHI 1 BW_Weaponready();
			MP4C III 1 {A_Weaponoffset(-0.35,0.5,WOF_ADD); return BW_Weaponready();}
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("MP40/BoltRelease",11,CHANF_OVERLAP,0.7);
			MP4C JKLMNA 1 BW_Weaponready();
			MP4U E 1 BW_WeaponReady();
			goto ready;
		
		AltFire:
			TNT1 A 0
			{
				A_StartSound("Generic/ADS", 0, CHANF_OVERLAP, 0.5);
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
			MP4T ABCD 1;
			goto Ready_ADS;
		StopAim:
			TNT1 A 0 A_ZoomFactor(1.0);
			MP4T DCBA 1;
			goto Ready;

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
			DM4T ABCDEFGHIJ 1;
			goto ready_Dual;
		GoSingle:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_Startsound("Generic/ADS",CHAN_AUTO);
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			DM4T JIHGFEDCBA 1;
			goto ready;

		Select_Dual:
			DM4U ABCD 1;
			goto Ready_Dual;
		Deselect_Dual:
			TNT1 A 0 BW_ClearDualOverlays();
			DM4U FGHI 1;
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
			DM4L A 1 {
				BW_GunBarrelSmoke(ofsPos:(22,-8,-5),left:true);
				if(pressingButton(BT_Attack) && invoker.Ammoleft.amount > 0)
					return resolvestate("Dual_Left_Fire");
				return resolvestate(null);
			}
			loop;
		Dual_Right:
			DM4R A 1 {
				BW_GunBarrelSmoke(ofsPos:(22,7,-5));
				if(pressingButton(BT_AltAttack) && invoker.ammo2.amount > 0)
					return resolvestate("Dual_Right_Fire");
				return resolvestate(null);
			}
			loop;
		Dual_Left_Fire:
			TNT1 A 0 BW_DualPrefire("Dual_Left_DryFire",true);
			TNT1 A 0 BW_SetFiring(true,false);
			DM4L B 1 bright BW_DualMP40Fire(true);
			DM4L C 1 bright;
			DM4L D 1;
			DM4L E 1;
			TNT1 A 0 BW_SetFiring(false,false);
			DM4L F 1 BW_QuickRefire("Dual_Left_Fire",BT_ATTACK,false);
			goto Dual_Left;
		Dual_Left_DryFire:
			DM4L A 1;
			goto Dual_Left;
		Dual_Right_Fire:
			TNT1 A 0 BW_DualPrefire("Dual_Right_DryFire",false);
			TNT1 A 0 BW_SetFiring(true,true);
			DM4R B 1 bright BW_DualMP40Fire();
			DM4R C 1 bright;
			DM4R D 1;
			DM4R E 1;
			TNT1 A 0 BW_SetFiring(false,true);
			DM4R F 1 BW_QuickRefire("Dual_Right_Fire",BT_ALTATTACK,false);
			goto Dual_Right;
		Dual_Right_DryFire:
			DM4R A 1;
			goto Dual_Right;
		

		
		KickFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KickFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			MP4K ABC 1;
			MP4K DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			MP4K GGG 1;
			MP4K FEDCBA 1;
			goto ready;
		SlideFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("SlideFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4K ABCD 1;
			MP4K EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			MP4K GGG 1;
			MP4K GGG 1;
			MP4K GGG 1;
			MP4K GGG 1;
			MP4K GGG 1;
			MP4K GGG 1;
		SlideFlashEnd:
			TNT1 A 0 BW_jumpifAkimbo("SlideFlashEnd_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			MP4K FEDCBA 1;
			goto ready;
		KnifeGunFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KnifeGunFlash_Akimbo");
			MP4U FGHI 1;	//temporary
			TNT1 A 5;
			MP4U ABCD 1;
			stop;
		KnifeGunFlash_Akimbo:
			DM4U FGHI 1;	//temporary
			TNT1 A 5;
			DM4U ABCD 1;
			stop;

		KickFlash_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			DM4K ABC 1;
			DM4K DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			DM4K GGG 1;
			DM4K FEDCBA 1;
			goto ready;
		SlideFlash_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			DM4K ABCD 1;
			DM4K EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			DM4K GGG 1;
			DM4K GGG 1;
			DM4K GGG 1;
			DM4K GGG 1;
			DM4K GGG 1;
			DM4K GGG 1;
		SlideFlashEnd_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			DM4K FEDCBA 1;
			goto ready;



		
		ReloadADS:
			TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
			TNT1 A 0 A_StartSound("Generic/ADS", 0, CHANF_OVERLAP, 0.5);
			MP4T DCBA 1;
		Reload:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "ReloadADS");
			TNT1 A 0 BW_CheckReload("EmptyReload","Fidget","NoAmmo",32,1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4R ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			MP4R MNOPQRST 1;
			TNT1 A 0 A_startsound("MP40/Out",17);
			MP4R UVWXYZ 1;
			MP4S ABCCC 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			MP4S DEFG 1;
			TNT1 A 0 A_startsound("MP40/In",18);
			MP4S HIJKL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),32,1);
			MP4S MNO 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			MP4R QPONM 1;
			MP4R GFEDCBA 1;
			goto ready;

		EmptyReload:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4R ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			MP4R MNOPQRST 1;
			TNT1 A 0 A_startsound("MP40/Out",17);
			MP4R UVWXYZ 1;
			MP4S ABCCC 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			MP4S DEFG 1;
			TNT1 A 0 A_startsound("MP40/In",18);
			MP4S HIJKL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),31,1);
			MP4S MNO 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			MP4R QPONM 1;
			MP4R GFEDCBA 1;
		//rechamber
			MP4C ABCDE 1;
			TNT1 A 0 A_Startsound("MP40/BoltBack",10,CHANF_OVERLAP,0.7);
			MP4C FGHI 1;
			MP4C III 1 A_Weaponoffset(-0.35,0.5,WOF_ADD);
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("MP40/BoltRelease",11,CHANF_OVERLAP,0.7);
			MP4C JKLMNA 1;
			goto ready;
		
		Reload_Dual:
			TNT1 A 0 BW_ClearDualOverlays();
			//go single
			DM4T JIHGFEDCBA 1;
			TNT1 A 0 A_jumpif(invoker.ammo2.amount > 31,"Reload_Left");
		ReloadRight:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"EmptyReloadRight");
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4R ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			MP4R MNOPQRST 1;
			TNT1 A 0 A_startsound("MP40/Out",17);
			MP4R UVWXYZ 1;
			MP4S ABCCC 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			MP4S DEFG 1;
			TNT1 A 0 A_startsound("MP40/In",18);
			MP4S HIJKL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),32,1);
			MP4S MNO 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			MP4R QPONM 1;
			MP4R GFEDCBA 1;
			goto FinishedRight;

		EmptyReloadRight:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4R ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			MP4R MNOPQRST 1;
			TNT1 A 0 A_startsound("MP40/Out",17);
			MP4R UVWXYZ 1;
			MP4S ABCCC 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			MP4S DEFG 1;
			TNT1 A 0 A_startsound("MP40/In",18);
			MP4S HIJKL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),31,1);
			MP4S MNO 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			MP4R QPONM 1;
			MP4R GFEDCBA 1;
		//rechamber
			MP4C ABCDE 1;
			TNT1 A 0 A_Startsound("MP40/BoltBack",10,CHANF_OVERLAP,0.7);
			MP4C FGHI 1;
			MP4C III 1 A_Weaponoffset(-0.35,0.5,WOF_ADD);
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("MP40/BoltRelease",11,CHANF_OVERLAP,0.7);
			MP4C JKLMNA 1;
			goto FinishedRight;

		FinishedRight:
			TNT1 A 0 A_jumpif(invoker.ammoleft.amount > 31 || invoker.ammo1.amount < 1,"EndDualReload");
		//lower right
		Reload_Left:
			MP4U FGHI 1;
			TNT1 A 1;
		//raise left
			MP4U ABCD 1;
	
		//reload left
		doReloadLeft:
			TNT1 A 0 A_jumpif(invoker.ammoleft.amount < 1,"EmptyReloadLeft");
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4R ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			MP4R MNOPQRST 1;
			TNT1 A 0 A_startsound("MP40/Out",17);
			MP4R UVWXYZ 1;
			MP4S ABCCC 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			MP4S DEFG 1;
			TNT1 A 0 A_startsound("MP40/In",18);
			MP4S HIJKL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotypeLeft.getclassname(),invoker.ammotype1.getclassname(),32,1);
			MP4S MNO 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			MP4R QPONM 1;
			MP4R GFEDCBA 1;
		FinishedLeft:
		//lower left
			MP4U FGHI 1;
			TNT1 A 1;
		//raise right
			MP4U ABCD 1;
		//back to dual
		EndDualReload:
			DM4T ABCDEFGHIJ 1;
			goto ready_Dual;
		
		EmptyReloadLeft:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4R ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			MP4R MNOPQRST 1;
			TNT1 A 0 A_startsound("MP40/Out",17);
			MP4R UVWXYZ 1;
			MP4S ABCCC 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			MP4S DEFG 1;
			TNT1 A 0 A_startsound("MP40/In",18);
			MP4S HIJKL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotypeLeft.getclassname(),invoker.ammotype1.getclassname(),31,1);
			MP4S MNO 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			MP4R QPONM 1;
			MP4R GFEDCBA 1;
		//rechamber
			MP4C ABCDE 1;
			TNT1 A 0 A_Startsound("MP40/BoltBack",10,CHANF_OVERLAP,0.7);
			MP4C FGHI 1;
			MP4C III 1 A_Weaponoffset(-0.35,0.5,WOF_ADD);
			TNT1 A 0 A_Weaponoffset(0,32);
			TNT1 A 0 A_Startsound("MP40/BoltRelease",11,CHANF_OVERLAP,0.7);
			MP4C JKLMNA 1;
			goto EndDualReload;
	}
}

Class BW_MP40Mag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 32;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 32;
	}
}

Class BW_MP40MagLeft : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 32;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 32;
	}
}