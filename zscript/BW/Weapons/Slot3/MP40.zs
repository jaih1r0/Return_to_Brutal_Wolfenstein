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
		BW_FireBullets("BW_MP40Bullets",3,2,-1,25,"Bulletpuff","Bullet",0,0,0);
		BW_HandleWeaponFeedback(2, 3, -0.5, frandom(+0.30, -0.30), -5, 0, 0);
		invoker.ammo2.amount--;
	}
	
	states
	{
		spawn:
			MP4W A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("MP40/Equip");
			MP4U ABCD 1;
			goto ready;
		Deselect:
			MP4U FGHI 1;
			TNT1 A 0 A_lower(120);
			wait;
		Ready:
			MP4U E 1 BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER2);
			loop;
		Fire:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"DryFire");
			MP4F A 1 bright BW_MP40Fire();
			MP4F B 1 bright;
			MP4F C 1;
			MP4F D 1;
			MP4U E 1 A_Refire();
			MP4U E 1;
			goto ready;
		
		DryFire:
			MP4U E 1;
			goto ready;
		
		User2:
			MP4K ABC 1;
			MP4K DEF 1;
			MP4K GGG 1;
			MP4K FEDCBA 1;
			goto ready;
		
		Reload:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount >= invoker.FullMag||invoker.ammo1.amount < 1,"Ready");
			MP4R ABCD 1;
			MP4R EFGH 1;
			MP4R IJKL 1;
			MP4R MNOP 1;
			MP4R QRST 1;
			MP4R UVWX 1;
			TNT1 A 0 A_startsound("MP40/Take",17);
			MP4R YZ 1;
			MP4S ABCD 1;
			MP4S EFGH 1;
			MP4S IJ 1;
			TNT1 A 0 A_startsound("MP40/Insert",18);
			MP4S KL 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),32,1);
			MP4S MNOP 1;
			MP4S QRST 1;
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