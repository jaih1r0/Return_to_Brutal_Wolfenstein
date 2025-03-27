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
		Tag "Trenchgun";
		Scale 0.5;
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
		BTGU FG 1;
		TNT1 A 0 A_StartSound("Generic/Rifle/Holster", 0, CHANF_OVERLAP, 1);
		BTGU HI 1;
		TNT1 A 0 BW_WeaponLower();
		wait;

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
		TNT1 A 0 A_StartSound("Generic/Rifle/raise", 0, CHANF_OVERLAP, 1);
		TNT1 A 0 BW_WeaponRaise("Trench/raise");
		BTGU ABCD 1;
		goto ready;
	Ready:	//keeping ready as the actual ready state
		TNT1 A 0 BW_JumpifAiming("Ready_ADS");
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"Ready_NoAmmo");
		BTGU E 1 BW_WeaponReady(WRF_ALLOWRELOAD);
		loop;
	
	Ready_NoAmmo:
		TNT1 A 0 A_jumpif(invoker.ammo2.amount > 0,"Ready");
		BTGF H 1 BW_WeaponReady(WRF_ALLOWRELOAD);
		loop;

	Fire:
		TNT1 A 0 BW_JumpifAiming("Fire_ADS");
		TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
		BTGF A 1 bright FireWeapon();
		BTGF B 1 bright;
		BTGF C 1;
		TNT1 A 0 A_ZoomFactor(1.0);
		BTGF DE 1;
		BTGF FG 1;
		BTGF H 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"Ready_NoAmmo");
	Pump:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		BTGP ABC 1;
		BTGP DEF 1;
		BTGP GHIJ 1;
		BTGP K 1 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
		BTGP LMNOP 1;
		BTGP Q 1 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
		BTGP RS 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
		BTGP T 1;
		BTGP JIHG 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"EndPumpNoAmmo");
		BTGR FEDCBA 1;
		goto ready;
	EndPumpNoAmmo:
		BTGP FEDCBA 1;
		goto ready;

	/*WeaponReady:
		SHTA E 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReadyEmpty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2:
		SHTA F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "WeaponReady2Empty");
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;*/
	WeaponReadyEmpty:
		SHTC F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	WeaponReady2Empty:
		SHTC L 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
		//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
		Loop;
	//Fire:
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
		TNT1 A 0 {
			A_StartSound("uni/clothfoleys", 0, CHANF_OVERLAP);
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
		BTGT ABCD 1;
		goto Ready_ADS;
	StopAim:
		TNT1 A 0 A_ZoomFactor(1.0);
		BTGT DCBA 1;
		goto ready;
	
	Ready_ADS:
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"Ready_NoAmmo_ADS");
		BTGT E 1 BW_WeaponReady(WRF_ALLOWRELOAD);
		loop;
	Ready_NoAmmo_ADS:
		TNT1 A 0 A_jumpif(invoker.ammo2.amount > 0,"Ready_ADS");
		BTGA H 1 BW_WeaponReady(WRF_ALLOWRELOAD);
		loop;
	
	Fire_ADS:
		TNT1 A 0 BW_PrefireCheck(1,"ReloadADS","DryFire_ADS");
		BTGA A 1 bright FireWeapon();
		BTGA B 1 bright;
		BTGA C 1;
		TNT1 A 0 A_ZoomFactor(1.2);
		BTGA D 1;
		BTGA EF 1;
		BTGA GH 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"Ready_NoAmmo_ADS");
	ADS_Slam:
		BTGS ABC 1;
		TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
		BTGS DDE 1;
		TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
		BTGS FGHI 1;
		BTGT E 2;
		TNT1 A 0 A_refire("Fire_ADS");
		goto Ready_ADS;
	
	DryFire:
		BTGF H 1;
		goto ready;
	DryFire_ADS:
		BTGA H 1;
		goto ready_ADS;


	NoAmmo:
		TNT1 A 0 BW_JumpifAiming("NoAmmo_ADS");
		BTGU E 1;
		goto ready;
	NoAmmo_ADS:
		BTGT E 1;
		goto Ready_ADS;

	ReloadADS:
		BTGT DCBA 1;
		TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
	Reload:
		TNT1 A 0 BW_CheckReload(null,"Ready","ready",7);
		TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		BTGR ABC 1;
		BTGR DEF 1;
		BTGR GHI 1;
		BTGR JK 1;
	ReloadLoop:
		BTGR K 2;
		TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", 0, CHANF_OVERLAP, 1);
		BTGR LM 1;
		TNT1 A 0 A_StartSound("Trench/Shell", 0, CHANF_OVERLAP, 1);
		BTGR N 1 BW_AmmointoMagSingle(7,1);
		BTGR OPQ 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
		BTGR RS 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount >= 7 || invoker.ammo1.amount < 1,"ReloadEnd");
		loop;
	ReloadEnd:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		BTGR JIHG 1;
		BTGR FEDCBA 1;
		goto ready;
	
	
	
	
	KickFlash:
		TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
		BTGR ABC 1;
		BTGR DEF 1;
		TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
		BTGP GHIJK 1;
		BTGP IHG 1;
		BTGR FEDCBA 1;
		goto ready;
	
	SlideFlash:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		BTGR ABCD 1;
		BTGR EFGH 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
		BTGR IJK 1;
		BTGR KKK 1;
		BTGR KKK 1;
		BTGR KKK 1;
		BTGR KKK 1;
		BTGR KKK 1;
	SlideFlashEnd:
		TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
		BTGR FEDCBA 1;
		goto ready;
	
	
	
	
	//AltFire:
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
	
	//DryFire:
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
	//Reload:
		TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 1, "UnAimReload");
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0 && CountInv("Clip") == 0, "WeaponReadyEmpty");
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 7 || CountInv("Clip") == 0, "WeaponReady");
		TNT1 A 0 A_JumpIf(CountInv("BW_Trenchgun_Mag") == 0, "Reload2");
		TNT1 A 0 A_TakeInventory("AimingToken");
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
		SHTD ABCD 1;
		SHTE IA 1;
	//ReloadLoop:
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
	//ReloadEnd:
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