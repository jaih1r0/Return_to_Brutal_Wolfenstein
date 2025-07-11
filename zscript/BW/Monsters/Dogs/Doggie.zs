Class BW_Dog : BW_MonsterBase
{
    default
    {
        Health 50;
        Radius 14;
        Height 32;
        speed 6;
        Painchance 255;
        mass 50;
		
		BW_MonsterBase.headheight 16;
		BW_MonsterBase.feetheight 8;
		
        BW_MonsterBase.AttackRange 100;
        BW_MonsterBase.CanIReload false;
        SeeSound "dog/sight";
        DeathSound "dog/death";
		PainSound "Dog/Pain";
		Scale 0.75;
    }
    states
    {
        spawn:
            TNT1 A 0;
            TNT1 A 0 A_jump(100,"IdleRest","IdleSit");
        Idle_guard:
            WDOG AAA 1 {A_Wander(); A_LookEx();}
            WDOG BBB 1 {A_Wander(); A_LookEx();}
            WDOG CCC 1 {A_Wander(); A_LookEx();}
            WDOG DDD 1 {A_Wander(); A_LookEx();}
			TNT1 A 0
			{
				int chance = random(1,50);
				
				if(chance == 25)
				{
					A_Startsound("dog/Pant", CHAN_AUTO, CHANF_OVERLAP, 0.5);
				}
			}
            loop;

        IdleRest:
            NDOI AAA 2 {A_LookEx();A_SetScale(scale.X,Scale.Y+0.01);}
            NDOI AAA 2 {A_LookEx();A_SetScale(scale.X,Scale.Y-0.01);}
			TNT1 A 0
			{
				int chance = random(1,50);
				
				if(chance == 25)
				{
					A_Startsound("dog/Pant", CHAN_AUTO, CHANF_OVERLAP, 0.5);
				}
			}
            loop;
        IdleSit:
            NDO2 AAA 2 {A_LookEx();A_SetScale(scale.X,Scale.Y+0.01);}
            NDO2 AAA 2 {A_LookEx();A_SetScale(scale.X,Scale.Y-0.01);}
			TNT1 A 0
			{
				int chance = random(1,50);
				
				if(chance == 25)
				{
					A_Startsound("dog/Pant", CHAN_AUTO, CHANF_OVERLAP, 0.5);
				}
			}
            loop;
        Reload:
        SeeContinue:
        See:
            TNT1 A 0 A_Setscale(0.75,YscaleFix);
            WDOG AAABBBB 1 A_Chase(); //AI_SmartChase();
            TNT1  A 0 A_JumpIfCloser(100,"Melee");
            WDOG CCCCDDDD 1 A_Chase(); //AI_SmartChase();
            TNT1  A 0 A_JumpIfCloser(100,"Melee");
            Loop;
        
        Missile:
        Melee:
            //TNT1 A 0 A_CheckLOFRanged("MeleeAproach","Randommove");
        MeleeAproach:
            WDG6 A 6 A_FaceTarget();
            TNT1 A 0 A_JumpIfCloser(60, "CloseBite");
            TNT1 A 0 A_Startsound("dog/attack");
            TNT1 A 0 {vel.z += 2;}
            TNT1 A 0 A_FaceTarget();
            TNT1 A 0 A_Recoil(-10);
            WDG6 B 6;
            TNT1 A 0 A_FaceTarget();
            WDG6 C 6 A_SargAttack();
            Goto See;
        
        CloseBite:
            WDG6 AA 3 A_FaceTarget();
            WDG6 B 3 A_SargAttack();
            WDG6 CC 3;
            WDOG AA 4;
            Goto See;

        Randommove:
            TNT1 A 0 A_jump(256,"Roll","PushForward");
        //sidestep
        Roll:
            TNT1 A 0 A_jump(100,"see");
            TNT1 A 0 A_FaceTarget();
            TNT1 A 0 velfromangle(3,angle + randompick(-90,90));
            WDOG AABB 1;
            goto see;
        //forward leap
        PushForward:
            TNT1 A 0 A_FaceTarget();
            TNT1 A 0 A_Recoil(-5);
            WDOG AABB 1;
            goto see;
        Fallback:   //backward leap
            TNT1 A 0 A_FaceTarget();
            TNT1 A 0 A_Recoil(4);
            WDOG AABB 1;
            goto see;
        Pain:
            WDOG E 6;
            Goto See;
        
        Death:
            TNT1 A 0 A_NoBlocking();
            WDOG HIJK 1;
            WDOG K -1;
            stop;
        Xdeath:
            WDG5 ABCD 1;
            WDG5 D -1;
            stop;
    }
}