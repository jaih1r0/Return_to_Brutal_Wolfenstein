class BW_Trenchgun : BaseBWWeapon
{
 	Default
	{
		Weapon.AmmoType "BW_ShotgunAmmo";
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
		Inventory.PickupSound "Generic/Pickup/Rifle";
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
	}
	
	action void FireWeapon()
	{
		A_AlertMonsters();
		
		A_StartSound("Trench/Fire", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_StartSound("Trench/FireAlt", CHAN_AUTO, CHANF_OVERLAP, 0.7);
		A_StartSound("Trench/Fireadd", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		A_StartSound("Trench/FireMech", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_StartSound("Trench/FireBass", CHAN_AUTO, CHANF_OVERLAP, 0.75);
		
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_12GABullets",1.5,1.5,8,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(3, 4, -0.40, frandom(+0.35, -0.35));//, 0, 0, 0);
			A_ZoomFactor(1.2-0.04);
			//BW_SpawnCasing("BW_ShellCasing",20,3,-5,random(2,5),random(2,5),random(1,3));
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,2,0,30,0.55);
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,-2,0,30,0.55);
		}
		else
		{
			A_overlay(-7,"MuzzleFlash");
			BW_FireBullets("BW_12GABullets",2.5,2.5,8,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(3, 4, -0.60, frandom(+0.45, -0.45));//, -5, 0, 0);
			A_ZoomFactor(1-0.04);
			//BW_SpawnCasing("BW_ShellCasing",24,-1,-6,random(3,6),random(2,5),random(3,6));
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,2,0,24,0.55);
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,-2,0,24,0.55);
		}
		BW_AddBarrelHeat(32);
		//gunsmoke 
		A_TakeInventory("BW_Trenchgun_Mag", 1);
	}
	
	States
	{
	
	Deselect:
		TNT1 A 0 BW_SetReloading(false);
		TNT1 A 0 A_ZoomFactor(1);
		TNT1 A 0 A_StartSound("Trench/Drop", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGU FG 1;
		TNT1 A 0 A_StartSound("Generic/Rifle/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGU HI 1;
		TNT1 A 0 BW_WeaponLower();
		wait;
	//User3:
	//	TNT1 A 0 A_ZoomFactor(1);
	//	TNT1 A 0 A_TakeInventory("AimingToken");
	//	Goto KnifeAttack;
	Select:
		TNT1 A 0 A_StartSound("Generic/Rifle/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGU AB 1;
		TNT1 A 0 BW_WeaponRaise("Trench/raise");
		BTGU CD 1;
		goto ready;
	Ready:	//keeping ready as the actual ready state
		TNT1 A 0 BW_JumpifAiming("Ready_ADS");
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"Ready_NoAmmo");
		BTGU E 1 {
			BW_GunBarrelSmoke(ofsPos:(28,0,-6));
			BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
		}
		loop;
	
	Ready_NoAmmo:
		TNT1 A 0 A_jumpif(invoker.ammo2.amount > 0,"Ready");
		BTGF H 1 {
			BW_GunBarrelSmoke(ofsPos:(28,0,-6));
			BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
		}
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
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGH BC 1;
		BTGH DEF 1;
		BTGH GHIJK 1;
		BTGP B 1 A_StartSound("Trench/Back", CHAN_AUTO, CHANF_OVERLAP, 1);
		TNT1 A 0 BW_SpawnCasing("BW_ShellCasing",20,-5,-16,random(3,6),random(2,5),random(3,6));
		BTGP CDE 1;
		BTGP F 1 A_StartSound("Trench/Forward", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGP GH 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGP I 1;
		//BTGH K 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"EndPumpNoAmmo");
		BTGH HGFED 1;
		BTGH LMN 1;
		TNT1 A 0 A_refire();
		goto ready;
	EndPumpNoAmmo:
		BTGH HGFEDCBA 1;
		goto ready;

	AltFire:
		TNT1 A 0 {
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
		BTGT ABCD 1;
		goto Ready_ADS;
	StopAim:
		TNT1 A 0 A_ZoomFactor(1.0);
		BTGT DCBA 1;
		goto ready;
	
	Ready_ADS:
		TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"Ready_NoAmmo_ADS");
		BTGT E 1 {
			BW_GunBarrelSmoke(ofsPos:(30,0,-3));
			return BW_WeaponReady(WRF_ALLOWRELOAD);
		}
		loop;
	Ready_NoAmmo_ADS:
		TNT1 A 0 A_jumpif(invoker.ammo2.amount > 0,"Ready_ADS");
		BTGA H 1 {
			BW_GunBarrelSmoke(ofsPos:(30,0,-3));
			return BW_WeaponReady(WRF_ALLOWRELOAD);
		}
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
		TNT1 A 0 A_StartSound("Trench/Back", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGS ABCDD 1;
		TNT1 A 0 A_StartSound("Trench/Forward", CHAN_AUTO, CHANF_OVERLAP, 1);
		TNT1 A 0 BW_SpawnCasing("BW_ShellCasing",20,3,-5,random(2,5),random(2,5),random(1,3));
		BTGS EFGHI 1;
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
		TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
		TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
		BTGT DCBA 1;
	Reload:
		TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "ReloadADS");
		TNT1 A 0 BW_CheckReload("ReloadEmpty","Ready","ready",7);
		TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGH NML 1;
		BTGH DEF 1;
		BTGH GHIJK 1;
	ReloadLoop:
		BTGR ABC 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGR D 1;
		TNT1 A 0 A_StartSound("Trench/Shell", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGR E 1 BW_AmmointoMagSingle(7,1);
		BTGR FGH 1 A_WeaponReady(WRF_NOSWITCH);
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGR IAAAA 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount >= 7 || invoker.ammo1.amount < 1,"ReloadEnd");
		loop;
	ReloadEnd:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGH HGFEDLMN 1;
		goto ready;
	
	ReloadEmpty:
		TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGH ABC 1;
		BTGH DEF 1;
		BTGH GHIJK 1;
	//reload one
		BTGR ABC 1;
		TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGR D 1;
		TNT1 A 0 A_StartSound("Trench/Shell", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGR E 1 BW_AmmointoMagSingle(7,1);
		BTGR FGH 1 A_WeaponReady(WRF_NOSWITCH);
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGR IAAAA 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount >= 7 || invoker.ammo1.amount < 1,"ReloadEnd");
	//pump
		BTGP AA 1;
		BTGP B 1 A_StartSound("Trench/Back", CHAN_AUTO, CHANF_OVERLAP, 1);
		TNT1 A 0 BW_SpawnCasing("BW_ShellCasing",20,-5,-16,random(3,6),random(2,5),random(3,6));
		BTGP CCDDE 1;
		BTGP F 1 A_StartSound("Trench/Forward", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGP GH 1;
		TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGP I 1;
		BTGH KKKKKK 1;
		TNT1 A 0 A_jumpif(invoker.ammo2.amount >= 7 || invoker.ammo1.amount < 1,"ReloadEnd");
		goto ReloadLoop;
		
	
	KickFlash:
		TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGK ABC 1;
		BTGK DEF 1;
		TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGK GHHHH 1;
		BTGK HG 1;
		BTGK FEDCBA 1;
		goto ready;
	
	SlideFlash:
		TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGK ABCD 1;
		BTGK EFGH 1;
		TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGK GHG 1;
		BTGK HGH 1;
		BTGK GHG 1;
		BTGK HGH 1;
		BTGK GGH 1;
		BTGK HGG 1;
	SlideFlashEnd:
		TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
		BTGK FEDCBA 1;
		goto ready;

 	Spawn:
		SHTA G -1;
		Stop;
	
	MuzzleFlash:
		TNT1 A 0 A_overlayflags(overlayid(),PSPF_MIRROR|PSPF_FLIP,random(0,1));
		BTGM AB 1 bright;
		stop;
	
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