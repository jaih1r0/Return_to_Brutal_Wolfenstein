class BW_EventHandler : EventHandler
{
	override void playerentered(playerevent e)
	{
		let ft = FootStepsManager(new("FootStepsManager"));
		let pmo = players[e.playernumber].mo;
		if(ft && pmo)
			ft.init(pmo);
		pmo.A_SetBlend(0x000000,1.0,35);
		players[e.PlayerNumber].mo.A_GiveInventory("Z_NashMove", 1);
	}
	
	int kicktimer;
	int KnifeTimer;
	const kickcooldown = 18;

	//this only works for singleplayer, for mp these would need to be an array and acount for all players
	int ComboTimer;
	int ComboCounter;
	const ComboSpace = TICRATE * 5;	//5 secs, probably would be better to turn this into a cvar
	string lastWeap;

	clearscope int, int getcomboinfo() const	//this is used only to retrieve info to the hud
	{
		return ComboTimer,ComboCounter;
	}

    override void WorldTick()
    {
        //PlayerInfo plyr = players[consoleplayer];

		if(kicktimer > 0)
			kicktimer--;
		if(KnifeTimer > 0)
			KnifeTimer--;
		if(ComboTimer > 0)
			ComboTimer--;
		else
			ComboCounter = 0;
    }

	override void WorldThingDied(WorldEvent e)
	{
		if(e.thing && e.thing.bismonster)
			HandleKillCombos(e.thing);
	}
	
    override void NetworkProcess(ConsoleEvent e)
    {
        let pl = players[e.Player].mo;
        if(!pl)
         return;

		if (e.Name ~== "KickEm")
		{	
			if(kicktimer <= 0)
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
					kicktimer = 18;
				}
				
			}
		}

		if (e.Name ~== "SlashEm")
		{	
			if(KnifeTimer <= 0)
			{
				let wp = pl.player.readyweapon;
				if(!wp)
					return;

				if(pl.findinventory("AimingToken"))	//currently aiming, abort mission
					return;

				let psp = pl.player.findpsprite(-4);
				if(psp)	//is already knifing
					return;
				
				let ks = wp.resolvestate("KnifeAttack");
				if(ks)
					pl.player.SetPSprite(PSP_WEAPON,ks);
				KnifeTimer = 12;
				
			}
		}

	}

	//basic version of a combo system
	void HandleKillCombos(actor victim)
	{
		if(!victim)	//no monster killed
			return;
		if(!victim.target || !victim.target.player)	//monster was not killed by player
			return;
		let plr = victim.target.player.mo;
		int givescore = clamp(victim.spawnhealth(),1,100);
		
		if(ComboCounter > 0)
			givescore *= ComboCounter;
		//incentivize weapon combos
		/*if(plr.player.readyweapon && plr.player.readyweapon.getclassname() != lastWeap)
		{
			lastWeap = plr.player.readyweapon.getclassname();
			givescore *= 2;
		}*/
		int sc = plr.score;
		plr.score += givescore;
		
		ComboTimer = ComboSpace;
		ComboCounter++;
	}
}