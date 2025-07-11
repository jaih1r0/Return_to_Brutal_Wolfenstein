//dummy definitions, just so they spawn in map flor19

Class BW_Archvile : BW_MonsterBase //1381
{
    Default
	{
		Health 700;
		Radius 20;
		Height 56;
		Mass 500;
		Speed 15;
		PainChance 10;
		Monster;
		MaxTargetRange 896;
		+QUICKTORETALIATE 
		+FLOORCLIP 
		+NOTARGET
		SeeSound "vile/sight";
		PainSound "vile/pain";
		DeathSound "vile/death";
		ActiveSound "vile/active";
		MeleeSound "vile/stop";
		Obituary "$OB_VILE";
		Tag "$FN_ARCH";
        BW_MonsterBase.headheight 38;
		BW_MonsterBase.feetheight 18;
		BW_MonsterBase.HeadShotMult 2.0;
		BW_MonsterBase.HasHeadshot true;
	}
	States
	{
        Spawn:
            VILE AB 10 A_Look;
            Loop;
        See:
            VILE AABBCCDDEEFF 2 A_VileChase;
            Loop;
        Missile:
            VILE G 0 BRIGHT A_VileStart;
            VILE G 10 BRIGHT A_FaceTarget;
            VILE H 8 BRIGHT A_VileTarget;
            VILE IJKLMN 8 BRIGHT A_FaceTarget;
            VILE O 8 BRIGHT A_VileAttack;
            VILE P 20 BRIGHT;
            Goto See;
        Heal:
            VILE [\] 10 BRIGHT;
            Goto See;
        Pain:
            VILE Q 5;
            VILE Q 5 A_Pain;
            Goto See;
        Death:
            VILE Q 7;
            VILE R 7 A_Scream;
            VILE S 7 A_NoBlocking;
            VILE TUVWXY 7;
            VILE Z -1;
            Stop;
	}
}

Class BW_Baron : BW_MonsterBase //1383
{
    Default
	{
		Health 1000;
		Radius 24;
		Height 64;
		Mass 1000;
		Speed 8;
		PainChance 50;
        PainChance "Nuts",255;
		Monster;
		+FLOORCLIP
		+BOSSDEATH
		+E1M8BOSS
		SeeSound "baron/sight";
		PainSound "baron/pain";
		DeathSound "baron/death";
		ActiveSound "baron/active";
		Obituary "$OB_BARON";
		HitObituary "$OB_BARONHIT";
		Tag "$FN_BARON";
        bloodcolor "DarkGreen";
        BW_MonsterBase.headheight 48;
		BW_MonsterBase.feetheight 36;
		BW_MonsterBase.HeadShotMult 2.0;
		BW_MonsterBase.HasHeadshot true;
        BW_MonsterBase.nuts true;
	}
	States
	{
        Spawn:
            BOSS AB 10 A_Look ;
            Loop;
        See:
            BOSS AABBCCDD 3 A_Chase;
            Loop;
        Melee:
        Missile:
            BOSS EF 8 A_FaceTarget;
            BOSS G 8 A_BruisAttack;
            Goto See;

        Pain:
            BOSS H  2;
            BOSS H  2 A_Pain;
            Goto See;
        Death:
            BOSS I  8;
            BOSS J  8 A_Scream;
            BOSS K  8;
            BOSS L  8 A_NoBlocking;
            BOSS MN 8;
            BOSS O -1 A_BossDeath;
            Stop;
        Raise:
            BOSS O 8;
            BOSS NMLKJI  8;
            Goto See;
        Pain.Nuts:
            TNT1 A 0 A_pain();
            BNRJ AC 8;
            TNT1 A 0 A_pain();
            BNRJ AC 8;
            TNT1 A 0 A_pain();
            BNRJ AC 8;
            TNT1 A 0 A_pain();
            BNRJ AC 8;
            goto see;
	}
}

