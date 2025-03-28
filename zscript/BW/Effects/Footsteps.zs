
Class FootStepsManager : thinker
{
	PlayerPawn follow;
	int refresh;
	bool enabled;
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
			sound snd = BW_StaticHandler.getmaterialstep(texman.getname(follow.floorpic));
			double vol = FootStepsManager.LinearMap(vl,3,14,0.5,1.0);
			follow.A_Startsound(snd,CHAN_AUTO,volume:(BW_FootstepsVol * vol),pitch: frandom(0.95,1.05));
			refresh = FootStepsManager.LinearMap(vl,3,14,24,10);
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