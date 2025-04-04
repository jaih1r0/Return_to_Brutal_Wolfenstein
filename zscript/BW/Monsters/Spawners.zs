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

Class BW_ZombiemanSpawner : BW_Spawner replaces Zombieman
{
	default
	{
		dropItem "BW_BrownGuard_Pistol",Skill_All, 1;
		DropItem "BW_BrownGuard_Rifle", Skill_hard|Skill_Uber, 1;
	}
}

Class BW_ShotgunguySpawner : BW_Spawner replaces ShotgunGuy
{
	Default
	{
		DropItem "BW_BlueGuard_MP40", Skill_All, 2;
		DropItem "BW_BlueGuard_TrenchGun", Skill_normal|Skill_hard, 1;
		DropItem "BW_BlueGuard_TrenchGun", Skill_Uber, 5;
	}
}

Class BW_RiflemanSpawner : BW_Spawner
{
	default
	{
		dropItem "BW_BrownGuard_Rifle",Skill_All, 1;
	}
}
