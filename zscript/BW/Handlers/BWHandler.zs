class BW_EventHandler : EventHandler
{
	
	
	int kicktimer;
	int KnifeTimer;
	const kickcooldown = 18;

	//this only works for singleplayer, for mp these would need to be an array and acount for all players
	int ComboTimer;
	int ComboCounter;
	const ComboSpace = TICRATE * 5;	//5 secs, probably would be better to turn this into a cvar
	string lastWeap;

	array<actor>	worldDebris;
	array<actor>	worldCasings;

	clearscope int, int getcomboinfo() const	//this is used only to retrieve info to the hud
	{
		return ComboTimer,ComboCounter;
	}

	override void playerentered(playerevent e)
	{
		let pmo = players[e.playernumber].mo;
		let steps = new("BW_Footsteps");
		if (steps)
			steps.init(pmo);
		
		pmo.A_SetBlend(0x000000,1.0,35);
		players[e.PlayerNumber].mo.A_GiveInventory("Z_NashMove", 1);
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

		
		if(BW_DebrisLimit >= 0)		//limit the amount of debris
		{
			while(worldDebris.size() > BW_DebrisLimit)
				worldDebris[0].destroy();
		}

		if(BW_CasingsLimit >= 0)	//limit the amount of casings
		{
			while(worldCasings.size() > BW_CasingsLimit)
				worldCasings[0].destroy();
		}

		if(BW_CleanTics > 0)		//if this is not 0, clean after this amount of seconds
		{
			if(level.time % (BW_CleanTics * TICRATE) == 0)
				NashgoreGameplayStatics.ClearGore();
		}

    }

	override void worldthingspawned(worldevent e)
	{
		if(e.thing is "BW_CasingBase")
			worldCasings.push(e.thing);
		if(e.thing is "BW_Debris")
			worldDebris.push(e.thing);
	}

	override void worldthingdestroyed(worldevent e)
	{
		if(e.thing && e.thing is "BW_CasingBase")
			worldCasings.delete(worldCasings.find(e.thing));
		if(e.thing && e.thing is "BW_Debris")
			worldDebris.delete(worldDebris.find(e.thing));
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
		if(pl.health < 1)
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

				if(pl.findinventory("CanThrowAxe"))
				{
					pl.A_TakeInventory("CanthrowAxe",10);
					let ks = wp.resolvestate("AxeThrow");
					if(ks)
						pl.player.SetPSprite(PSP_WEAPON,ks);
					KnifeTimer = 12;
					return;
				}

				let psp = pl.player.findpsprite(-4);
				if(psp)	//is already knifing
					return;
				
				let ks = wp.resolvestate("KnifeAttack");
				if(ks)
					pl.player.SetPSprite(PSP_WEAPON,ks);
				if(pl.countinv("BW_AxeAmmo") > 0)
					KnifeTimer = 3;
				else
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

		/*if(plr.score > 9999)	//every 10000 points
		{
			console.printf("you got %d score points. %s earned.",plr.score,"soulsphere");
			plr.A_GiveInventory("Soulsphere",1);
			plr.score = 0;
		}*/
	}
}