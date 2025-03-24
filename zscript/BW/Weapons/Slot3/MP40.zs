Class BW_MP40 : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 3;
		Weapon.AmmoType "Clip";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_MP40Mag";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 0;
		BaseBWWeapon.FullMag 32;
		tag "MP40";
		Inventory.PickupSound "weapons/pistol/pickup";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "[Slot 3] Maschinenpistole 40";
	}
	
	action void BW_MP40Fire()
	{
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_Startsound("MP40/Fire",5,CHANF_OVERLAP);
		A_Startsound("MP40/FireAdd",5,CHANF_OVERLAP, 0.70);
		BW_FireBullets("BW_MP40Bullets",0.5,0.5,-1,25,"Bulletpuff","Bullet",0,0,0);
		BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30), -5, 0, 0);
		invoker.ammo2.amount--;
	}
	
	states
	{
		spawn:
			MP4W A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/SMG/Raise");
			MP4U AB 1;
			TNT1 A 0 A_StartSound("MP40/raise", 0, CHANF_OVERLAP, 1);
			MP4U CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 A_Startsound("MP40/Lower",5,CHANF_OVERLAP);
			MP4U FG 1;
			TNT1 A 0 A_StartSound("Generic/SMG/Holster", 0, CHANF_OVERLAP, 1);
			MP4U HI 1;
			TNT1 A 0 A_lower(120);
			wait;
		Ready:
			MP4U E 1 BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER2);
			loop;
		Fire:
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			MP4F A 1 bright BW_MP40Fire();
			MP4F B 1 bright;
			MP4F C 1 A_Startsound("MP40/FireMech",5,CHANF_OVERLAP, 0.8);
			MP4F D 1;
			MP4U E 1 A_Refire();
			MP4U E 1;
			goto ready;
		
		DryFire:
			MP4U E 1;
			goto ready;
		NoAmmo:
			MP4U E 1;
			goto ready;
		
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			MP4K ABC 1;
			MP4K DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			MP4K GGG 1;
			MP4K FEDCBA 1;
			goto ready;
		SlideFlash:
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
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			MP4K FEDCBA 1;
			goto ready;
		Reload:
			TNT1 A 0 BW_CheckReload(null,"Ready","NoAmmo",32,1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			MP4R ABCDEFGHIJKL 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Small", 0, CHANF_OVERLAP, 1);
			MP4R MNOPQRSTUV 1;
			TNT1 A 0 A_startsound("MP40/Out",17);
			MP4R WXYZ 1;
			MP4S AB 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", 0, CHANF_OVERLAP, 1);
			MP4S CDEFGH 1;
			TNT1 A 0 A_startsound("MP40/In",18);
			MP4S IJKL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),32,1);
			MP4S MNOPQRST 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", 0, CHANF_OVERLAP, 1);
			MP4S UV 1;
			MP4R FEDCBA 1;
			goto ready;
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