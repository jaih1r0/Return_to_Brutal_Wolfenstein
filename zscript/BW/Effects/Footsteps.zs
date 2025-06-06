
class BW_Footsteps : Thinker //the less actors the better
{	
	//the player footsteps are attached to.
	PlayerPawn toFollow;
	PlayerInfo fplayer;
	
	protected int updateTics;
	
	protected transient CVar f_enabled_cache;	
	protected transient CVar f_vol_cache;
	protected transient CVar f_delay_cache;
	protected bool f_enabled;	
	protected double f_vol;
	protected double f_delay;
	protected bool 	 left;

	//attach PlayerPawn, load the texture/sound associated tables.
	void Init( PlayerPawn attached_player)
	{
		toFollow = attached_player;
		fplayer = toFollow.player;
	}
	
	override void Tick()
	{
		if (!toFollow) {
			destroy();
			return;
		}
		//Cache cvars:
		if (f_enabled_cache == null)
			f_enabled_cache = CVar.GetCVar('BW_DisablePlayerFootsteps',fplayer);
		if (f_vol_cache == null)
			f_vol_cache = CVar.GetCVar('BW_FootstepsVol',fplayer);
		f_enabled = f_enabled_cache.GetBool();
		f_vol = f_vol_cache.GetFloat();
		f_delay = 1.4; //]Pop] This one gets hardcoded for manual adjustment
		
		updateTics--;
		
		//0) do nothing until updateTics is below 0
		if (updateTics > 0)
			return;
		   
		double playerVel2D = toFollow.vel.xy.length();
		
		//2) Only play footsteps when on ground, and if the player is moving fast enough.
		if (!f_enabled && (playerVel2D > 0.1) && (toFollow.pos.z - toFollow.floorz <= 0)) 
		{			
			sound stepsound; name mat;	

			//current floor texture for the player:
			string floortex = (Texman.GetName(toFollow.floorpic));
			[stepsound,mat] = BW_StaticHandler.getmaterialstepandName(floortex);	//get step sound and material for the floor

			//sound volume is amplified by speed.
			double soundVolume = f_vol * playerVel2D * 0.12; //multiplied by 0.12 because raw value is too high to be used as volume
			
			//play the sound if it's non-null
			if (stepsound != "step/none")
			{
				toFollow.A_StartSound(stepsound, CHAN_AUTO, CHANF_LOCAL|CHANF_UI, volume:soundVolume);
				if(steppedonLiquid(mat))
				{
					vector3 steppos = (cos(tofollow.angle + 90),sin(tofollow.angle + 90),0);
					steppos *= (left ? -7 : 7);
					BW_StepActor.spawnfootstepFx(toFollow,toFollow.pos + steppos,mat,false);	//splashes
				}
				left = !left;	//change side
			}
			//delay CVAR value is inverted, where 1.0 is default, higher means more frequent, smaller means less frequent
			double dmul = (2.1 - Clamp(f_delay,0.1,2));
			updateTics = (gameinfo.normforwardmove[0] - playerVel2D) * dmul;   
		} 
		else 
		{
			// no need to poll for change too often
			updateTics = 1;
		}
	}

	bool steppedonLiquid(name material = 'null')
	{
		switch(material)
		{
			case 'water':
			case 'blood':
			case 'acid':
			case 'slime':
			case 'lava':
			case 'purplewater':
				return true;	break;

			default:
				return false;	break;
		}
		return false;
	}
	
	// a totally ugly check for texture name:
	sound GetFlatSound(name texname) {
		//first check the all flat names array
		bool inlist = false;
		for (int i = 0; i < FLATS_NAMES.Size(); i++) {
			if (FLATS_NAMES[i] == texname) {
				inlist = true;
				break;
			}
		}
		// and return default sound if not found
		if (!inlist) {			
			return "step/default";
		}
		//if found, check against each array with the names of differently sounding floors
		for (int i = 0; i < FLATS_SLIME.Size(); i++) {
			if (FLATS_SLIME[i] == texname)
				return "step/slime";
		}
		for (int i = 0; i < FLATS_SLIMY.Size(); i++) {
			if (FLATS_SLIMY[i] == texname)
				return "step/slimy";
		}
		for (int i = 0; i < FLATS_LAVA.Size(); i++) {
			if (FLATS_LAVA[i] == texname)
				return "step/lava";
		}
		for (int i = 0; i < FLATS_ROCK.Size(); i++) {
			if (FLATS_ROCK[i] == texname)
				return "step/rock";
		}
		for (int i = 0; i < FLATS_WOOD.Size(); i++) {
			if (FLATS_WOOD[i] == texname)
				return "step/wood";
		}
		for (int i = 0; i < FLATS_TILEA.Size(); i++) {
			if (FLATS_TILEA[i] == texname)
				return "step/tile/a";
		}
		for (int i = 0; i < FLATS_TILEB.Size(); i++) {
			if (FLATS_TILEB[i] == texname)
				return "step/tile/b";
		}
		for (int i = 0; i < FLATS_HARD.Size(); i++) {
			if (FLATS_HARD[i] == texname)
				return "step/hard";
		}
		for (int i = 0; i < FLATS_CARPET.Size(); i++) {
			if (FLATS_CARPET[i] == texname)
				return "step/carpet";
		}
		for (int i = 0; i < FLATS_METALA.Size(); i++) {
			if (FLATS_METALA[i] == texname)
				return "step/metal/a";
		}
		for (int i = 0; i < FLATS_METALB.Size(); i++) {
			if (FLATS_METALB[i] == texname)
				return "step/metal/b";
		}
		for (int i = 0; i < FLATS_DIRT.Size(); i++) {
			if (FLATS_DIRT[i] == texname)
				return "step/dirt";
		}
		for (int i = 0; i < FLATS_GRAVEL.Size(); i++) {
			if (FLATS_GRAVEL[i] == texname)
				return "step/gravel";
		}
		return "step/default";
	}
	
