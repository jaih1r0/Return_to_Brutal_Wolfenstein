
Class BW_MainMenu : BW_ZF_ListMenu
{
	
	override void init(Menu parent, ListMenuDescriptor desc)
	{
			super.init(parent, desc);
			
			vector2 SCN = (800,600);//(640,480); 
			setbaseresolution(SCN);
			//normal	-	Credits: Kenney
			let box2 = BW_ZF_BoxTextures.createTextureNormalized("graphics/Menu/bgboxa.png",(0.25,0.25),(0.75,0.75),true,true);
			
			//if(gamestate & GS_TITLELEVEL  != 0)
			//{
			//
			//}
			
			let cmd = new("BW_MainMenuHandler");
			cmd.destmen = self;
			
			font bwfon = font.getfont('BWFONT');
			
			vector2 initpos = (SCN.x / 64,SCN.y / 12);
			vector2 butsize = (150,50);
			vector2 titlepatchItemsize = (180,100);
			vector2 bgsize = butsize;
			vector2 bgpos = initpos;
			
			bgback = BW_ZF_BoxImage.create(initpos, bgsize, box2,scale:(1, 1));
			bgback.setalpha(0.0);
			bgback.pack(mainframe);
			
			BW_ZF_Element head,tail;
			
			for(int i=0; i < mDesc.mItems.Size(); i++)
			{
				ListMenuItem item = mDesc.mItems[i];
				if(item is 'ListMenuItemTextItem')
				{
					let textitem = ListMenuItemTextItem(item);
					let butto = BW_ZF_Button.create(initpos,butsize,textitem.mText
					,cmd,"activate:"..i,inactive:null,hover: null,click: null, disabled: null
					,bwfon,0.7);
					butto.pack(mainframe);
					initpos.y += butsize.y + 5;
					bgsize.y += butsize.y - 3; //- 2.5;
					
					if(!head)
					{
						head = butto;
					}
					if(tail)
					{
						butto.setFocusNeighbor(BW_ZF_NavEventType_Up,tail);
						tail.setFocusNeighbor(BW_ZF_NavEventType_Down,butto);
						tail = butto;
					}
					
					if(!tail)
						tail = butto;
						
					if(i == mDesc.mSelectedItem)		//this element was selected previously
						setfocus(butto,BW_ZF_NavEventType_Tab);
				}
				
				
				if(item is "ListMenuItemStaticPatchSplash")
				{
					
					let gpatch = ListMenuItemStaticPatch(item);
					string texnam = texman.getname(gpatch.mtexture);
					
					let [xw,yh] = texman.getsize(gpatch.mtexture);
					vector2 scl = (titlepatchItemsize.x / xw , titlepatchItemsize.y / yh); 
					
					let titlepatch = BW_ZF_Image.create(initpos,titlepatchItemSize,texnam,imageScale:scl);
					titlepatch.pack(mainframe);
					
					//slpashes
					string splnum = stringtable.localize("$BW_Number_of_Splashes");
					int splashes = splnum.toint();
					string Splash = "$BWSplash"..random(1,splashes);
					
					SplashLabel = BW_ZF_Label.create(initpos + (titlepatchItemSize.x / 2,titlepatchItemSize.y * 0.9)
					,(500,30),text: stringtable.localize(splash), fnt:bwfon,wrap:false,textScale:0.62,textColor:font.cr_yellow);
					
					SplashLabel.pack(mainframe);
					
					
					initpos.y += titlepatchItemSize.y + 30;
					bgpos.y += titlepatchItemSize.y + 30;
				}
				
				
				
			}
			
			if(head && tail)
			{
				head.setFocusNeighbor(BW_ZF_NavEventType_Up,tail);
				tail.setFocusNeighbor(BW_ZF_NavEventType_Down,head);
				
				focusDefaults[BW_ZF_NavEventType_Down] = head;
				focusDefaults[BW_ZF_NavEventType_Up] = tail;
				
				//setfocus(head,BW_ZF_NavEventType_Tab);
			}
			
			
			bgback.setbox(bgpos,bgsize);
			
			
			
			
	}
	
	override void setupFocusIndicator()
	{
		let focusBox = BW_ZF_BoxTextures.createTextureNormalized ("Graphics/Menu/foc_us.png",
		(0.25, 0.25),(0.75, 0.75),true,true);
		
		let focusBox2 = BW_ZF_BoxTextures.createTextureNormalized ("Graphics/Menu/foc_usi.png",
		(0.25, 0.25),(0.75, 0.75),true,true);
		
		let bw = BWFocuser.Create((0,0),(0,0),focusBox, focusBox2);
		setFocusIndicator(bw);	//(BW_ZF_BoxImage.create((0, 0), (0, 0), focusBox));
		setFocusPriority(BW_ZF_FocusPriority_JustAboveFocused);
	}
	
	override void positionFocusIndicator(Vector2 pos, Vector2 size)
	{
		double prog = BW_Statics.linearmap(focusedTics,0,7,0.0,1.0,true);
		
		getFocusIndicator().setalpha(prog);
		BWFocuser(getfocusindicator()).prog = prog;
		
		getFocusIndicator().setBox(pos, size);
	}
	
	override void changeFocusIndicator(BW_ZF_Element oldFocus, BW_ZF_Element newFocus)
	{
		if(oldfocus && oldfocus is "BW_ZF_Button")
			BW_ZF_Button(oldfocus).settextcolor(font.cr_white);
		
		if(newfocus && newfocus is "BW_ZF_Button")
			BW_ZF_Button(newfocus).settextcolor(font.cr_yellow);
		
		if(!oldfocus && newfocus ||oldfocus && newfocus && oldfocus != newfocus)
		{
			menusound("menu/cursor");
			focusedtics = 0;
		}
	}
	
	double sinner;
	BW_ZF_Label SplashLabel;
	BW_ZF_Element prevFocus;
	BW_ZF_BoxImage bgback;
	
	override void ticker()
	{	
		super.ticker();
		SplashLabel.settextscale(SplashLabel.gettextscale() + sin(sinner) * 0.002);
	}
	
	
	override void drawer()
	{
		
		super.drawer();
		
		sinner = (sinner + dt * 5) % 360;
		
		bgback.setalpha(BW_Statics.linearmap(openedtics,0,15.0,0,0.75,true));
		
		
	}
	
}



Class BW_MainMenuHandler : BW_ZF_Handler
{
	BW_MainMenu destmen;
	override void buttonClickCommand(BW_ZF_Button caller, Name command)
	{
		array<string> cm;
		string com = command;
		com.split(cm,":");
		if(cm[0] == "activate")
		{
			destmen.menusound("menu/advance");
			int indx = cm[1].toint();
			if(indx < destmen.mdesc.mItems.size())
			{
				destmen.mdesc.mSelectedItem = indx;
				destmen.mdesc.mItems[indx].activate();
			}
		}
		
	}
	
	Override void ElementHoverChanged(BW_ZF_Element caller, Name command, bool unhovered)
	{
		if(unhovered)
			return;
		destmen.SetFocus(caller,BW_ZF_NavEventType_Tab);
	}
}





//dummy class, used in the menudef to indicate this thing should draw the splashtext
Class ListMenuItemStaticPatchSplash : ListMenuItemStaticPatch
{	
}



