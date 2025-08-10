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
            TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 A_StartSound("Fists/Swap", 0, CHANF_OVERLAP, 1);
            MPFU DC 1;
			TNT1 A 0 A_Startsound("Generic/Melee/Lower", CHAN_AUTO, CHANF_OVERLAP, 1);
			MPFU BA 1;
            TNT1 A 0 BW_WeaponLower();
            wait;
        Ready:
            MPFI ABCDEFGHIJKLMNOPQRSTUVWX 1 BW_WeaponReady(WRF_ALLOWUSER3);
            loop;
		BackToReady:
			MPFU BCD 1;
			goto ready;
			
        Fire:   //left jab
            TNT1 A 0 A_Startsound("Fists/Swing",7);
            MPFL ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFL D 1;
            MPFL E 1 BW_Punch();
            MPFL EFG 1;
            TNT1 A 0 A_Startsound("Generic/Cloth/Medium",9);
            MPFL HI 1 BW_QuickRefire("AltFire2",BT_ALTATTACK,false);
            MPFI A 1 BW_QuickRefire("AltFire2",BT_ALTATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire("Fire2");
            goto ready;
		Fire2:
			TNT1 A 0 A_Startsound("Fists/Swing",7);
            MPFL ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFL D 1;
            MPFL E 1 BW_Punch();
            MPFL EFG 1;
            TNT1 A 0 A_Startsound("Generic/Cloth/Medium",9);
            MPFL HI 1 BW_QuickRefire("StrongRight",BT_ALTATTACK,false);
            MPFI A 1 BW_QuickRefire("StrongRight",BT_ALTATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire("StrongLeft");
            goto ready;
			
			
        AltFire:    //right jab
            TNT1 A 0 A_Startsound("Fists/Swing",8);
            MPFR ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFR D 1;
            MPFR E 1 BW_Punch();
            MPFR EFG 1;
            TNT1 A 0 A_Startsound("Generic/Cloth/Medium",9);
            MPFR HI 1 BW_QuickRefire("Fire2",BT_ATTACK,false);
            MPFI A 1 BW_QuickRefire("Fire2",BT_ATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire("AltFire2");
            goto ready;
		AltFire2:
            TNT1 A 0 A_Startsound("Fists/Swing",8);
            MPFR ABC 1;
            TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
            MPFR D 1;
            MPFR E 1 BW_Punch();
            MPFR EFG 1;
            TNT1 A 0 A_Startsound("Generic/Cloth/Medium",9);
            MPFR HI 1 BW_QuickRefire("StrongLeft",BT_ATTACK,false);
            MPFI A 1 BW_QuickRefire("StrongLeft",BT_ATTACK,false);
            MPFI A 1;
            TNT1 A 0 A_Refire("StrongRight");
            goto ready;
			
		StrongLeft:
			MPFU CA 1;
			TNT1 A 0 A_QuakeEx(2,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
			TNT1 A 1;
			TNT1 A 0 A_Startsound("Fists/Swing",8);
			MPHL AB 1;
			MPHL C 1 BW_strongpunch();
			MPHL E 1 BW_Punch();
			MPHL F 1;
			MPHL GGHH 1;
			MPHL IJKL 1;
			TNT1 A 1;
			goto BackToReady;
		
		StrongRight:
			MPFU CA 1;
			TNT1 A 0 A_QuakeEx(2,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
			TNT1 A 1;
			TNT1 A 0 A_Startsound("Fists/Swing",8);
			MPHR AB 1;
			MPHR C 1 BW_strongpunch();
			MPHR E 1 BW_Punch();
			MPHR F 1;
			MPHR GGHH 1;
			MPHR IJKL 1;
			TNT1 A 1;
			goto BackToReady;
			
			
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

    action void BW_Punch(int dist = 60,int dmg = 30, double sideOfs = 0)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, dist, pitch, offsetz: pz,offsetside:sideOfs, data: t);
		
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

    action void BW_strongpunch(int dist = 60, int dmg = 50)
    {
        blockthingsiterator bti = blockthingsiterator.create(self,dist);
        actor mo,puf;
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
		
        quat baseq = quat.fromangles(angle,pitch,roll);
        vector3 ofss = baseq * (dist,0,pz);
		
        puf = spawn("BW_dmgpuff",levellocals.vec3offset(pos,ofss));
		//BW_Statics.SpawnIndicator(levellocals.vec3offset(pos,ofss));
        while(bti.next())
        {
            mo = bti.thing;
            if(mo && (mo.bisMonster || mo.bshootable) && mo != self && checksight(mo)) //can be damaged, is not the player, and the player can see it
            {
                vector3 sc = levellocals.sphericalcoords((pos.xy,pos.z + height * 0.5),(mo.pos.xy,mo.pos.z + mo.height * 0.5),(angle,pitch));
                if(abs(sc.x) < 60 && abs(sc.y) < 30 && sc.z < dist)
                {
                    mo.A_Startsound("Fists/Hit", CHAN_AUTO, CHANF_OVERLAP, 0.75);
                    mo.damagemobj(puf,self,dmg,'melee');
                }
            }
        }
    }
	

}