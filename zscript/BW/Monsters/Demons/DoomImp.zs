Class BW_Imp : BW_MonsterBase //1380
{
    Default
	{
		Health 60;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 5;
		PainChance 200;
		Monster;
		+FLOORCLIP
		SeeSound "imp/sight";
		PainSound "imp/pain";
		DeathSound "imp/death";
		ActiveSound "imp/active";
		HitObituary "$OB_IMPHIT";
		Obituary "$OB_IMP";
		Tag "$FN_IMP";
		BW_MonsterBase.AttackRange 1000;
        BW_MonsterBase.headheight 38;
		BW_MonsterBase.feetheight 18;
		BW_MonsterBase.HeadShotMult 2.0;
		BW_MonsterBase.HasHeadshot true;
	}
	
	override void BeginPlay()
	{
		super.BeginPlay();
		Mana = random(1,10);
	}
	
	override void Tick()
	{
		Super.Tick();
		if(Mana < 10)
		{
			Mana = Mana+0.01;
		}
	}
	
	void FireProjBullets()
	{
		A_Light(1);
		BW_FireMonsterBullet("DoomImpBall");
		Mana = Mana - 3;
	}
	
	States
	{
        Spawn:
            TROO A 1;
			TNT1 A 0;
		Stand:
			TROO AAAA 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			TROO AAAA 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y-0.01);
			}
			Loop;
        See:
			TNT1 A 0
			{
				A_SetScale(1,YscaleFix);
				EnemyLastSighted = Level.MapTime;
				if(Mana < 3)
				{
					bFRIGHTENED = true;
				}
				else
				{
					bFRIGHTENED = false;
				}
			}
		SeeContinue:
			TROO AAAABBBB 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			TROO CCCCDDDD 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			Loop;
		FallBack:
			TNT1 A 0 A_Jump(255, "Fallback1", "Roll", "See");
		FallBack1:
			TROO D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			TROO C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			TROO B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			TROO A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			TROO D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			TROO C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			TROO B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			TROO A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
			}
			Goto Missile;
			
       Melee:
			TROO A 1 A_CheckLOF(1);
			Goto See;
			TROO E 1 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TROO E random(10,20);
			TROO FG 3
			{
				//Melee attack
				A_StartSound("Fists/Swing");
				A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
			}
			TROO G 3;
			TROO FE 6;
			Goto See;
		Missile:
			TNT1 A 0 A_JumpIf(AttackDelay > 3, "See");
			TROO E 1 A_CheckLOFRanged("AttackHandler", "Roll");
			Goto See;
		AttackHandler:
			TNT1 A 0
			{
				if(Mana < 3)
				{
					return A_Jump(256,"Reload");
				}
				AttackDelay = AttackDelay + 20;
				
				return A_Jump(256, "Attack1", "Fallback", "Roll");
			}
		
		Attack1:
			TNT1 A 0
			{
				if(Mana < 3)
				{
					A_Jump(256,"Reload");
				}
			}
			TROO E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TROO E random(2,10) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TROO F random(2,10) BRIGHT A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TROO G 6 BRIGHT FireProjBullets;
			TROO F 4;
			TNT1 A 0 A_Jump(90, "Attack1");
			TROO E 8;
			Goto See;
		
		Reload:
			TROO F 8 A_ActiveSound();
			TROO E 8;
			Goto See;
		
		Roll:
			TNT1 A 0 A_Jump(256, "SHR", "SHL", "See");
		SHR:
			TROO A 3 A_FaceTarget;
			TROO E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), -8, frandom(5,10), CVF_RELATIVE);
			}
			TROO E 24;
		SHRL:
			TROO E 1 A_CheckFloor("SHRE");
			TROO E 1;
			Loop;
		SHRE:
			TROO E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "See", "Missile");
			Goto See;
		SHL:
			TROO A 3 A_FaceTarget;
			TROO E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), 8, frandom(5,10), CVF_RELATIVE);
			}
			TROO E 24;
		SHLL:
			TROO E 1 A_CheckFloor("SHLE");
			TROO E 1 A_CheckCeiling("SHLE");
			Loop;
		SHLE:
			TROO E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "Roll", "See", "Missile");
			Goto See;
		
		Pain:
            TNT1 A 0 A_JumpIf(kickeddown, "KickedPain");
            TROO H 4 A_Pain;
            Goto See;
		
		Pain.Kick:
			TNT1 A 0
			{
				kickeddown = true;
				A_Pain();
				A_ChangeVelocity(0, 0, 5, CVF_RELATIVE);
			}
			TROK A 3;
		KickedLoop:
			TROK A 1 A_CheckFloor("Kicked");
			Loop;
		KickedPain:
			TROK B 10 A_Pain();
		Kicked:
			TNT1 A 0 A_CheckFloor(1);
			Goto KickedLoop;
			TNT1 A 0;
			TROK BC 10;
			TROK C random(25,50);
			TROK D 10;
			TNT1 A 0
			{
				kickeddown = false;
				A_ActiveSound();
			}
			Goto See;
		
        Death:
            TROO I 8;
            TROO J 8 A_Scream;
            TROO K 6;
            TROO L 6 A_NoBlocking;
            TROO M -1;
            Stop;
        XDeath:
            TROO N 5;
            TROO O 5 A_XScream;
            TROO P 5;
            TROO Q 5 A_NoBlocking;
            TROO RST 5;
            TROO U -1;
            Stop;
        Raise:
            TROO ML 8;
            TROO KJI 6;
            Goto See;
	}
}