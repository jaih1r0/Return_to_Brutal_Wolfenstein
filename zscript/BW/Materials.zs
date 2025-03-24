//
//	materials detection system, inspired by the one in pb, so thanks generic
//	this is mainly for footsteps
//
Class BW_StaticHandler : StaticEventHandler
{
	clearscope static BW_StaticHandler get()
	{
		return BW_StaticHandler(BW_StaticHandler.find("BW_StaticHandler"));
	}
	
	clearscope static name getmaterialname(string texture)
	{
		if(!texture)
			return 'null';
		
		BW_StaticHandler hnd = BW_StaticHandler(BW_StaticHandler.find("BW_StaticHandler"));
		
		if(hnd.MaterialTextures.size() < 1)
			return 'null';
		
		for(int i = 0; i < hnd.MaterialTextures.size(); i++)
		{
			if(texture ~== hnd.MaterialTextures[i])
				return name(hnd.MaterialTypes[i]);
		}
		return 'null';
	}
	
	clearscope static sound getmaterialstep(string texture)
	{
		if(!texture)
			return sound("step/none");
		
		BW_StaticHandler hnd = BW_StaticHandler(BW_StaticHandler.find("BW_StaticHandler"));
		
		if(hnd.MaterialTextures.size() < 1)
			return sound("step/default");
		
		for(int i = 0; i < hnd.MaterialTextures.size(); i++)
		{
			if(texture ~== hnd.MaterialTextures[i])
				return sound(hnd.MaterialStep[i]);
		}
		return sound("step/default");
	}
	
	clearscope static sound getmaterialSound(string texture)
	{
		if(!texture)
			return sound("step/none");
		
		BW_StaticHandler hnd = BW_StaticHandler(BW_StaticHandler.find("BW_StaticHandler"));
		
		if(hnd.MaterialTextures.size() < 1)
			return sound("bullet_generic");
		
		for(int i = 0; i < hnd.MaterialTextures.size(); i++)
		{
			if(texture ~== hnd.MaterialTextures[i])
				return sound(hnd.MaterialImpactSnd[i]);
		}
		return sound("bullet_generic");
	}
	
	//setup
	override void OnRegister()
	{
		
		for(int i = 0; i < self.SkyDef.size(); i++)
		{
			self.MaterialTypes.push("Sky");
			self.MaterialStep.push("step/none");
			self.MaterialImpactSnd.push("step/none");
			self.MaterialTextures.push(self.SkyDef[i]);
		}
		
		for(int i = 0; i < self.StoneDef.size(); i++)
		{
			self.MaterialTypes.push("Stone");
			self.MaterialStep.push("step/default");
			self.MaterialImpactSnd.push("bullet_Stone");
			self.MaterialTextures.push(self.StoneDef[i]);
		}
		
		for(int i = 0; i < self.MarbleDef.size(); i++)
		{
			self.MaterialTypes.push("Marble");	//marble is actually just stone heh
			self.MaterialStep.push("step/tile/b");
			self.MaterialImpactSnd.push("bullet_Stone");
			self.MaterialTextures.push(self.MarbleDef[i]);
		}
		
		for(int i = 0; i < self.WoodDef.size(); i++)
		{
			self.MaterialTypes.push("Wood");
			self.MaterialStep.push("step/wood");
			self.MaterialImpactSnd.push("bullet_Wood");
			self.MaterialTextures.push(self.WoodDef[i]);
		}
		
		for(int i = 0; i < self.MetalDef.size(); i++)
		{
			self.MaterialTypes.push("Metal");
			self.MaterialStep.push("step/metal/a");
			self.MaterialImpactSnd.push("bullet_metal");
			self.MaterialTextures.push(self.MetalDef[i]);
		}
		
		for(int i = 0; i < self.CarpetDef.size(); i++)
		{
			self.MaterialTypes.push("Carpet");
			self.MaterialStep.push("step/carpet");
			self.MaterialImpactSnd.push("bullet_Wood");
			self.MaterialTextures.push(self.CarpetDef[i]);
		}
		
		for(int i = 0; i < self.PurpleStoneDef.size(); i++)
		{
			self.MaterialTypes.push("PurpleStone");
			self.MaterialStep.push("step/default");
			self.MaterialImpactSnd.push("bullet_Stone");
			self.MaterialTextures.push(self.PurpleStoneDef[i]);
		}
		
		for(int i = 0; i < self.DirtDef.size(); i++)
		{
			self.MaterialTypes.push("Dirt");
			self.MaterialStep.push("step/dirt");
			self.MaterialImpactSnd.push("bullet_Dirt");
			self.MaterialTextures.push(self.DirtDef[i]);
		}
		
		for(int i = 0; i < self.GravelDef.size(); i++)
		{
			self.MaterialTypes.push("Gravel");
			self.MaterialStep.push("step/gravel");
			self.MaterialImpactSnd.push("bullet_Dirt");
			self.MaterialTextures.push(self.GravelDef[i]);
		}
		
		for(int i = 0; i < self.WaterDef.size(); i++)
		{
			self.MaterialTypes.push("Water");
			self.MaterialStep.push("step/water");
			self.MaterialImpactSnd.push("bullet_water");
			self.MaterialTextures.push(self.WaterDef[i]);
		}
		
		for(int i = 0; i < self.SlimeDef.size(); i++)
		{
			self.MaterialTypes.push("Slime");	//brown watha
			self.MaterialStep.push("step/slime");
			self.MaterialImpactSnd.push("bullet_water");
			self.MaterialTextures.push(self.SlimeDef[i]);
		}
		
		for(int i = 0; i < self.PurpleLiqDef.size(); i++)
		{
			self.MaterialTypes.push("PurpleWater");	//purpurina
			self.MaterialStep.push("step/Water");
			self.MaterialImpactSnd.push("bullet_water");
			self.MaterialTextures.push(self.PurpleLiqDef[i]);
		}
		
		for(int i = 0; i < self.ElectricDef.size(); i++)
		{
			self.MaterialTypes.push("Electric");
			self.MaterialStep.push("step/metal/b");
			self.MaterialImpactSnd.push("bullet_electric");
			self.MaterialTextures.push(self.ElectricDef[i]);
		}
		
		for(int i = 0; i < self.CrystalDef.size(); i++)
		{
			self.MaterialTypes.push("Crystal");
			self.MaterialStep.push("step/snow");	//dont think this is even used to walk over it
			self.MaterialImpactSnd.push("bullet_crystal");
			self.MaterialTextures.push(self.CrystalDef[i]);
		}
		
		for(int i = 0; i < self.LavaDef.size(); i++)
		{
			self.MaterialTypes.push("Lava");
			self.MaterialStep.push("step/lava");
			self.MaterialImpactSnd.push("world/lavasizzle");
			self.MaterialTextures.push(self.LavaDef[i]);
		}
		
		  
		for(int i = 0; i < self.FleshDef.size(); i++)
		{
			self.MaterialTypes.push("Flesh");
			self.MaterialStep.push("step/slimy");
			self.MaterialImpactSnd.push("bullet_flesh");
			self.MaterialTextures.push(self.FleshDef[i]);
		}
		
		for(int i = 0; i < self.BurnRockDef.size(); i++)
		{
			self.MaterialTypes.push("BurnStone");
			self.MaterialStep.push("step/lava");
			self.MaterialImpactSnd.push("bullet_Stone");
			self.MaterialTextures.push(self.BurnRockDef[i]);
		}
		
		for(int i = 0; i < self.BloodDef.size(); i++)
		{
			self.MaterialTypes.push("Blood");
			self.MaterialStep.push("step/water");
			self.MaterialImpactSnd.push("bullet_water");
			self.MaterialTextures.push(self.BloodDef[i]);
		}
		
		//console.printf("Pushed: "..self.MaterialTextures.size().." materials ("..self.MaterialTypes.size());
	}
	array	<string>	MaterialTypes;
	array	<string>	MaterialTextures;
	array	<string>	MaterialStep;
	array	<string>	MaterialImpactSnd;
	
	static const string SkyDef[] = {
		"F_SKY1","F_SKY2"
	};
	
	static const string StoneDef[] = {
		"FLOOR0_2","BSTONE1","BSTONE2","BRICK2","BRICK3","BRICK4","FLAT5_4",
		"RROCK01","BW126_1","BW126_2","BW126_4","SFLR6_4","FLOOR1_1","BW_FLOOR2",
		"BRWINDOW","PANEL3","TANROCK2","BWWALL20","BWWALL21","E3M3A1","EP5TX128",	//blue
		"BW96_1","BW96_2","BW96_3","BW96_4","BW96_5","BRICK1","TLITE6_6","BWFLOOR2",
		"CEIL5_1","FLAT1","FLAT19","BWWALL24","BWSOD1","SFLR6_1","BWSOD11","BWSOD7",
		"BWSOD12","BWSOD9","BWSOD6","BWSOD15","PANBLACK","PANRED","PANEL5","BWSOD22",
		"BWSOD28","BWSOD13","FLAT5_7","BWSOD8","BWSOD14","BWSOD10","ZIMMER2","BWSOD21",
		"BWSOD30","BWSOD54","BWSOD20","BWSOD51","BWSOD42","BWSOD39","BW_SOD16","BWSOD2",
		"BWSOD16","BWSOD17","BW126_3","CASWALL","BWWALL26","BWWALL25","BWSO103","BWSO107",
		"RROCK04","ROCK5","RROCK09","RROCK02","RROCK11","FLAT1_2",	//brown stone
		"CEMENT7","128REDBW","128REDB2","128REDB3","BWREDW1","BWREDW2","BWREDW3","MARBGRAY",	//bricks
		"STONE5","MARBFAC4","ZZWOLF13","BWREDW4","FLAT5_3",//red stone 
		"BWTESTX1","BWTESTX2","ZEB89","CEIL4_3",	//doubts on this one
		"BLAKWAL1","W3","BIGBRIK2","BIGBRIK3","BWFLOR13","EP3WALL1","EP3WALL2","EP3WALL3",
		"FLOOR5_1","BWB1","LAB2","LABFLAT","LAB3","LAB1","LAB4","LAB13",	//
		"W2","W5","TANROCK5","TANROCK4","EP2TEX1","EP2TEX2",	//green stone bricks
		"EP3WALL4","EP3WALL5","EP3WALL6","F17","W1","F18","BWFLOOR3","BWWALL3","RROCK17",
		"EP5TX64","EP5T164","EP5T264","EP5TX96","EP5T196","CAZS3","CEIL3_5","BW126_5",
		"EP5T296","EP5T1128","EP5T2128","CEIL3_5","BRICK6","BRICK7","CFTX1128","CFTX164",
		"CFTX264","EP6T196","CAZS3","BRICK11","CFTX196","CFTX364","CFTX1328","CFTX396",
		"CFTX2428","CFTX2128","BWWALL27","CFTX464","CFTX364","SATANA","PANBLUE","ROCKRED1",
		"REDWALL","FLAT1_1","RROCK12","BWSOD27","BWSOD26","BWSOD29","BWSOD38","BWSOD67","BWSOD76",
		"BWSOD70","BWSOD73","BWSOD67","BWSOD68","BWSOD71","BWSOD74","BWSOD80","BRONZE3","MIDBRONZ",
		"BWSOD75","BWSOD79","BWSOD44","BWSOD48","BWSOD41","BWSOD36","BWSOD46","SODVTALL",
		"BWSOD81","BWSOD84","BWSOD87","BWSOD82","BWSOD91","BWSOD89","BWSOD92","BWSOD85","BWSOD94",
		"BWSOD93","BWSOD67","BWSOD96","BWSOD95","E2M8A3","LAB5","E2M8A1","BWSOD97","BWSO100",
		"BWSOD98","BWSOD88","RROCK13","BWFLOOR10","BWSOD99","LAB6","BWSOD45","BWSOD83","BWSO115",
		"BWSO111","BWSO119","BWSO117","BWSO118","BRICK8","BWSO136","BWSO133","BWSO108","BWSO116",
		"BWSO120","BWSO121","BWSO122","BWSOD77","BWSO131","BWSO132","PANEL7","SLIME13","RROCK20",
		"RROCK15","BWSO129","BWSO134","BWSO135","BWSO106","BWSO114","BWSO110","BWSOD31","BWSO130",
		"CFTX296","FLOOR6_1","CFTX496","BWWALL13","PANEL1","PANEL2","BRICK12","EP3WALL7",
		"E2M8A4","E2M8A5","E2M8A6","E2M9LAB","BWSO105","SO145","SP_HOT1","ROCKRED2","ROCKRED3",
		"GSTONE2","BWWALL5","BWSOD23"
	};
	
	static const string MarbleDef[] = {
		"DEM1_4","CEIL3_6","GRNLITE1","BWFLOOR18","FLAT1_3","BWWALL22","BWWALL23","FLAT5",
		"BWFLOR18","FLAT9","FLAT23","FLAT4","FLOOR5_2","BW126_6","BW126_7","BW126_8","GATE1",
		"FLAT20","CEIL3_4","CEIL3_2","TLITE6_1","SFLR7_4","CEIL3_1","CEIL3_3","F9","TLITE6_4",
		"LABFLA1","FLOOR4_1","DEM1_6","DEM1_5","BWFLOOR6","W8","FLAT17","CEIL4_1","FLOOR7_2",
		"FLOOR0_1","FLOOR1_7","BWFLOR17","BWFLOR15","FLOOR5_3",	//fancy blue 
		"SODRFL","FLOOR4_8","CEIL1_2","EP6TX96","EP6T296","MARBLE1",
		"STONE6","PANEL6","STONE7","COMP01","SO139","GSTONE1","MARBFAC3","MARBLE2","MARBFAC3","MARBLE3"
	};
	
	static const string WoodDef[] = {
		"BW8AL","FLOOR3_3","BRONZE1","F8","F2","FLAT5_5","ZIMMER3","ZIMMER4","FLAT5_2",
		"FLAT5_1","CEIL1_1","FLOOR0_7","BWWDOOR1","CAZZOSO","BW126_9","FLOOR4_5",
		"BW96_6","BW96_7","BW96_8","F3","DEM1_3","BWWDOOR2","BWWDOOR3","BWWDOOR4","BWWDOOR5",
		"BWSOD21","FLOOR4_6","BWDESK","EP2VO5","EP2WO1","BRICKLIT","FLAT126_12","BW96_9",
		"BWSO104","B126_11","CEIL1_3","BWBIGDOR","BWBIGDO1","B126_12","BWFLOOR5","EP2WO3",
		"EP2VO6","EP2VO7","B126_10","BWFLOR16","BWFLOR12","BWLIB3","F14","BWFLOR19",
		"W6","BW126_13","EP5F51","EP5F52","EP6TX196","EP6T196","F1","WOOD12","EP2WO2",
		"EP5F53","EP2VO4","B126_13","W9","BIGBRIK1","BWLIB1","SODDOR","BWBOX2","BWBOX1",
		"FLOOR7_1","BIGDOOR5","BIGDOOR6","BWLIB5","BWLIB4","BIGDOOR7","SW1WOOD","BWWALL11"
	};
	
	static const string MetalDef[] = {
		"WOOD6","WOOD7","WOOD8","WOOD9",	//huh? why?
		"SFLR6_4","FLOOR0_3","SW2SKULL","SFLR7_1","DOORTRAK",
		"STUCCO","STUCCO1","STUCCO2","STUCCO3","BWLCDR","BLKDOOR","REDDOOR",
		"MIDBARS3","MIDGRATE","METAL","CEMENT8","TANROCK3","BSTONE3","ASHWALL3",
		"BWWALL15","BWMOB6","SLIME14","SW1SKULL","SOD2","BWSO123","BWSO125","BWSO126",
		"BWSO127","BWSO128","SOD1","SLIME15","STEP5","METAL2","SLIME16","SUPPORT3",
		"SW1COMM","BW_ELEV3","SW2STON1","SW1SATYR","SW2LION","SW2SATYR","BWMOB4","BWMENS",
		"BWGDOOR1","BWGDOOR2","MIDBRN1","SW2COMM"
	};
	
	static const string CarpetDef[] = {
		"FLOOR1_6","FLAT14","EP4TXT1","EP4TXT2","EP4TXT4","EP4TXT5","EP4TXT8","EP4TXT10","EP4TXT12",
		"EP4TXT19","BWMQ2","EP4TXT11","EP4TXT13","EP4TXT9","EP4TXT18","EP4TXT3","EP4TXT6","EP4TXT14",
		"EP4TXT7","EP4TXT20","EP439","BWSO137","BWMQ1"
	};
	
	static const string PurpleStoneDef[] = {
		"GAY1","GAY2","GAY3","GAY4","GAY5","GAY6","GAY8","BWSOD3","GAY7"
	};
	
	static const string DirtDef[] = {
		"FLOOR0_6","FLAT10","RROCK18","MFLR8_2","RROCK03","RROCK16",
		"GRASS1","GRASS2","RROCK19",	//actually grass
		"BROWNHUG","BWSOD19","BWFLOOR8"
	};
	
	static const string GravelDef[] = {
		"FLOOR6_2","MFLR8_4","FLAT8","BWFLOOR9"
	};
	
	static const string WaterDef[] = {
		"FWATER1","FWATER2","SFALL1"
	};
	
	static const string SlimeDef[] = {
		"SLIME01","SLIME05","Nukage1"
	};
	
	static const string PurpleLiqDef[] = {
		"PURPLEBL","PURPLEFA"
	};
	
	static const string BloodDef[] = {
		"BFALL1","BLOOD1","BFALL01"
	};
	
	static const string ElectricDef[] = {
		"NAZIPC1","NAZIPC2"
	};
	
	static const string LavaDef[] = {
		"LAVA1"
	};
	
	static const string FleshDef[] = {
		"SKSNAKE2","SKIN2","SKSPINE2","SKSNAKE1","SLOPPY2","SKINMET2","SKINSCAB",
		"SKINSYMB","SP_FACE2","SKINFACE","SKINEDGE"
	};
	
	static const string BurnRockDef[] = {
		"RROCK05","CRACKLE4","CRACKLE2","FIRELAVA","FIRELAV2","FIRELAV3"
	};
	
	static const string CrystalDef[] = {
		"BWINDO2","BWMIRR2","BWMIRROR"
	};
	
}


