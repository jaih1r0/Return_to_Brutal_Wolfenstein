Class BW_BrownGuard_Pistol : BW_MonsterBase replaces Zombieman //[Pop] replace is temporary until spawners are implemented. Do we want to do spawner injection?
{
		Default
		{
			Radius 16;
			Height 56;
			Speed 2;
			FastSpeed 4;
			Mass 100;
			Health 60;
			GibHealth -40;
			PainChance 256;
			Scale 1; //Make sure to adjust the values in the See state to match these
			BloodColor "Red";
			
			BW_MonsterBase.AttackRange 1600; //32 Dmu (1 meter) * 50 (55 yards effective range of Luger)
			BW_MonsterBase.CanIRoll true;
			SeeSound "Nazi/Generic/sight";
			PainSound "Nazi/Generic/pain";
			DeathSound "Nazi/Generic/death";
			ActiveSound "Nazi/Generic/sight";
			
			Obituary "$OB_ZOMBIE";
		}
		
		int HowManyGrenadesHaveIThrown;
		
		void FireProjBullets()
		{
			A_Light(2);
			A_SpawnProjectile("BW_LugerBullets", 32, 0, (frandom(3,-3)), CMF_OFFSETPITCH, (frandom(3,-3)));
			A_StartSound("Luger/Fire", CHAN_AUTO, CHANF_OVERLAP);
			AmmoInMag--;
		}
		
		void FireProjGren()
		{
			//Grenade
			HowManyGrenadesHaveIThrown++;
		}
		
		override void PostBeginPlay()
		{
			Super.PostBeginPlay(); // call the super function for virtual functions so we don't break shit if GZdoom update.
		}
		
		override void BeginPlay()
		{
			super.BeginPlay();
			AmmoInMag = random(4,8); //Luger P08
		}
		
		override void Tick()
		{
			Super.Tick();
		}
		
		States
		{
		
		Spawn:
			WBPN H 1;
			TNT1 A 0;
		Stand:
			WBPN HHHH 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			WBPN HHHH 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y-0.01);
			}
			Loop;
		See:
			TNT1 A 0
			{
				A_SetScale(1,1);
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
			WBPN AAAABBBB 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			WBPN CCCCDDDD 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			Loop;
		FallBack:
			TNT1 A 0 A_Jump(255, "Fallback1", "Roll", "See");
		FallBack1:
			WBPN D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBPN C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBPN B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBPN A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBPN D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBPN C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBPN B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBPN A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
			}
			Goto Missile;
		
		////////////////
		//Attack Logic// 
		////////////////
		Melee:
			WBPN A 1 A_CheckLOF(1);
			Goto See;
			WBPN A 1 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBPN C random(10,20);
			WBPN C 3
			{
				//Melee attack
				A_StartSound("Fists/Swing");
				A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
			}
			WBPN G 3;
			WBPN E 6;
			Goto See;
		Missile:
			TNT1 A 0 A_JumpIf(AttackDelay > 3, "See");
			WBPN E 1 A_CheckLOFRanged("AttackHandler", "Roll");
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
				
				AttackDelay = AttackDelay + 20;
				
				return A_Jump(256, "Attack1", "Attack2", "Attack3");
			}
		
		Attack1:
			TNT1 A 0
			{
				if(AmmoInMag <= 0)
				{
					A_Jump(256,"Reload");
				}
			}
			WBPN E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBPN E random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBPN F 1 BRIGHT FireProjBullets;
			WBPN E 4;
			TNT1 A 0 A_Jump(90, "Attack1");
			WBPN E 8;
			Goto See;
			
		Grenade:
			TNT1 A 0 A_JumpIfCloser(500, 1);
			Goto Attack1;
			TNT1 A 0 A_JumpIfCloser(90, "Attack1");
		ThrowGrenade:
			TNT1 A 0; //Grenade sound
			WBPN E 6
			{
				A_ActiveSound();
				A_FaceTarget(90,45);
			}
			WBPN E 6;
			WBPN E 6
			{
				A_FaceTarget(90,45);
				FireProjGren();
			}
			WBPN E 6;
			Goto See;
		Reload:
			WBPR A 6;
			WBPR B 6 A_StartSound("Luger/Out", 8, CHANF_OVERLAP, attenuation: 2);
			WBPR C 12;
			WBPR B 6;
			WBPR A 6 A_StartSound("Luger/In", 8, CHANF_OVERLAP, attenuation: 2);
			WBPR C 2;
			TNT1 A 0
			{
				A_StartSound("Luger/Charge", 8, CHANF_OVERLAP, attenuation: 1.5);
				AmmoInMag = 9;
			}
			WBPR A 2;
			Goto See;

		////////////////
		//Pain Logic// 
		////////////////
		Pain:
			WBPN G 6 A_Pain();
			Goto See;
		Death:
			TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
			}
			WBPN IJKL 3;
			WBPN M -1;
			Stop;
		XDeath:
			TNT1 A 0
			{
				A_XScream();
				A_NoBlocking();
			}
			WBPN IJKL 3;
			WBPN M -1;
			Stop;
		Raise:
			WBPN MLKJIG 3;
			Goto Spawn;
		
		////////////////////
		//Generic By Actor//
		////////////////////
		
		Roll:
			TNT1 A 0 A_Jump(256, "SHR", "SHL", "See");
		SHR:
			WBPN A 3 A_FaceTarget;
			WBPN E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), -8, 0, CVF_RELATIVE);
			}
			WBPN E 24;
		SHRL:
			WBPN E 1 A_CheckFloor("SHRE");
			WBPN E 1;
			Loop;
		SHRE:
			WBPN E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "See", "Missile");
			Goto See;
		SHL:
			WBPN A 3 A_FaceTarget;
			WBPN E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), 8, 0, CVF_RELATIVE);
			}
			WBPN E 24;
		SHLL:
			WBPN E 1 A_CheckFloor("SHLE");
			WBPN E 1 A_CheckCeiling("SHLE");
			Loop;
		SHLE:
			WBPN E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "Roll", "See", "Missile");
			Goto See;
	}
}