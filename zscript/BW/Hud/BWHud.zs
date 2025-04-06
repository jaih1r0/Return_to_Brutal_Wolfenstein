Class BW_Hud : BaseStatusBar
{
	HUDFont 		BWFont;	//Font: Tormentstein 3D - credits: Jimmy, Kinsie, id Software
	int 			healthCol;
	double 			alfadeofs;
	bool 			NoHud;
	DynamicValueInterpolator DV_Health,DV_Armor,DV_Ammo1,DV_Ammo2,DV_Score;
	int oldScore, scoreTics;
	BW_EventHandler scorehandler;
	int combo_timer,combo_counter, oldcounter, counterTics;
	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 240);
		BWFont = HUDFont.Create("BWFONT");
		DV_Health = dynamicvalueinterpolator.create(0,1,1,10);
		DV_Armor = dynamicvalueinterpolator.create(0,1,1,10);
		DV_Ammo1 = dynamicvalueinterpolator.create(0,1,1,10);
		DV_Ammo2 = dynamicvalueinterpolator.create(0,1,1,10);
		DV_Score = dynamicvalueinterpolator.create(0,1,1,10);
	}
	
	override void Draw(int state, double TicFrac)
	{
		Super.Draw(state, TicFrac);
		if(state != HUD_None)
		{
			BeginHUD();
			DrawHudStuff();
		}
	}
	//DisableHud
	override void NewGame()
	{
		Super.NewGame();
		healthCol = Font.CR_YELLOW;
		alfadeofs = 0.0;
	}
	
	override void Tick()
	{
		Super.Tick();
		let pl = cplayer.mo;
		if(pl.health < 25)
			healthcol = Font.CR_RED;
		else
			healthcol = Font.CR_YELLOW;
		
		if(!scorehandler)
			scorehandler = BW_EventHandler(EventHandler.find("BW_EventHandler"));

		DV_Health.update(pl.health);
		DV_Armor.update(GetArmorAmount());
		oldScore = DV_Score.getvalue();
		DV_Score.update(pl.score);
		if(cplayer.readyweapon)
		{
			Ammo Primary, Secondary;
			[Primary, Secondary] = GetCurrentAmmo();
			if(primary)
				DV_Ammo1.update(primary.amount);
			if(Secondary)
				DV_Ammo2.update(Secondary.amount);
		}
		if(oldScore != DV_Score.getvalue())
			scoreTics = 70;
		if(scoreTics)
			scoreTics--;
		if(counterTics)
			counterTics--;
		if(scorehandler)
		{
			oldcounter = combo_counter;
			[combo_timer,combo_counter] = scorehandler.getcomboinfo();
		}
		if(oldcounter != combo_counter)
			counterTics = 8;
		NoHud = cplayer.mo.findinventory("DisableHud");
		/*if(cplayer.mo.findinventory("NoSliding"))
		{
			alfadeofs += 0.01;
			if(alfadeofs >= 0.5)
				alfadeofs = 0.0;
			//alfadeofs = frandom(0.1,0.5);
		}*/
	}
	
	void DrawHudStuff()
	{
		if(NoHud)
			return;
		let pl = Cplayer.mo;
		
		//health
		int hl = DV_Health.getvalue();//pl.health;
		drawstring(BWFont,formatnumber(hl),(15,-25),DI_SCREEN_LEFT_BOTTOM ,healthcol);
		let mg = getmugshot(5);
		drawtexture(mg,(25,-30),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_BOTTOM,1.0,(-1,-1),(2.0,2.0));//,DI_SCREEN_CENTER_BOTTOM|DI_ITEM_BOTTOM);
		
		//armor
		int amm = DV_Armor.getvalue();//GetArmorAmount();
		if(amm > 0)
		{
			drawstring(BWFont,formatnumber(amm),(70,-25),DI_SCREEN_LEFT_BOTTOM,Font.CR_YELLOW);
			TextureID armi;
			vector2 amivec;
			let ba = pl.findinventory("BasicArmor");
			[armi,amivec] = GetIcon(ba,0);
			drawTexture(armi,(50,-30),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,1.0,(60,60),(4.0,4.0));
		}
		//weapons
		if(cplayer.readyweapon != null)
		{
			Ammo Primary, Secondary;
			[Primary, Secondary] = GetCurrentAmmo();
			if(primary)
			{
				int am1 = DV_Ammo1.getvalue();	//primary.amount;
				int max1 = primary.maxamount;
				string stam = "\ck";
				if(am1 < max1)
					stam = "\cj";
				if(am1 <= 1)
					stam = "\ca";
				drawstring(BWFont,""..stam..am1.."\ck/"..max1,(-140,-25),DI_SCREEN_RIGHT_BOTTOM);
				TextureID armi;
				vector2 amivec;
				[armi,amivec] = GetIcon(Primary,0);
				drawTexture(armi,(-150,-15),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,1.0,(40,40),amivec * 2);
			}
			
			if(Secondary) //&& !pl.findinventory("BWAllowReloadCheck"))
			{
				int am2 = DV_Ammo2.getvalue();	//Secondary.amount;
				int max2 = Secondary.maxamount;
				string stam = "\ck";
				if(am2 < max2)
					stam = "\cj";
				if(am2 < 1)
					stam = "\ca";
				drawstring(BWFont,""..stam..am2.."\ck/"..max2,(-140,-45),DI_SCREEN_RIGHT_BOTTOM,Font.CR_YELLOW);
				TextureID armi;
				vector2 amivec;
				[armi,amivec] = GetIcon(Secondary,0);
				drawTexture(armi,(-150,-35),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,1.0,(40,40),amivec * 2);
			}
			
			
			//grenades
			int gam = pl.countinv("BW_GrenadeAmmo");
			if(gam > 0)
			{
				drawimage("GRNDA",(-160,-65),DI_SCREEN_RIGHT_BOTTOM);
				drawstring(BWFont,""..gam,(-140,-75),DI_SCREEN_RIGHT_BOTTOM,Font.CR_YELLOW);
			}	
			else
			{
				drawimage("GRNDA",(-160,-65),DI_SCREEN_RIGHT_BOTTOM,col:0xFF705050);
				drawstring(BWFont,""..gam,(-140,-75),DI_SCREEN_RIGHT_BOTTOM,Font.CR_BRICK);
			}
			/*
			//axes
			drawimage("izras",(-160,-85),DI_SCREEN_RIGHT_BOTTOM);
			int aam = pl.countinv("AxeAmmo");
			drawstring(BWFont,""..aam,(-140,-95),DI_SCREEN_RIGHT_BOTTOM,Font.CR_YELLOW);
			*/
			//weapon image
			textureid wimg;	vector2 wimgsc;
			[wimg,wimgsc] = geticon(cplayer.readyweapon,DI_SKIPICON|DI_SKIPALTICON);
			if(wimg.isvalid())
				drawtexture(wimg,(-200,-35),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,1.0,(90,60),wimgsc);
			
			//weapon tag
			drawstring(BWFont,cplayer.readyweapon.gettag(),(-320,-12),DI_SCREEN_RIGHT_BOTTOM);
		}
		
		//level info
		bool Kcompl = level.killed_monsters >= Level.total_monsters;
		bool Icompl = level.found_items >= Level.total_items;
		bool Scompl = level.found_secrets >= Level.total_secrets;
		drawstring(BWFont,"K: "..level.killed_monsters.."/"..Level.total_monsters,(20,5),DI_SCREEN_LEFT_TOP,translation: Kcompl ? FONT.CR_YELLOW:FONT.CR_WHITE,scale:(0.85,0.85));
		drawstring(BWFont,"I: "..level.found_items.."/"..Level.total_items,(20,20),DI_SCREEN_LEFT_TOP,translation: Icompl ? FONT.CR_YELLOW:FONT.CR_WHITE,scale:(0.85,0.85));
		drawstring(BWFont,"S: "..level.found_secrets.."/"..Level.total_secrets,(20,35),DI_SCREEN_LEFT_TOP,translation: Scompl ? FONT.CR_YELLOW:FONT.CR_WHITE,scale:(0.85,0.85));
		drawstring(BWFont,"T: "..level.TimeFormatted(),(20,50),DI_SCREEN_LEFT_TOP,scale:(0.85,0.85));
		
		//score
		if(scoreTics)
		{
			double scalpha = 1.0;
			double scltx = 1.0;
			if(scoreTics <= 30)
				scalpha = BW_Statics.LinearMap(scoreTics,0,30,0.0,1.0);
			if(scoreTics >= 63)
				scltx = BW_Statics.LinearMap(scoreTics,63,70,1.0,1.1);
			drawstring(BWFont,string.format("Score: %05d",DV_Score.getvalue()),(-180,20),DI_SCREEN_RIGHT_TOP,Font.CR_GOLD,alpha:scalpha,scale:(scltx,scltx));
		}
		//drawstring(BWFont,string.format("Timer %d",combo_timer),(-170,30),DI_SCREEN_RIGHT_TOP,Font.CR_GREEN,alpha:0.5);
		
		if(combo_timer > 0)
		{
			int prog = BW_Statics.LinearMap(combo_timer,0,thinker.ticrate * 5,0,100);
			int baralfa = clamp(prog * 255 / 100,0,128);
			color barcol = color(baralfa,32,255,12);
			fill(barcol,-180,40,prog,7,DI_SCREEN_RIGHT_TOP);
		}
		if(combo_counter > 0)
		{
			double ccsc = 1.0;
			if(counterTics)
				ccsc = BW_Statics.LinearMap(counterTics,0,8,1.0,1.2);
			drawstring(BWFont,string.format("x%d",combo_counter),(-180,40),DI_SCREEN_RIGHT_TOP,Font.CR_GOLD,alpha:0.5,scale:(ccsc,ccsc));
		}
		
		//slide thing
		//if(pl.findinventory("NoSliding"))
		//	DrawImage("MYLEG",(110,-30),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.5 + alfadeofs,(100,100),(2.0,2.0));
		
		//oxigen
		int ox = GetAirTime();
		if(ox < level.airsupply)
		{
			int oxam = thinker.tics2seconds(ox);
			string airox = oxam <= 5 ? "O2: \ca"..oxam.."\c-" : "O2: \cz"..oxam.."\c-";
			drawstring(BWFont,airox,(15,-105),DI_SCREEN_LEFT_BOTTOM ,healthcol);
		}
		
		//keys
		DrawHudKeys();
	}
	
	static const string wolfkeys[] = {
		"HasPickedUpBlackKey","HasPickedUpDiamondKey",
		"BlueCard","RedCard","YellowCard",
		"BlueSkull","YellowSkull"//,"RedSkull"
	};
	
	protected virtual void DrawHudKeys()
	{
		Vector2 keypos = (-25 - 10, 2 + 25);
		int rowc = 0;
		double roww = 0;
		for(let i = CPlayer.mo.Inv; i != null; i = i.Inv)
		{
			if (i is "Key" && i.Icon.IsValid())
			{
				//
				
				bool dontdrawme = true;
				string kn = i.getclassname();
				for(int j = 0; j < wolfkeys.size(); j++)
				{
					if(kn == wolfkeys[j])
						dontdrawme = false;
				}
				if(dontdrawme)
					continue;
				
				DrawTexture(i.Icon, keypos, DI_SCREEN_RIGHT_TOP|DI_ITEM_LEFT_TOP,1.0,(15,15),(2.0,2.0));
				Vector2 size = TexMan.GetScaledSize(i.Icon);
				keypos.Y += size.Y + 2;
				roww = max(roww, size.X);
				if (++rowc == 3)
				{
					keypos.Y = 10 + 10;
					keypos.X -= roww - 15 - 10;
					roww = 0;
					rowc = 0;
				}
			}
			
			if(i is "HasPickedUpBlackKey" || i is "HasPickedUpDiamondKey")
			{
				textureid ktx = i.Icon;
				vector2 ofs = (-50,20);
				if(i is "HasPickedUpBlackKey")
				{
					ktx = texman.checkfortexture("NK1CON");
				}
				else
				{
					ofs =( -50,30);
					ktx = texman.checkfortexture("DK1CON");
				}
				DrawTexture(ktx,ofs, DI_SCREEN_RIGHT_TOP|DI_ITEM_LEFT_TOP,1.0,(20,20),(2.0,2.0));
				
			}
			
		}
	}
	
}


Class DisableHud : inventory
{
	default
	{
		inventory.maxamount 1;
	}
}