	static const name FLATS_NAMES[] = {
			"FWATER1","FWATER2","FWATER3","FWATER4",
			"FLOOR0_1","FLOOR0_3","FLOOR1_7","FLOOR4_1","FLOOR4_5","FLOOR4_6",
			"TLITE6_1","TLITE6_5","CEIL3_1","CEIL3_2","CEIL4_2","CEIL4_3","CEIL5_1",
			"FLAT2","FLAT5","FLAT18",
			"FLOOR0_2","FLOOR0_5","FLOOR0_7",
			"FLAT5_3","CRATOP1","CRATOP2",
			"FLAT9","FLAT17","FLAT19",
			"COMP01","GRNLITE1","FLOOR1_1","FLAT14","FLAT5_5","FLOOR1_6",
			"CEIL4_1","GRASS1","GRASS2","RROCK16","RROCK19",
			"FLOOR6_1","FLOOR6_2","FLAT10",
			"MFLR8_3","MFLR8_4","RROCK17","RROCK18",
			"FLOOR0_6","FLOOR4_8","FLOOR5_1","FLOOR5_2","FLOOR5_3","FLOOR5_4",
			"TLITE6_4","TLITE6_6","FLOOR7_1","MFLR8_1","CEIL3_5",
			"CEIL5_2","CEIL3_6","FLAT8",
			"SLIME13","STEP1","STEP2",
			"GATE1","GATE2","GATE3",
			"CEIL1_2","CEIL1_3","SLIME14","SLIME15","SLIME16",
			"FLAT22","FLAT23","CONS1_1","CONS1_5","CONS1_7",
			"GATE4","FLAT4","FLAT1","FLAT5_4",
			"MFLR8_2","FLAT1_1","FLAT1_2","FLAT1_3","FLAT5_7","FLAT5_8",
			"GRNROCK","RROCK01","RROCK02","RROCK03","RROCK04","RROCK05","RROCK06","RROCK07","RROCK08","RROCK09","RROCK10","RROCK11","RROCK12","RROCK13","RROCK14","RROCK15","RROCK20",
			"SLIME09","SLIME10","SLIME11","SLIME12","FLAT5_6","FLOOR3_3","FLAT20",
			"CEIL3_3","CEIL3_4","FLAT3","FLOOR7_2",
			"DEM1_1","DEM1_2","DEM1_3","DEM1_4","DEM1_5","DEM1_6",
			"CEIL1_1","FLAT5_1","FLAT5_2",
			"NUKAGE1","NUKAGE2","NUKAGE3","BLOOD1","BLOOD2","BLOOD3","SLIME01","SLIME02","SLIME03","SLIME04","SLIME05","SLIME06","SLIME07","SLIME08",
			"SFLR6_1","SFLR6_4","SFLR7_1","SFLR7_4","LAVA1","LAVA2","LAVA3","LAVA4","F_SKY1","
			BDT_WFL","BDT_BFL","BDT_LFL","BDT_AFL","BDT_SFL1","BDT_SFL2"
		};
		
