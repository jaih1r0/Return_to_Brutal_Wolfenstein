Class BW_WhiteOfficer_M1911 : BW_MonsterBase //replaces Zombieman //[Pop] replace is temporary until spawners are implemented. Do we want to do spawner injection?
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
			
			BW_MonsterBase.AttackRange 2000; //32 Dmu (1 meter) * 50 (55 yards effective range of Luger)
			BW_MonsterBase.CanIRoll true;
			SeeSound "Nazi/Generic/sight";
			PainSound "Nazi/Generic/pain";
			DeathSound "Nazi/Generic/death";
			ActiveSound "Nazi/Generic/sight";
			
			DropItem "BW_USAPistolAmmo", 255, 8;
			DropItem "BW_M1911", 100, 1;
			
			Obituary "$OB_ZOMBIE";
		}
		
		int HowManyGrenadesHaveIThrown;
		
		void FireProjBullets()
		{
			A_Light(2);
			//A_SpawnProjectile("BW_LugerBullets", 32, 0, (frandom(3,-3)), CMF_AIMDIRECTION, self.pitch + (frandom(3,-3)));
			BW_FireMonsterBullet("BW_EnemyM1911Bullets");
			A_StartSound("M1911/Fire", CHAN_AUTO, CHANF_OVERLAP);
			A_StartSound("M1911/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 0.8);
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
			AmmoInMag = random(4,7); //M1911
		}
		
		override void Tick()
		{
			Super.Tick();
		}
		
		States
		{
		
		Spawn:
			WTGA Z 1;
			TNT1 A 0;
		Stand:
			WTGA ZZZZ 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			WTGA ZZZZ 5
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
			WTGA AAAABBBB 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			WTGA CCCCDDDD 1 AI_SmartChase();
			TNT1 A 0 A_Fallback();
			Loop;
		FallBack:
			TNT1 A 0 A_Jump(255, "Fallback1", "Roll", "See");
		FallBack1:
			WTGA D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WTGA C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WTGA B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WTGA A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WTGA D 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WTGA C 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WTGA B 3 {
				A_FaceTarget(10);
				A_Recoil(2);
				return A_Jump(64,"Missile");
			}
			WTGA A 3 {
				A_FaceTarget(10);
				A_Recoil(2);
			}
			Goto Missile;
		
		////////////////
		//Attack Logic// 
		////////////////
		Melee:
			WTGA A 1 A_CheckLOF(1);
			Goto See;
			WTGA A 1 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WTGA C random(10,20);
			WTGA H 3
			{
				//Melee attack
				A_StartSound("Fists/Swing");
				A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
			}
			WTGA H 3;
			WTGA E 6;
			Goto See;
		Missile:
			TNT1 A 0 A_JumpIf(AttackDelay > 3, "See");
			WTGA E 1 A_CheckLOFRanged("AttackHandler", "Roll");
			WTGA E 2 A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
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
		
		UncrouchAttack1:
			WTGC BA 2;
			WTGA E 2;
		Attack1:
			TNT1 A 0
			{
				if(AmmoInMag <= 0)
				{
					A_Jump(256,"Reload");
				}
			}
			WTGA F random(5,20) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WTGA G 1 BRIGHT FireProjBullets;
			WTGA F 2;
			TNT1 A 0 A_Jump(128, "Attack1");
			WTGA E 8;
			Goto See;
		Attack2:
			TNT1 A 0
			{
				if(AmmoInMag <= 0)
				{
					A_Jump(256,"Reload");
				}
			}
			WTGA AE 2;
			WTGC AB 4;
		Attack2Loop:
			TNT1 A 0
			{
				if(AmmoInMag <= 0)
				{
					A_Jump(256,"Reload");
				}
			}
			WTGC C random(5,12) A_FaceTarget(45, 45, 0, 0, FAF_MIDDLE);
			WTGC D 1 BRIGHT FireProjBullets;
			WTGC C 2;
			TNT1 A 0 A_Jump(164, "Attack2Loop", "UncrouchAttack1");
			WTGC BA 4;
			WTGA EA 2;
			Goto See;
			
		Grenade:
			TNT1 A 0 A_JumpIfCloser(500, 1);
			Goto Attack1;
			TNT1 A 0 A_JumpIfCloser(90, "Attack1");
		ThrowGrenade:
			TNT1 A 0; //Grenade sound
			WTGG A 6
			{
				A_ActiveSound();
				A_FaceTarget(90,45);
			}
			WTGG B 6;
			WTGG C 6
			{
				A_FaceTarget(90,45);
				FireProjGren();
			}
			WTGG D 6;
			Goto See;
		Reload:
			WTGA E 6;
			WTGR A 6;
			WTGR B 6 A_StartSound("M1911/MagOut", 8, CHANF_OVERLAP, attenuation: 2);
			WTGR C 6;
			WTGR B 6;
			WTGR A 6 A_StartSound("M1911/MagIn", 8, CHANF_OVERLAP, attenuation: 2);
			WTGR C 2;
			TNT1 A 0
			{
				A_StartSound("M1911/Charge", 8, CHANF_OVERLAP, attenuation: 1.5);
				AmmoInMag = 8;
			}
			WTGR A 4;
			Goto See;

		////////////////
		//Pain Logic// 
		////////////////
		Pain:
			TNT1 A 0 A_JumpIf(kickeddown, "KickedPain");
			WTGA H 6 A_Pain();
			Goto See;
		
		Raise:
			WTGA NMLKJIH 3;
			Goto Spawn;
		Pain.Kick:
			TNT1 A 0
			{
				kickeddown = true;
				A_Pain();
				A_ChangeVelocity(0, 0, 5, CVF_RELATIVE);
			}
			WTGK A 3;
		KickedLoop:
			WTGK A 1 A_CheckFloor("Kicked");
			Loop;
		KickedPain:
			WTGK B 10 A_Pain();
		Kicked:
			TNT1 A 0 A_CheckFloor(1);
			Goto KickedLoop;
			TNT1 A 0;
			WTGK BC 10;
			WTGK C random(25,50);
			WTGC A 10;
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
			WTGA A 3 A_FaceTarget;
			WTGA E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), -8, 0, CVF_RELATIVE);
			}
			WTGA E 24;
		SHRL:
			WTGA E 1 A_CheckFloor("SHRE");
			WTGA E 1;
			Loop;
		SHRE:
			WTGA E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "See", "Missile");
			Goto See;
		SHL:
			WTGA A 3 A_FaceTarget;
			WTGA E 3
			{
				A_FaceTarget();
				A_ChangeVelocity(frandom(5,-5), 8, 0, CVF_RELATIVE);
			}
			WTGA E 24;
		SHLL:
			WTGA E 1 A_CheckFloor("SHLE");
			WTGA E 1 A_CheckCeiling("SHLE");
			Loop;
		SHLE:
			WTGA E 1 A_FaceTarget;
			TNT1 A 0 A_Stop();
			TNT1 A 0 A_Jump(256, "Roll", "See", "Missile");
			Goto See;
		
		///////////////////////////////////////////////////////////////
		//
		//	Deaths
		//
		//////////////////////////////////////////////////////////////
		Death:
			TNT1 A 0 A_jumpif(HitHead(),"Death_HeadShot");
			TNT1 A 0 A_jumpif(HitRightArm(),"Death_RightArm");
			//TNT1 A 0 A_jumpif(HitRightFoot(),"Death_RightFoot");
			TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
			}
			WTGA IJKLM 3;
			WTGA N -1;
			Stop;
		XDeath:
			TNT1 A 0
			{
				A_XScream();
				A_NoBlocking();
			}
			WTGA IJKLM 3;
			WTGA N -1;
			Stop;
		
		Death.Explosive:
			TNT1 A 0
			{
				A_giveinventory("BW_HeadDeath",1);
				A_Scream();
				A_NoBlocking();
				BW_SpawnGib("BW_WOArm",(pos + (0,0,30)),frandom(-5.5,5.0),frandom(5.0,5.0),4);
				BW_SpawnGib("BW_WOLEG",(pos + (0,0,12)),frandom(-5.5,5.0),frandom(5.0,5.0),4);
				BW_SpawnGib("BW_WOHead",(pos + (0,0,35)),frandom(-5.5,5.0),frandom(5.0,5.0),4);
				vel.z += 3;
				NashGoreGibs.SpawnGibs(self);
			}
			WTDD ABCE 2;
			WTDD F -1;
			stop;
		/*
		Death.Knife:
			TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
			}
			GUCC A 3;
			GUCC B 3;
			GUCC CD 3;
			GUCC E -1;
			stop;
		*/
		Death.Melee:
		Death.pistol:
			TNT1 A 0 A_jumpif(HitHead(),"Death_HeadShotMinor");
			goto death;
		Death.Rifle:
			TNT1 A 0 A_jumpif(HitHead(),"Death_HeadShot");
			goto death;

		Death_RightArm:
			TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
				A_Startsound("Gore/LimbGib");
				spawnBloodSpurt(zofs:25);
				A_giveinventory("BW_ArmDeath",1);	//dont random flip
			}
			WTDC ABCD 3;
			WTDC E -1;
			stop;
		/*
		Death_RightFoot:
			TNT1 A 0
			{
				A_Scream();
				A_NoBlocking();
				//A_SpawnitemEx("BW_BGLeg",0,0,12,frandom(-3,3),frandom(-3,3),frandom(-1,3.5));
				A_Startsound("Gore/LimbGib");
				BW_SpawnGib("BW_BGLEG",(pos + (0,0,12)),frandom(-5.0,5.0),frandom(2.0,4.0),4.5);
				spawnBloodSpurt(zofs:10);
				A_giveinventory("BW_LegDeath",1); //dont random flip
			}
			SALE A 3;
			SALE B 3;
			SALE CD 3;
			SALE E -1;
			stop;
		*/
		Death_HeadShotMinor:
			TNT1 A 0 
			{
				A_giveinventory("BW_HeadDeath",1);
				//A_Scream();
				A_NoBlocking(); //
				A_Startsound("Gore/HeadShotMin");
			}
			WTDB A 3 spawnBloodSpurt();
			WTDB BCD 3;
			WTDB E -1;
			stop;

		Death_HeadShot:
			TNT1 A 0 
			{
				//A_Scream();
				A_NoBlocking();
				A_Startsound("Gore/HeadShot");
				BW_SpawnGib("BW_WOHead",(pos + (0,0,headheight)),frandom(-3.0,3.0),frandom(3.0,3.0),frandom(-1.0,4.0));
			}
			TNT1 A 0 A_giveinventory("BW_HeadDeath",1);
			TNT1 A 0 spawnBloodSpurt(10);
			WTDA AB 3;
			WTDA CCC 3 spawnBloodSpurt();
			WTDA DEF 3;
			WTDA E -1;
			stop;
		
	}
}