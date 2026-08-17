class wolfStatus : DoomStatusScreen
{

	ui textureID 	strips;
	ui double 		alfa;
	ui BWInterMug 	muggen;
	ui font			interfont;
	ui double 		dt, prevMS;
	ui double 		bordertimer;
	ui int			playerScore;
	const timedif = 1000.0 / 60.0;
	
	override void ticker()
	{
		super.ticker();
		
		if(muggen)
			muggen.tickmug();
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	//	drawing functions
	////////////////////////////////////////////////////////////////////////////
	
	override void Drawer()
	{	
		
		if(!strips)
			strips = texman.checkfortexture("graphics/IntermissionScreens/SCBORDUP.png");
		vector2 sc = (screen.getwidth(),screen.getheight());
		
		switch (CurState)
		{
			case StatCount:
				alfa = 1.0;
				widescreenDatShit();
				// draw animated background
				bg.drawBackground(CurState, false, false);
				drawscreenborders(strips,(0,0),sc);
				drawStats();
				
				
				drawmugg(alfa);
				break;
		
			case ShowNextLoc:
			case LeavingIntermission:	// this must still draw the screen once more for the wipe code to pick up.
				widescreenDatShit();
				drawShowNextLoc();
				if(curState == ShowNextLoc)
					muggen.setend();
				
				
				alfa = max(0.05,alfa - 0.025);
				drawscreenborders(strips,(0,0),sc,alfa); 
				drawmugg(alfa);
				break;
		
			default:
				alfa = max(0.05,alfa - 0.025);
				widescreenDatShit();
				drawNoState();
				drawscreenborders(strips,(0,0),sc,alfa); 
				drawmugg(alfa);
				break;
		}
		
		updateDeltaTime();
		bordertimer += dt;
		
	}
	
	
	
	// Draws images to the left and right of the traditional intermission graphic,
	// as a sick hack to fill in space for widescreen players (aka. most players
	// nowadays in this Brutal-tinged era.
	// Rewritten by Gutawer. Kudos!
	ui void widescreenDatShit ()
    {
        TextureID interborder = TexMan.CheckForTexture("INTBACK", TexMan.Type_MiscPatch);
        Vector2 borderSize = TexMan.GetScaledSize(interborder);
        Vector2 interpicTL, interpicRS;
        [interpicTL, interpicRS] = Screen.VirtualToRealCoords((0, 0), (640, 400), (640, 400));
        screen.DrawTexture (interborder, true, interPicTL.x - borderSize.x * CleanXFac, -64, DTA_CleanNoMove, true);
        screen.DrawTexture (interborder, true, interPicTL.x + interPicRS.x, -64, DTA_CleanNoMove, true);
    }
	
	ui void drawscreenborders(textureid border, vector2 pos, vector2 size, double alfa = 1.0)
	{
		if(bordertimer < 1.0)
		{
			return;
		}
		
		double timeri = 105.0;	//3 seconds i think
		double raisetime = clamp(bordertimer - timeri, -timeri,0.0);
		
		//up
		screen.drawtexture(border,false,pos.x,pos.y + raisetime
		,DTA_DestWidthF,size.x,DTA_DestHeightF,size.y * 0.05,DTA_Alpha,alfa);
		
		//down
		screen.drawtexture(border,false,pos.x,pos.y - raisetime + (size.y - 40)
		,DTA_DestWidthF,size.x,DTA_DestHeightF,size.y * 0.05,DTA_Alpha,alfa,DTA_FlipY,true);
	}
	
	ui void drawmugg(double Alpha)
	{
		if(bordertimer < 1.0)
		{
			return;
		}
		
		double timeri = 105.0;	//3 seconds i think
		double raisetime = clamp(bordertimer - timeri, -timeri,0.0);
		
		if(muggen)
		{
			muggen.drawmug((300 + (raisetime * 10),320),(375,375), Alpha);
		}
	}
	
	
	
	override void drawStats()
	{
		
		vector2 sc = (screen.getwidth(),screen.getheight());
		drawLevelFinish((0,50));
		string percchar = "%";
		//the bj portrait draw at [200,220] to [480,500]
		vector2 pos = (200,500);
		int resxofs = 900;	//how far the results are printed from the description
		int fonth = interfont.getheight();	//lets keep things civil
		
		// Kills
		pos.y += fonth * 3;
		StatusBarScreen.drawstring(interfont,"Kills: ",pos,0,font.cr_yellow,1.0,scale:(2.0,2.0));
		if (sp_state >= 2)
		{
			string kls = string.format("%4d /%4d (%d%s)",cnt_kills[0],wbs.maxkills,getperc(cnt_kills[0],wbs.maxkills),percchar);
			kls = (cnt_kills[0] >= wbs.maxkills) ? "\cf"..kls : kls;
			
			StatusBarScreen.drawstring(interfont,kls,pos + (resxofs,0),0,alpha:1.0,scale:(2.0,2.0));
		}
			
		
		
		// Items
		pos.y += fonth * 4;
		StatusBarScreen.drawstring(interfont,"Items: ",pos,0,font.cr_yellow,1.0,scale:(2.0,2.0));
		if (sp_state >= 4)
		{
			string itms = string.format("%4d /%4d (%d%s)",cnt_items[0],wbs.maxitems,getperc(cnt_items[0],wbs.maxitems),percchar);//string.format("%4d /%4d",cnt_items[0],wbs.maxitems);
			itms = (cnt_items[0] >= wbs.maxitems) ? "\cf"..itms : itms;
			StatusBarScreen.drawstring(interfont,itms,pos + (resxofs,0),0,alpha:1.0,scale:(2.0,2.0));
		}
		
		
		// Secrets
		pos.y += fonth * 4;
		StatusBarScreen.drawstring(interfont,"Secrets: ",pos,0,font.cr_yellow,1.0,scale:(2.0,2.0));
		if (sp_state >= 6)
		{

			string scs = string.format("%4d /%4d (%d%s)",cnt_secret[0],wbs.maxsecret,getperc(cnt_secret[0],wbs.maxsecret),percchar);//string.format("%4d /%3d",cnt_secret[0],wbs.maxsecret);
			scs = (cnt_secret[0] >= wbs.maxsecret) ? "\cf"..scs : scs;
			StatusBarScreen.drawstring(interfont,scs,pos + (resxofs,0),0,alpha:1.0,scale:(2.0,2.0));
		}
		
		
		// Score
		pos.y += fonth * 4;
		StatusBarScreen.drawstring(interfont,"Score: ",pos,0,font.cr_yellow,1.0,scale:(2.0,2.0));
		if (sp_state >= 8)
		{
			//StatusBarScreen.SS_TEXT_CENTER
			string scr = string.format("%4d",PlayerScore);
			StatusBarScreen.drawstring(interfont,scr,pos + (resxofs,0),0,alpha:1.0,scale:(2.0,2.0));
			
		}
		
		// Time
		pos.y += fonth * 6;
		if (wbs.partime)
		{
			StatusBarScreen.drawstring(interfont,"Time:",pos,0,font.cr_yellow,1.0,scale:(2.0,2.0));
			if(sp_state >= 10)
			{
				string tim = TimeString(cnt_time);
				StatusBarScreen.drawstring(interfont,tim,pos + (500,0),0,alpha:1.0,scale:(2.0,2.0));
				if(wi_showtotaltime)
					StatusBarScreen.drawstring(interfont,"   Total: "..TimeString(cnt_total_time),pos + (resxofs,0),0,alpha:1.0,scale:(2.0,2.0));
			}
				
		}
		
	
	}
	
	ui void drawLevelFinish(vector2 pos)
	{
		string lev = string.format("Level Finished: %s",wbs.thisname);
		StatusBarScreen.drawstring(interfont,lev,pos
		,StatusBarScreen.SS_SCREEN_TOP_CENTER|StatusBarScreen.SS_TEXT_CENTER|StatusBarScreen.SS_NOASPECTCORRECTION
		,scale:(2,2));
		
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	//	helper functions
	////////////////////////////////////////////////////////////////////////////
	
	int getperc(int v1, int v2)
	{
		if(!v2)	//avoid division by 0
			return 100;
		return v1 * 100 / v2;
	}
	
	bool perfectScore()
	{
		return (cnt_kills[0] >= wbs.maxkills
		&& cnt_items[0] >= wbs.maxitems
		&& cnt_secret[0] >= wbs.maxsecret);
	}
	
	//from pb hehe
	private string TimeString(int t)
	{
		t= max(t,0); 
		int h = t/3600; 
		int m = (t/60)%60; 
		int s = t%60;
		if(h) return String.Format("%02d:%02d:%02d",h,m,s);
		return String.Format("%02d:%02d",m,s);
	}
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	//	updating functions
	////////////////////////////////////////////////////////////////////////////
	
	
	ui void updateDeltaTime()
	{
		if(!prevMS)
		{
			prevMS = MSTime();
			return;
		}
		double ftime = MSTime()-prevMS;
		prevMS = MSTime();
		dt = (max(1,ftime)/timedif);
	}
	
	override void Start (wbstartstruct wbstartstruct)
	{
		super.Start(wbstartstruct);
		interfont = font.getfont("BWFONT");
		/*
		muggen = BWInterMug.getnew();
		string lev = wbstartstruct.current;
		if(lev.indexof("BW_") > -1)	//the level name starts with BW_
		{
			
		}
		else	//just display a random one
		{
			muggen.pushframe("graphics/BWPistol1.png");	//0
			muggen.pushframe("graphics/BWPistol2.png");	//1
			muggen.pushframe("graphics/BWPistol3.png");	//2
			muggen.setendframe(2);
		}
		*/
		string baseframe = "graphics/IntermissionScreens/Portraits/";
		muggen = BWInterMug.getnew();
		muggen.setendframe(0); 
		
		switch(random(0,2))
		{
			case 0:
				muggen.pushframe(baseframe.."BWPistol1.png");	//0
				muggen.pushframe(baseframe.."BWPistol2.png");	//1
				muggen.pushframe(baseframe.."BWPistol3.png");	//2
				muggen.setendframe(2);
				break;
			case 1:
				muggen.pushframe(baseframe.."BWSMG1.png");	//0
				muggen.pushframe(baseframe.."BWSMG2.png");	//1
				muggen.pushframe(baseframe.."BWSMG3.png");	//2
				muggen.setendframe(2);
				break;
			case 2:
				muggen.pushframe(baseframe.."BWVictory1.png");	//0
				muggen.pushframe(baseframe.."BWVictory2.png");	//1
				muggen.pushframe(baseframe.."BWVictory2.png");	//2
				muggen.setendframe(2);
				break;
		}
		
	}
	
	//from metadoom
	override void updateStats ()
	{
		if (acceleratestage && sp_state != 12)
		{
			acceleratestage = 0;
			sp_state = 12;
			PlaySound("intermission/nextstage");

			cnt_kills[0] = Plrs[me].skills;
			cnt_items[0] = Plrs[me].sitems;
			cnt_secret[0] = Plrs[me].ssecret;
			cnt_time = Thinker.Tics2Seconds(Plrs[me].stime);
			cnt_par = Thinker.Tics2Seconds(wbs.partime);
			cnt_total_time = Thinker.Tics2Seconds(wbs.totaltime);
		}

		if (sp_state == 2)
		{
			if (intermissioncounter)
			{
				cnt_kills[0] += 2;

				if (!(bcnt&3))
					PlaySound("intermission/tick");
			}
			if (!intermissioncounter || cnt_kills[0] >= Plrs[me].skills)
			{
				cnt_kills[0] = Plrs[me].skills;
				// Play a different sound if you 100%
				if (Plrs[me].skills >= wbs.maxkills)
				{
					PlaySound("intermission/nextstage");
				} else {
					PlaySound("intermission/nextstage");
				}
				sp_state++;
			}
		}
		else if (sp_state == 4)
		{
			if (intermissioncounter)
			{
				cnt_items[0] += 2;

				if (!(bcnt&3))
					PlaySound("intermission/tick");
			}
			if (!intermissioncounter || cnt_items[0] >= Plrs[me].sitems)
			{
				cnt_items[0] = Plrs[me].sitems;
				// Play a different sound if you 100%
				if (Plrs[me].sitems >= wbs.maxitems)
				{
					PlaySound("intermission/nextstage");
				} else {
					PlaySound("intermission/nextstage");
				}
				sp_state++;
			}
		}
		else if (sp_state == 6)
		{
			if (intermissioncounter)
			{
				cnt_secret[0] += 2;

				if (!(bcnt&3))
					PlaySound("intermission/tick");
			}
			if (!intermissioncounter || cnt_secret[0] >= Plrs[me].ssecret)
			{
				cnt_secret[0] = Plrs[me].ssecret;
				// Play a different sound if you 100%
				if (Plrs[me].ssecret >= wbs.maxsecret)
				{
					PlaySound("intermission/nextstage");
				} else {
					PlaySound("intermission/nextstage");
				}
				sp_state++;
			}
		}
		else if (sp_state == 8)
		{
			// score count
			if(intermissioncounter)
			{
				playerScore = min(PlayerScore + 100, Players[consoleplayer].mo.score);
				if (!(bcnt&3))
					PlaySound("intermission/tick");
				console.printf("counting score");
			}
				
			if(!intermissioncounter || playerScore >= Players[consoleplayer].mo.score)
			{
				PlaySound("intermission/nextstage");
				sp_state++;
			}
		}
		
		// This bit is largely untouched logic-wise, except for advancing the
		// state number.
		else if (sp_state == 10)
		{
			if (intermissioncounter)
			{
				if (!(bcnt&3))
					PlaySound("intermission/tick");

				cnt_time += 3;
				cnt_par += 3;
				cnt_total_time += 3;
			}

			int sec = Thinker.Tics2Seconds(Plrs[me].stime);
			if (!intermissioncounter || cnt_time >= sec)
				cnt_time = sec;

			int tsec = Thinker.Tics2Seconds(wbs.totaltime);
			if (!intermissioncounter || cnt_total_time >= tsec)
				cnt_total_time = tsec;

			int psec = Thinker.Tics2Seconds(wbs.partime);
			if (!intermissioncounter || cnt_par >= psec)
			{
				cnt_par = psec;

				if (cnt_time >= sec)
				{
					cnt_total_time = tsec;
					PlaySound("intermission/nextstage");
					sp_state++;
				}
			}
		}
		else if (sp_state == 12)
		{
			if (acceleratestage)
			{
				PlaySound("intermission/paststats");
				initShowNextLoc();
			}
		}
		else if (sp_state & 1)
		{
			if (!--cnt_pause)
			{
				sp_state++;
				cnt_pause = Thinker.TICRATE;
			}
		}
	}
	
	
}



//
//	the thing that handles the portrait animations with code
//
Class BWInterMug ui
{
	array <textureID> texs;
	int curframe,endframe;
	int tick, framedur;
	bool onend;
	
	const singleframedur = 20;
	
	static BWInterMug getnew()
	{
		let n = new("BWInterMug");
		n.framedur = singleframedur;
		return n;
	}
	
	void setend()
	{
		onend = true;
		curframe = endframe;
	}
	
	void setendframe(int f)
	{
		endframe = f;
	}
	
	void pushframe(string tx)
	{
		let fm = texman.checkfortexture(tx);
		if(fm.isvalid())
			texs.push(fm);
	}
	
	
	ui void tickmug()
	{
		tick++;
		framedur--;
		if(framedur <= 0)
		{
			framedur = singleframedur;
			curframe++;
			if(curframe > texs.size())
				curframe = 0;
			if(curframe == endframe && !onend)
				curframe = 0;
		}
	}
	
	ui void drawmug(vector2 pos, vector2 size, double Alpha)
	{
		if(curframe >= texs.size())
			return;
		
		StatusBarScreen.DrawTexture(texs[curframe],pos,StatusBarScreen.SS_ABS_SIZE,Alpha,size);
		//screen.drawtexture(texs[curframe],false,pos.x,pos.y,DTA_DestWidthF,size.x,DTA_DestHeightF,size.y);
	}
}