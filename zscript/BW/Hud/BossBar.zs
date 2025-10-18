Class BW_BossBarHandler : eventhandler
{
    textureID bossPortrait,bossPortrait_Angry;
    int maxHP, stopTimer, presentationTimer;
    dynamicvalueinterpolator curHP;
    bool inUse, validPortrait, validPortrait2;
    Actor curBoss;
    string presentation;
    Font useFont;
    const fadeStopTimer = TICRATE;
    transient ui cVar scaler;
    int portdimx,portdimy;

    override void worldloaded(worldevent e)
    {
        curHP = DynamicValueInterpolator.create(0,10,1,100);
        useFont = font.findfont("BWFONT");//smallfont;
    }

    override void worldTick()
    {
        if(!inuse)
            return;
        if(!curBoss)
            return;
        curHP.update(curBoss.health);

        if(curBoss.health < 1)
            stopTimer++;
        if(stopTimer > fadeStopTimer)
            inuse = false;
        if(presentationTimer > 0) //let the presentation string float for some time
            presentationTimer--;
    }

    override void renderoverlay(renderevent e)
    {
        if(!e.camera)
            return;
        if(!inUse)
            return;
        if(!scaler)
            scaler = CVar.GetCVar("BW_BossBarScale", e.camera.player);
        
        //general things
        vector2 screenSize = (screen.getwidth(),screen.getheight());
        vector2 drawpos = (screensize.x / 2,screensize.y / 10);

        double alfa = BW_Statics.LinearMap(stopTimer,0,fadeStopTimer,1.0f,0.0f);

        double scaless = scaler.getfloat(); //2.f;   //might turn this into a cvar //effectively, turned it into a cvar

        int vfontsize = useFont.GetHeight();
        

        int curHealth = curHP.getvalue();
        string curval = string.format("%d / %d",curHealth,maxHP);
        int curvalsize = useFont.StringWidth(curval); //this is used to center this string
        
        bool critical = curBoss.health < (maxHP * 0.25);   

        //health in numbers
        int healthCol = critical ? Font.CR_RED : Font.CR_YELLOW;
        screen.drawtext(useFont,healthCol,drawpos.x - ((curvalsize/2) * scaless),drawpos.y,curval,DTA_Alpha,alfa,
        DTA_ScaleX,scaless,DTA_ScaleY,scaless);

        //the introduction string of the boss
        if(presentation != "" && presentationTimer)
        {
            int pressize = useFont.StringWidth(presentation); //presentation.CodePointCount();
            screen.drawtext(useFont,Font.CR_ORANGE,drawpos.x - ((pressize/2) * scaless),drawpos.y - (vfontsize * scaless),
            presentation,DTA_Alpha,alfa,DTA_ScaleX,scaless,DTA_ScaleY,scaless);
        }
        else    //the actual boss name
        {
            string tagg = curBoss.gettag();
            int bosstxs = useFont.StringWidth(tagg);
            screen.drawtext(useFont,Font.CR_ORANGE,drawpos.x - ((bosstxs/2) * scaless),drawpos.y - (vfontsize * scaless),
            tagg,DTA_Alpha,alfa,DTA_ScaleX,scaless,DTA_ScaleY,scaless);
        }

        int fullBarW = 200;
        int fullBarH = 8;
        int thick = 1;
        thick *= scaless;
        fullBarH *= scaless;
        fullBarW *= scaless;
        

        vector2 startbarpos = (drawpos.x - fullbarW/2, drawpos.y + (20 * scaless) - fullbarH/2);

        //the background bar
        
        screen.Dim(0x0B0303, alfa * 0.75f, startbarpos.x, startbarpos.y, fullBarW, fullBarH,STYLE_Translucent);

        int fillbar = BW_Statics.LinearMap(curHP.getvalue(),0,maxHP,0,fullBarW);

        //the actual health bar indicator
        screen.Dim(0xE4080A, alfa, startbarpos.x, startbarpos.y, fillbar, fullBarH,STYLE_Translucent);

        //pseudo light
        screen.Dim(0xFE3335, alfa, startbarpos.x, startbarpos.y, fillbar, fullBarH / 4,STYLE_Translucent);
        //pseudo shadow
        screen.Dim(0xBC0204, alfa, startbarpos.x, startbarpos.y + (3*fullbarH/4), fillbar, fullBarH / 4,STYLE_Translucent);

        //the border of the bar
        int alfaofthisthing = 255 * alfa;   //so the frame fades with the rest of the bar
        color framecol = color(alfaofthisthing,223,197,123); //0xFFDFC57B
        //framecol.A = alfaofthisthing;
        screen.DrawLineFrame(framecol, startbarpos.x, startbarpos.y, fullBarW, fullBarH, thick);//,int(255 * alfa));

        if(validPortrait)
        {
            vector2 portpos = startbarpos;
            vector2 desSize = (30,30);
            desSize *= scaless;
            //portpos -= (portdimx * scaless);
            portpos.x -= desSize.x + (4 * scaless);
            portpos.y -= desSize.Y + (2 * scaless);
            
            screen.Dim(critical ? 0xE4080A : 0x5DE2E7, alfa, portpos.x, portpos.y, desSize.x,desSize.y,STYLE_Translucent);

            screen.drawtexture((critical && validPortrait2) ? bossPortrait_Angry : bossPortrait,
                false,
                portpos.x,portpos.y,
                DTA_TopLeft,true,DTA_Alpha,alfa,
                DTA_DestWidth,int(desSize.x),DTA_DestHeight,int(desSize.y));
            
            screen.DrawLineFrame(framecol,portpos.x,portpos.y,desSize.x,desSize.y,1);
        }

    }

    static void RequestInitBossBar(bossbarinfo bbi, actor bosstoCheck)
    {
        if(!bbi.ready || !bosstoCheck)
            return;
        let ev = BW_BossBarHandler(eventhandler.find("BW_BossBarHandler"));
		if(!ev)
			return;
        ev.bossPortrait = texman.checkfortexture(bbi.portrait);
        ev.presentation = bbi.presentation;
        ev.maxHP = bbi.maxhp;
        ev.curBoss = bosstoCheck;
        ev.inUse = true;
        ev.stopTimer = 0;
        ev.presentationTimer = TICRATE * 3;
        ev.validPortrait = ev.bossPortrait.IsValid() && bbi.portrait != "TNT1A0";
        /*if(ev.validPortrait)
        {
            //console.printf("valid texture "..bbi.portrait);
            int xx,yy;
            [xx,yy] = texman.getsize(ev.bossPortrait);
            ev.portdimx = xx;
            ev.portdimy = yy;
        }*/

        ev.bossPortrait_Angry = texman.checkfortexture(bbi.angryPortrait);
        ev.validPortrait2 = ev.bossPortrait_Angry.IsValid() && bbi.angryPortrait != "TNT1A0";
        
    }

}