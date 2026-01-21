Class BW_BlackGuard_STG44 : BW_MonsterBase 
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
			
			BW_MonsterBase.headheight 42; //Taller, so zones are different
			BW_MonsterBase.feetheight 22;
			
			BW_MonsterBase.AttackRange 9600; //32 Dmu (1 meter) * 300 (300 yards effective range of MP40)
			BW_MonsterBase.CanIRoll true;
			SeeSound "Nazi/Generic/sight";
			PainSound "Nazi/Generic/pain";
			DeathSound "Nazi/Generic/death";
			ActiveSound "Nazi/Generic/sight";
			
			DropItem "BW_SMGAmmo", 255, 30;
			DropItem "BW_STG44", 100, 1;
			
			Obituary "$OB_ZOMBIE";
		}
		
		int HowManyGrenadesHaveIThrown;
		
		void FireProjBullets()
		{
			A_Light(2);
			//A_SpawnProjectile("BW_MP40Bullets", 32, 0, (frandom(3,-3)), CMF_AIMDIRECTION, self.pitch + (frandom(3,-3)));
			BW_FireMonsterBullet("BW_EnemySTG44Bullets");
			A_Startsound("STG/Fire", CHAN_AUTO, CHANF_OVERLAP, 0.65);
			A_Startsound("STG/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 1);
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
			AmmoInMag = random(15,30); //STG44
		}
		
		override void Tick()
		{
			Super.Tick();
		}
		
		States
		{
		
		Spawn:
			WSS1 H 1;
			TNT1 A 0;
		Stand:
			WSS1 HHHH 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			WSS1 HHHH 5
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
			WSS1 AAAABBBB 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			WSS1 CCCCBBBB 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			Loop;
		FallBack:
			TNT1 A 0 A_Jump(255, "Fallback1", "Roll", "See");
		FallBack1:
			WSS1 B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WSS1 C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WSS1 B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WSS1 A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WSS1 B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WSS1 C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WSS1 B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WSS1 A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
			}
			Goto Missile;
		
		////////////////
		//Attack Logic// 
		////////////////
		Melee:
			WSS1 A 1 A_CheckLOF(1);
			Goto See;
			WSS1 A 1 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 B random(10,20);
			WSSK A 6
			{
				//Melee attack
				A_StartSound("Fists/Swing");
				A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
			}
			WSS1 H 6;
			Goto See;
		Missile:
			TNT1 A 0 A_JumpIf(AttackDelay > 3, "See");
			WSS1 E 1 A_CheckLOFRanged("AttackHandler", "Roll");
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
			WSS1 E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 E random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 1;
			TNT1 A 0 A_Jump(128, "Attack1");
			WSS1 E 8;
			Goto See;
		Attack2:
			TNT1 A 0
			{
				if(AmmoInMag <= 2)
				{
					A_Jump(256,"Reload");
				}
			}
			WSS1 E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 E random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 3 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 3 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			TNT1 A 0 A_Jump(128, "Attack1", "Attack2");
			WSS1 E 8;
			Goto See;
		Attack3:
			TNT1 A 0
			{
				if(AmmoInMag <= 4)
				{
					A_Jump(256,"Reload");
				}
			}
			WSS1 E 4 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 E random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 3 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 3 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 3 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 3 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WSS1 F 1 BRIGHT FireProjBullets;
			WSS1 E 3 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			TNT1 A 0 A_Jump(128, "Attack1", "Attack2", "Attack3");
			WSS1 E 8;
			Goto See;
			
		Grenade:
			TNT1 A 0 A_JumpIfCloser(500, 1);
			Goto Attack1;
			TNT1 A 0 A_JumpIfCloser(90, "Attack1");
		ThrowGrenade:
			TNT1 A 0; //Grenade sound
			WSS1 E 6
			{
				A_ActiveSound();
				A_FaceTarget(90,45);
			}
			WSS1 E 6;
			WSS1 E 6
			{
				A_FaceTarget(90,45);
				FireProjGren();
			}
			WSS1 E 6;
			Goto See;
		Reload:
			WSS1 H 6;
			WSSR A 8;
			WSSR B 12 A_StartSound("STG/MagOutEmpty", 8, CHANF_OVERLAP, attenuation: 2);
			WSSR C 8;
			WSSR D 8 A_StartSound("STG/MagInEmpty", 8, CHANF_OVERLAP, attenuation: 2);
			WSSR B 12;
			WSSR A 8;
			TNT1 A 0
			{
				A_StartSound("STG/Charge", 8, CHANF_OVERLAP, attenuation: 1.5);
				AmmoInMag = 30;
			}
			WSSR A 8;
			WSS1 H 6;
			Goto See;

		////////////////
		//Pain Logic// 
		////////////////
		Pain:
			TNT1 A 0 A_JumpIf(kickeddown, "KickedPain");
			WSS1 G 6 A_Pain();
			Goto See;
		
		Raise:
			WSS1 LKJIHG 3;
			Goto Spawn;
		Pain.Kick:
			TNT1 A 0
			{
				kickeddown = true;
				A_Pain();
				A_ChangeVelocity(0, 0, 5, CVF_RELATIVE);
			}
			WSSK B 3;
		KickedLoop:
			WSSK B 1 A_CheckFloor("Kicked");
			Loop;
		KickedPain:
			WSSK C 10 A_Pain();
		Kicked:
			TNT1 A 0 A_CheckFloor(1);
			Goto KickedLoop;
			TNT1 A 0;
			WSSK CD 10;
			WSSK D random(25,50);
			WSSK E 10;
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
			WSS1 A 3 A_FaceTarget;
			WSS1 E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), -8, 0, CVF_RELATIVE);
			}
			WSS1 E 24;
		SHRL:
			WSS1 E 1 A_CheckFloor("SHRE");
			WSS1 E 1;
			Loop;
		SHRE:
			WSS1 E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "See", "Missile");
			Goto See;
		SHL:
			WSS1 A 3 A_FaceTarget;
			WSS1 E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), 8, 0, CVF_RELATIVE);
			}
			WSS1 E 24;
		SHLL:
			WSS1 E 1 A_CheckFloor("SHLE");
			WSS1 E 1 A_CheckCeiling("SHLE");
			Loop;
		SHLE:
			WSS1 E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "Roll", "See", "Missile");
			Goto See;
		

		//////////////////////////////////////////////////////////////
		//deaths
		///////////////////////////////////////////////////////////////
		Death:
			TNT1 A 0 A_jumpif(HitHead(),"Death_HeadShot");
			TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
			}
			WSS1 HIJKL 3;
			WSS1 M -1;
			Stop;
		XDeath:
			TNT1 A 0
			{
				A_XScream();
				A_NoBlocking();
			}
			WSS1 HIJKL 3;
			WSS1 M -1;
			Stop;
		/*
		Death.Explosive:
			TNT1 A 0
			{
				A_XScream();
				A_NoBlocking();
				NashGoreGibs.SpawnGibs(self);
			}
			NAZ2 ABC 3;
			NAZ2 DEF 3;
			WSS1 L -1;
			Stop;

		Death.pistol:
			TNT1 A 0 A_jumpif(HitHead(),"Death_HeadShotMinor");
			goto Death;

		Death_HeadShotMinor:
			TNT1 A 0 
			{
				A_giveinventory("BW_HeadDeath",1);
				//A_Scream();
				A_NoBlocking();
				A_Startsound("Gore/HeadShotMin");
			}
			1AZH A 3 spawnBloodSpurt();
			1AZH B 3;
			1AZH C 3;
			1AZH D 3;
			1AZH E -1;
			stop;

		Death_HeadShot:
			TNT1 A 0 
			{
				//A_Scream();
				A_NoBlocking();
				A_Startsound("Gore/HeadShot");
			}
			TNT1 A 0 A_giveinventory("BW_HeadDeath",1);
		Death_HeadShotEnd:
			NAZH AAB 2 spawnBloodSpurt();
			NAZH BCD 3;
			NAZH E -1;
			stop;
			*/
	}
}