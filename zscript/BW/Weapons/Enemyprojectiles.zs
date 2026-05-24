
Class BW_EnemyLugerBullets : BW_LugerBullets
{
    default
    {
        speed 50;
    }
}

Class BW_EnemyM1911Bullets : BW_M1911Bullets
{
    default
    {
        speed 50;
    }
}


Class BW_EnemyMP40Bullets : BW_MP40Bullets
{
    default
    {
        speed 50;
    }
}

Class BW_EnemyM1ThompsonBullets : BW_M1ThompsonBullets
{
    default
    {
        speed 50;
    }
}

Class BW_EnemySTG44Bullets : BW_STG44Bullets
{
    default
    {
        speed 50;
    }
}

Class BW_EnemyKar98Bullets : BW_Kar98Bullets
{
    default
    {
        speed 50;
    }
}

Class BW_Enemy12GABullets : BW_12GABullets
{
    default
    {
        speed 50;
    }
}

Class BW_EnemyMGBullets : BW_MGBullets
{
    default
    {
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
		damage 5;
		speed 12;
		renderstyle "Normal";
		BounceType "Doom";
		BounceFactor 0.5;
		WallBounceFactor 0.5;
		+NOGRAVITY;
		+USEBOUNCESTATE
		radius 3;
		height 6;
		Gravity 1.0;
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
				A_StartSound("Axe/HitWall");
				bNoGravity = false;
			}
			Goto Spawn;
		Death:
			CLVR A 0
			{
				if(random(1,10))
				{
					bNoGravity = false;
				}
				A_StartSound("Axe/HitWall");
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