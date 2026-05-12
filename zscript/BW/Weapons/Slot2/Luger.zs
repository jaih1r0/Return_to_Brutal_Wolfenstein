class BW_Luger : BW_DualWeapon
{
 	Default
	{
		Weapon.AmmoType "BW_PistolAmmo";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType2 "BW_Luger_Mag";
		BaseBWWeapon.AmmoTypeLeft "BW_Luger_Mag_Left";
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
		Scale 0.35;
		Inventory.PickupSound "Generic/Pickup/Pistol";
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
	}
	
	action void BW_LugerFire()
	{
		A_AlertMonsters();
		
		A_StartSound("Luger/Fire", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_StartSound("Luger/Fireadd", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		A_StartSound("Luger/FireTail", CHAN_AUTO, CHANF_OVERLAP, 0.7);
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		
		if(CountInv("AimingToken"))
		{
			BW_FireBullets("BW_LugerBullets",0.1,0.1,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15));//, 0, 0, 0);
			A_ZoomFactor(1.2-0.01);
			BW_SpawnCasing("BW_9MMCasing",20,2,-3,random(2,5),random(2,5),random(3,6));
		}
		else
		{
			BW_FireBullets("BW_LugerBullets",0.5,0.5,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.40, frandom(+0.30, -0.30));//, -5, 0, 0);
			A_ZoomFactor(1-0.01);
			BW_SpawnCasing("BW_9MMCasing",27,2,-7,random(2,5),random(2,5),random(3,6));
		}
		//gunsmoke
		BW_AddBarrelHeat(10);
		A_TakeInventory("BW_Luger_Mag", 1);
	}
	
	action void BW_DualLugerFire(bool isLeft = false)
	{
		A_AlertMonsters();
		
		A_SpawnItemEx("PlayerMuzzleFlash",30,0,45);
		A_StartSound("Luger/Fire", CHAN_AUTO, CHANF_OVERLAP, 1);
		A_StartSound("Luger/Fireadd", CHAN_AUTO, CHANF_OVERLAP, 0.8);
		A_StartSound("Luger/FireTail", CHAN_AUTO, CHANF_OVERLAP, 0.7);
		
		if(isLeft)
		{
			invoker.AmmoLeft.amount--;
			BW_FireBullets("BW_LugerBullets",1.0,1.0,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15));//, 0, 0, 0);
			BW_SpawnCasing("BW_9MMCasing",20,-12,-3,random(2,5),random(2,5),random(3,6));
			BW_AddBarrelHeat(10,false,true);
		}
		else
		{
			invoker.ammo2.amount--;
			BW_FireBullets("BW_LugerBullets",1.0,1.0,-1,25,"Bulletpuff","Bullet",0,0,0);
			BW_HandleWeaponFeedback(2, 3, -0.40, frandom(+0.30, -0.30));//, -5, 0, 0);
			BW_SpawnCasing("BW_9MMCasing",27,12,-7,random(2,5),random(2,5),random(3,6));
			BW_AddBarrelHeat(10,false,false);
		}
	}
	
	States
	{
	
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_ZoomFactor(1);
			TNT1 A 0 A_StartSound("Lug/lower", CHAN_AUTO, CHANF_OVERLAP, 1);
			TNT1 A 0 BW_jumpifAkimbo("Deselect_Dual");
			ZLUS FG 1;
			TNT1 A 0 A_StartSound("Generic/Pistol/Holster", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLUS HI 1;
			TNT1 A 0 BW_WeaponLower();
			Wait;
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Pistol/raise");
			TNT1 A 0 BW_jumpifAkimbo("Select_Dual");
			ZLUS AB 1;
			TNT1 A 0 A_StartSound("Lug/raise", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLUS CD 1;
			goto ready;
		Ready:
			TNT1 A 0 BW_jumpifAkimbo("Ready_Dual");
			ZLUS E 1 {
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReadyEmpty");
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		Ready_ADS:
			ZLU2 A 1 {
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "WeaponReady2Empty");
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		ReadyEmpty:
			ZLUG E 1 {
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		ReadyEmpty_ADS:
			ZLU2 E 1 {
				BW_GunBarrelSmoke(ofsPos:(18,0,-4),startsize:4);
				return BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3);
			}
			//TNT1 A 0 A_JumpIfInventory("ThrowGrenade", 1, "FragGrenade");
			Loop;
		Fire:
			TNT1 A 0 BW_JumpifAiming("Fire_ADS");
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			TNT1 A 0 BW_LugerFire();
			ZLUG AB 1 BRIGHT;
			ZLUG C 1 A_StartSound("Luger/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
			TNT1 A 0 A_ZoomFactor(1);
			ZLUG D 1;
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "ReadyEmpty");
			ZLUG E 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
			ZLUG F 1;
			Goto Ready;
		Fire_ADS:
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire_ADS");
			ZLU2 B 1 BRIGHT BW_LugerFire();
			ZLU2 C 1;
			TNT1 A 0 A_ZoomFactor(1.2);
			ZLU2 D 1;
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "ReadyEmpty_ADS");
			ZLU2 E 1 A_StartSound("Luger/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
			ZLU2 F 1 BW_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER2 | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
			Goto Ready_ADS;
		
		AltFire:
			TNT1 A 0
			{
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
			ZLUX AB 1;
			TNT1 A 0 A_ZoomFactor(1.2);
			ZLUX CD 1;
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "ReadyEmpty_ADS");
			goto Ready_ADS;
		StopAim:
			ZLUX DC 1;
			TNT1 A 0 A_ZoomFactor(1);
			ZLUX BA 1;
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "ReadyEmpty");
			goto Ready;
		
		DryFire:
			ZLUG E 1;
			Goto ReadyEmpty;
		DryFire2:
			ZLU2 E 1;
			Goto ReadyEmpty_ADS;
		
		//Dual States
		
		//dual wield states
		User2:
		GoDual:
			TNT1 A 0 {
				if(!BW_CangoDual())
				{
					if((player.cmd.buttons & BT_USER2) && !(player.oldbuttons & BT_USER2))	//print it only once per tap
						A_log("you need 2 "..invoker.gettag().." to dual wield.");
					BW_SetAkimbo(false);
					return resolvestate("Ready");
				}
				if(BW_CheckAkimbo())
				{
					BW_SetAkimbo(false);
					BW_ClearDualOverlays();
					return resolvestate("GoSingle");
				}
				BW_SetAkimbo(true);
				return resolvestate(null);
			}
			TNT1 A 0 A_Startsound("Generic/ADS",CHAN_AUTO);
			DLUT ABCDE 1;
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			DLUT FGHIJ 1;
			goto Ready_Dual;
		GoSingle:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",CHAN_AUTO);
			DLUT JIHGF 1;
			TNT1 A 0 A_Startsound("Generic/ADS",CHAN_AUTO);
			DLUT EDCBA 1;
			goto ready;

		Select_Dual:
			DLUS ABCD 1;
			goto Ready_Dual;
		Deselect_Dual:
			TNT1 A 0 BW_ClearDualOverlays();
			DLUS DCBA 1;
			TNT1 A 0 BW_WeaponLower();
			wait;

		StartDual:
		Ready_Dual:
			TNT1 A 1 BW_MainDualReady();
			loop;

		Dual_Left:
			DLUL A 1 {
				BW_GunBarrelSmoke(ofsPos:(22,-8,-5),left:true);
				return BW_DualReady(true,"Dual_Left_Fire");
			}
			loop;
		Dual_Left_Empty:
			DLUL C 1 {
				BW_GunBarrelSmoke(ofsPos:(22,-8,-5),left:true);
				return BW_DualReady(true,"Dual_Left_Fire");
			}
			loop;
		Dual_Right:
			DLUR A 1 {
				BW_GunBarrelSmoke(ofsPos:(22,7,-5));
				return BW_DualReady(false,"Dual_Right_Fire");
			}
			loop;
		Dual_Right_Empty:
			DLUR C 1 {
				BW_GunBarrelSmoke(ofsPos:(22,7,-5));
				return BW_DualReady(false,"Dual_Right_Fire");
			}
			loop;
		
		Dual_Left_Fire:
			TNT1 A 0 BW_DualPrefire("Dual_Left_DryFire",true);
			TNT1 A 0 BW_SetFiring(true,false);
			DLUL B 1 bright BW_DualLugerFire(true);
			DLUL C 1;
			DLUL D 1 A_StartSound("Luger/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
			TNT1 A 0 BW_SetFiring(false,false);
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag_Left") == 0, "Dual_Left_Empty");
			DLUL E 1;
			DLUL FF 1; //BW_QuickRefire("Dual_Left_Fire",BT_ATTACK,false);
			goto Dual_Left;
		Dual_Left_DryFire:
			TNT1 A 0 A_Startsound("weapon/dryfire",13);
			DLUL C 1;
			goto Dual_Left_Empty;
		Dual_Right_Fire:
			TNT1 A 0 BW_DualPrefire("Dual_Right_DryFire",false);
			TNT1 A 0 BW_SetFiring(true,true);
			DLUR B 1 bright BW_DualLugerFire();
			DLUR C 1;
			DLUR D 1 A_StartSound("Luger/FireMech", CHAN_AUTO, CHANF_OVERLAP, 0.8);
			TNT1 A 0 BW_SetFiring(false,true);
			TNT1 A 0 A_JumpIf(CountInv("BW_Luger_Mag") == 0, "Dual_Right_Empty");
			DLUR E 1;
			DLUR FF 1; //BW_QuickRefire("Dual_Right_Fire",getRightfirebutton(),false);
			goto Dual_Right;
		Dual_Right_DryFire:
			TNT1 A 0 A_Startsound("weapon/dryfire",CHAN_AUTO);
			DLUR C 1;
			goto Dual_Right_Empty;
		
		UnAimReload:
			TNT1 A 0 A_TakeInventory("AimingToken");
			TNT1 A 0 A_StartSound("Generic/ADS", CHAN_AUTO, CHANF_OVERLAP, 0.5);
			ZLUX DC 1;
			TNT1 A 0 A_ZoomFactor(1);
			ZLUX BA 1;
		Reload:
			TNT1 A 0 A_JumpIf(CountInv("AimingToken") == 1, "UnAimReload");
			TNT1 A 0 BW_CheckReload("Reload2","Ready","ReadyEmpty",9,1);
			TNT1 A 0 A_TakeInventory("AimingToken");
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLR2 ABCDEFGHIJ 1;
			TNT1 A 0 A_StartSound("Luger/Out", CHAN_AUTO, CHANF_OVERLAP);
			ZLR2 LMNNNNN 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLR2 OPQRSTUUUUU 1;
			TNT1 A 0 A_StartSound("Luger/In", CHAN_AUTO, CHANF_OVERLAP);
			ZLR2 VWXYZZZZZ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 9, 1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZL22 ABCDEFG 1;
			ZLR2 HGFEDCBA 1;
			Goto Ready;
		Reload2:
			TNT1 A 0 A_TakeInventory("AimingToken");
			ZLR3 ABCDEFGH 1;
			TNT1 A 0 A_StartSound("Luger/outempty", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 ABCDEFGHIIIIIJKLM 1;
			TNT1 A 0 A_StartSound("Luger/inempty", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 NOPPPPPPQ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 8, 1);
			ZLR4 RSSSSS 1;
			TNT1 A 0 A_StartSound("Luger/Charge", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 TTUUVW 1;
			ZLUR IHGFEDCBA 1;
			Goto Ready;
		Spawn:
			BLGW A -1;
			Stop;
		
		
		Reload_Dual:
			TNT1 A 0 BW_ClearDualOverlays();
			//go single
			DLUT JIHGFEDCBA 1;
			TNT1 A 0 A_jumpif(invoker.ammo2.amount > 8,"Reload_Left");
		ReloadRight:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"EmptyReloadRight");
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLR2 ABCDEFGHIJ 1;
			TNT1 A 0 A_StartSound("Luger/Out", CHAN_AUTO, CHANF_OVERLAP);
			ZLR2 LMNNNNN 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLR2 OPQRSTUUUUU 1;
			TNT1 A 0 A_StartSound("Luger/In", CHAN_AUTO, CHANF_OVERLAP);
			ZLR2 VWXYZZZZZ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 9, 1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZL22 ABCDEFG 1;
			ZLR2 HGFEDCBA 1;
			goto FinishedRight;

		EmptyReloadRight:
			ZLR3 ABCDEFGH 1;
			TNT1 A 0 A_StartSound("Luger/outempty", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 ABCDEFGHIIIIIJKLM 1;
			TNT1 A 0 A_StartSound("Luger/inempty", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 NOPPPPPPQ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammo2.getclassname(), invoker.ammo1.getclassname(), 8, 1);
			ZLR4 RSSSSS 1;
			TNT1 A 0 A_StartSound("Luger/Charge", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 TTUUVW 1;
			ZLUR IHGFEDCBA 1;
			Goto Ready;
			goto FinishedRight;

		FinishedRight:
			TNT1 A 0 A_jumpif(invoker.ammoleft.amount > 8 || invoker.ammo1.amount < 1,"EndDualReload");
		Reload_Left:
		//lower right
			ZLUS FGHI 1;
			TNT1 A 1;
		//raise left
			ZLUS ABCD 1;
	
		//reload left
		doReloadLeft:
			TNT1 A 0 A_jumpif(invoker.ammoleft.amount < 1,"EmptyReloadLeft");
			TNT1 A 0 A_StartSound("Generic/Cloth/Short", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLR2 ABCDEFGHIJ 1;
			TNT1 A 0 A_StartSound("Luger/Out", CHAN_AUTO, CHANF_OVERLAP);
			ZLR2 LMNNNNN 1;
			TNT1 A 0 A_StartSound("Generic/Ammo/MagFoley", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZLR2 OPQRSTUUUUU 1;
			TNT1 A 0 A_StartSound("Luger/In", CHAN_AUTO, CHANF_OVERLAP);
			ZLR2 VWXYZZZZZ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotypeLeft.getclassname(), invoker.ammo1.getclassname(), 9, 1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			ZL22 ABCDEFG 1;
			ZLR2 HGFEDCBA 1;
			goto FinishedLeft;
			
		EmptyReloadLeft:
			TNT1 A 0 A_TakeInventory("AimingToken");
			ZLR3 ABCDEFGH 1;
			TNT1 A 0 A_StartSound("Luger/outempty", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 ABCDEFGHIIIIIJKLM 1;
			TNT1 A 0 A_StartSound("Luger/inempty", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 NOPPPPPPQ 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotypeLeft.getclassname(), invoker.ammo1.getclassname(), 8, 1);
			ZLR4 RSSSSS 1;
			TNT1 A 0 A_StartSound("Luger/Charge", CHAN_AUTO, CHANF_OVERLAP);
			ZLR4 TTUUVW 1;
			ZLUR IHGFEDCBA 1;
			Goto Ready;
			goto FinishedLeft;
		
		FinishedLeft:
		//lower left
			ZLUS FGHI 1;
			TNT1 A 1;
		//raise right
			ZLUS ABCD 1;
		//back to dual
		EndDualReload:
			DLUT ABCDEFGHIJ 1;
			goto ready_Dual;
		
		KickFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KickFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK ABC 1;
			LUGK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK GGG 1;
			LUGK FEDCBA 1;
			goto ready;
		SlideFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("SlideFlash_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK ABCD 1;
			LUGK EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
			LUGK GGG 1;
		SlideFlashEnd:
			TNT1 A 0 BW_jumpifAkimbo("SlideFlashEnd_Akimbo");
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			LUGK FEDCBA 1;
			goto ready;
		KnifeGunFlash:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 BW_jumpifAkimbo("KnifeGunFlash_Akimbo");
			ZLUS HIGF 1;	//temporary
			TNT1 A 5;
			ZLUS ABCD 1;
			stop;
		
		KnifeGunFlash_Akimbo:
			DLUS DCBA 1;	//temporary
			TNT1 A 5;
			DLUS ABCD 1;
			stop;

		KickFlash_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			DLUS EDCBA 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", CHAN_AUTO, CHANF_OVERLAP, 1);
			DLUS AAAAA 1;
			DLUS ABCDE 1;
			goto ready;
		SlideFlash_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			DLUS ECDBA 1;
			DLUS AAA 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", CHAN_AUTO, CHANF_OVERLAP, 1);
			DLUS AAA 1;
			DLUS AAA 1;
			DLUS AAA 1;
			DLUS AAA 1;
			DLUS AAA 1;
			DLUS AAA 1;
		SlideFlashEnd_Akimbo:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", CHAN_AUTO, CHANF_OVERLAP, 1);
			DLUS AABCDE 1;
			goto ready;

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

Class BW_Luger_Mag_Left : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 9;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 9;
	}
}