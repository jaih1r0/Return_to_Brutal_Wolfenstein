class BW_Luger : BaseBWWeapon
{
 	Default
	{
		Weapon.AmmoType "Clip";
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
		Scale 1;
		Inventory.PickupSound "weapons/pistol/pickup";
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
	}
	
	action void FireWeapon()
	{
		A_AlertMonsters();
		/*
		A_Overlay(-3, "MuzzleSmall");
		A_OverlayFlags(-3, PSPF_ALPHA, true);
		A_OverlayFlags(-3, PSPF_RENDERSTYLE, true);
		A_OverlayRenderstyle(-3, STYLE_ADD);
		*/
		//[Pop] BW doesnt need overlay flashes
		
		A_StartSound("Luger/Fire", 0, CHANF_OVERLAP, 1);
		A_StartSound("Luger/Fireadd", 0, CHANF_OVERLAP, 0.8);
		BW_FireBullets("BW_LugerBullets",0.1,0.1,-1,25,"Bulletpuff","Bullet",0,0,0);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		//this handles placing the flash correctly
		if(CountInv("AimingToken"))
		{
			A_OverlayOffset(-3, 0 - 18, 32 - 54);
			BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15), 0, 0, 0);
			A_ZoomFactor(1.2-0.01);
		}
		else
		{
			A_OverlayOffset(-3, 0 + 24, 32 - 42);
			BW_HandleWeaponFeedback(2, 3, -0.40, frandom(+0.30, -0.30), -5, 0, 0);
			A_ZoomFactor(1-0.01);
		}
		//gunsmoke
		A_TakeInventory("BW_Luger_Mag", 1);
	}
	
	States
	{
	
	Deselect:
		TNT1 A 0 A_ZoomFactor(1);
		TNT1 A 0 A_StartSound("Lug/lower", 0, CHANF_OVERLAP, 1);
		ZLUS FG 1;
		TNT1 A 0 A_StartSound("Generic/Pistol/Holster", 0, CHANF_OVERLAP, 1);
		ZLUS HI 1;
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
		TNT1 A 0 A_StartSound("Generic/Pistol/raise", 0, CHANF_OVERLAP, 1);
		ZLUS AB 1;
		TNT1 A 0 A_StartSound("Lug/raise", 0, CHANF_OVERLAP, 1);
		ZLUS CD 1;
	WeaponReady:
		ZLUS E 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReadyEmpty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2:
		ZLU2 A 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReady2Empty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReadyEmpty:
		ZLUG E 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2Empty:
		ZLU2 E 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	Fire:
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "Fire2");
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "DryFire");
		ZLUG B 1 BRIGHT;
		TNT1 A 0 FireWeapon();
		ZLUG C 1;
		TNT1 A 0 A_ZoomFactor(1);
		ZLUG D 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReadyEmpty");
		ZLUG E 1;
		ZLUG F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		Goto WeaponReady;
	Fire2:
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "DryFire2");
		ZLU2 B 1 BRIGHT;
		TNT1 A 0 FireWeapon();
		ZLU2 C 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		ZLU2 D 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReady2Empty");
		ZLU2 E 1;
		ZLU2 F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		Goto WeaponReady2;
	AltFire:
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "AltFire2");
		TNT1 A 0 A_GiveInventory("AimingToken");
		TNT1 A 0 A_StartSound("uni/clothfoleys", 0, CHANF_OVERLAP);
		ZLUX AB 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		ZLUX CD 1;
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReady2Empty");
		Goto WeaponReady2;
	AltFire2:
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("uni/clothfoleys", 0, CHANF_OVERLAP);
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
		ZLUX DC 1;
		TNT1 A 0 A_ZoomFactor(1);
		ZLUX BA 1;
	Reload:
		TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 1, "UnAimReload");
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0 && CountInv("Clip") == 0, "WeaponReadyEmpty");
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 9 || CountInv("Clip") == 0, "WeaponReady");
		TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "Reload2");
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
		ZLR2 ABCDEFGHIJ 1;
		TNT1 A 0 A_StartSound("Luger/Out", 0, CHANF_OVERLAP);
		ZLR2 LMNNNNN 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
		ZLR2 OPQRSTUUUUU 1;
		TNT1 A 0 A_StartSound("Luger/In", 0, CHANF_OVERLAP);
		ZLR2 VWXYZZZZZ 1;
		TNT1 A 0 BW_AmmoIntoMag("BW_Luger_Mag", "Clip", 9, 1);
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		ZL22 ABCDEFG 1;
		ZLR2 HGFEDCBA 1;
		Goto WeaponReady;
	Reload2:
		TNT1 A 0 A_TakeInventory("AimingToken");
		ZLR3 ABCDEFGH 1;
		TNT1 A 0 A_StartSound("Luger/outempty", 0, CHANF_OVERLAP);
		ZLR4 ABCDEFGHIJKLM 1;
		TNT1 A 0 A_StartSound("Luger/inempty", 0, CHANF_OVERLAP);
		ZLR4 NOPQ 1;
		TNT1 A 0 BW_AmmoIntoMag("BW_Luger_Mag", "Clip", 8 , 1);
		ZLR4 RS 1;
		TNT1 A 0 A_StartSound("Luger/Charge", 0, CHANF_OVERLAP);
		ZLR4 TUVW 1;
		ZLUR IHGFEDCBA 1;
		Goto WeaponReady;
 	Spawn:
		B003 S -1;
		Stop;
	
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