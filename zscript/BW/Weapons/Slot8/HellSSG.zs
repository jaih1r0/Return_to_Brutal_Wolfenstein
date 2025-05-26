Class BW_SSG : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 8;
		tag "SSG";
		Weapon.AmmoType "BW_ShotgunAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "SSGShells";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		
		BaseBWWeapon.FullMag 2;
		
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 8] Hellish SSG";
		Scale 0.5;
		Inventory.PickupSound "Generic/Pickup/Rifle";
	}
	
	action void A_FireSSG()
	{
		A_AlertMonsters();
		
		A_StartSound("HSSG/Fire", 0, CHANF_OVERLAP, 1);
		A_StartSound("Trench/FireAdd", 0, CHANF_OVERLAP, 0.75);
		A_StartSound("HSSG/FireAdd", 0, CHANF_OVERLAP, 0.9);
		A_StartSound("Trench/FireMech", 0, CHANF_OVERLAP, 1);
		/*A_StartSound("Trench/FireAlt", 0, CHANF_OVERLAP, 0.7);
		A_StartSound("Trench/Fireadd", 0, CHANF_OVERLAP, 0.8);
		A_StartSound("Trench/FireMech", 0, CHANF_OVERLAP, 1);*/
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		BW_FireBullets("BW_12GABullets",12.5,4.5,24,22,"Bulletpuff","Shotgun",0,0,0);
		BW_HandleWeaponFeedback(6, 4, -5.60, frandom(+1.75, -1.75));//, -5, 0, 0);
			//BW_SpawnCasing("BW_ShellCasing",24,-1,-6,random(3,6),random(2,5),random(3,6));
		BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,2,0,24,0.55);
		BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,-2,0,24,0.55);
		BW_AddBarrelHeat(32);
		BW_AddBarrelHeat(32,false,true);
		//gunsmoke 
		invoker.ammo2.amount -= 2;
	}
	
	states
	{
		spawn:
			SGN2 A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("HSSG/Raise");
			BHGU AB 1;
			TNT1 A 0 A_StartSound("Generic/Rifle/raise", 0, CHANF_OVERLAP, 1);
			BHGU CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 A_Startsound("HSSG/Drop",0,CHANF_OVERLAP);
			BHGU FG 1;
			TNT1 A 0 A_StartSound("Generic/Rifle/Holster", 0, CHANF_OVERLAP, 1);
			BHGU HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			BHGU E 1 {
				BW_GunBarrelSmoke(ofsPos:(30,1.5,-8));
				BW_GunBarrelSmoke(ofsPos:(30,-1.5,-8),left:true);
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
			}
			loop;
		DryFire:
			BHGU E 1;
			goto ready;
		NoAmmo:
			BHGU E 1;
			goto ready;
		Fire:
			TNT1 A 0 BW_PrefireCheck(2,"Reload","DryFire");
			BHGF A 1 bright A_FireSSG();
			BHGF B 1 bright;
			BHGF CCC 1;
			BHGF DE 1;
			BHGF FG 1;
			BHGF H 1;
			BHGU EEE 1;
			goto ready;
		
		Reload:
			TNT1 A 0 BW_CheckReload(null,"Ready","NoAmmo",2);
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			BHGO ABC 1;
			TNT1 A 0 A_Startsound("hssg/open", CHAN_AUTO, CHANF_OVERLAP, 0.6);
			BHGO DEF 1;
			BHGO GI 1;
			TNT1 AA 0 BW_SpawnCasing("BW_ShellCasing",24,-1,-10,random(3,6),-random(2,5),random(3,6));
			BHGO K 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", 0, CHANF_OVERLAP, 1);
			BHGR A 10;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			BHGR BCD 1;
			BHGR FG 1;
			TNT1 A 0 A_Startsound("hssg/shell", CHAN_AUTO, CHANF_OVERLAP);
			BHGR HIJ 1;
			BHGR KL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),2,1);
			TNT1 A 6;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			BHGR MNO 1;
			TNT1 A 0 A_Startsound("hssg/close",CHAN_AUTO);
			BHGR PQS 1;
			BHGR SS 1 A_Weaponoffset(-0.5,1,WOF_ADD);
			BHGR S 1;
			BHGR S 1 A_Weaponoffset(-1,2,WOF_ADD);
			BHGR SSSS 1;
			BHGR TT 1 A_Weaponoffset(1,-2,WOF_ADD);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 A_weaponoffset(0,32);
			BHGR TUV 1;
			BHGR WXY 1;
			BHGU E 2;
			goto ready;
		
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BHGK ABC 1;
			BHGK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			BHGK GHHHG 1;
			BHGK FEDCBA 1;
			goto ready;	
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BHGK ABCD 1;
			BHGK EFGH 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			BHGK HHH 1;
			BHGK HHH 1;
			BHGK HHH 1;
			BHGK HHH 1;
			BHGK HHH 1;
			BHGK HHH 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BHGK FEDCBA 1;
			goto ready;
	}
}

Class SSGShells : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 2;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 2;
	}
}