		//"step/slime"
		static const name FLATS_SLIME[] = {	"BDT_WFL", "BDT_BFL", "BDT_AFL", "BDT_SFL1", "BDT_SFL2", "BLOOD1", "BLOOD2", "BLOOD3", "NUKAGE1", "NUKAGE2", "NUKAGE3", "SLIME01", "SLIME02", "SLIME03", "SLIME04", "SLIME05", "SLIME06", "SLIME07", "SLIME08", "FWATER1", "FWATER2", "FWATER3", "FWATER4" };
		//"step/slimy"
		static const name FLATS_SLIMY[] = { "SFLR6_1","SFLR6_4","SFLR7_1","SFLR7_4" };
		//"step/lava"
		static const name FLATS_LAVA[]	= { "LAVA1","LAVA2","LAVA3","LAVA4","BDT_LFL" };
		//"step/rock"
		static const name FLATS_ROCK[]	= { "SLIME09","SLIME10","SLIME11","SLIME12","RROCK01","RROCK02","RROCK05","RROCK06","RROCK07","RROCK08","FLAT1","FLAT1_1","FLAT1_2","FLAT5_6","FLAT5_7","FLAT5_8","FLOOR5_4","GRNROCK","MFLR8_2","MFLR8_3","RROCK03","RROCK04","RROCK09","RROCK10","RROCK11","RROCK12","RROCK13","RROCK14","RROCK15","SLIME13" };
		//"step/wood"
		static const name FLATS_WOOD[]	= { "FLOOR0_2","CEIL1_1","CRATOP1","CRATOP2","FLAT5_1","FLAT5_2" };
		//"step/tile/a"
		static const name FLATS_TILEA[] = { "CEIL1_3","CEIL3_3","CEIL3_4","COMP01","FLAT2","FLAT3","FLAT8","FLAT9","FLAT17","FLAT18","FLAT19","FLOOR0_6","FLOOR0_7","FLOOR3_3","FLOOR4_1","FLOOR4_5","FLOOR4_6","FLOOR4_8","FLOOR5_1","FLOOR5_2","FLOOR5_3","TLITE6_1","TLITE6_4","TLITE6_5","TLITE6_6" };
		//"step/tile/b"
		static const name FLATS_TILEB[] = { "DEM1_1","DEM1_2","DEM1_3","DEM1_4","DEM1_5","DEM1_6","FLOOR7_2" };
		//"step/hard"
		static const name FLATS_HARD[]	= { "CEIL3_1","CEIL3_2","CEIL3_5","CEIL3_6","CEIL5_1","CEIL5_2","FLAT5","FLOOR0_1","FLOOR0_3","FLOOR1_6","FLOOR1_7","FLOOR7_1","GRNLITE1","MFLR8_1" };
		//"step/carpet"
		static const name FLATS_CARPET[] = { "CEIL4_1","CEIL4_2","CEIL4_3","FLAT5_3","FLAT5_4","FLAT5_5","FLAT14","FLOOR1_1" };
		//"step/metal/a"
		static const name FLATS_METALA[] = { "FLOOR0_5","CEIL1_2","FLAT1_3","FLAT20","GATE1","GATE2","GATE3","SLIME14","SLIME15","SLIME16","STEP1","STEP2" };
		//"step/metal/b"
		static const name FLATS_METALB[] = { "CONS1_1","CONS1_5","CONS1_7","FLAT4","FLAT22","FLAT23","GATE4" };
		//"step/dirt"
		static const name FLATS_DIRT[]	= { "FLAT10","GRASS1","GRASS2","MFLR8_4","RROCK16","RROCK17","RROCK18","RROCK19","RROCK20" };
		//"step/gravel"
		static const name FLATS_GRAVEL[] = { "FLOOR6_1","FLOOR6_2" };
}

