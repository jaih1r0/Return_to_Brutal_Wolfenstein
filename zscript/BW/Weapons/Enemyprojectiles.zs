
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