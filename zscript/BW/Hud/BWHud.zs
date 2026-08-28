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
	textureID mHudBlood;
	textureID mHudReference;
	uint mbloodtics;
	
	int HUDStyle;

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
		mHudBlood = texman.checkfortexture("graphics/HUD/pain1.png");
		mHudReference = texman.checkfortexture("graphics/HUD/HUDREF.png");
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
		
		HUDStyle =		CVar.GetCVar("BW_HUDStyle", CPlayer).getint(); 
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

		let bwplay = BWPlayer(pl);
		if(bwplay)
		{
			mbloodtics = bwplay.bloodtics;
		}
		
	}
	
	void DrawHudStuff()
	{
		if(NoHud)
			return;
		let pl = Cplayer.mo;
		
		//[Pop] This is a reference image.
		/*
		screen.drawtexture(mHudReference,false,0,0
			,DTA_DestWidth, screen.getwidth()
			,DTA_DestHeight,screen.getheight()
			,DTA_Alpha,	1);
		*/
		drawbloodoverlay();
		drawhudMessages();

		switch(HUDStyle)
		{
			default:
			case 0:
				DrawRTBWPrototypeHUD();
				break;
				
			case 2:
				DrawRTCWXBoxHUD();
				break;
		}
	}
	
	static const string ignorelist[] =
	{
		"BW_BlackKey","BW_DiamondKey",
		"BlueCard","RedCard","YellowCard"//,
		//"BlueSkull","YellowSkull","RedSkull"
	};
	
	//[Pop] heres the function to handle the drawing of keys, it does look like a lot
	//but its mainly some sprite checking and stuff to make sure it works right.
	virtual void DrawKeys(vector2 pos, int keycount = 10, int space = 23, int flags = DI_ITEM_CENTER)
    {
        //from NC HUD
        textureid icon, iconskull, iconcard;
        vector2 size;
        bool scaleup;
        int count = 0;
        
        for(let i = CPlayer.mo.Inv; i != null; i = i.Inv)
        {
            if(i is "Key" || i is "HasPickedUpBlackKey" || i is "HasPickedUpDiamondKey")
            {
                // Draw up to defined keycount.
                if(count == keycount)
                {
                    break;
                }
                
                icon = i.AltHUDIcon;

                if (!icon.IsValid())
                {
                    if(i.SpawnState && i.SpawnState.sprite != 0)
                    {
                        icon = i.SpawnState.GetSpriteTexture(0);
                    }
                    else
                    {
                        icon = i.Icon;
                    }
                    
                    if(!icon.IsValid())
                    {
                        continue;
                    }
                }
				
                string kn = i.getclassname();
				for(int j = 0; j < ignorelist.size(); j++)
				{
					if(kn == ignorelist[j])
						icon = TexMan.CheckForTexture("TNT1A0");
				}
				
                // Exclude keys which use 'TNT1A0' as their icon.
                if (TexMan.GetName(icon) ~== "TNT1A0")
                {
                    continue;
                }
				
                
                // Scale the icon up if needed.
                size = TexMan.GetScaledSize(icon);
                scaleup = (size.x <= 11 && size.y <= 11);
				DrawTexture(icon, (pos.x, pos.y), flags, box : (11, 11), scaleup ? (1, 1) : (1, 1));
				pos.x += space;
            }
        }
    }
	
	void drawammolist(ammo current, vector2 pos, int StringFlags, int TextureFlags)
	{
		vector2 drawpos = pos;
		for(let inv = cplayer.mo.inv; inv; inv = inv.inv)
		{
			if(inv is "BW_Ammo")
			{
				let tex = inv.althudicon;
				if(tex)
					DrawTexture(tex,drawpos - (20,-6),TextureFlags,1.0,box:(20,14));
				drawstring(BWFont,string.format("%d/%d",inv.amount,inv.maxamount),(drawpos.x + 40, drawpos.y),StringFlags,translation: (current != null && current == inv) ? font.CR_YELLOW : font.CR_Untranslated);
				drawpos -= (0,15);
			}
		}
	}

	void drawbloodoverlay()
	{
		if(mbloodtics)
		{
			double alfa = BW_Statics.linearmap(mbloodtics,0,35,0.0,0.85,true);
			screen.drawtexture(mHudBlood,false,0,0
			,DTA_DestWidth, screen.getwidth()
			,DTA_DestHeight,screen.getheight()
			,DTA_Alpha,	alfa);
		}
	}
	
	void DrawComboScore(vector2 pos, int StringFlags, int FillFlags)
	{
		//score
		if(scoreTics)
		{
			double scalpha = 1.0;
			double scltx = 1.0;
			if(scoreTics <= 30)
				scalpha = BW_Statics.LinearMap(scoreTics,0,30,0.0,1.0);
			if(scoreTics >= 63)
				scltx = BW_Statics.LinearMap(scoreTics,63,70,1.0,1.1);
			drawstring(BWFont,string.format("Score: %05d",DV_Score.getvalue()),pos,StringFlags,Font.CR_GOLD,alpha:scalpha,scale:(scltx,scltx));
		}
		//drawstring(BWFont,string.format("Timer %d",combo_timer),(-170,30),DI_SCREEN_RIGHT_TOP,Font.CR_GREEN,alpha:0.5);
		
		if(combo_timer > 0)
		{
			int prog = BW_Statics.LinearMap(combo_timer,0,thinker.ticrate * 5,0,140);
			int baralfa = clamp(prog * 255 / 100,0,128);
			color barcol = color(baralfa,32,255,12);
			fill(barcol,pos.x, pos.y+20,prog,7,FillFlags);
		}
		if(combo_counter > 0)
		{
			double ccsc = 1.0;
			if(counterTics)
				ccsc = BW_Statics.LinearMap(counterTics,0,8,1.0,1.2);
			drawstring(BWFont,string.format("x%d",combo_counter),(pos.x,pos.y+20), StringFlags,Font.CR_GOLD,alpha:0.5,scale:(ccsc,ccsc));
		}
	}
	
	void DrawOxygen(vector2 pos, int StringFlags)
	{
		//oxigen
		int ox = GetAirTime();
		if(ox < level.airsupply)
		{
			int oxam = thinker.tics2seconds(ox);
			string airox = oxam <= 5 ? "O2: \ca"..oxam.."\c-" : "O2: \cz"..oxam.."\c-";
			drawstring(BWFont,airox,pos,StringFlags,healthcol);
		}
	}
	
	void DrawLevelInfo(vector2 pos, int StringFlags)
	{
		//level info
		bool Kcompl = level.killed_monsters >= Level.total_monsters;
		bool Icompl = level.found_items >= Level.total_items;
		bool Scompl = level.found_secrets >= Level.total_secrets;
		drawstring(BWFont,"K: "..level.killed_monsters.."/"..Level.total_monsters,(pos.x,pos.y),DI_SCREEN_LEFT_TOP,translation: Kcompl ? FONT.CR_YELLOW:FONT.CR_WHITE,scale:(0.85,0.85));
		drawstring(BWFont,"I: "..level.found_items.."/"..Level.total_items,(pos.x,pos.y+15),DI_SCREEN_LEFT_TOP,translation: Icompl ? FONT.CR_YELLOW:FONT.CR_WHITE,scale:(0.85,0.85));
		drawstring(BWFont,"S: "..level.found_secrets.."/"..Level.total_secrets,(pos.x,pos.y+30),DI_SCREEN_LEFT_TOP,translation: Scompl ? FONT.CR_YELLOW:FONT.CR_WHITE,scale:(0.85,0.85));
		drawstring(BWFont,"T: "..level.TimeFormatted(),(pos.x,pos.y+45),DI_SCREEN_LEFT_TOP,scale:(0.85,0.85));
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
		double startY = 80.;
		double startX = 30.;
		int flags = DI_SCREEN_LEFT | DI_ITEM_LEFT | DI_TEXT_ALIGN_LEFT;
		int movedir = 1;

		if(isCentered)
		{
			startY = 10;
			startX = 0;
			flags = DI_SCREEN_CENTER_TOP | DI_ITEM_CENTER | DI_TEXT_ALIGN_CENTER;
		}
		else
		{
			switch(msgpos)
			{
				case 0:		//below level stats
					break;
				default:	//over mugshot
				case 1:
					startY = -160.;
					flags = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT | DI_TEXT_ALIGN_LEFT;
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