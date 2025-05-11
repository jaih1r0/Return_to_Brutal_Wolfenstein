Class BW_Hud : BaseStatusBar
{
	HUDFont 		BWFont;	//Font: Tormentstein 3D - credits: Jimmy, Kinsie, id Software
	int 			healthCol;
	double 			alfadeofs;
	bool 			NoHud;
	DynamicValueInterpolator DV_Health,DV_Armor,DV_Ammo1,DV_Ammo2,DV_Score,DV_LeftAmmo;
	int oldScore, scoreTics;
	BW_EventHandler scorehandler;
	int combo_timer,combo_counter, oldcounter, counterTics;

	bool isCentered, custommsg, curammolist;
	double messageScale; 
	int msgpos;

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
		DV_LeftAmmo = dynamicvalueinterpolator.create(0,1,1,10);
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
		updateCvars();
	}

	void updateCvars()
	{
		isCentered = 		CVar.GetCVar("con_centernotify", CPlayer).getbool();
		messageScale = 		CVar.GetCVar("BW_messageScale", CPlayer).getfloat();
		custommsg = 		CVar.GetCVar("BW_Custommsg", CPlayer).getbool(); 
		msgpos =			CVar.GetCVar("BW_messagepos", CPlayer).getint();
		curammolist =		CVar.GetCVar("BW_CurrentAmmoList", CPlayer).getbool(); 
	}
	
	override void Tick()
	{
		Super.Tick();
		let pl = cplayer.mo;
		if(pl.health < 25)
			healthcol = Font.CR_RED;
		else
			healthcol = Font.CR_YELLOW;
		
		if(menuactive || consolestate == c_up) 
			updateCvars();
		
		if(!scorehandler)
			scorehandler = BW_EventHandler(EventHandler.find("BW_EventHandler"));

		DV_Health.update(pl.health);
		DV_Armor.update(GetArmorAmount());
		oldScore = DV_Score.getvalue();
		DV_Score.update(pl.score);
		tickhudmessages();
		if(cplayer.readyweapon)
		{
			Ammo Primary, Secondary;
			[Primary, Secondary] = GetCurrentAmmo();
			if(primary)
				DV_Ammo1.update(primary.amount);
			if(Secondary)
				DV_Ammo2.update(Secondary.amount);
			if(cplayer.readyweapon is "BW_DualWeapon")
				DV_LeftAmmo.update(BW_DualWeapon(cplayer.readyweapon).Ammoleft.amount);
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
		
		drawhudMessages();

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
		Ammo Primary, Secondary;
		if(cplayer.readyweapon != null)
		{
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

			//
			int grenindY = -75;
			bool isAkimbo;
			if(cplayer.readyweapon is "BW_DualWeapon")
			{
				if(BW_DualWeapon(cplayer.readyweapon).Hud_IsAkimbo())
				{
					grenindY -= 15;
					isAkimbo = true;
					int am2 = DV_LeftAmmo.getvalue();	//Secondary.amount;
					int max2 = BW_DualWeapon(cplayer.readyweapon).Ammoleft.maxamount;
					string stam = "\ck";
					if(am2 < max2)
						stam = "\cj";
					if(am2 < 1)
						stam = "\ca";
					drawstring(BWFont,""..stam..am2.."\ck/"..max2,(-140,-65),DI_SCREEN_RIGHT_BOTTOM,Font.CR_YELLOW);
				}
			}
			
			
			//grenades
			int gam = pl.countinv("BW_GrenadeAmmo");
			if(gam > 0)
			{
				drawimage("GRNDA",(-160,grenindY+10),DI_SCREEN_RIGHT_BOTTOM);
				drawstring(BWFont,""..gam,(-140,grenindY),DI_SCREEN_RIGHT_BOTTOM,Font.CR_YELLOW);
			}	
			else
			{
				drawimage("GRNDA",(-160,grenindY+10),DI_SCREEN_RIGHT_BOTTOM,col:0xFF705050);
				drawstring(BWFont,""..gam,(-140,grenindY),DI_SCREEN_RIGHT_BOTTOM,Font.CR_BRICK);
			}
			
			//axes
			int aam = pl.countinv("BW_AxeAmmo");
			if(aam > 0)
			{
				drawimage("izras",(-160,grenindY-10),DI_SCREEN_RIGHT_BOTTOM);
				drawstring(BWFont,""..aam,(-140,grenindY-20),DI_SCREEN_RIGHT_BOTTOM,Font.CR_YELLOW);
			}
			else
			{
				drawimage("izras",(-160,grenindY-10),DI_SCREEN_RIGHT_BOTTOM,col:0xFF705050);
				drawstring(BWFont,""..aam,(-140,grenindY-20),DI_SCREEN_RIGHT_BOTTOM,Font.CR_BRICK);
			}
			//weapon image
			textureid wimg;	vector2 wimgsc;
			[wimg,wimgsc] = geticon(cplayer.readyweapon,DI_SKIPICON|DI_SKIPALTICON);
			if(wimg.isvalid())
			{
				drawtexture(wimg,(-200,-35),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,1.0,(90,60),wimgsc);
				if(isAkimbo)
					drawtexture(wimg,(-210,-40),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_RIGHT_BOTTOM,1.0,(90,60),wimgsc);
			}
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
		if(curammolist)
			drawammolist(Primary);
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

	void drawammolist(ammo current)
	{
		vector2 drawpos = (-140,-130);
		for(let inv = cplayer.mo.inv; inv; inv = inv.inv)
		{
			if(inv is "BW_Ammo")
			{
				let tex = inv.althudicon;
				if(tex)
					DrawTexture(tex,drawpos - (20,-6),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER,1.0,box:(20,14));
				drawstring(BWFont,string.format("%d/%d",inv.amount,inv.maxamount),drawpos,DI_SCREEN_RIGHT_BOTTOM,translation: (current != null && current == inv) ? font.CR_YELLOW : font.CR_Untranslated);
				drawpos -= (0,15);
			}
		}
	}


	//
	// custom message drawing
	//
	array <BW_msgInfo> messages;
	uint scrolltics;
	const DEFAULT_MSG_DUR = 42;
	const SCROLL_TIME = 12;
	override bool processnotify(EPrintLevel printlevel, String outline)
	{
		if(!custommsg)
			return false;
		
		string newm; int ind;
		[newm,ind] = getLastmsg();
		if(ind > -1)
		{
			if(messages[ind] && messages[ind].msg ~== outline)
				messages[ind].addRepeated(DEFAULT_MSG_DUR);
			else
			{
				addHudMessage(outline,DEFAULT_MSG_DUR,printlevel);
				scrolltics = SCROLL_TIME;
			}
		}
		else
		{
			addHudMessage(outline,DEFAULT_MSG_DUR,printlevel);
			scrolltics = SCROLL_TIME;
		}
		return true;
	}

	override void flushnotify()
	{
		if(level.time == 0)
			clearmessages();
	}

	void addHudMessage(string msg,uint duration = DEFAULT_MSG_DUR, EPrintLevel printlev = 0)
	{
		messages.push(BW_msgInfo.create(msg,duration,printlev));
	}

	void clearmessages()
	{
		messages.clear();
	}

	string,int getLastmsg()
	{
		int ind = messages.size();
		if(ind <= 0)
			return "",-1;
		ind = max(0,ind - 1);
		if(messages[ind])
			return messages[ind].msg,ind;
		return "",-1;
	}

	void tickhudmessages()
	{
		if(messages.size() > 0)
		{
			for(int i = 0; i < messages.size(); i++)
			{
				if(messages[i])	messages[i].tick();
			}
		}
		if(scrolltics > 0)
			scrolltics--;
	}

	ui void drawhudMessages()
	{
		if(messages.size() < 1)
			return;
		
		double fontscale = 1.0 * messageScale;
		int yfontsize = BWFont.mFont.getheight() * fontscale;
		double startY = 70.;
		double startX = 20.;
		int flags = DI_SCREEN_LEFT;
		int movedir = 1;

		if(isCentered)
		{
			startY = 10;
			startX = -screen.getwidth() / 3.5;
			flags = DI_SCREEN_CENTER_TOP;
		}
		else
		{
			switch(msgpos)
			{
				case 0:		//below level stats
					break;
				default:	//over mugshot
				case 1:
					startY = -150.;
					flags = DI_SCREEN_LEFT_BOTTOM;
					movedir = -1;	//move upwards
					break;
			}
		}
		
		startY += movedir * yfontsize * (double(scrolltics) / SCROLL_TIME);
		


		int maxmsg = 6;
		for(int i = 0; i < messages.size(); i++)
		{
			if(messages[i])
			{
				drawstring(BWFont,messages[i].getmsg(),(startX,startY),flags,messages[i].getColor()
				,alpha:messages[i].alfa,
				scale:(fontscale,fontscale));
				startY += yfontsize * movedir;
				maxmsg--;
			}
			if(maxmsg < 1)
				break;
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

Class BW_msgInfo
{
	double alfa;
	uint duration;
	string msg;
	int rep;
	EPrintLevel type;
	void tick()
	{
		duration--;
		if(duration <= 20)
			alfa -= 0.05;
		if(duration < 1)
			destroy();
	}

	void addRepeated(uint newduration)
	{
		duration = newduration;
		alfa = 1.0;
		rep++;
	}

	string getmsg()
	{
		if(rep > 0)
			return string.format("%s (x%d)",msg,rep+1);
		return msg;
	}

	int getColor()
	{
		//string.format("msg%dcolor",type);
		if(type <= 4)
			return CVar.GetCVar(string.format("msg%dcolor",type)).GetInt();
		return 0;
	}

	static BW_msgInfo create(string msg,uint duration,EPrintLevel type)
	{
		let nmsg = new("BW_msgInfo");
		if(nmsg)
		{
			nmsg.msg = msg;
			nmsg.duration = duration;
			nmsg.alfa = 1.0;
			nmsg.type = type;
		}
		return nmsg;
	}
}