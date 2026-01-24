class BW_M1911 : BaseBWWeapon
{
 	Default
	{
		Weapon.AmmoType "BW_USAPistolAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_M1911_Mag";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		
		Weapon.SlotNumber 2;
		BaseBWWeapon.FullMag 8;
		/*
		zoom 1.0
		zoomaim 1.2
		zoomdelta 0.01
		zoom tics 1
		*/
		
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 2] M1911";
		Tag "Colt M1911A1";
		Scale 0.35;
		Inventory.PickupSound "Generic/Pickup/Pistol";
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
	}
	
	action void FireWeapon()
	{
		A_AlertMonsters();
		
		A_StartSound("M1911/Fire", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_StartSound("M1911/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		A_StartSound("M1911/FireTail", CHAN_AUTO, CHANF_OVERLAP, 0.75, ATTN_NORM, 1.5);
		A_StartSound("M1911/FireBass", CHAN_AUTO, CHANF_OVERLAP, 0.6);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_M1911Bullets",0.1,0.1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15));//, 0, 0, 0);
			A_ZoomFactor(1.2-0.01);
			BW_SpawnCasing("BW_45ACPCasing",20,2,-3,random(2,5),random(2,5),random(3,6));
		}
		else
		{
			BW_FireBullets("BW_M1911Bullets",0.5,0.5,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.40, frandom(+0.30, -0.30));//, -5, 0, 0);
			A_ZoomFactor(1-0.01);
			BW_SpawnCasing("BW_45ACPCasing",27,2,-7,random(2,5),random(2,5),random(3,6));
		}
		//gunsmoke
		BW_AddBarrelHeat(12);
		A_TakeInventory("BW_M1911_Mag", 1);
	}
	
	States
	{
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 A_ZoomFactor(1);
			TNT1 A 0 A_StartSound("M1911/lower", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45S FG 1;
			TNT1 A 0 A_StartSound("Generic/Pistol/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45S HI 1;
			TNT1 A 0 BW_WeaponLower();
			Wait;
		Select:
			TNT1 A 0 BW_WeaponRaise();
			TNT1 A 0 A_StartSound("Generic/Pistol/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45S AB 1;
			TNT1 A 0 A_StartSound("M1911/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45S CD 1;
			goto ready;
		Ready:
		WeaponReady:
			M45S E 1
			{
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "WeaponReadyEmpty");
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		WeaponReady2:
			M4F2 A 1
			{
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "WeaponReady2Empty");
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		WeaponReadyEmpty:
			M4F1 C 1
			{
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		WeaponReady2Empty:
			M4F2 C 1
			{
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		Fire:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Fire2");
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "DryFire");
			M4F1 B 1 BRIGHT FireWeapon();
			M4F1 C 1;
			TNT1 A 0 A_ZoomFactor(1);
			M4F1 D 1 A_StartSound("M1911/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "WeaponReadyEmpty");
			M4F1 EA 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
			Goto WeaponReady;
		Fire2:
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "DryFire2");
			M4F2 B 1 BRIGHT FireWeapon();
			M4F2 C 1;
			TNT1 A 0 A_ZoomFactor(1.2);
			M4F2 D 1;
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "WeaponReady2Empty");
			M4F2 E 1 A_StartSound("M1911/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8); 
			M4F2 A 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
			Goto WeaponReady2;
		AltFire:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "AltFire2");
			TNT1 A 0 A_GiveInventory("AimingToken");
			TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			M4S2 AB 1;
			TNT1 A 0 A_ZoomFactor(1.2);
			M4S2 CD 1;
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "WeaponReady2Empty");
			Goto WeaponReady2;
		AltFire2:
			TNT1 A 0 A_TakeInventory("AimingToken");
			TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			M4S2 DC 1;
			TNT1 A 0 A_ZoomFactor(1);
			M4S2 BA 1;
			TNT1 A 0 A_JumpIf(CountInv("BW_M1911_Mag") == 0, "WeaponReadyEmpty");
			Goto WeaponReady;
		
		DryFire:
			M4F1 C 1;
			Goto WeaponReadyEmpty;
		DryFire2:
			M4F2 C 1;
			Goto WeaponReady2Empty;
	
		UnAimReload:
			TNT1 A 0 A_TakeInventory("AimingToken");
			TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			M4S2 DC 1;
			TNT1 A 0 A_ZoomFactor(1);
			M4S2 BA 1;
		Reload:
			TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 1, "UnAimReload");
			TNT1 A 0 BW_CheckReload("Reload2","WeaponReady","WeaponReadyEmpty",9,1);
			TNT1 A 0 A_TakeInventory("AimingToken");
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			M4R1 ABCDEFGHIJKK 1;
			TNT1 A 0 A_StartSound("M1911/MagOut", CHAN_AUTO, CHANF_OVERLAP);
			M4R1 LMNOP 2;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			M4R1 H 10;
			M4R1 PO 2;
			TNT1 A 0 A_StartSound("M1911/MagIn", CHAN_AUTO, CHANF_OVERLAP);
			M4R1 NMLKKK 2;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 8, 1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			M4R1 JIHGFEDCBA 1;
			Goto WeaponReady;
		Reload2:
			TNT1 A 0 A_TakeInventory("AimingToken");
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			M4R2 ABCDEFFF 1;
			TNT1 A 0 A_StartSound("M1911/MagOut", CHAN_AUTO, CHANF_OVERLAP);
			M4R2 GHIJKKKLM 2;
			TNT1 A 0 A_StartSound("M1911/MagIn", CHAN_AUTO, CHANF_OVERLAP);
			M4R2 NOPPP 2;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 7, 1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			M4R2 Q 1;
			TNT1 A 0 A_StartSound("M1911/Charge", CHAN_AUTO, CHANF_OVERLAP);
			M4R2 RSTUVW 2;
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			M4R1 FEDCBA 1;
			Goto WeaponReady;
		
		Spawn:
			M45P A -1;
			Stop;
	
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45K ABC 1;
			M45K DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45K GGG 1;
			M45K FEDCBA 1;
			goto WeaponReady;	//this needs to go to ready instead
			//goto ready;
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45K ABCD 1;
			M45K EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45K GGG 1;
			M45K GGG 1;
			M45K GGG 1;
			M45K GGG 1;
			M45K GGG 1;
			M45K GGG 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			M45K FEDCBA 1;
			goto WeaponReady;
			//goto ready;

	}
}

Class BW_M1911_Mag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 8;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 8;
	}
}