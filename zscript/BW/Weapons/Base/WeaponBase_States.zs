//
//
//	Base class for weapons
//  - default states 
//
Extend Class BaseBWWeapon
{
    states
	{
		DoKick:
			TNT1 A 0 A_jumpif(pos.z <= floorz + 2 && vel.xy.length() > 3 && (player.cmd.buttons & BT_CROUCH),"SlideKick");
			TNT1 A 0 handlekickFlash();
			TNT1 A 0 A_StartSound("Player/Kick", 0, CHANF_OVERLAP, 1);
			BWK1 ABCDE 1;
			BWK1 FGG 1;
			TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
			BWK1 HIJ 1;
			BWK1 K 3 HandleKick();
			BWK1 LNO 1;
			TNT1 A 2;
			stop;

		SlideKick:
			TNT1 A 0 BW_SlideDirSet();
			TNT1 A 0 BW_SlideThrust(30);	//thrust relative to angle and input, aka slide in any direction, not just forward
			TNT1 A 0 handlekickFlash(1);
			//start sliding 8 frames
			TNT1 A 0 A_StartSound("Player/Slide", 0, CHANF_OVERLAP, 1);
			BWK2 ABC 1;
			TNT1 A 0 A_QuakeEx(1,0,0,20,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
			BWK2 DEF 1;
			BWK2 GH 1;
			//slidin, 18 frames
			BWK2 IJK 1 SlideHandle("EndSlideKick",20);
			BWK2 IJK 1 SlideHandle("EndSlideKick",20);
			BWK2 IJK 1 SlideHandle("EndSlideKick",20);
			BWK2 IJK 1 SlideHandle("EndSlideKick",15);
			BWK2 IJK 1 SlideHandle("EndSlideKick",12);
			BWK2 IJK 1 SlideHandle("EndSlideKick",10);
		EndSlideKick:
			TNT1 A 0 {
				BW_SlideDirSet(true);	//reset direction
				//keep the weapon synced with the kick overlay
				State PSPState = player.GetPSprite(PSP_WEAPON).Curstate;
				if(InStateSequence(PSPState,invoker.ResolveState("SlideFlash")))
				{
					state endslide = invoker.resolvestate("SlideFlashEnd");
					if(endslide)
						player.SetPSprite(PSP_WEAPON,endslide);
				}
			}
			//end sliding 6 frames
			BWK2 H 1;
			BWK2 FDCBA 1;
			stop;
		
		//there was already an states block here lol
		User1: //replaces BD Weapon Special
			TNT1 A 1;
			Goto WeaponReady;
		
		User2:
		KnifeAttack:
			TNT1 A 0 handleKnifeFlash();
			TNT1 A 0 A_Startsound("Fists/Swing",16);
			TNT1 A 1;
			TNT1 A 0 A_StartSound("Knife/Swing", 0, CHANF_OVERLAP, 1);
			BWKF JIH 1;
			BWKF G 1;
			TNT1 A 0 A_QuakeEx(0,0.5,0,7,0,10,"",QF_SCALEDOWN|QF_RELATIVE,0,0,0,0,0,2,2);
			BWKF G 2 BW_HandleKnife(); //A_CustomPunch(12, 1, CPF_PULLIN | CPF_NOTURN, "BulletPuff", 64, 0, 0, "BasicArmorBonus", "melee/knife/hit");
			BWKF FEDCBA 1;
			TNT1 A 0 A_Jump(256, "Ready");
			goto ready;
		
		//old
			TNT1 A 0 handleKnifeFlash();
			TNT1 A 0 A_StartSound("Knife/Swing", 0, CHANF_OVERLAP, 1);
			BWKF ABC 1;
			BWKF DE 1;
			TNT1 A 0 A_QuakeEx(0,0.5,0,7,0,10,"",QF_SCALEDOWN|QF_RELATIVE,0,0,0,0,0,2,2);
			BWKF F 2 BW_HandleKnife(); //A_CustomPunch(12, 1, CPF_PULLIN | CPF_NOTURN, "BulletPuff", 64, 0, 0, "BasicArmorBonus", "melee/knife/hit");
			BWKF GGHIJ 1;
			TNT1 A 0 A_Jump(256, "Ready");
			goto ready;
			
			TNT1 A 0 A_StartSound("melee/knife/slash", 0, CHANF_OVERLAP, 1);
			KNI9 AB 1;
			KNI9 CDEF 1 A_CustomPunch(12, 1, CPF_PULLIN | CPF_NOTURN, "BulletPuff", 64, 0, 0, "BasicArmorBonus", "melee/knife/hit");
			KNI9 GHI 1;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		
		KnifeGunFlash:
			TNT1 A 12;
			stop;
		
		User3:
		GrenadeThrow:
			TNT1 A 1;
			//raise
			TNT1 A 0 A_startsound("Grenade/Draw",6,CHANF_OVERLAP);
			BGTR ABCDE 1;
			BGTR FF 1;
			BGTR GHIJ 1;
			//hold pin
			BGTR KK 1;
			//remove pin
			TNT1 A 0 A_Startsound("Grenade/Pin",6,CHANF_OVERLAP);
			BGTR LMN 1;
			//lower
			BGTR OPQ 1;
			TNT1 A 2;	//
			//throw
			TNT1 A 0 A_startsound("Grenade/Throw",7,CHANF_OVERLAP);
			BGTR RST 1;
			BGTR U 1 
			{
				A_fireprojectile("BW_Grenade",0,0,5);
				Takeinventory("BW_grenadeAmmo",1);
			}
			BGTR VWXY 1;
			TNT1 A 0 A_jump(256,"Ready");
			wait;

		LedgeGrabbing:
			BWLG ABC 1;
			BWLG DEF 1;
			BWLG GHI 1;
			BWLG J 1;
			TNT1 AA 0 A_jump(256,"Ready");
			wait;
		FinishClimb:
			BWLG G 1;
			BWLG HIJ 1;
			TNT1 AA 0 A_jump(256,"Ready");
			wait;
		PrepareLedgeGrab:	//pseudo virtual function
			TNT1 A 1;
			stop;
		//dummy kick flashes 
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			TNT1 ABC 1;
			TNT1 DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			TNT1 GGG 1;
			TNT1 FEDCBA 1;
			goto WeaponReady;	//this needs to go to ready instead
			//goto ready;
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			TNT1 ABCD 1;
			TNT1 EFGG 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			TNT1 GGG 1;
			TNT1 GGG 1;
			TNT1 GGG 1;
			TNT1 GGG 1;
			TNT1 GGG 1;
			TNT1 GGG 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			TNT1 FEDCBA 1;
			goto WeaponReady;
			

	}
}