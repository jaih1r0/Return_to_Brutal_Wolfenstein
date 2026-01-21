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

Class DooM_ZombiemanSpawner : BW_Spawner replaces Zombieman
{
	default
	{
		dropItem "BW_BrownGuard_Pistol",Skill_All, 1;
		DropItem "BW_BrownGuard_Rifle", Skill_All, 1;
	}
}

Class DooM_ShotgunguySpawner : BW_Spawner replaces Shotgunguy
{
	Default
	{
		DropItem "BW_BlueGuard_MP40", Skill_All, 2;
		DropItem "BW_BlueGuard_TrenchGun", Skill_normal|Skill_hard, 1;
		DropItem "BW_BlueGuard_M1Thompson", Skill_normal|Skill_hard, 1;
		DropItem "BW_BlueGuard_TrenchGun", Skill_Uber, 5;
	}
}

Class DooM_DoomImpSpawner : BW_Spawner replaces DoomImp
{
	default
	{
		dropItem "BW_Mutant",Skill_All, 1;
		DropItem "BW_Imp", Skill_All, 1;
	}
}

Class DooM_ChainGunGuySpawner : BW_Spawner replaces Chaingunguy
{
	default
	{
		dropItem "BW_BlackGuard_STG44",Skill_All, 1;
	}
}

Class DooM_DemonSpawner : BW_Spawner replaces Demon
{
	default
	{
		dropItem "BW_Dog",Skill_All, 1;
		DropItem "BW_Pinky", Skill_All, 1;
	}
}

Class DooM_CacodemonSpawner : BW_Spawner replaces Cacodemon
{
	default
	{
		DropItem "BW_Caco", Skill_All, 1;
	}
}

Class DooM_LostSoulSpawner : BW_Spawner replaces LostSoul
{
	default
	{
		DropItem "BW_LostSoul", Skill_All, 1;
	}
}

Class DooM_BaronOfHellSpawner : BW_Spawner replaces BaronOfHell
{
	default
	{
		DropItem "BW_Baron", Skill_All, 1;
	}
}

Class DooM_ArchvileSpawner : BW_Spawner replaces Archvile
{
	default
	{
		DropItem "BW_Archvile", Skill_All, 1;
	}
}