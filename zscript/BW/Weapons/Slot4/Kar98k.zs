Class BW_Kar98K : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 4;
		scale 0.35;
		Inventory.PickupSound "Generic/Pickup/Rifle";
		weapon.ammotype2 "Kar98Ammo";
		weapon.ammotype1 "BW_KarAmmo";//"Clip";
		weapon.ammogive1 15;
		BaseBWWeapon.FullMag 5;
		+weapon.noautofire;
		
		Inventory.Pickupmessage "[Slot 4] Karabiner 98k";
		Tag "Kar98K";
	}
	
	action void firekarbullets()
	{
		BW_FireBullets("BW_Kar98Bullets",0.1,0.1,-1,160,"Bulletpuff","Rifle",0,0,0);
		
		A_StartSound("Kar98/Fire", CHAN_AUTO, CHANF_OVERLAP, 0.9);
		A_Startsound("Kar98/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_StartSound("Kar98/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.75);
		
		if(CountInv("AimingToken"))
		{
			A_ZoomFactor(1.4-0.04);
			BW_HandleWeaponFeedback(4, 6, -0.5, frandom(+0.30, -0.30));//, -5, 0, 0);
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,2,0,24,0.55);
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,-2,0,24,0.55);
		}
		else
		{
			A_ZoomFactor(1.0-0.04);
			BW_HandleWeaponFeedback(4, 6, -0.4, frandom(+0.25, -0.25));//, -5, 0, 0);
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,2,0,24,0.55);
			BW_GunSmoke("graphics/D_GSMK1.png",20,0,-5,4,-2,0,24,0.55);
		}
		
		BW_AddBarrelHeat(42);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		invoker.ammo2.amount--;
	}
	
	states
	{
		Spawn:
			K98W A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Marksman/Raise");
			K98U AB 1;
			TNT1 A 0 A_StartSound("Kar98/Raise", 0, CHANF_OVERLAP, 1);
			K98U CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 A_Startsound("Kar98/Drop",5,CHANF_OVERLAP);
			K98U FG 1;
			TNT1 A 0 A_StartSound("Generic/Marksman/Holster", 0, CHANF_OVERLAP, 1);
			K98U HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 0,"Ready_NoAmmo");
			K98U E 1 {
				BW_GunBarrelSmoke(ofsPos:(30,0,-5));
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
			}
			loop;
		Ready_NoAmmo:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount > 0,"Ready");
			K98U E 1 {
				BW_GunBarrelSmoke(ofsPos:(28,0,-6));
				BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
			}
			loop;
			
		DryFire:
			K98U E 1;
			goto ready;
		DryFire_ADS:
			K98U J 1;
			goto ready_ADS;
		NoAmmo:
			K98U E 1;
			goto ready;
		NoAmmo_ADS:
			K98U J 1;
			goto ready_ADS;

		Fire:
			TNT1 A 0 BW_JumpifAiming("Fire_ADS");
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			K98F B 1 bright firekarbullets();
			TNT1 A 0 A_QuakeEx(1,1,1,6,0,10,"",QF_RELATIVE|QF_SCALEDOWN);
			K98F C 1 bright;
			TNT1 A 0 A_ZoomFactor(1.0);
			K98F DEF 1;
			K98F GHI 1;
			//K98F A 1;
		Bolt:
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 A_StartSound("Kar98/BoltOpen", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98P ABCD 1;
			K98P EFGH 1 {A_SetPitch(pitch + 0.5); A_SetAngle(angle + 0.25);}
			TNT1 A 0 BW_SpawnCasing("BW_9MMCasing",29,3,-10,random(2,3),random(2,3),random(3,6));
			K98P IJKM 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			K98P MMNO 1 {A_SetPitch(pitch - 0.5); A_SetAngle(angle - 0.25);}
			TNT1 A 0 A_StartSound("Kar98/BoltClose", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98P PQ 1;
			K98P RS 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			K98P TU 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			K98P VWXYZ 1;
			K98U EE 1;
			TNT1 A 0 A_Refire();
			goto ready;
			
		AltFire:
			TNT1 A 0 {
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
			TNT1 A 0 A_ZoomFactor(1.4);
			K98U KLMN 1;
			goto Ready_ADS;
		StopAim:
			TNT1 A 0 A_ZoomFactor(1.0);
			K98U NMLK 1;
			goto ready;
		
		Ready_ADS:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"Ready_NoAmmo_ADS");
			K98U J 1 {
				BW_GunBarrelSmoke(ofsPos:(30,0,-3));
				return BW_WeaponReady(WRF_ALLOWRELOAD);
			}
			loop;
		Ready_NoAmmo_ADS:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount > 0,"Ready_ADS");
			K98U J 1 {
				BW_GunBarrelSmoke(ofsPos:(30,0,-3));
				return BW_WeaponReady(WRF_ALLOWRELOAD);
			}
			loop;
		
		Fire_ADS:
			TNT1 A 0 BW_PrefireCheck(1,"ReloadADS","DryFire_ADS");
			K98F J 1 bright firekarbullets();
			TNT1 A 0 A_QuakeEx(1,1,1,6,0,10,"",QF_RELATIVE|QF_SCALEDOWN);
			K98F K 1 bright;
			K98F L 1 A_ZoomFactor(1.4);
			K98F MN 3;
		Bolt_ADS:
			TNT1 A 0 A_ZoomFactor(1.0);
			K98U NMLK 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 A_StartSound("Kar98/BoltOpen", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98P ABCD 1;
			K98P EFGH 1 {A_SetPitch(pitch + 0.5); A_SetAngle(angle + 0.25);}
			TNT1 A 0 BW_SpawnCasing("BW_9MMCasing",29,3,-10,random(2,3),random(2,3),random(3,6));
			K98P IJKM 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			K98P MMNO 1 {A_SetPitch(pitch - 0.5); A_SetAngle(angle - 0.25);}
			TNT1 A 0 A_StartSound("Kar98/BoltClose", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98P PQ 1;
			K98P RS 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			K98P TU 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			K98P VWXYZ 1;
			TNT1 A 0 A_ZoomFactor(1.4);
			K98U KLMN 1;
			TNT1 A 0 A_Refire("Fire_ADS");
			goto Ready_ADS;
		
		ReloadADS:
			TNT1 A 0 A_StartSound("Generic/ADS", 0, CHANF_OVERLAP, 0.5);
			TNT1 A 0 {A_setinventory("AimingToken",0); A_ZoomFactor(1.0);}
			K98U NMLK 1;
		Reload:
			TNT1 A 0 A_JumpIfInventory("AimingToken", 1, "ReloadADS");
			TNT1 A 0 BW_CheckReload(null,"Ready","NoAmmo",5,1);
			TNT1 A 0 A_StartSound("Kar98/BoltOpen", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98R ABCDE 2;
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			K98R FGHIJ 2;
			TNT1 A 0 A_JumpIf(CountInv("Kar98Ammo") == 0 && CountInv("Clip") > 4, "Reload_Clip");
		Reload_Bullet:
			TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", 0, CHANF_OVERLAP, 1);
			K98R KLMNOPQ 2;
		Reload_Bullets_Loop:
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			K98R RST 2;
			TNT1 A 0 A_StartSound("Kar98/CartLoad", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98R U 4 BW_AmmointoMagSingle(5,1);
			K98R UTSR 2;
			TNT1 A 0 A_jumpif(invoker.ammo2.amount >= 5 || invoker.ammo1.amount < 1, "Reload_Bullet_End");
			Loop;
		Reload_Bullet_End:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			K98R QPONMLKJ 2;
			Goto Reload_End;
		Reload_Clip:
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			K98R VWXYZ 2;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			K98C ABC 2;
			TNT1 A 0 A_StartSound("Kar98/ClipLoad", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98C DDDD 2;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			K98C EEEE 2;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			K98C FGHIJ 2;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),5,1);
			goto Reload_End2;
		Reload_End:
			K98R JIHGF 2;
		Reload_End2:
			TNT1 A 0 A_StartSound("Kar98/BoltClose", CHAN_AUTO, CHANF_OVERLAP, 1);
			K98R ED 2;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			K98R CBA 2;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			Goto Ready;
			
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			K98K ABC 1;
			K98K DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			K98K GGG 1;
			K98K FEDCBA 1;
			goto ready;	
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			K98K ABCD 1;
			K98K EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			K98K GGG 1;
			K98K GGG 1;
			K98K GGG 1;
			K98K GGG 1;
			K98K GGG 1;
			K98K GGG 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			K98K FEDCBA 1;
			goto ready;
	}
}

Class Kar98Ammo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 5;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 5;
	}
}