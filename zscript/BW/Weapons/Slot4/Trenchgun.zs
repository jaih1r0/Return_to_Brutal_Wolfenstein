class BW_Trenchgun : BaseBWWeapon
{
 	Default
	{
		Weapon.AmmoType "Shell";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_Trenchgun_Mag";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		
		Weapon.SlotNumber 4;
		BaseBWWeapon.FullMag 7;
		/*
		zoom 1.0
		zoomaim 1.2
		zoomdelta 0.01
		zoom tics 1
		*/
		
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 4] Winchester Model 1897";
		Tag "Luger P-08";
		Scale 1;
		Inventory.PickupSound "weapons/pistol/pickup";
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
	}
	
	action void FireWeapon()
	{
		A_AlertMonsters();
		
		A_StartSound("Trench/Fire", 0, CHANF_OVERLAP, 1);
		A_StartSound("Trench/FireAlt", 0, CHANF_OVERLAP, 0.7);
		A_StartSound("Trench/Fireadd", 0, CHANF_OVERLAP, 0.8);
		A_StartSound("Trench/FireMech", 0, CHANF_OVERLAP, 1);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_12GABullets",1,1,8,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(3, 4, -0.40, frandom(+0.35, -0.35), 0, 0, 0);
			A_ZoomFactor(1.2-0.04);
		}
		else
		{
			BW_FireBullets("BW_12GABullets",1.5,1.5,8,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(3, 4, -0.60, frandom(+0.45, -0.45), -5, 0, 0);
			A_ZoomFactor(1-0.04);
		}
		//gunsmoke
		A_TakeInventory("BW_Trenchgun_Mag", 1);
	}
	
	States
	{
	
	Deselect:
		TNT1 A 0 A_ZoomFactor(1);
		TNT1 A 0 A_StartSound("Trench/Drop", 0, CHANF_OVERLAP, 1);
		SHTA DC 1;
		TNT1 A 0 A_StartSound("Generic/Rifle/Holster", 0, CHANF_OVERLAP, 1);
		SHTA BA 1;
		PSTG A 0 A_Lower(25);
		Wait;
	User3:
		TNT1 A 0 A_ZoomFactor(1);
		TNT1 A 0 A_TakeInventory("AimingToken");
		Goto KnifeAttack;
	Select:
		TNT1 A 0
		{
			A_TakeInventory("AimingToken");
		}
		TNT1 A 0 A_Raise(25);
		Wait;
	Ready:
		TNT1 A 0 A_StartSound("Generic/Rifle/raise", 0, CHANF_OVERLAP, 1);
		SHTA AB 1;
		TNT1 A 0 A_StartSound("Trench/raise", 0, CHANF_OVERLAP, 1);
		SHTA CD 1;
	WeaponReady:
		SHTA E 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReadyEmpty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2:
		SHTA F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReady2Empty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReadyEmpty:
		SHTC F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2Empty:
		SHTC L 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	Fire:
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Fire2");
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "DryFire");
		TNT1 A 0 FireWeapon();
		SHTC AB 1 BRIGHT;
		SHTC C 1;
		TNT1 A 0 A_ZoomFactor(1);
		SHTC DEF 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReadyEmpty");
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		SHTD ABCDDD 1;
		TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
		SHTD EFGHHHHH 1;
		TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
		SHTD IJK 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
		SHTD DCBA 1;
		Goto WeaponReady;
	Fire2:
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "DryFire2");
		TNT1 A 0 FireWeapon();
		SHTC GH 1 BRIGHT;
		SHTC I 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		SHTC JKL 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReady2Empty");
		TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
		SHTD LMNOOO 1;
		TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
		SHTD PQR 1;
		TNT1 A 0 A_ReFire("Fire2");
		Goto WeaponReady2;
	AltFire:
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "AltFire2");
		TNT1 A 0 A_GiveInventory("AimingToken");
		TNT1 A 0 A_StartSound("uni/clothfoleys", 0, CHANF_OVERLAP);
		SHTB AB 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		SHTB CD 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReady2Empty");
		Goto WeaponReady2;
	AltFire2:
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("uni/clothfoleys", 0, CHANF_OVERLAP);
		SHTB DC 1;
		TNT1 A 0 A_ZoomFactor(1);
		SHTB BA 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReadyEmpty");
		Goto WeaponReady;
	
	DryFire:
		SHTC F 1;
		Goto WeaponReadyEmpty;
	DryFire2:
		SHTC L 1;
		Goto WeaponReady2Empty;
	
	UnAimReload:
		TNT1 A 0 A_TakeInventory("AimingToken");
		SHTB DC 1;
		TNT1 A 0 A_ZoomFactor(1);
		SHTB BA 1;
	Reload:
		TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 1, "UnAimReload");
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0 && CountInv("Clip") == 0, "WeaponReadyEmpty");
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 7 || CountInv("Clip") == 0, "WeaponReady");
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "Reload2");
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		SHTD ABCD 1;
		SHTE IA 1;
	ReloadLoop:
		TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", 0, CHANF_OVERLAP, 1);
		SHTE AAA 1;
		TNT1 A 0 A_StartSound("Trench/Shell", 0, CHANF_OVERLAP, 1);
		SHTE BCDEEE 1;
		TNT1 A 0 BW_AmmoIntoMag("BW_Trenchgun_Mag", "Shell", CountInv("BW_Trenchgun_Mag") + 1, 1);
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
		SHTE FGHAAA 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 7, "ReloadEnd");
		TNT1 A 0 A_JumpIf(CountInv("Shell") == 0, "ReloadEnd");
		Loop;
	ReloadEnd:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		SHTE AI 1;
		SHTD DCBA 1;
		Goto WeaponReady;
	Reload2:
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		SHTD ABCD 1;
		SHTE IA 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", 0, CHANF_OVERLAP, 1);
		SHTE AAABCDEEE 1;
		TNT1 A 0 A_StartSound("Trench/Shell", 0, CHANF_OVERLAP, 1);
		SHTE FGHAAA 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
		TNT1 A 0 BW_AmmoIntoMag("BW_Trenchgun_Mag", "Shell", 1, 1);
		SHTE AI 1;
		SHTD BCD 1;
		TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
		SHTD EFGHHHHH 1;
		TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
		SHTD IJK 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
		SHTD CB 1;
		SHTE IA 1;
		TNT1 A 0 A_JumpIf(CountInv("Shell") == 0, "ReloadEnd");
		Goto ReloadLoop;
 	Spawn:
		SHTA G -1;
		Stop;
	
	}
}

Class BW_Trenchgun_Mag : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 7;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 7;
	}
}