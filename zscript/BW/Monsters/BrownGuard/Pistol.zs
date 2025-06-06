Class BW_BrownGuard_Pistol : BW_MonsterBase //replaces Zombieman //[Pop] replace is temporary until spawners are implemented. Do we want to do spawner injection?
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
			
			DropItem "BW_PistolAmmo", 255, 8;
			DropItem "BW_Luger", 100, 1;
			
			Obituary "$OB_ZOMBIE";
		}
		
		int HowManyGrenadesHaveIThrown;
		
		void FireProjBullets()
		{
			A_Light(2);
			//A_SpawnProjectile("BW_LugerBullets", 32, 0, (frandom(3,-3)), CMF_AIMDIRECTION, self.pitch + (frandom(3,-3)));
			BW_FireMonsterBullet("BW_EnemyLugerBullets");
			A_StartSound("Luger/Fire", CHAN_AUTO, CHANF_OVERLAP);
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
				
				return A_Jump(256, "Attack1");
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
			TNT1 A 0 A_JumpIf(kickeddown, "KickedPain");
			WBPN G 6 A_Pain();
			Goto See;
		
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
		
		///////////////////////////////////////////////////////////////
		//
		//	Deaths
		//
		//////////////////////////////////////////////////////////////
		Death:
			TNT1 A 0 A_jumpif(HitHead(),"Death_HeadShot");
			TNT1 A 0 A_jumpif(HitRightArm(),"Death_RightArm");
			TNT1 A 0 A_jumpif(HitRightFoot(),"Death_RightFoot");
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
		
		Death.Explosive:
			TNT1 A 0
			{
				A_giveinventory("BW_HeadDeath",1);
				A_Scream();
				A_NoBlocking();
				BW_SpawnGib("BW_BGArm",(pos + (0,0,30)),frandom(-5.5,5.0),frandom(5.0,5.0),4);
				BW_SpawnGib("BW_BGLEG",(pos + (0,0,12)),frandom(-5.5,5.0),frandom(5.0,5.0),4);
				BW_SpawnGib("BW_BGHead",(pos + (0,0,35)),frandom(-5.5,5.0),frandom(5.0,5.0),4);
				vel.z += 3;
				NashGoreGibs.SpawnGibs(self);
			}
			ID13 ABC 2;
			ID13 EF 2;
			ID13 G -1;
			stop;

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
				//A_SpawnitemEx("BW_BGArm",0,0,30,frandom(-3,3),frandom(-3,3),frandom(-1,3.5));
				A_Startsound("Gore/LimbGib");
				BW_SpawnGib("BW_BGArm",(pos + (0,0,30)),frandom(-2.5,2.5),frandom(1.5,3.0),2);
				spawnBloodSpurt(zofs:25);
				A_giveinventory("BW_ArmDeath",1);	//dont random flip
			}
			GSUB A 3;
			GSUB B 3;
			GSUB CD 3;
			GSUB E -1;
			stop;

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

		Death_HeadShotMinor:
			TNT1 A 0 
			{
				A_giveinventory("BW_HeadDeath",1);
				//A_Scream();
				A_NoBlocking(); //
				A_Startsound("Gore/HeadShotMin");
				if(!random(0,1)) //50%
					BW_SpawnGib("BW_EnemyHelmethDrop",(pos + (0,0,headheight)),frandom(-3.0,3.0),frandom(-3.0,3.0),frandom(-1.0,4.0));
					//A_SpawnitemEx("BW_EnemyHelmethDrop",0,0,headheight,frandom(-3,3),frandom(-3,3),frandom(-1,4));
			}
			ZMA1 A 3 spawnBloodSpurt();
			ZMA1 B 3;
			ZMA1 C 3;
			ZMA1 D 3;
			ZMA1 E -1;
			stop;

		Death_HeadShot:
			TNT1 A 0 
			{
				//A_Scream();
				A_NoBlocking();
				A_Startsound("Gore/HeadShot");
				BW_SpawnGib("BW_BGHead",(pos + (0,0,headheight)),frandom(-3.0,3.0),frandom(3.0,3.0),frandom(-1.0,4.0));
			}
			TNT1 A 0 A_jump(128,"Death_HeadShotEnd");
			TNT1 A 0 A_giveinventory("BW_HeadDeath",1);
			ZMAD F 4 spawnBloodSpurt();
			ZMAD GH 4;
			ZMAD F 4 spawnBloodSpurt();
			ZMAD GH 4;
			ZMAD F 4 spawnBloodSpurt();
			ZMAD GH 4;
			ZMAD F 4 spawnBloodSpurt();
			ZMAD GH 4;
		Death_HeadShotEnd:
			TNT1 A 0 spawnBloodSpurt(10);
			ZMAD ACCCD 3;
			ZMAD E -1;
			stop;
		
	}
}