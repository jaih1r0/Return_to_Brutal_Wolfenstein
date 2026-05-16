//
//	if we move to newer uzdoom, this can be removed in favour of AllEpisodes/AllSkills global vars
//

Class BWMenuStaticInfo : StaticEventhandler
{
	Array<BWSkillInfo> _skillInfo;
	array<BWEpisodeInfo> episinfo;
	override void onregister()
	{
		//this actually works on uzdoom (but not on 4.14.3, gotta wait for 5.0)
		/*console.printf("===== EPISODES ======");
		for(int i = 0; i < AllEpisodes.size(); i++)
		{
			console.printf("[%d] %s [map: %s]",i,AllEpisodes[i].mEpisodeName,AllEpisodes[i].mEpisodeMap);
		}
		
		console.printf("===== Skills ======");
		for(int i = 0; i < AllSkills.size(); i++)
		{
			console.printf("[%d] skill: %s",i,AllSkills[i].SkillName);
		}*/
		
		
		_skillInfo.clear();
		episinfo.clear();
		
		
		
		array<int> lumpssearch;
		//first get all the lumps
		for(int lump = -1; (lump = Wads.FindLump("MAPINFO", lump + 1,Wads.GlobalNamespace)) != -1;)
		{
			//console.printf("LUMP: %d, name: %s",lump,wads.GetLumpFullName(lump));
			if(lump != -1)
				lumpssearch.push(lump);
		}

		//parse them, both skills and episodes at the same time
		for(int i = 0; i < lumpssearch.size(); i++)
		{
			ParseSkillsEpisodes(_skillInfo,episinfo,"MAPINFO",lumpssearch[i]);
		}
		
		//check repeated ones
		if(_SkillInfo.size() > 0)
		{
			array<BWSkillInfo> dup;
			
			for(int i = 0; i < _skillInfo.size(); i++)
			{
				if(dup.size() < 1)
					dup.push(_skillInfo[i]);
				else
				{
					bool alreadythere;
					for(int j = 0; j < dup.size(); j++)
					{
						if(_skillInfo[i].displayName == dup[j].displayName)
							alreadythere = true;
					}
					if(!alreadythere)
						dup.push(_skillInfo[i]);
				}
			}

			_skillInfo.move(dup);
		}
		//just in case
		
		
		if(_skillInfo.size() < 1)
		{
			let curSkillInfo1 = new("BWSkillInfo");
				curSkillInfo1.displayName = "Easy";
				curSkillInfo1.Description = "idk";
				curSkillInfo1.Pic = "";
				_skillInfo.push(curSkillInfo1);
			let curSkillInfo2 = new("BWSkillInfo");
				curSkillInfo2.displayName = "Normal";
				curSkillInfo2.Description = "vec(0,1,0)";
				curSkillInfo2.Pic = "";
				_skillInfo.push(curSkillInfo2);
			let curSkillInfo3 = new("BWSkillInfo");
				curSkillInfo3.displayName = "Hard";
				curSkillInfo3.Description = "yes";
				curSkillInfo3.Pic = "";
				_skillInfo.push(curSkillInfo3);
		}
		
		
	
	}
	
	
	
	//from HaloDoom -> https://github.com/Lewisk3/HaloDoom_GZDoomVersion/blob/e1c16e0cb1389064b76849f16c7485b35c658115/ZScript/math.zsc#L544
	static bool, string parseStrElement(String type, String ln, bool filterNewLines = true, bool filterSpaces = true)
	{
		string quote = "\"";
		string lnLower = ln.MakeLower();
		type = type.MakeLower();
		
		int element_S = lnLower.IndexOf(type);
		int elementStr_S = lnLower.IndexOf(quote, element_S);
		int element_E = lnLower.IndexOf(quote, elementStr_S+1);
		
		/*
		console.printf("Parsing: [%s] \nfor StringKeyword %s", ln, type);
		console.printf("Starting At: %d -> %s \n", element_S, lnLower.Mid(element_S));
		console.printf("String Starts: %d -> %s \n", elementStr_S, lnLower.Mid(elementStr_S));
		console.printf("Ending At: %d -> %s \n", element_E, lnLower.Mid(element_E));
		console.printf("\n\n");
		*/
		
		if(element_S < 0 || element_E < 0) return false, "";
		
		String output = ln.Mid(elementStr_S+1, (element_E-elementStr_S)-1);	
		if(filterNewLines) output.Replace("\n", "");
		if(filterSpaces) 
		{
			output.Replace(" ", "");
			output.Replace("\t", "");
		}
		
		return true, output;
	}
	
	

	static void ParseSkillsEpisodes(out Array<BWSkillInfo> skInfo,out Array<BWEpisodeInfo> episInf, string lumpSearch = "MAPINFO", int lump =-1)
	{
		// adwnawdlnkdawlknawdkln why isn't this just a feature??!?!!?!?!?
		// ffs.

		//console.printf("\cr%d = Reading %s =",lump,lumpSearch);
		
		{
			string data = Wads.ReadLump(lump);
			string dataLower = data.MakeLower();
			//console.printf("[] \cvReading Lump #%d: %s (Path: %s)",lump,wads.GetLumpFullName(lump),wads.GetLumpFullPath(lump));
			// Look for `skill` keyword(s).
			int skillIndex = 0;
			int skillOffset = 0;
			int loopCheck = 0;
			while(skillIndex >= 0)
			{
				loopCheck++;
				if(loopCheck > 100) 
				{
					console.printf("Error reading mapinfo.");
					break;
				}
				
				skillIndex = dataLower.IndexOf("skill", skillOffset);
				if(skillIndex < 0) break;
				
				// Grab skill block.
				int blockStart = dataLower.IndexOf("{", skillIndex);
				int blockEnd = dataLower.IndexOf("}", skillIndex);
				if(blockStart < 0 || blockEnd < 0) break;
				
				int blockLen = blockEnd - blockStart;
				skillOffset = blockEnd+1; // Advance read "head".
				
				string skillData = data.Mid(blockStart, blockLen);
				string skillDataLower = skillData.MakeLower();
			
				// Field to read from.
				string skillPic;
				string skillName;
				string skillDesc;
				
				// Filter "confusing" fields.
				int picName = skillDataLower.IndexOf("picname");
				int className = skillDataLower.IndexOf("playerclassname");
				bool gotStr;
				
				if(picName > -1)
				{		
					// Parse skillPic
					[gotStr, skillPic] = BWMenuStaticInfo.parseStrElement("picname", skillData);
					if(!gotStr) return;
								
					int picNameEnd = skillDataLower.IndexOf("\n", picName);
					skillData.Remove(picName, picNameEnd-picName);
				}
				if(className > -1)
				{
					int classNameEnd = skillDataLower.IndexOf("\n", className);
					skillData.Remove(picName, classNameEnd-className);
				}
				skillDataLower = skillData.MakeLower();
				
				// Get name
				[gotStr, skillName] = BWMenuStaticInfo.parseStrElement("name", skillData,true,false);
				if(!gotStr) return;
				
				// Localize name if needed.
				bool specialName = skillName.IndexOf("$") >= 0; 
				if(specialName) skillName = StringTable.Localize(skillName);
				
				// Get "desc" from `MustConfirm`
				[gotStr, skillDesc] = BWMenuStaticInfo.parseStrElement("mustconfirm", skillData,true,false);
				if(!gotStr) skillDesc = "";
				
				let curSkillInfo = new("BWSkillInfo");
				curSkillInfo.displayName = skillName;
				curSkillInfo.Description = skillDesc;
				curSkillInfo.Pic = skillPic;
						
				skInfo.push(curSkillInfo);
			}
			
			skillIndex = 0;
			skillOffset = 0;
			loopCheck = 0;

			while(skillIndex >= 0)
			{
				loopCheck++;
				if(loopCheck > 100) 
				{
					console.printf("Error reading mapinfo.");
					break;
				}
				
				skillIndex = dataLower.IndexOf("episode", skillOffset);
				if(skillIndex < 0) break;
				
				string startmap = "nomap";
				int nextws = datalower.IndexOf(" ",skillIndex);
				int nextnextws = nextws;
				if(nextws > 0)
					nextnextws = datalower.IndexOf(" ",nextws);
				
				if(nextnextws > nextws && nextws > 0)
					startmap = datalower.mid(nextws,nextnextws);

				// Grab skill block.
				int blockStart = dataLower.IndexOf("{", skillIndex);
				int blockEnd = dataLower.IndexOf("}", skillIndex);
				if(blockStart < 0 || blockEnd < 0) break;
				
				int blockLen = blockEnd - blockStart;
				skillOffset = blockEnd+1; // Advance read "head".
				
				string skillData = data.Mid(blockStart, blockLen);
				string skillDataLower = skillData.MakeLower();
			
				// Field to read from.
				string skillPic;
				string skillName;
				string skillDesc;
				
				// Filter "confusing" fields.
				int picName = skillDataLower.IndexOf("picname");
				int className = skillDataLower.IndexOf("playerclassname");
				bool gotStr;
				
				if(picName > -1)
				{		
					// Parse skillPic
					[gotStr, skillPic] = BWMenuStaticInfo.parseStrElement("picname", skillData);
					if(!gotStr) return;
								
					int picNameEnd = skillDataLower.IndexOf("\n", picName);
					skillData.Remove(picName, picNameEnd-picName);
				}
				if(className > -1)
				{
					int classNameEnd = skillDataLower.IndexOf("\n", className);
					skillData.Remove(picName, classNameEnd-className);
				}
				skillDataLower = skillData.MakeLower();
				
				// Get name
				[gotStr, skillName] = BWMenuStaticInfo.parseStrElement("name", skillData,true,false);
				if(!gotStr) return;
				
				// Localize name if needed.
				bool specialName = skillName.IndexOf("$") >= 0; 
				if(specialName) skillName = StringTable.Localize(skillName);
				
				let curEpisInfo = new("BWEpisodeInfo");
				curEpisInfo.displayName = skillName;
				curEpisInfo.patch = skillPic;
				curEpisInfo.startmap = startmap;

						
				episInf.push(curEpisInfo);
			}
		}
	}

	
	/*
	override void worldloaded(worldevent e)
	{
		string plclas;
		int skil;
		string epis;
		
		skil = G_SkillPropertyInt(SKILLP_ACSReturn);
		string idk;
		int idkskil = skil;
		int actualskil;
		
		switch(skil)
		{
			case bw_spawner.Skill_baby: 	actualskil = 0;		break;
			case bw_spawner.Skill_easy: 	actualskil = 1;		break;
			case bw_spawner.Skill_normal: 	actualskil = 2;		break;
			case bw_spawner.Skill_hard: 	actualskil = 3;		break;
			case bw_spawner.Skill_Uber: 	actualskil = 4;		break;
		}
		int interp = 2 ** actualskil;
		
		console.printf("SKILL: \ca%d, Real: %d Index[%d] \c- name:%s",skil,interp,actualskil,_SkillInfo[actualskil].displayname);
		
		
		//console.printf("skill %d, %s [%d] \ca[[[%d]]] HTE SKIL: %d",actualSkil,_SkillInfo[skil].displayname, skil, idkskil, (2 ** skil));
	}*/
}

Class BWSkillInfo
{
	string displayName;
	string Description;
	string Pic;
}

Class BWEpisodeInfo
{
	string displayname;
	string patch;
	string startmap;
}