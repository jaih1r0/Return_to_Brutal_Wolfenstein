class BW_Luger : BaseBWWeapon
{
 	Default
	{
		Weapon.AmmoType "BW_PistolAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_Luger_Mag";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		
		Weapon.SlotNumber 2;
		BaseBWWeapon.FullMag 9;
		/*
		zoom 1.0
		zoomaim 1.2
		zoomdelta 0.01
		zoom tics 1
		*/
		
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 2] Pistole Parabellum";
		Tag "Luger P-08";
		Scale 0.35;
		Inventory.PickupSound "Generic/Pickup/Pistol";
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
	}
	
	action void FireWeapon()
	{
		A_AlertMonsters();
		
		A_StartSound("Luger/Fire", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_StartSound("Luger/Fireadd", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		A_StartSound("Luger/FireTail", CHAN_AUTO, CHANF_OVERLAP, 0.7);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_LugerBullets",0.1,0.1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15));//, 0, 0, 0);
			A_ZoomFactor(1.2-0.01);
			BW_SpawnCasing("BW_9MMCasing",20,2,-3,random(2,5),random(2,5),random(3,6));
		}
		else
		{
			BW_FireBullets("BW_LugerBullets",0.5,0.5,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.40, frandom(+0.30, -0.30));//, -5, 0, 0);
			A_ZoomFactor(1-0.01);
			BW_SpawnCasing("BW_9MMCasing",27,2,-7,random(2,5),random(2,5),random(3,6));
		}
		//gunsmoke
		BW_AddBarrelHeat(10);
		A_TakeInventory("BW_Luger_Mag", 1);
	}
	
	States
	{
	
	Deselect:
		TNT1 A 0 BW_SetReloading(false);
		TNT1 A 0 A_ZoomFactor(1);
		TNT1 A 0 A_StartSound("Lug/lower", CHAN_AUTO, CHANF_OVERLAP, 1);
		ZLUS FG 1;
		TNT1 A 0 A_StartSound("Generic/Pistol/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
		ZLUS HI 1;
		TNT1 A 0 BW_WeaponLower();
		Wait;
	//User3:
	//	TNT1 A 0 A_ZoomFactor(1);
	//	TNT1 A 0 A_TakeInventory("AimingToken");
	//	Goto KnifeAttack;
	Select:
		TNT1 A 0 BW_WeaponRaise();
		TNT1 A 0 A_StartSound("Generic/Pistol/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
		ZLUS AB 1;
		TNT1 A 0 A_StartSound("Lug/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
		ZLUS CD 1;
		goto ready;
	Ready:
	WeaponReady:
		ZLUS E 1 {
			BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
			return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
		}
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReadyEmpty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2:
		ZLU2 A 1 {
			BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
			return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
		}
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReady2Empty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReadyEmpty:
		ZLUG E 1 {
			BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
			return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
		}
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2Empty:
		ZLU2 E 1 {
			BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
			return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
		}
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	Fire:
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Fire2");
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "DryFire");
		TNT1 A 0 FireWeapon();
		ZLUG AB 1 BRIGHT;
		ZLUG C 1 A_StartSound("Luger/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		TNT1 A 0 A_ZoomFactor(1);
		ZLUG D 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReadyEmpty");
		ZLUG E 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		ZLUG F 1;
		Goto WeaponReady;
	Fire2:
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "DryFire2");
		ZLU2 B 1 BRIGHT FireWeapon();
		ZLU2 C 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		ZLU2 D 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReady2Empty");
		ZLU2 E 1 A_StartSound("Luger/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		ZLU2 F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		Goto WeaponReady2;
	AltFire:
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "AltFire2");
		TNT1 A 0 A_GiveInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
		ZLUX AB 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		ZLUX CD 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReady2Empty");
		Goto WeaponReady2;
	AltFire2:
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
		ZLUX DC 1;
		TNT1 A 0 A_ZoomFactor(1);
		ZLUX BA 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReadyEmpty");
		Goto WeaponReady;
	
	DryFire:
		ZLUG E 1;
		Goto WeaponReadyEmpty;
	DryFire2:
		ZLU2 E 1;
		Goto WeaponReady2Empty;
	
	UnAimReload:
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
		ZLUX DC 1;
		TNT1 A 0 A_ZoomFactor(1);
		ZLUX BA 1;
	Reload:
		TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 1, "UnAimReload");
		TNT1 A 0 BW_CheckReload("Reload2","WeaponReady","WeaponReadyEmpty",9,1);
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		ZLR2 ABCDEFGHIJ 1;
		TNT1 A 0 A_StartSound("Luger/Out", CHAN_AUTO, CHANF_OVERLAP);
		ZLR2 LMNNNNN 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		ZLR2 OPQRSTUUUUU 1;
		TNT1 A 0 A_StartSound("Luger/In", CHAN_AUTO, CHANF_OVERLAP);
		ZLR2 VWXYZZZZZ 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 9, 1);
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		ZL22 ABCDEFG 1;
		ZLR2 HGFEDCBA 1;
		Goto WeaponReady;
	Reload2:
		TNT1 A 0 A_TakeInventory("AimingToken");
		ZLR3 ABCDEFGH 1;
		TNT1 A 0 A_StartSound("Luger/outempty", CHAN_AUTO, CHANF_OVERLAP);
		ZLR4 ABCDEFGHIIIIIJKLM 1;
		TNT1 A 0 A_StartSound("Luger/inempty", CHAN_AUTO, CHANF_OVERLAP);
		ZLR4 NOPPPPPPQ 1;
		TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 8, 1);
		ZLR4 RSSSSS 1;
		TNT1 A 0 A_StartSound("Luger/Charge", CHAN_AUTO, CHANF_OVERLAP);
		ZLR4 TTUUVW 1;
		ZLUR IHGFEDCBA 1;
		Goto WeaponReady;
 	Spawn:
		BLGW A -1;
		Stop;
	
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK ABC 1;
			LUGK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK GGG 1;
			LUGK FEDCBA 1;
			goto WeaponReady;	//this needs to go to ready instead
			//goto ready;
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK ABCD 1;
			LUGK EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK FEDCBA 1;
			goto WeaponReady;
			//goto ready;

	}
}

Class BW_Luger_Mag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 9;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 9;
	}
}