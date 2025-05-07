Class BW_Leichenfaust : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 8;
		weapon.ammotype1 "BW_LFAmmo";
		weapon.ammogive1 50;
		scale 0.4;
		Inventory.Pickupmessage "[Slot 8] Leichenfaust 1943";
		Tag "Leichenfaust";
		Inventory.PickupSound "Generic/Pickup/Launcher";
	}
	states
	{
		Spawn:
			LFPK A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Rifle/Raise");
			BFPU AB 1;
			TNT1 A 0 A_StartSound("MG42/Raise", 0, CHANF_OVERLAP, 1);
			BFPU CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 A_Stopsound(42);
			TNT1 A 0 A_Startsound("MG42/Drop",5,CHANF_OVERLAP);
			BFPU FG 1;
			TNT1 A 0 A_StartSound("Generic/Rifle/Holster", 0, CHANF_OVERLAP, 1);
			BFPU HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			BFPI ABCDEFGHIJKLMNO 1 {
				if(invoker.ammo1.amount < 1)
					return resolvestate("Ready2");
				return BW_WeaponReady(WRF_ALLOWUSER3);
			}
			loop;
		NoAmmo:
		Ready2:
			TNT1 A 0 A_jumpif(invoker.ammo1.amount > 0,"SpinReload");
			BFPF L 1 BW_WeaponReady(WRF_ALLOWUSER3);
			loop;
		Fire:
			TNT1 A 0 BW_PrefireCheck(1,"DryFire","DryFire",true);
			BFPF A 1 bright firebfg();
			BFPF BC 1 bright;
			BFPF DEFGH 1;
			BFPF IJKL 1;
			TNT1 A 0 A_jumpif(invoker.ammo1.amount < 1,"NoAmmo");
		SpinReload:
			TNT1 A 0 A_Startsound("LF/Spin",33);
			BFPS ABABCD 1;
			BFPS CDEF 1;
			BFPS GHI 1;
			BFPS JKL 1;
			BFPI MNO 1;
			goto ready;
		DryFire:
			BFPF L 1;
			goto ready;
		
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BFPK ABC 1;
			BFPK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			BFPK GHHHG 1;
			BFPK FEDCBA 1;
			goto ready;	
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BFPK ABCD 1;
			BFPK EFGH 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			BFPK HHH 1;
			BFPK HHH 1;
			BFPK HHH 1;
			BFPK HHH 1;
			BFPK HHH 1;
			BFPK HHH 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BFPK FEDCBA 1;
			goto ready;
		
	}
	
	action void firebfg()
	{
		A_Fireprojectile("BFGBALL",0,0,0,-12,0);
		A_Startsound("LF/Fire",32);
		BW_QuakeCamera(12, 2);
		BW_WeaponRecoilBasic(-2, frandom(-2.2,2.2));
		invoker.ammo1.amount--;
	}
}


Class BW_LFAmmo : BW_Ammo //7692
{
	default
	{
		scale 0.75;
		inventory.amount 3;
        inventory.maxamount 6;
        ammo.backpackamount 2;
        ammo.BackpackMaxAmount 12;
        tag "PlasmaSix Cell";
	}
	states
	{
		spawn:
			LFAM A -1 bright;
			stop;
	}
}