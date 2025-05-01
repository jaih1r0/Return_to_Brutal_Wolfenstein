Class BW_BlueGuard_Trenchgun : BW_MonsterBase
{
		Default
		{
			Radius 16;
			Height 56;
			Speed 4;
			FastSpeed 6;
			Mass 100;
			Health 90;
			GibHealth -40;
			PainChance 256;
			Scale 1; //Make sure to adjust the values in the See state to match these
			BloodColor "Red";
			Translation "192:207=96:105", "240:247=106:111";	//"197:207=16:47", "240:247=187:191";//just to avoid them looking exactly the same
			
			BW_MonsterBase.headheight 42; //Taller, so zones are different
			BW_MonsterBase.feetheight 22;
			
			BW_MonsterBase.AttackRange 640; //32 Dmu (1 meter) * 20 (20 yards effective range of M1897)
			BW_MonsterBase.CanIRoll true;
			SeeSound "Nazi/Generic/sight";
			PainSound "Nazi/Generic/pain";
			DeathSound "Nazi/Generic/death";
			ActiveSound "Nazi/Generic/sight";
			
			DropItem "BW_ShotgunAmmo", 255, 6;
			DropItem "BW_Trenchgun", 100, 1;
			
			Obituary "$OB_ZOMBIE";
		}
		
		int HowManyGrenadesHaveIThrown;
		
		void FireProjBullets()
		{
			A_Light(2);
			BW_FireMonsterBullet("BW_EnemyMP40Bullets",8);
			A_StartSound("Trench/Fire", CHAN_AUTO, CHANF_OVERLAP, 1);
			A_StartSound("Trench/FireAlt", CHAN_AUTO, CHANF_OVERLAP, 0.7);
			AmmoInMag--;
		}
		
		void FireProjGren()
		{
			A_Spawnprojectile("BW_enemyGrenade", 32, 0, 0, CMF_ABSOLUTEPITCH, self.pitch-5);
			HowManyGrenadesHaveIThrown++;
		}
		
		override void PostBeginPlay()
		{
			Super.PostBeginPlay(); // call the super function for virtual functions so we don't break shit if GZdoom update.
		}
		
		override void BeginPlay()
		{
			super.BeginPlay();
			AmmoInMag = random(3,7); //MP40
		}
		
		override void Tick()
		{
			Super.Tick();
		}
		
		States
		{
		
		Spawn:
			NAZS A 1;
			TNT1 A 0;
		Stand:
			NAZS AAAA 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			NAZS AAAA 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y-0.01);
			}
			TNT1 A 0 A_Jump(64, "StandPipe");
			Loop;
		StandPipe:
			NAZS A 5 A_LookEx();
			NAZS DB 5 A_LookEx();
		StandPipeLoop:
			NAZS B 5;
			NAZS CCCC 5
			{
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			NAZS CB 5;
			NAZS BBBB 5
			{
				A_SetScale(scale.X,Scale.Y-0.01);
			}
			NAZS BBB 5 A_LookEx();
			TNT1 A 0 A_Jump(64, "StandPipeEnd");
			Loop;
		StandPipeEnd:
			NAZS BDA 5 A_LookEx();
			Goto Stand;
		See:
			TNT1 A 0
			{
				A_SetScale(1,YscaleFix);
				EnemyLastSighted = Level.MapTime;
				if(AmmoInMag < 5)
				{
					bFRIGHTENED = true;
				}
				else
				{
					bFRIGHTENED = false;
				}
			}
		SeeContinue:
			NAZI AAAABBBB 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			NAZI CCCCDDDD 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			Loop;
		FallBack:
			TNT1 A 0 A_Jump(255, "Fallback1", "Roll", "See");
		FallBack1:
			NAZI D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			NAZI C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			NAZI B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			NAZI A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			NAZI D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			NAZI C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			NAZI B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			NAZI A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
			}
			Goto Missile;
		
		////////////////
		//Attack Logic// 
		////////////////
		Melee:
			NAZI A 1 A_CheckLOF(1);
			Goto See;
			NAZI A 1 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZK A random(10,20);
			NAZK B 6
			{
				//Melee attack
				A_StartSound("Fists/Swing");
				A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
			}
			NAZI A 6;
			Goto See;
		Missile:
			TNT1 A 0 A_JumpIf(AttackDelay > 3, "See");
			NAZI E 1 A_CheckLOFRanged("AttackHandler", "Roll");
			Goto See;
		AttackHandler:
			TNT1 A 0
			{
				int chance = (random(1,256));
				
				if((chance > 232) && (HowManyGrenadesHaveIThrown < 4))
				{
					return A_Jump(256, "Grenade");
				}
				
				if(AmmoInMag <= 0)
				{
					return A_Jump(256,"Reload");
				}
				
				AttackDelay = AttackDelay + 35;
				
				return A_Jump(256, "Attack1", "Attack2");
			}
		
		Attack1:
			TNT1 A 0
			{
				if(AmmoInMag <= 0)
				{
					A_Jump(256,"Reload");
				}
			}
			NAZI E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZI E random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZI F 2 BRIGHT FireProjBullets;
			NAZI E 1;
			NAZI E 10;
			TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
			NAZI E 10;
			TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
			NAZI E 10;
			TNT1 A 0 A_Jump(128, "Attack1");
			NAZI E 8;
			Goto See;
		Attack2:
			TNT1 A 0
			{
				if(AmmoInMag <= 3)
				{
					A_Jump(256,"Reload");
				}
			}
			NAZI E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZI E random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZI F 2 BRIGHT FireProjBullets;
			NAZI E 2 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
			NAZI E 8 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
			NAZI E 8 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZI F 2 BRIGHT FireProjBullets;
			NAZI E 2 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
			NAZI E 8 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
			NAZI E 8 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZI F 2 BRIGHT FireProjBullets;
			NAZI E 2 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, 1);
			NAZI E 8 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TNT1 A 0 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, 1);
			NAZI E 5 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			NAZI E 8;
			Goto See;
			
		Grenade:
			TNT1 A 0 A_JumpIfCloser(500, 1);
			Goto Attack1;
			TNT1 A 0 A_JumpIfCloser(90, "Attack1");
		ThrowGrenade:
			TNT1 A 0; //Grenade sound
			NAZI E 6
			{
				A_ActiveSound();
				A_FaceTarget(90,45);
			}
			NAZI E 6;
			NAZI E 6
			{
				A_FaceTarget(90,45);
				FireProjGren();
			}
			NAZI E 6;
			Goto See;
		Reload:
			TNT1 A 0 A_StartSound("Trench/Shell", 0, CHANF_OVERLAP, 1);
			TNT1 A 0 A_JumpIf(AmmoInMag > 0, "ReloadLoop");
			NAZR A 6;
			TNT1 A 0 A_StartSound("Trench/Back", 0, CHANF_OVERLAP, attenuation: 2);
			NAZR ADE 4;
			NAZR B 12 A_StartSound("Trench/Shell", 0, CHANF_OVERLAP, 1);
			NAZR A 4 A_StartSound("Trench/Forward", 0, CHANF_OVERLAP, attenuation: 2);
			TNT1 A 0
			{
				AmmoInMag++;
			}
		ReloadLoop:
			NAZR A 6;
			NAZR DE 4;
			NAZR B 4 A_StartSound("Trench/Shell", 0, CHANF_OVERLAP, 1);
			TNT1 A 0
			{
				AmmoInMag++;
			}
			TNT1 A 0 A_JumpIf(AmmoInMag == 7, "ReloadEnd");
			Loop;
		ReloadEnd:
			NAZR BA 4;
			NAZS A 4;
			Goto See;

		////////////////
		//Pain Logic// 
		////////////////
		Pain:
			TNT1 A 0 A_JumpIf(kickeddown, "KickedPain");
			NAZI G 6 A_Pain();
			Goto See;
		Death:
			TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
			}
			NAZI HIJK 3;
			NAZI L -1;
			Stop;
		XDeath:
			TNT1 A 0
			{
				A_XScream();
				A_NoBlocking();
			}
			NAZI HIJK 3;
			NAZI L -1;
			Stop;
		Raise:
			NAZI LKJIHG 3;
			Goto Spawn;
		Pain.Kick:
			TNT1 A 0
			{
				kickeddown = true;
				A_Pain();
				A_ChangeVelocity(0, 0, 5, CVF_RELATIVE);
			}
			NAZI A 3;
		KickedLoop:
			NAZL A 1 A_CheckFloor("Kicked");
			Loop;
		KickedPain:
			NAZL B 10 A_Pain();
		Kicked:
			TNT1 A 0 A_CheckFloor(1);
			Goto KickedLoop;
			TNT1 A 0;
			NAZL BC 10;
			NAZL C random(25,50);
			NAZL D 10;
			TNT1 A 0
			{
				kickeddown = false;
				A_ActiveSound();
			}
			Goto See;
		
		////////////////////
		//Generic By Actor//
		////////////////////
		
		Roll:
			TNT1 A 0 A_Jump(256, "SHR", "SHL", "See");
		SHR:
			NAZI A 3 A_FaceTarget;
			NAZI E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), -8, 0, CVF_RELATIVE);
			}
			NAZI E 24;
		SHRL:
			NAZI E 1 A_CheckFloor("SHRE");
			NAZI E 1;
			Loop;
		SHRE:
			NAZI E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "See", "Missile");
			Goto See;
		SHL:
			NAZI A 3 A_FaceTarget;
			NAZI E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), 8, 0, CVF_RELATIVE);
			}
			NAZI E 24;
		SHLL:
			NAZI E 1 A_CheckFloor("SHLE");
			NAZI E 1 A_CheckCeiling("SHLE");
			Loop;
		SHLE:
			NAZI E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "Roll", "See", "Missile");
			Goto See;
	}
}