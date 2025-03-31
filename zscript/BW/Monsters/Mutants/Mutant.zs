Class BW_Mutant : BW_MonsterBase //7078
{
    //$Category BW Enemies 
    //$Title Mutant
    default
    {
        Health 75;
        Radius 20;
        Height 56;
        Mass 500;
        Speed 5;
        FastSpeed 8;
        Painchance 120;
        painchance "Kick", 255;
        +NOINFIGHTING;
        SeeSound "";
        PainSound "";
        DeathSound "Mutant/Death";
        Scale 1;
        bloodcolor "FF00FF"; //magenta
        BW_MonsterBase.CanIReload false;    //i think they have a builtin bullets factory inside
        BW_MonsterBase.AttackRange 2000;
        dropitem "clip";
    }

    void MutantFire()
    {
        A_SpawnProjectile("BW_LugerBullets", 32, 0, (frandom(3,-3)), CMF_AIMDIRECTION | CMF_OFFSETPITCH, (frandom(3,-3)));
        A_StartSound("Luger/Fire", CHAN_AUTO, CHANF_OVERLAP);
    }

    void MutantSuperFire()
    {
        A_SpawnProjectile("BW_MutantSuperBullet", 32, 0, (frandom(5,-5)), CMF_AIMDIRECTION | CMF_OFFSETPITCH, (frandom(2,-2)));
        A_StartSound("Luger/Fire", CHAN_AUTO, CHANF_OVERLAP);
        A_StartSound("Trench/Fire", CHAN_AUTO, CHANF_OVERLAP, 1);
    }

    states
    {
        spawn:
            WMUT Z 1;
			TNT1 A 0;
		Stand:
            WMUT ZZZZ 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			WMUT ZZZZ 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y-0.01);
			}
			Loop;
        See:
            TNT1 A 0 
            {
                A_SetScale(1.0,1.0);
                EnemyLastSighted = Level.MapTime;
            }
        SeeContinue:
            WMUT AAA 2 AI_SmartChase();
            WMUT BBB 2 AI_SmartChase();
            WMUT CCC 2 AI_SmartChase();
            WMUT DDD 2 AI_SmartChase();
            loop;
        Missile:
            WMUT G 1 A_CheckLOFRanged("AttackHandler", "Roll");
        AttackHandler:
            TNT1 A 0 A_jump(64,"SuperFire");
        Attack1:
            WMUT GG 3 A_FaceTarget();
            WMUT H 3 MutantFire();
            WMUT G 3 A_FaceTarget();
            WMUT I 3 MutantFire();
            WMUT G 3;
            goto see;
        SuperFire:
            WMUT GGGGG 3 A_FaceTarget();
            WMUT H 3 MutantSuperFire();
            WMUT G 9 A_FaceTarget();
            TNT1 A 0 A_jumpif(checklof(),"Attack1");
            goto see;
        Melee:
            WMUT G 3 A_FaceTarget();
            ZMUT A 6 A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
            WMUT G 3 A_FaceTarget();
            ZMUT B 6 A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
            goto see;
        Pain:
            TNT1 A 0 A_SetScale(1.0,1.0);
            TNT1 A 0 A_JumpIf(kickeddown, "KickedPain");
            WMUT J 3 A_Pain();
            WMUT J 3;
            goto see;
        Death:
            TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
			}
            WMUT JKMNO 2;
            WMUT O -1;
            stop;
        XDeath:
            TNT1 A 0
			{
				A_XScream();
				A_NoBlocking();
			}
            WMUT JKMNO 2;
            WMUT O -1;
            stop;
        Raise:
            WMUT ONMKJ 3;
            goto spawn;

        Reload:
            WMUT ZZZ 2;
            goto see;

        Roll:
        FallBack:
            WMUT G 3 A_FaceTarget();
            TNT1 A 0 
            {
                A_ChangeVelocity(frandom(5,-5), -8, 0, CVF_RELATIVE);
            }
            ZMUT A 3;
            WMUT G 1;
            goto see;
        
        Pain.Kick:
			TNT1 A 0
			{
				kickeddown = true;
				A_Pain();
				A_ChangeVelocity(-1, 0, 6, CVF_RELATIVE);
			}
			ZMUT C 3;
		KickedLoop:
            ZMUT C 1 A_CheckFloor("Kicked");
			Loop;
		KickedPain:
            ZMUT D 10 A_Pain();
		Kicked:
			TNT1 A 0 A_CheckFloor(1);
			Goto KickedLoop;
			TNT1 A 0;
            ZMUT D 5;
			ZMUT E 15;
			ZMUT E random(25,50);
			ZMUT F 10;
			TNT1 A 0
			{
				kickeddown = false;
				A_ActiveSound();
			}
			Goto See;
    }
}