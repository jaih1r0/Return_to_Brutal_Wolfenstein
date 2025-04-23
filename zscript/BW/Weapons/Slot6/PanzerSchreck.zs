Class BW_Panzerschreck : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 6;
		weapon.ammotype1 "RocketAmmo";
		weapon.ammotype2 "PanzerAmmo";
		weapon.ammogive1 3;
		BaseBWWeapon.FullMag 1;
		
		Inventory.Pickupmessage "[Slot 6] Panzerschreck";
		Tag "Panzerschreck";
		Inventory.PickupSound "Generic/Pickup/Launcher";
	}
	states
	{
		spawn:
			LAUN A -1;
			stop;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Launcher/Raise");
			PZSU AB 1;
			TNT1 A 0 A_StartSound("Panzerschreck/Raise", 0, CHANF_OVERLAP, 1);
			PZSU CD 1;
			goto ready;
		Deselect:
			TNT1 A 0 A_Startsound("Panzerschreck/Drop",0,CHANF_OVERLAP);
			PZSU FG 1;
			TNT1 A 0 A_StartSound("Generic/Launcher/Holster", 0, CHANF_OVERLAP, 1);
			PZSU HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
		Ready:
			PZSU E 1 {
				BW_GunBarrelSmoke(ofsPos:(30,0,-5));
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
			}
			loop;
		DryFire:
			PZSU E 1;
			goto ready;
		NoAmmo:
			PZSU E 1;
			goto ready;
		Fire:
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			PZSU E 3 A_Startsound("Panzerschreck/Trigger",0,CHANF_OVERLAP);
			PZSF A 1 bright firepanzerrocket();
			PZSF B 1 bright;
			PZSF C 1 A_StartSound("Panzerschreck/Whoosh", CHAN_AUTO, CHANF_OVERLAP, 0.75);
			PZSF DEF 1;
			PZSF GHI 1;
			PZSU EEE 1;
			goto ready;
		Reload:
			TNT1 A 0 BW_CheckReload(null,"Ready","NoAmmo",1,1);
			TNT1 A 0 A_StartSound("Generic/Rattle/Large", 0, CHANF_OVERLAP, 1);
			PZSR ABCDEFGHI 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			PZSR J 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/CartFoley", 0, CHANF_OVERLAP, 1);
			PZSR KL 1;
			TNT1 A 0 A_Startsound("Panzerschreck/Load",21);
			PZSR MNOP 1;
			PZSR QQQQQ 1;
			
			PZSR RSTUVWX 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),1,1);
			TNT1 A 3;
			PZSR EDCBA 1;
			goto ready;
		
		
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			PZSK ABC 1;
			PZSK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			PZSK GHHHG 1;
			PZSK FEDCBA 1;
			goto ready;	
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			PZSK ABCD 1;
			PZSK EFGH 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			PZSK HHH 1;
			PZSK HHH 1;
			PZSK HHH 1;
			PZSK HHH 1;
			PZSK HHH 1;
			PZSK HHH 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			PZSK FEDCBA 1;
			goto ready;
	}
	
	action void firepanzerrocket()
	{
		A_Fireprojectile("BW_Rocket",0,0);
		A_StartSound("Panzerschreck/Fire", CHAN_AUTO, CHANF_OVERLAP);
		BW_HandleWeaponFeedback(4, 6, -1.5, frandom(1.30, -1.30));
		BW_AddBarrelHeat(42);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		invoker.ammo2.amount--;
	}
}

Class PanzerAmmo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 1;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 1;
	}
}