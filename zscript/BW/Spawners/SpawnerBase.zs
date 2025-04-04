/*/////////////////////////////////////////////////////
//
//  base class for spawners
//
////////////////////////////////////////////////////*/

//default gzdoom random spawner, but 'probability' is used as a skill selector for spawn
Class BW_Spawner : RandomSpawner
{
    /*
    default
    {
        dropitem "thing",Skill,weight;
    }
    */
    
    //enum with the skill names, to easier reading
    enum BW_Skills {
        Skill_Baby 		= 	1,
        Skill_Easy 		= 	2,
        Skill_Normal 	= 	4,
        Skill_Hard 		= 	8,
        Skill_Uber 		= 	16,
		Skill_All		= 	Skill_baby|Skill_easy|Skill_normal|Skill_hard|Skill_Uber
    }
    
    int getSkill()
    {
        return G_SkillPropertyInt(SKILLP_SpawnFilter);
    }

    override Name ChooseSpawn()
	{
		DropItem di;   // di will be our drop item list iterator
		DropItem drop; // while drop stays as the reference point.
		int n = 0;
		bool nomonsters = sv_nomonsters || level.nomonsters;

        int skill = getSkill();

		drop = di = GetDropItems();
		if (di != null)
		{
			while (di != null)
			{
				bool shouldSkip = !(di.Probability & skill == skill) || (di.Name == 'None') || (nomonsters && IsMonster(di));
				//console.printf("[skill: %d](%s)di.prob: %d (chance: %d) (shouldskip:%s)",skill,di.name,di.probability,(di.probability & skill),(shouldSkip ? "true":"false"));
				if (!shouldSkip)
				{
					int amt = di.Amount;
					if (amt < 0) amt = 1; // default value is -1, we need a positive value.
					n += amt; // this is how we can weight the list.
				}
                

				di = di.Next;
			}
			if (n == 0)
			{ // Nothing left to spawn. They must have all been monsters, and monsters are disabled.
				return 'None';
			}
			// Then we reset the iterator to the start position...
			di = drop;
			// Take a random number...
			n = random[randomspawn](0, n-1);
			// And iterate in the array up to the random number chosen.
			while (n > -1 && di != null)
			{
				if (di.Name != 'None' &&
					(!nomonsters || !IsMonster(di)) &&
                    (di.Probability & skill == skill))
				{
					int amt = di.Amount;
					if (amt < 0) amt = 1;
					n -= amt;
					if ((di.Next != null) && (n > -1))
						di = di.Next;
					else
						n = -1;
				}
				else
				{
					di = di.Next;
				}
			}
			if (di == null)
			{
				return 'Unknown';
			}
			else
			{
				return di.Name;
			}
		}
		else
		{
			return 'None';
		}
	}

}

