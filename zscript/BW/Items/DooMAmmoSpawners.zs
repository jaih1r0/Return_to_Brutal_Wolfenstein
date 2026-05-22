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

Class DooM_ClipSpawner : BW_Spawner replaces Clip
{
	default
	{
		dropItem "BW_PistolAmmo", Skill_All, 2;
		dropItem "BW_USAPistolAmmo", Skill_All, 2;
		dropItem "BW_STGAmmo", Skill_All, 1;
	}
}

Class DooM_ClipBoxSpawner : BW_Spawner replaces ClipBox
{
	default
	{
		dropItem "BW_PistolAmmo", Skill_All, 1;
		dropItem "BW_USAPistolAmmo", Skill_All, 1;
		dropItem "BW_STGAmmo", Skill_All, 1;
		dropItem "BW_MGAmmo", Skill_All, 3;
		dropItem "BW_ThreeNades", Skill_All, 1;
	}
}

Class DooM_ShellSpawner : BW_Spawner replaces Shell
{
	default
	{
		dropItem "BW_ShotgunAmmo", Skill_All, 1;
		dropItem "BW_KarAmmo", Skill_All, 1;
	}
}

Class DooM_ShellBoxSpawner : BW_Spawner replaces ShellBox
{
	default
	{
		dropItem "BW_ShotgunAmmo", Skill_All, 1;
		dropItem "BW_KarAmmo", Skill_All, 1;
	}
}

Class DooM_CellSpawner : BW_Spawner replaces Cell
{
	default
	{
		dropItem "BW_GasCan", Skill_All, 2;
		dropItem "BW_TeslaCell", Skill_All, 2;
		dropItem "BW_LFAmmo", Skill_All, 1;
	}
}

Class DooM_CellPackSpawner : BW_Spawner replaces CellPack
{
	default
	{
		dropItem "BW_GasCan", Skill_All, 1;
		dropItem "BW_TeslaCell", Skill_All, 1;
		dropItem "BW_LFAmmo", Skill_All, 2;
	}
}