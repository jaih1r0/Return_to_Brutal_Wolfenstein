Class BW_Hud : BaseStatusBar
{
	HUDFont 		BWFont;	//Font: Tormentstein 3D - credits: Jimmy, Kinsie, id Software
	int 			healthCol;
	double 			alfadeofs;
	bool 			NoHud;
	override void Init()
	{
		Super.Init();
		SetSize(0, 320, 240);
		BWFont = HUDFont.Create("BWFONT");
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
		if(cplayer.mo.health < 25)
			healthcol = Font.CR_RED;
		else
			healthcol = Font.CR_YELLOW;
		//NoHud = cplayer.mo.findinventory("DisableHud");
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
		int hl = pl.health;
		drawstring(BWFont,formatnumber(hl),(15,-25),DI_SCREEN_LEFT_BOTTOM ,healthcol);
		let mg = getmugshot(5);
		drawtexture(mg,(30,-30),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_BOTTOM,1.0,(-1,-1),(2.0,2.0));//,DI_SCREEN_CENTER_BOTTOM|DI_ITEM_BOTTOM);
		
		//armor
		int amm = GetArmorAmount();
		if(amm > 0)
		{
			drawstring(BWFont,formatnumber(amm),(70,-25),DI_SCREEN_LEFT_BOTTOM,Font.CR_YELLOW);
			TextureID armi;
			vector2 amivec;
			let ba = pl.findinventory("BasicArmor");
			[armi,amivec] = GetIcon(ba,0);
			drawTexture(armi,(35,-30),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,1.0,(90,90),(4.0,4.0));
		}
		//weapons
		if(cplayer.readyweapon != null)
		{
			Ammo Primary, Secondary;
			[Primary, Secondary] = GetCurrentAmmo();
			if(primary)
			{
				int am1 = primary.amount;
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
				int am2 = Secondary.amount;
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
			
			/*
			//grenades
			drawimage("GRNDA",(-160,-65),DI_SCREEN_RIGHT_BOTTOM);
			int gam = pl.countinv("GrenadeAmmo");
			drawstring(BWFont,""..gam,(-140,-75),DI_SCREEN_RIGHT_BOTTOM,Font.CR_YELLOW);
			
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
		//"HasPickedUpBlackKey","HasPickedUpDiamondKey",
		"BlueCard","RedCard","YellowCard",
		"BlueSkull","YellowSkull"//,"RedSkull"
	};
	
	protected virtual void DrawHudKeys()
	{
		Vector2 keypos = (-25 - 10, 2 + 20);
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
			
			/*if(i is "HasPickedUpBlackKey" || i is "HasPickedUpDiamondKey")
			{
				textureid ktx = i.Icon;
				vector2 ofs = (-60,20);
				if(i is "HasPickedUpBlackKey")
				{
					ktx = texman.checkfortexture("NK1CON");
				}
				else
				{
					ofs =( -70,20);
					ktx = texman.checkfortexture("DK1CON");
				}
				DrawTexture(ktx,ofs, DI_SCREEN_RIGHT_TOP|DI_ITEM_LEFT_TOP,1.0,(20,20),(2.0,2.0));
				
			}
			*/
			
		}
	}
	
}