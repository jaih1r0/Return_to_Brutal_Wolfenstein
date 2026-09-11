Class BW_FG42 : BW_DualWeapon
{
	default
	{
		weapon.slotnumber 5;
		Weapon.AmmoType "BW_KarAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_FG42Mag";
		BaseBWWeapon.AmmoTypeLeft "BW_FG42MagLeft";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		BaseBWWeapon.FullMag 20;
		tag "FG42";
		Inventory.PickupSound "Generic/Pickup/LMG";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 5] Fallschirmjagergewehr 42";
		+weapon.noautofire;
		+weapon.noalert;
	}
	
	action void BW_FG42Fire()
	{
		A_AlertMonsters();
		
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("FG42/Fire",CHAN_AUTO,CHANF_OVERLAP, 0.9);
		A_Startsound("FG42/Bass",CHAN_AUTO,CHANF_OVERLAP);
		A_Startsound("FG42/FireAdd",CHAN_AUTO,CHANF_OVERLAP);
		invoker.ammo2.amount--;
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_MGBullets",0.1,0.1,-1,35,"Bulletpuff","Machinegun",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.75, frandom(+0.35, -0.35));//, -5, 0, 0);
			A_ZoomFactor(1.2-0.01);
			BW_SpawnCasing("BW_792Casing",20,3,-5,random(2,5),random(2,5),random(1,3));
		}
		else
		{
			BW_FireBullets("BW_MGBullets",1.5,1.5,-1,35,"Bulletpuff","Machinegun",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.75, frandom(+0.35, -0.35));//, -5, 0, 0);
			A_ZoomFactor(1.0-0.01);
			BW_SpawnCasing("BW_792Casing",20,2,-12,random(2,5),random(3,6),random(1,4));
		}
		BW_AddBarrelHeat(16);
		
	}

	action void BW_DualFG42Fire(bool isLeft = false)
	{
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("FG42/Fire",CHAN_AUTO,CHANF_OVERLAP, 0.9);
		A_Startsound("FG42/Bass",CHAN_AUTO,CHANF_OVERLAP);
		A_Startsound("FG42/FireAdd",CHAN_AUTO,CHANF_OVERLAP);
		
		if(isLeft)
		{
			invoker.AmmoLeft.amount--;
			BW_FireBullets("BW_MGBullets",3,3,-1,35,"Bulletpuff","Machinegun",0,0,-3);
			BW_HandleWeaponFeedback(2, 3, -1.0, frandom(+0.50, -0.50),d2:-6);
			BW_SpawnCasing("BW_792Casing",29,-12,-10,random(2,5),random(3,6),random(1,4));
			BW_AddBarrelHeat(16);
		}
		else
		{
			invoker.ammo2.amount--;
			BW_FireBullets("BW_MGBullets",3,3,-1,35,"Bulletpuff","Machinegun",0,0,3);
			BW_HandleWeaponFeedback(2, 3, -1.0, frandom(+0.50, -0.50),d2:6);
			BW_SpawnCasing("BW_792Casing",29,12,-10,random(2,5),random(3,6),random(1,4));
			BW_AddBarrelHeat(16);
		}
	}
	
	states
	{
	Spawn:
		FG4P A -1;
		stop;

	Select:
		TNT1 A 0 BW_WeaponRaise("Generic/SMG/Raise");
		TNT1 A 0 BW_jumpifAkimbo("Select_Dual");
		FG4S AB 1;
		TNT1 A 0 A_StartSound("FG42/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
		FG4S CD 1;
		goto ready;

	Deselect:
		TNT1 A 0 BW_SetReloading(false);
		TNT1 A 0 BW_ClearDualOverlays();
		TNT1 A 0 A_Startsound("FG42/Lower",CHAN_AUTO,CHANF_OVERLAP);
		TNT1 A 0 BW_jumpifAkimbo("Deselect_Dual");
		FG4S EF 1;
		TNT1 A 0 A_StartSound("Generic/SMG/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
		FG4S GH 1;
		TNT1 A 0 BW_WeaponLower();
		wait;

	Ready:
		TNT1 A 0 BW_jumpifAkimbo("Ready_Dual");
		FG4F A 1 
		{
			BW_GunBarrelSmoke(ofsPos:(22,0,-5));
			return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3|WRF_ALLOWUSER2|WRF_ALLOWUSER4);
		}
		loop;

	Ready_ADS:
		FGF2 A 1 
		{
			BW_GunBarrelSmoke(ofsPos:(23,0,-3));
			return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER4);
		}
		loop;

	Fire:
		TNT1 A 0 BW_JumpifAiming("Fire_ADS");
		TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
		FG4F B 1 bright BW_FG42Fire();
		FG4F C 1 bright;
		TNT1 A 0 A_ZoomFactor(1);
		FG4F E 1 A_Startsound("FG42/FireMech",CHAN_AUTO,CHANF_OVERLAP, 0.8);
		TNT1 A 0 A_Refire();
		FG4F D 1;
		goto ready;

	Fire_ADS:
		TNT1 A 0 BW_PrefireCheck(1,"Reload_ADS","DryFire_ADS");
		FGF2 B 1 bright BW_FG42Fire();
		FGF2 C 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		FGF2 E 1 A_Startsound("FG42/FireMech",CHAN_AUTO,CHANF_OVERLAP, 0.8);
		TNT1 A 0 A_Refire();
		FGF2 D 1;
		Goto Ready_ADS;

	DryFire:
		TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
		FG4F A 1;
		goto ready;

	DryFire_ADS:
		TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
		FGF2 A 1;
		goto ready_ADS;

	NoAmmo:
		TNT1 A 0 BW_JumpifAiming("NoAmmo_ADS");
		FG4F A 1;
		goto ready;

	NoAmmo_ADS:
		FGF2 A 1;
		goto ready_ADS;

	//rechamber too
	Fidget_ADS:
		TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
		TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
		FGAS DCBA 1;
	User4:
	Fidget:
		TNT1 A 0 BW_ClearDualOverlays();
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Fidget_ADS");
		FGR1 ABCDEF 1 BW_Weaponready();
		FGR2 ABCD 1 BW_Weaponready();
		TNT1 A 0 A_Startsound("FG42/Charge",CHAN_AUTO,CHANF_OVERLAP,0.7);
		FGR2 E 1 BW_Weaponready();
		FGR2 FFFFFFFFFF 1 {A_Weaponoffset(-0.35,0.5,WOF_ADD); return BW_Weaponready();}
		TNT1 A 0 A_Weaponoffset(0,32);
		FGR2 GH 1 BW_Weaponready();
		FGR1 FEDCBA 1 BW_WeaponReady();
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
		FGAS ABCD 1;
		goto Ready_ADS;

	StopAim:
		TNT1 A 0 A_ZoomFactor(1.0);
		FGAS DCBA 1;
		goto Ready;

	//dual wield states
	User2:
	GoDual:
		TNT1 A 0 
		{
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
		FGDT ABCDEF 1;
		FGDS ABCD 1;
		goto ready_Dual;

	GoSingle:
		TNT1 A 0 BW_ClearDualOverlays();
		TNT1 A 0 A_Startsound("Generic/ADS",CHAN_AUTO);
		TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
		FGDS DCBA 1;
		FGDT FEDCBA 1;
		goto ready;

	Select_Dual:
		FGDS ABCD 1;
		goto Ready_Dual;

	Deselect_Dual:
		TNT1 A 0 BW_ClearDualOverlays();
		FGDS DCBA 1;
		TNT1 A 0 BW_WeaponLower();
		wait;

	StartDual:
	Ready_Dual:
		TNT1 A 1 BW_MainDualReady();
		loop;

	Dual_Left:
		FDF2 A 1 
		{
			BW_GunBarrelSmoke(ofsPos:(22,-8,-5),left:true);
			return BW_DualReady(true,"Dual_Left_Fire");
		}
		loop;

	Dual_Right:
		FDF1 A 1 
		{
			BW_GunBarrelSmoke(ofsPos:(22,7,-5));
			return BW_DualReady(false,"Dual_Right_Fire");
		}
		loop;

	Dual_Left_Fire:
		TNT1 A 0 BW_DualPrefire("Dual_Left_DryFire",true);
		TNT1 A 0 BW_SetFiring(true,false);
		FDF2 B 1 bright BW_DualFG42Fire(true);
		FDF2 C 1 bright;
		FDF2 A 1;
		TNT1 A 0 BW_SetFiring(false,false);
		TNT1 A 0 BW_QuickRefire("Dual_Left_Fire",BT_ATTACK,false);
		goto Dual_Left;

	Dual_Left_DryFire:
		TNT1 A 0 A_Startsound("weapon/dryfire",13);
		FDF2 A 1;
		goto Dual_Left;

	Dual_Right_Fire:
		TNT1 A 0 BW_DualPrefire("Dual_Right_DryFire",false);
		TNT1 A 0 BW_SetFiring(true,true);
		FDF1 B 1 bright BW_DualFG42Fire();
		FDF1 C 1 bright;
		FDF1 A 1;
		TNT1 A 0 BW_SetFiring(false,true);
		TNT1 A 0 BW_QuickRefire("Dual_Right_Fire",getRightfirebutton(),false);
		goto Dual_Right;

	Dual_Right_DryFire:
		TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
		FDF1 A 1;
		goto Dual_Right;

	KickFlash:
		TNT1 A 0 BW_ClearDualOverlays();
		TNT1 A 0 BW_jumpifAkimbo("KickFlash_Akimbo");
		TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
		FG4K ABC 1;
		FG4K DEE 1;
		TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
		FG4K EEE 1;
		FG4K EEDCBA 1;
		goto ready;

	SlideFlash:
		TNT1 A 0 BW_ClearDualOverlays();
		TNT1 A 0 BW_jumpifAkimbo("SlideFlash_Akimbo");
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		FG4K ABCD 1;
		FG4K EEEE 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		FG4K EEE 1;
		FG4K EEE 1;
		FG4K EEE 1;
		FG4K EEE 1;
		FG4K EEE 1;
		FG4K EEE 1;
	SlideFlashEnd:
		TNT1 A 0 BW_jumpifAkimbo("SlideFlashEnd_Akimbo");
		TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
		FG4K EEDCBA 1;
		goto ready;

	KnifeGunFlash:
		TNT1 A 0 BW_ClearDualOverlays();
		TNT1 A 0 BW_jumpifAkimbo("KnifeGunFlash_Akimbo");
		FG4S EFGH 1;	//temporary
		TNT1 A 5;
		FG4S ABCD 1;
		stop;

	KnifeGunFlash_Akimbo:
		FGDS DCBA 1;	//temporary
		TNT1 A 5;
		FGDS ABCD 1;
		stop;

	KickFlash_Akimbo:
		TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGDS DCBA 1;
		TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGDS AAAAAAA 1;
		FGDS ABCD 1;
		goto ready;

	SlideFlash_Akimbo:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGDS DCBA 1;
		FGDS AAAA 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGDS AAA 1;
		FGDS AAA 1;
		FGDS AAA 1;
		FGDS AAA 1;
		FGDS AAA 1;
		FGDS AAA 1;
	SlideFlashEnd_Akimbo:
		TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGDS AAABCD 1;
		goto ready;
	
	LowerGun:
		FG4K ABCDEEE 1 {
			A_WeaponReady(WRF_ALLOWRELOAD);
			return BW_JumpifBlockedGun("raisegun",0,true);
		}
	LowerGunLoop:
		FG4K E 1 {
			A_WeaponReady(WRF_ALLOWRELOAD);
			return BW_JumpifBlockedGun("RaiseGun",0,true);
		}
		loop;
	RaiseGun:
		FG4K EEEDCBA 1 {
			A_WeaponReady(WRF_ALLOWRELOAD);
			return BW_JumpifBlockedGun("LowerGun",0,false);
		}
		goto ready;

	Reload_ADS:
		TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
		TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
		FGAS DCBA 1;
	Reload:
		TNT1 A 0 BW_ClearDualOverlays();
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Reload_ADS");
		TNT1 A 0 BW_CheckReload("EmptyReload","Fidget","NoAmmo",20,1);
		TNT1 A 0 A_StartSound("Generic/Rattle/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGR1 ABCD 1;
		TNT1 A 0 A_startsound("FG42/MagOut",CHAN_AUTO);
		FGR1 EFFFFFFFGHIIIIIJKLM 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGR1 NOOOOOOO 1;
		TNT1 A 0 A_startsound("FG42/MagIn",CHAN_AUTO);
		FGR1 OOONMPQRST 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),20,1);
		FGR1 TTSRI 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGR1 HGFEDCBA 1;
		goto ready;

	EmptyReload:
		TNT1 A 0 A_StartSound("Generic/Rattle/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGR1 ABCD 1;
		TNT1 A 0 A_startsound("FG42/MagOut",CHAN_AUTO);
		FGR1 EFFFFFFFGHIIIIIJKLM 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGR1 NOOOOOOO 1;
		TNT1 A 0 A_startsound("FG42/MagIn",CHAN_AUTO);
		FGR1 OOONMPQRST 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),20,1);
		FGR1 TTSRI 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		FGR1 HGF 1;
		//rechamber
		FGR2 ABCD 1;
		TNT1 A 0 A_Startsound("FG42/Charge",CHAN_AUTO,CHANF_OVERLAP,0.7);
		FGR2 E 1;
		FGR2 FFFFFFFFFFFF 1;
		FGR2 GH 1;
		FGR1 FEDCBA 1;
		goto ready;
		
	Reload_Dual:
		TNT1 A 0 BW_ClearDualOverlays();
		//go single
		DM4T JIHGFEDCBA 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount > 31,"Reload_Left");
	ReloadRight:
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"EmptyReloadRight");
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R ABCDEFGHIJKL 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R MNOPQRST 1;
		TNT1 A 0 A_startsound("FG42/Out",CHAN_AUTO);
		MP4R UVWXYZ 1;
		MP4S ABCCC 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4S DEFG 1;
		TNT1 A 0 A_startsound("FG42/In",CHAN_AUTO);
		MP4S HIJKL 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),32,1);
		MP4S MNO 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R QPONM 1;
		MP4R GFEDCBA 1;
		goto FinishedRight;

	EmptyReloadRight:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R ABCDEFGHIJKL 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R MNOPQRST 1;
		TNT1 A 0 A_startsound("FG42/Out",CHAN_AUTO);
		MP4R UVWXYZ 1;
		MP4S ABCCC 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4S DEFG 1;
		TNT1 A 0 A_startsound("FG42/In",CHAN_AUTO);
		MP4S HIJKL 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),32,1);
		MP4S MNO 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R QPONM 1;
		MP4R GFEDCBA 1;
		//rechamber
		MP4C ABCDE 1;
		TNT1 A 0 A_Startsound("FG42/BoltBack",CHAN_AUTO,CHANF_OVERLAP,0.7);
		MP4C FGHI 1;
		MP4C III 1 A_Weaponoffset(-0.35,0.5,WOF_ADD);
		TNT1 A 0 A_Weaponoffset(0,32);
		TNT1 A 0 A_Startsound("FG42/BoltRelease",CHAN_AUTO,CHANF_OVERLAP,0.7);
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
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R ABCDEFGHIJKL 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R MNOPQRST 1;
		TNT1 A 0 A_startsound("FG42/Out",CHAN_AUTO);
		MP4R UVWXYZ 1;
		MP4S ABCCC 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4S DEFG 1;
		TNT1 A 0 A_startsound("FG42/In",CHAN_AUTO);
		MP4S HIJKL 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammotypeLeft.getclassname(),invoker.ammotype1.getclassname(),32,1);
		MP4S MNO 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
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
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R ABCDEFGHIJKL 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Small", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R MNOPQRST 1;
		TNT1 A 0 A_startsound("FG42/Out",CHAN_AUTO);
		MP4R UVWXYZ 1;
		MP4S ABCCC 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4S DEFG 1;
		TNT1 A 0 A_startsound("FG42/In",CHAN_AUTO);
		MP4S HIJKL 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammotypeLeft.getclassname(),invoker.ammotype1.getclassname(),32,1);
		MP4S MNO 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		MP4R QPONM 1;
		MP4R GFEDCBA 1;
		//rechamber
		MP4C ABCDE 1;
		TNT1 A 0 A_Startsound("FG42/BoltBack",CHAN_AUTO,CHANF_OVERLAP,0.7);
		MP4C FGHI 1;
		MP4C III 1 A_Weaponoffset(-0.35,0.5,WOF_ADD);
		TNT1 A 0 A_Weaponoffset(0,32);
		TNT1 A 0 A_Startsound("FG42/BoltRelease",CHAN_AUTO,CHANF_OVERLAP,0.7);
		MP4C JKLMNA 1;
		goto FinishedLeft;
	}
}

Class BW_FG42Mag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 20;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 20;
	}
}

Class BW_FG42MagLeft : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 20;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 20;
	}
}