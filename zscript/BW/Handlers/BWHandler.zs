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
	int KnifeTimer;
	const kickcooldown = 18;
	
    override void WorldTick()
    {
        PlayerInfo plyr = players[consoleplayer];

		if(kicktimer > 0)
			kicktimer--;
		if(KnifeTimer > 0)
			KnifeTimer--;
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
}