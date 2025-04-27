
Class FootStepsManager : thinker
{
	PlayerPawn follow;
	int refresh;
	bool enabled, left;
	int cvarsavetics;
	override void tick()
	{
		if(!follow)
			return;
		if(cvarsavetics++ >= 35)
		{
			enabled = !cvar.getcvar("BW_DisablePlayerFootsteps",follow.player).getbool();
			cvarsavetics = 0;
		}
		if(refresh > 0)
		{
			refresh--;
			return;
		}
		if(!enabled)
			return;
		double vl = follow.vel.xy.length();
		bool onground = (follow.pos.z <= follow.floorz + 1);
		//console.printf(""..vl);
		if(vl > 0.5 && onground)
		{
			sound snd; name mat;
			[snd,mat] =BW_StaticHandler.getmaterialstepandName(texman.getname(follow.floorpic));
			double vol = FootStepsManager.LinearMap(vl,3,14,0.5,1.0);
			follow.A_Startsound(snd,CHAN_AUTO,volume:(BW_FootstepsVol * vol),pitch: frandom(0.95,1.05));
			refresh = FootStepsManager.LinearMap(vl,3,14,24,10);
			
			
			switch(mat)
			{
				case 'Water':case 'Slime': case 'PurpleWater': case 'Blood':
				case 'Flesh': case 'Acid': case 'Lava':
					vector3 sidest = (cos(follow.angle + 90),sin(follow.angle + 90),0);
					sidest *= (left ? -7:7);
					BW_StepActor.spawnfootstepFx(follow,follow.pos + sidest,mat);
					//BW_StepActor.doStep(follow.pos + sidest,mat,follow.CurSector);
					break;
			}
			left = !left;
			
		}
		else
			refresh = 3;
	}
	
	void Init(PlayerPawn toAttach)
    {
        follow = toAttach;
        refresh = 2;
		enabled = !cvar.getcvar("BW_DisablePlayerFootsteps",toAttach.player).getbool();
	}
	
	clearScope Static Double LinearMap(Double Val, Double O_Min, Double O_Max, Double N_Min, Double N_Max) 
	{
		Return (Val - O_Min) * (N_Max - N_Min) / (O_Max - O_Min) + N_Min;
	}
	
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

	static void spawnfootstepFx(actor self, vector3 spos, name stepType)
	{
		vector3 norm = self.cursector.floorplane.normal;

		switch(stepType)
		{
			case 'Water':		SpawnImpact_water(spos,norm,stepType,self,0x98A6C5);				break;
			case 'Slime':		SpawnImpact_water(spos,norm,stepType,self,0x956730,"SLIMC0");		break;
			case 'PurpleWater': SpawnImpact_water(spos,norm,stepType,self,0xC098C7,"PSPHB0");		break;
			case 'Blood': 		SpawnImpact_water(spos,norm,stepType,self,0xFF0000);				break;
			case 'Flesh':		SpawnImpact_water(spos,norm,stepType,self,0xFF0000);				break;
			case 'Acid': 		SpawnImpact_water(spos,norm,stepType,self,0x5FB534);				break;
            case 'Lava': 		spawnimpact_Lava(spos,norm,stepType,self);									break;
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

	static void SpawnImpact_water(vector3 spos,vector3 norm,name stepType,actor self,color col = 0xFFFFFF, string splashsprite = "WSPHC0")
	{	
		spawnFxSmoke(stepType,"PUF2U0",col,self,norm);
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
			case 'Slime':  case 'Blood': 
            WTRPX.Style = STYLE_Add;
            break;
            //case 'PurpleWater': case 'Water':
        }
		for(int i = 0; i < random(2,5); i++)
		{
			WTRPX.Size = frandom(18,26);
			WTRPX.Lifetime = Random(5,8); 
			WTRPX.accel = (0,0,frandom(-0.75,-0.4));
			vector3	fs = (norm.x + frandom(-2.0,2.0),norm.y + frandom(-2.0,2.0),norm.z * frandom(1.5,3.0));
			WTRPX.Vel = norm + fs;	//(norm * random(2,3));	
			Level.SpawnParticle (WTRPX);
		}
	}

    static void spawnimpact_Lava(vector3 spos,vector3 norm,name stepType,actor self)
    {
        spawnFxSmoke(stepType,"PUF2U0",0xE49801,self,norm);
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
		
		
        for(int i = 0; i < random(1,3); i++)
		{
			vector3 fs = (0,0,0);
            WTFSMK.Size = frandom(15,30);
            WTFSMK.Lifetime = Random(8,12); 
		    WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
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