//
//
//	Base class for weapons
//  - default states 
//
Extend Class BaseBWWeapon
{
    states
	{
		//handles kick and knife inputs
		HelperHandler:
			TNT1 A 1 {
				int btns = player.cmd.buttons;
				int oldbt = player.oldbuttons;
				bool isKicking = !!(player.findpsprite(-3));
				bool isSlashing = !!(player.findpsprite(-4));
				bool aiming = BW_IsAiming();

				if(!isKicking && (btns & BT_Zoom))
					A_overlay(-3,"DoKick");
				
				if(!isKicking && player.onground && tappedButton(BT_Crouch) &&
				vel.xy.length() > 2 && BW_CrouchKick)
					A_overlay(-3,"SlideKick");

				if(!isSlashing && (btns & BT_User1) && !aiming)
					player.SetPSprite(PSP_WEAPON,resolvestate("KnifeAttack"));
				
			}
			loop;
		
		//User4:	//kick
		DoKick:
			TNT1 A 0 A_jumpif(pos.z <= floorz + 2 && vel.xy.length() > 3 && (player.cmd.buttons & BT_CROUCH),"SlideKick");
			TNT1 A 0 A_jumpif(vel.xy.length() > 0 && (pos.z > floorz || vel.z != 0),"AirKick");
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
				if(InStateSequence(PSPState,invoker.ResolveState("SlideFlash"))	||
				InStateSequence(PSPState,invoker.ResolveState("SlideFlash_Akimbo")))
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
		
		AirKick:
			TNT1 A 0 handlekickFlash(0);
			TNT1 A 1;
			TNT1 A 0 A_StartSound("Player/Kick", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
			BWK3 A 1 A_recoil(-3);
			BWK3 BC 1 A_recoil(-2);
			BWK3 DE 1 A_recoil(-2);
			TNT1 A 0 HandleKick(dmg:25);
			BWK3 F 1 A_recoil(-1);
			TNT1 A 0 HandleKick(dmg:35);
			BWK3 GHII 1;
			BWK3 FEDCBA 1;
			stop;
		
		//there was already an states block here lol
		
		User1:	//knoife/axe
		KnifeAttack:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 handleKnifeFlash();
			TNT1 A 0 A_jumpif(countinv("BW_AxeAmmo") > 0,"AxeAttack");
			TNT1 A 0 A_Startsound("Fists/Swing",16);
			TNT1 A 1;
			TNT1 A 0 A_StartSound("Knife/Swing", 0, CHANF_OVERLAP, 1);
			BWKF JIH 1;
			BWKF G 1;
			TNT1 A 0 A_QuakeEx(0,0.5,0,7,0,10,"",QF_SCALEDOWN|QF_RELATIVE,0,0,0,0,0,2,2);
			BWKF G 2 BW_HandleKnife();
			BWKF FEDCBA 1;
			TNT1 A 0 A_Jump(256, "Ready");
			goto ready;
		AxeAttack:
			TNT1 A 0 A_StartSound("Axe/Swing", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 giveinventory("CanThrowAxe",1);
			TNT1 AAA 1;
			BAX1 ABC 1 A_jumpif(shouldthrowaxe(),"AxeThrow");
			TNT1 A 0 A_QuakeEx(0.5,0.5,0.5,7,0,10,"",QF_SCALEDOWN|QF_RELATIVE,0,0,0,0,0,2,2);
			BAX1 D 1 A_jumpif(shouldthrowaxe(),"AxeThrow");
			BAX1 E 1 {
				if(shouldthrowaxe())
					return resolvestate("AxeThrow");
				BW_HandleKnife(100,70,true);
				return resolvestate(null);
			}
			BAX1 FGH 1 A_jumpif(shouldthrowaxe(),"AxeThrow");
			TNT1 A 2 A_jumpif(shouldthrowaxe(),"AxeThrow");
			TNT1 A 0 A_Jump(256, "Ready");
			goto ready;
		AxeThrow:
			TNT1 A 0 handleKnifeFlash(); //restart the gun flash
			TNT1 A 0 A_QuakeEx(0.5,0.5,0.5,7,0,10,"",QF_SCALEDOWN|QF_RELATIVE,0,0,0,0,0,2,2);
			BAX2 ABC 1;
			TNT1 A 0 A_Startsound("Fists/Swing",16);
			TNT1 A 0 {
				A_fireprojectile("BW_ThrowedAxe",0,0);
				A_TakeInventory("BW_AxeAmmo",1);
			}
			BAX2 DEF 1;
			BAX2 GHI 1;
			TNT1 A 4;
			TNT1 A 0 A_Jump(256, "Ready");
			goto ready;
		
		KnifeGunFlash:
			TNT1 A 14;
			stop;
		
		//User2:	//weapon special/dual wield/etc

		User3:
		GrenadeThrow:
			TNT1 A 0 BW_ClearDualOverlays();
			TNT1 A 0 A_overlay(-33,"PrepareGrenadeLayer");
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
			TNT1 A 0 A_jumpif(pressingButton(BT_USER3),"GrenadeDrop"); //if pressed user3 before throwing drop instead, will work on this later
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
			
		GrenadeDrop:
			TNT1 A 2;
			//drop (no animation for it yet
			TNT1 A 0 A_startsound("Grenade/Throw",7,CHANF_OVERLAP);
			BGTR RST 1;
			BGTR U 1 
			{
					A_fireprojectile("BW_GrenadeSlow",0,0,5);
					Takeinventory("BW_grenadeAmmo",1);
			}
			BGTR VWXY 1;
			TNT1 A 0 A_jump(256,"Ready");
			wait;

		LedgeGrabbing:
			TNT1 A 0 BW_ClearDualOverlays();
			BWLG ABC 1;
			BWLG DEF 1;
			BWLG GHI 1;
			BWLG J 1;
			TNT1 AA 0 A_jump(256,"Ready");
			wait;
		FinishClimb:
			TNT1 A 0 BW_ClearDualOverlays();
			BWLG G 1;
			BWLG HIJ 1;
			TNT1 AA 0 A_jump(256,"Ready");
			wait;
		PrepareLedgeGrab:	//pseudo virtual function
			TNT1 A 1;
			stop;
		PrepareKnifeLayer:	
			TNT1 A 1;
			stop;
		PrepareGrenadeLayer:
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