Class FootStepsManager : thinker
{
	PlayerPawn follow;
	int refresh;
	override void tick()
	{
		if(!follow)
			return;
		if(refresh > 0)
		{
			refresh--;
			return;
		}
		double vl = follow.vel.xy.length();
		bool onground = (follow.pos.z <= follow.floorz + 1);
		//console.printf(""..vl);
		if(vl > 0.5 && onground)
		{
			sound snd = BW_StaticHandler.getmaterialstep(texman.getname(follow.floorpic));
			double vol = FootStepsManager.LinearMap(vl,3,14,0.5,1.0);
			follow.A_Startsound(snd,CHAN_AUTO,volume:vol,pitch: frandom(0.95,1.05));
			refresh = FootStepsManager.LinearMap(vl,3,14,24,10);
		}
		else
			refresh = 3;
	}
	
	void Init(PlayerPawn toAttach)
    {
        follow = toAttach;
        refresh = 2;
	}
	
	clearScope Static Double LinearMap(Double Val, Double O_Min, Double O_Max, Double N_Min, Double N_Max) 
	{
		Return (Val - O_Min) * (N_Max - N_Min) / (O_Max - O_Min) + N_Min;
	}
	
}

class BW_EventHandler : EventHandler
{
	override void playerentered(playerevent e)
	{
		let ft = FootStepsManager(new("FootStepsManager"));
		let pmo = players[e.playernumber].mo;
		if(ft && pmo)
			ft.init(pmo);
		
		players[e.PlayerNumber].mo.A_GiveInventory("Z_NashMove", 1);
	}
	
	int kicktimer;
	const kickcooldown = 18;
	
    override void WorldTick()
    {
        PlayerInfo plyr = players[consoleplayer];

		if(kicktimer > 0)
			kicktimer--;
    }
	
    override void NetworkProcess(ConsoleEvent e)
    {
        let pl = players[e.Player].mo;
        if(!pl)
         return;

		if (e.Name ~== "KickEm")
		{	
			if(kicktimer == 0)
			{
				let wp = pl.player.readyweapon;
				if(!wp)
					return;
				let psp = pl.player.findpsprite(-3);
				if(!psp)	//is already kicking
				{
					//pl.A_GiveInventory("DoKick");
					let ks = wp.resolvestate("DoKick");
					if(ks)
						pl.player.SetPSprite(-3,ks);
					//let kf = wp.resolvestate("KickFlash");
					//if(kf)
					//	pl.player.SetPSprite(PSP_WEAPON,kf);
					kicktimer = 20;
				}
				
			}
		}
	}
}