Class BW_StepActor : Actor
{
	default
	{
		+nointeraction;
	}
	vector3 norm;
	double fAng;
	name stepType;

	static void spawnfootstepFx(actor self, vector3 spos, name stepType, bool isbig = false)
	{
		vector3 norm = self.cursector.floorplane.normal;

		switch(stepType)
		{
			case 'Water':		SpawnImpact_water(spos,norm,stepType,self,0x98A6C5,big:isbig);				break;
			case 'Slime':		SpawnImpact_water(spos,norm,stepType,self,0x956730,"SLIMC0",big:isbig);		break;
			case 'PurpleWater': SpawnImpact_water(spos,norm,stepType,self,0xC098C7,"PSPHB0",big:isbig);		break;
			case 'Blood': 		SpawnImpact_water(spos,norm,stepType,self,0xFF0000,big:isbig);				break;
			case 'Flesh':		SpawnImpact_water(spos,norm,stepType,self,0xFF0000,big:isbig);				break;
			case 'Acid': 		SpawnImpact_water(spos,norm,stepType,self,0x5FB534,big:isbig);				break;
            case 'Lava': 		spawnimpact_Lava(spos,norm,stepType,self,big:isbig);									break;
			case 'Dirt': 		spawnFxSmoke(stepType,"DIRPC0",0xFFFFFF,self,norm);					break;
			case 'Gravel':		spawnFxSmoke(stepType,"DIRPC0",0xFFFFFF,self,norm);					break;
			default: 																				break;
		}
	}

	states
	{
		spawn:
			TNT1 A 1;
			stop;
	}

	static void SpawnImpact_water(vector3 spos,vector3 norm,name stepType,actor self,color col = 0xFFFFFF, string splashsprite = "WSPHC0",bool big = false)
	{	
		//spawnFxSmoke(stepType,"PUF2U0",col,self,norm);
		FSpawnParticleParams WTRPX;
		
		WTRPX.Texture = TexMan.CheckForTexture(splashsprite);
		WTRPX.Color1 = col;//0xFFFFFF;
		WTRPX.Style = STYLE_Translucent;
		WTRPX.Flags = SPF_ROLL;
		WTRPX.Startroll = random(0,360);
		WTRPX.RollVel = frandom(-15,15);
		WTRPX.StartAlpha = 1.0;
		
		WTRPX.SizeStep = -2;
		WTRPX.Pos = spos;
		WTRPX.FadeStep = 0.075;
		vector3 tofs = (0,0,0);
        switch(stepType)
        {
            case 'Acid':   case 'Lava': 
            	WTRPX.Flags |= SPF_FULLBRIGHT;
			case 'Blood': 
            	WTRPX.Style = STYLE_Add;
			case 'Slime':
            break;
            //case 'PurpleWater': case 'Water':
        }
		int amt = big ? random(8,15) : random(2,5);
		for(int i = 0; i < amt; i++)
		{
			WTRPX.Size = frandom(18,26);
			WTRPX.Lifetime = Random(5,8); 
			WTRPX.accel = (0,0,frandom(-0.75,-0.4));
			vector3	fs = (norm.x + frandom(-2.0,2.0),norm.y + frandom(-2.0,2.0),norm.z * frandom(1.5,3.0));
			WTRPX.Vel = norm + fs;	//(norm * random(2,3));	
			Level.SpawnParticle (WTRPX);
		}
	}

    static void spawnimpact_Lava(vector3 spos,vector3 norm,name stepType,actor self, bool big = false)
    {
        //spawnFxSmoke(stepType,"PUF2U0",0xE49801,self,norm);
        FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = spos;
		WTFSMK.Texture = TexMan.CheckForTexture("FRPRC0");
		WTFSMK.Color1 = 0xFFFFFF;
		WTFSMK.Style = STYLE_ADD;
		WTFSMK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = frandom(-5,5);
		WTFSMK.StartAlpha = 0.75;
		
		WTFSMK.SizeStep = 1;
		
		int amt = big ? random(7,12) : random(2,4);
        for(int i = 0; i < random(1,3); i++)
		{
			vector3 fs = (0,0,0);
            WTFSMK.Size = frandom(15,30);
            WTFSMK.Lifetime = Random(8,12); 
		    WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
			if(norm.x == 0 && norm.y == 0)	//is a plane surface, so its normal will be 0, since its pointing up, in those cases just randomize xy
				fs = (frandom(-1.0,1.0),frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			else
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			WTFSMK.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			Level.SpawnParticle (WTFSMK);
		}
		
    }

	static void spawnFxSmoke(name type = 'default',string gfx = "PUF2U0", color col = 0xFFFFFF,actor self = null,vector3 norm = (0,0,0))
	{
		FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = self.pos;
        WTFSMK.Texture = TexMan.CheckForTexture(gfx);
		WTFSMK.Color1 = col;
		WTFSMK.Style = STYLE_Translucent;
		WTFSMK.Flags = SPF_ROLL;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = random(-5,5);
		WTFSMK.StartAlpha = 0.65;
		WTFSMK.Size = random(20,40);
		WTFSMK.SizeStep = 2;
		WTFSMK.Lifetime = Random(10,18); 
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		WTFSMK.Vel = norm * frandom[bwsmk](0.55,0.80);
        switch(type)  //add adjustments here
        {
            case 'Dirt':    WTFSMK.Size = random(15,20);     break;
            case 'Acid':   case 'Lava': 
            WTFSMK.Style = STYLE_Add;
            WTFSMK.Flags |= SPF_FULLBRIGHT;
            case 'Blood':
			case 'Slime': case 'PurpleWater': case 'Water':
            WTFSMK.Size = random(15,20);    break;
        }
		if(self.CeilingPic == SkyFlatNum)
			WTFSMK.accel = getwinddir(self);
		Level.SpawnParticle (WTFSMK);
	}

	static vector3 getwinddir(actor self)
	{
		if(!self.level)
			return (0,0,0);
		switch(self.level.levelnum % 4)
		{
			case 0:	return (0.05,0.05,0.03);	break;
			case 1:	return (-0.05,0.05,0.03);	break;
			case 2:	return (0.05,-0.05,0.03);	break;
			case 3:	return (-0.05,-0.05,0.03);	break;
		}
		return (0,0,0);
	}

}