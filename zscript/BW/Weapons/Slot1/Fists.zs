Class BW_Fists : BaseBWWeapon replaces fists
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
            MPFU ABCD 1;
            goto ready;
        Deselect:
            MPFU DCBA 1;
            TNT1 A 0 A_lower(120);
            wait;
        Ready:
            MPFI ABCDEFGHIJKLMNOPQRSTUVWX 1 BW_WeaponReady();
            loop;
        Fire:   //left jab
            MPFL ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFL D 1 BW_Punch();
            MPFL DEFG 1;
            MPFL HI 1 BW_QuickRefire("AltFire",BT_ALTATTACK,false);
            MPFI A 1 BW_QuickRefire("AltFire",BT_ALTATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire();
            goto ready;
        AltFire:    //right jab
            MPFR ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFR D 1 BW_Punch();
            MPFR DEFG 1;
            MPFR HI 1 BW_QuickRefire("Fire",BT_ATTACK,false);
            MPFI A 1 BW_QuickRefire("Fire",BT_ATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire();
            goto ready;
        KickFlash:
            MPFK ABC 1;
            MPFK DEF 1;
            MPFK GHHH 1;
            MPFK GFEDCBA 1;
            goto ready;

        SlideFlash:
            MPFK ABCD 1;
            MPFK EFGH 1;
        //sliding
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
            MPFK FGH 1;
        SlideFlashEnd:
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
					victim.damagemobj(puf,self,dmg,"Melee");
			}
		}
		if(t.hitType == TRACE_HitWall || t.hitType == TRACE_HitCeiling || t.hitType == TRACE_HitFloor)
			spawnpuff("BW_KickPuff",t.hitlocation,angle,0,0);

	}
}