Class BW_Caco : BW_MonsterBase //1386
{
    Default
	{
		Health 400;
		Radius 31;
		Height 56;
		Mass 400;
		Speed 8;
		PainChance 128;
		Monster;
		+FLOAT +NOGRAVITY
		SeeSound "caco/sight";
		PainSound "caco/pain";
		DeathSound "caco/death";
		ActiveSound "caco/active";
		Obituary "$OB_CACO";
		HitObituary "$OB_CACOHIT";
		Tag "$FN_CACO";
        bloodcolor "Blue";
        BW_MonsterBase.headheight 38;
		BW_MonsterBase.feetheight 18;
		BW_MonsterBase.HeadShotMult 2.0;
		BW_MonsterBase.HasHeadshot true;
	}
	States
	{
        Spawn:
            HEAD A 10 A_Look;
            Loop;
        See:
            HEAD A 3 A_Chase;
            Loop;
        Missile:
            HEAD B 5 A_FaceTarget;
            HEAD C 5 A_FaceTarget;
            HEAD D 5 BRIGHT A_HeadAttack;
            Goto See;
        Pain:
            HEAD E 3;
            HEAD E 3 A_Pain;
            HEAD F 6;
            Goto See;
        Death:
            HEAD G 8;
            HEAD H 8 A_Scream;
            HEAD I 8;
            HEAD J 8;
            HEAD K 8 A_NoBlocking;
            HEAD L -1 A_SetFloorClip;
            Stop;
        Raise:
            HEAD L 8 A_UnSetFloorClip;
            HEAD KJIHG 8;
            Goto See;
	}
}

Class BW_LostSoul : BW_MonsterBase//1384
{
    Default
	{
		Health 50;
		Radius 16;
		Height 32;
		Mass 50;
		Speed 8;
		Damage 3;
		PainChance 256;
		Monster;
		+FLOAT +NOGRAVITY +MISSILEMORE +DONTFALL +NOICEDEATH +ZDOOMTRANS +RETARGETAFTERSLAM
		AttackSound "skull/melee";
		PainSound "skull/pain";
		DeathSound "skull/death";
		ActiveSound "skull/active";
		//RenderStyle "SoulTrans";
		Obituary "$OB_SKULL";
		Tag "$FN_LOST";
        -countkill;
        +noblood;
        BW_MonsterBase.headheight 38;
		BW_MonsterBase.feetheight 18;
		BW_MonsterBase.HeadShotMult 2.0;
		BW_MonsterBase.HasHeadshot false;
	}
	States
	{
        Spawn:
            SKUL AB 10 BRIGHT A_Look;
            Loop;
        See:
            SKUL AB 6 BRIGHT A_Chase;
            Loop;
        Missile:
            SKUL C 10 BRIGHT A_FaceTarget;
            SKUL D 4 BRIGHT A_SkullAttack;
            SKUL CD 4 BRIGHT;
            Goto Missile+2;
        Pain:
            SKUL E 3 BRIGHT;
            SKUL E 3 BRIGHT A_Pain;
            Goto See;
        Death:
            SKUL F 6 BRIGHT;
            SKUL G 6 BRIGHT A_Scream;
            SKUL H 6 BRIGHT;
            SKUL I 6 BRIGHT A_NoBlocking;
            SKUL J 6;
            SKUL K 6;
            Stop;
	}
}

Class BW_Pinky : BW_MonsterBase //1388
{
    Default
	{
		Health 150;
		PainChance 180;
		Speed 10;
		Radius 30;
		Height 56;
		Mass 400;
		Monster;
		+FLOORCLIP
		SeeSound "demon/sight";
		AttackSound "demon/melee";
		PainSound "demon/pain";
		DeathSound "demon/death";
		ActiveSound "demon/active";
		Obituary "$OB_DEMONHIT";
		Tag "$FN_DEMON";
        BW_MonsterBase.headheight 38;
		BW_MonsterBase.feetheight 18;
		BW_MonsterBase.HeadShotMult 2.0;
		BW_MonsterBase.HasHeadshot true;
	}
	States
	{
        Spawn:
            SARG AB 10 A_Look;
            Loop;
        See:
            SARG AABBCCDD 2 Fast A_Chase;
            Loop;
        Melee:
            SARG EF 8 Fast A_FaceTarget;
            SARG G 8 Fast A_SargAttack;
            Goto See;
        Pain:
            SARG H 2 Fast;
            SARG H 2 Fast A_Pain;
            Goto See;
        Death:
            SARG I 8;
            SARG J 8 A_Scream;
            SARG K 4;
            SARG L 4 A_NoBlocking;
            SARG M 4;
            SARG N -1;
            Stop;
        Raise:
            SARG N 5;
            SARG MLKJI 5;
            Goto See;
	}
}
