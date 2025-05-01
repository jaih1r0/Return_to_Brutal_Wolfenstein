Class BW_BrownGuard_Rifle : BW_MonsterBase
{
		Default
		{
			Radius 16;
			Height 56;
			Speed 4;
			FastSpeed 6;
			Mass 100;
			Health 50;
			GibHealth -40;
			PainChance 256;
			Scale 1; //Make sure to adjust the values in the See state to match these
			BloodColor "Red";
			
			BW_MonsterBase.headheight 38;
			BW_MonsterBase.feetheight 19;
			
			BW_MonsterBase.AttackRange 1600; //32 Dmu (1 meter) * 50 (55 yards effective range of Luger)
			BW_MonsterBase.CanIRoll true;
			SeeSound "Nazi/Generic/sight";
			PainSound "Nazi/Generic/pain";
			DeathSound "Nazi/Generic/death";
			ActiveSound "Nazi/Generic/sight";
			
			DropItem "BW_KarAmmo", 255, 8;
			DropItem "BW_Kar98K", 100, 1;
			
			Obituary "$OB_ZOMBIE";
		}
		
		int HowManyGrenadesHaveIThrown;
		
		void FireProjBullets()
		{
			A_Light(2);
			//A_SpawnProjectile("BW_Kar98Bullets", 32, 0, (frandom(3,-3)), CMF_AIMDIRECTION, self.pitch + (frandom(3,-3)));
			BW_FireMonsterBullet("BW_EnemyKar98Bullets");
			A_StartSound("Kar98/Fire", CHAN_AUTO, CHANF_OVERLAP);
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
			AmmoInMag = random(3,5); //Luger P08
		}
		
		override void Tick()
		{
			Super.Tick();
		}
		
		States
		{
		
		Spawn:
			WBRN G 1;
			TNT1 A 0;
		Stand:
			WBRN GGGG 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			WBRN GGGG 5
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
			WBRN AAAABBBB 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			WBRN CCCCDDDD 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			Loop;
		FallBack:
			TNT1 A 0 A_Jump(255, "Fallback1", "Roll", "See");
		FallBack1:
			WBRN D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBRN C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBRN B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBRN A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBRN D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBRN C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBRN B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WBRN A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
			}
			Goto Missile;
		
		////////////////
		//Attack Logic// 
		////////////////
		Melee:
			WBRN A 1 A_CheckLOF(1);
			Goto See;
			WBRN A 1 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBRN C random(10,20);
			WBRN C 3
			{
				//Melee attack
				A_StartSound("Fists/Swing");
				A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
			}
			WBPN G 3;
			WBRN E 6;
			Goto See;
		Missile:
			TNT1 A 0 A_JumpIf(AttackDelay > 3, "See");
			WBRN E 1 A_CheckLOFRanged("AttackHandler", "Roll");
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
			WBRN E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBRN E random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBRN F 2 BRIGHT FireProjBullets;
			WBRN E 4;
			WBRN G 4;
			WBRN G 24 A_StartSound("Kar98/BoltOpen", 8, CHANF_OVERLAP, attenuation: 2);
			WBRN G 24 A_StartSound("Kar98/BoltClose", 8, CHANF_OVERLAP, attenuation: 2);
			WBRN E 4;
			TNT1 A 0 A_Jump(90, "Attack1");
			WBRN E 8;
			Goto See;
			
		Attack2:
			TNT1 A 0
			{
				if(AmmoInMag <= 0)
				{
					A_Jump(256,"Reload");
				}
			}
			WBRN G 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBRN JJ random(5,10) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBRN KK random(5,10) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WBRN L 2 BRIGHT FireProjBullets;
			WBRN K 4;
			WBRN J 4;
			WBRN J 24 A_StartSound("Kar98/BoltOpen", 8, CHANF_OVERLAP, attenuation: 2);
			WBRN J 24 A_StartSound("Kar98/BoltClose", 8, CHANF_OVERLAP, attenuation: 2);
			WBRN J 4;
			TNT1 A 0 A_Jump(90, "Attack2");
			WBRN G 8;
			Goto See;
			
		Grenade:
			TNT1 A 0 A_JumpIfCloser(500, 1);
			Goto Attack1;
			TNT1 A 0 A_JumpIfCloser(90, "Attack1");
		ThrowGrenade:
			TNT1 A 0; //Grenade sound
			WBRN G 6
			{
				A_ActiveSound();
				A_FaceTarget(90,45);
			}
			WBRN H 6;
			WBRN I 6
			{
				A_FaceTarget(90,45);
				FireProjGren();
			}
			WBRN G 6;
			Goto See;
		Reload:
			WBRN G 6;
			WBRN O 24 A_StartSound("Kar98/BoltOpen", 8, CHANF_OVERLAP, attenuation: 2);
			WBRN M 16;
			TNT1 A 0
			{
				A_StartSound("Kar98/ClipLoad", 8, CHANF_OVERLAP, attenuation: 2);
				AmmoInMag = 5;
			}
			WBRN NO 12;
			WBRN O 6;
			WBRN G 24 A_StartSound("Kar98/BoltClose", 8, CHANF_OVERLAP, attenuation: 2);
			WBRN E 2;
			Goto See;

		////////////////
		//Pain Logic// 
		////////////////
		Pain:
			TNT1 A 0 A_JumpIf(kickeddown, "KickedPain");
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
		Pain.Kick:
			TNT1 A 0
			{
				kickeddown = true;
				A_Pain();
				A_ChangeVelocity(0, 0, 5, CVF_RELATIVE);
			}
			WBNK A 3;
		KickedLoop:
			WBNK A 1 A_CheckFloor("Kicked");
			Loop;
		KickedPain:
			WBNK B 10 A_Pain();
		Kicked:
			TNT1 A 0 A_CheckFloor(1);
			Goto KickedLoop;
			TNT1 A 0;
			WBNK BC 10;
			WBNK C random(25,50);
			WBNK D 10;
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
			WBRN A 3 A_FaceTarget;
			WBRN E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), -8, 0, CVF_RELATIVE);
			}
			WBRN E 24;
		SHRL:
			WBRN E 1 A_CheckFloor("SHRE");
			WBRN E 1;
			Loop;
		SHRE:
			WBRN E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "See", "Missile");
			Goto See;
		SHL:
			WBRN A 3 A_FaceTarget;
			WBRN E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), 8, 0, CVF_RELATIVE);
			}
			WBRN E 24;
		SHLL:
			WBRN E 1 A_CheckFloor("SHLE");
			WBRN E 1 A_CheckCeiling("SHLE");
			Loop;
		SHLE:
			WBRN E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "Roll", "See", "Missile");
			Goto See;
	}
}