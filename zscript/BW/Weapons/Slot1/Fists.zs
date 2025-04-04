Class BW_Fists : BaseBWWeapon replaces fist
{
    default
    {
        weapon.slotnumber 1;
        tag "Melee";
        +weapon.noalert;
    }
    states
    {
        select:
            TNT1 A 0 BW_WeaponRaise();
			TNT1 A 0 A_StartSound("Fists/Swap", 0, CHANF_OVERLAP, 1);
            MPFU AB 1;
			TNT1 A 0 A_Startsound("Generic/Melee/Raise", CHAN_AUTO, CHANF_OVERLAP, 1);
			MPFU CD 1;
            goto ready;
        Deselect:
			TNT1 A 0 A_StartSound("Fists/Swap", 0, CHANF_OVERLAP, 1);
            MPFU DC 1;
			TNT1 A 0 A_Startsound("Generic/Melee/Lower", CHAN_AUTO, CHANF_OVERLAP, 1);
			MPFU BA 1;
            TNT1 A 0 BW_WeaponLower();
            wait;
        Ready:
            MPFI ABCDEFGHIJKLMNOPQRSTUVWX 1 BW_WeaponReady(WRF_ALLOWUSER3);
            loop;
        Fire:   //left jab
            TNT1 A 0 A_Startsound("Fists/Swing",7);
            MPFL ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFL D 1;
            MPFL E 1 BW_Punch();
            MPFL EFG 1;
            TNT1 A 0 A_Startsound("Generic/Cloth/Medium",9);
            MPFL HI 1 BW_QuickRefire("AltFire",BT_ALTATTACK,false);
            MPFI A 1 BW_QuickRefire("AltFire",BT_ALTATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire();
            goto ready;
        AltFire:    //right jab
            TNT1 A 0 A_Startsound("Fists/Swing",8);
            MPFR ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFR D 1;
            MPFR E 1 BW_Punch();
            MPFR EFG 1;
            TNT1 A 0 A_Startsound("Generic/Cloth/Medium",9);
            MPFR HI 1 BW_QuickRefire("Fire",BT_ATTACK,false);
            MPFI A 1 BW_QuickRefire("Fire",BT_ATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire();
            goto ready;
        KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
            MPFK ABC 1;
            MPFK DEF 1;
            MPFK GHHH 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
            MPFK GFEDCBA 1;
            goto ready;

        SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
            MPFK ABCD 1;
            MPFK EFGH 1;
        //sliding
			TNT1 A 0 A_StartSound("Generic/Rattle/medium", 0, CHANF_OVERLAP, 1);
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
        SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
            MPFK FEDCBA 1;
            goto ready;
    }

    action void BW_Punch(int dist = 60,int dmg = 30)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, dist, pitch, offsetz: pz, data: t);
		
		if(t.hitactor)
		{
			actor victim = t.hitactor;
			if(victim.bsolid || victim.bshootable)
			{
				actor puf = SpawnPuff("BW_KickPuff", t.hitlocation, angle, 0, 0, PF_HITTHING);
				if(puf)
                {
					victim.damagemobj(puf,self,dmg,"Melee");
                    puf.A_Startsound("Fists/Hit", CHAN_AUTO, CHANF_OVERLAP, 0.75);  //impacted enemy
                }
            }
		}
		if(t.hitType == TRACE_HitWall || t.hitType == TRACE_HitCeiling || t.hitType == TRACE_HitFloor)
        {
			actor pf = spawnpuff("BW_KickPuff",t.hitlocation,angle,0,0);
            if(pf)
                pf.A_Startsound("Fists/Hit", CHAN_AUTO, CHANF_OVERLAP, 0.75);   //impacted wall,floor,etc, may need a different sound here
        }
	}
}