
Class BW_EnemyLugerBullets : BW_LugerBullets
{
    default
    {
        speed 50;
		BW_Projectile.projectiledmg 12;
    }
}

Class BW_EnemyM1911Bullets : BW_M1911Bullets
{
    default
    {
        speed 50;
		BW_Projectile.projectiledmg 17;
    }
}


Class BW_EnemyMP40Bullets : BW_MP40Bullets
{
    default
    {
		BW_Projectile.projectiledmg 12;
        speed 50;
    }
}

Class BW_EnemyM1ThompsonBullets : BW_M1ThompsonBullets
{
    default
    {
		BW_Projectile.projectiledmg 17;
        speed 50;
    }
}

Class BW_EnemySTG44Bullets : BW_STG44Bullets
{
    default
    {
		BW_Projectile.projectiledmg 20;
        speed 50;
    }
}

Class BW_EnemyKar98Bullets : BW_Kar98Bullets
{
    default
    {
		BW_Projectile.projectiledmg 80;
        speed 50;
    }
}

Class BW_Enemy12GABullets : BW_12GABullets
{
    default
    {
		BW_Projectile.projectiledmg 11;
        speed 50;
    }
}

Class BW_EnemyMGBullets : BW_MGBullets
{
    default
    {
		BW_Projectile.projectiledmg 17;
        speed 50;
    }
}

Class BW_MutantSuperBullet : BW_EnemyLugerBullets
{
	default
	{
		BW_Projectile.projectiledmg 50;
		speed 50;
        BW_Projectile.TracerLightColor 0xCC6CE7;
	}
}

Class BW_MutantCleaver : Actor
{
	default
	{
		Projectile;
		speed 6;
		damagefunction damagebase;
		renderstyle "Normal";
		BounceType "Doom";
		BounceFactor 0.5;
		WallBounceFactor 0.5;
		BounceCount 3;
		+NOGRAVITY;
		+USEBOUNCESTATE
		radius 3;
		height 6;
		Gravity 1.0;
	}
	
	int damagebase;
	
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		damagebase = 15;
	}
	
	States
	{
		Spawn:
			CLVR ABCDEFGH 3;
			Loop;
		Bounce:
			CLVR # 1
			{
				A_ChangeVelocity(0,0,1, CVF_RELATIVE);
				SpawnPuff("Bulletpuff", pos, angle, 0, 0, PF_HITTHING);
				A_StartSound("Axe/HitWall", volume: 0.25);
				bNoGravity = false;
				damagebase = damagebase/3;
			}
			Goto Spawn;
		Death:
			CLVR A 0
			{
				if(random(1,10))
				{
					bNoGravity = false;
				}
				A_StartSound("Axe/HitWall", volume: 0.25);
				SpawnPuff("Bulletpuff", pos, angle, 0, 0, PF_HITTHING);
			}
			CLVR A 70;
			CLVR A 0 A_SetRoll(90);
			CLVR A -1;
			Stop;
		XDeath:
			CLVR A 0
			{
				bNoGravity = false;
				A_StartSound("Axe/Hit");
			}
			CLVR A 70;
			CLVR A 0 A_SetRoll(90);
			CLVR A -1;
			Stop;
	}
}