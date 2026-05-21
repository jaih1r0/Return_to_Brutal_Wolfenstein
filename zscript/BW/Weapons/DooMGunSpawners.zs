//BW_Spawner
/*
	enum BW_Skills {
        Skill_baby = 1, Skill_easy = 2,
        Skill_normal = 4,
        Skill_hard = 8,
        Skill_Uber = 16,
		Skill_All = Skill_baby|Skill_easy|Skill_normal|Skill_hard|Skill_Uber
    }
	
	multiple skills can be selected for a single monster by using | (bitwise OR) or the sum of
	the numbers defined above, for example:
	24 equals Skill_hard|Skill_Uber
*/

Class DooM_PistolSpawner : BW_Spawner replaces Pistol
{
	default
	{
		dropItem "BW_Luger", Skill_All, 1;
		dropItem "BW_M1911", Skill_All, 1;
	}
}

Class DooM_ShotgunSpawner : BW_Spawner replaces Shotgun
{
	default
	{
		dropItem "BW_Trenchgun", Skill_All, 3;
		dropItem "BW_Kar98k", Skill_All, 2;
		dropItem "BW_MP40", Skill_All, 1;
		dropItem "BW_STG44", Skill_All, 1;
		dropItem "BW_M1Thompson", Skill_All, 1;
	}
}

Class DooM_SuperShotgunSpawner : BW_Spawner replaces SuperShotgun
{
	default
	{
		dropItem "BW_SSG", Skill_All, 2;
		dropItem "BW_MP40", Skill_All, 1;
		dropItem "BW_STG44", Skill_All, 1;
		dropItem "BW_M1Thompson", Skill_All, 1;
	}
}

Class DooM_ChaingunSpawner : BW_Spawner replaces Chaingun
{
	default
	{
		dropItem "BW_MP40", Skill_All, 1;
		dropItem "BW_STG44", Skill_All, 1;
		dropItem "BW_M1Thompson", Skill_All, 1;
		dropItem "BW_MG42", Skill_All, 2;
		dropItem "BW_Chaingun", Skill_All, 2;
	}
}

Class DooM_RocketLauncherSpawner : BW_Spawner replaces RocketLauncher
{
	default
	{
		dropItem "BW_Panzerschreck", Skill_All, 1;
	}
}

Class DooM_PlasmaRifleSpawner : BW_Spawner replaces PlasmaRifle
{
	default
	{
		dropItem "BW_Flamethrower", Skill_All, 2;
		dropItem "BW_Tesla", Skill_All, 2;
	}
}

Class DooM_BFGSpawner : BW_Spawner replaces BFG9000
{
	default
	{
		dropItem "BW_Leichenfaust", Skill_All, 1;
	}
}