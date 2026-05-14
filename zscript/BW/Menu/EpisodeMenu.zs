class episInfoGrab ui
{
	string displayname;
	string patch;
	int epinum;
}

Class BWSkillInfoGrab ui
{
	string displayName;
	string Description;
	string Pic;
	int skillpos;
	
	static BWSkillInfoGrab from(string names, string descr, string pic, int pos)
	{
		let n = new("BWSkillInfoGrab");
		n.displayname = names;
		n.description = descr;
		n.pic = pic;
		n.skillpos = pos;
		return n;
	}
	
}

//
//	the episodemenu replacer
//

class BW_Epismenu : BW_ZF_Listmenu
{
	array<episInfoGrab> episodes;
	array<BWSkillInfoGrab> skils;
	override void Init(Menu parent, ListMenuDescriptor desc)
	{
		Super.Init(parent,desc);
		
		
		vector2 SCN = (800,600);
		setbaseresolution(SCN);
		
		font bwfon = font.getfont('BWFONT');
		
		let cmd = new("BW_EpiSkillHandler");
		cmd.destmen = self;
		
		
		//
		//	we start with random bs to get the episodes
		//
		for(int i = 0; i < desc.mItems.size(); i++)
		{
			let epis = new("episInfoGrab");
			ListMenuItem item = desc.mItems[i];			
			
			if(item is 'ListMenuItemTextItem')
			{
				let textitem = ListMenuItemTextItem(item);
				epis.displayname = textitem.mText;
			}
			
			if(item is 'ListMenuItemPatchItem')
			{
				let itmp = ListMenuItemPatchItem(item);
				epis.patch = texman.getname(itmp.mTexture);
			}
			
			if(epis.displayname != "" || epis.patch != "")
			{
				epis.epinum = i;
				episodes.push(epis);
			}
			
		}
		
		let ev = BWMenuStaticInfo(staticeventhandler.find("BWMenuStaticInfo"));
		if(!ev)		//this shouldnt happen, cuz the search is done at engine start
		{
			BW_ZF_Label FailLabel = BW_ZF_Label.create((35,20)
			,(200,40),text: "Something went Wrong", fnt:bwfon,wrap:true,textScale:1.2,textColor:font.cr_yellow);
			FailLabel.pack(mainframe);
			
			let buttoFail = BW_ZF_Button.create((70,100),(100,50),"Start Anyways"
			,cmd,"Start",inactive:null,hover: null,click: null, disabled: null
			,bwfon,0.7);
			setfocus(buttoFail,BW_ZF_NavEventType_Tab);
			buttoFail.pack(mainframe);
			return;
		}
		for(int i = 0; i < ev.episinfo.size(); i++)
		{
			for(int j = 0; j < episodes.size(); j++)
			{
				if(episodes[j].displayName != "")
					continue;
				if(episodes[j].patch != "" && episodes[j].patch == ev.episinfo[i].patch)
				{
					episodes[j].displayname = ev.episinfo[i].displayname;
				}
			}
		}
		
		array<episInfoGrab> temp;
		for(int i = 0; i < episodes.size(); i++)
		{
			if(episodes[i].displayname != "") //&& episodes[i].patch != "")
			{
				temp.push(episodes[i]);	//only save the ones with a name
				if(episodes[i].displayName == "Escape from Wolfenstein")
					bwmap = i;
			}	
		}
		
		episodes.clear();
		episodes.move(temp);
		
		
		///////////////////////////////////////////////////////////////////////
		//
		//	Here we FINALLY start with the actual menu
		//
		///////////////////////////////////////////////////////////////////////
		
		
		vector2 initpos = (SCN.x / 64,SCN.y / 12);
		vector2 initposer = initpos + (0,30);
		vector2 butsize = (200,50);
		initpos.y += butsize.y;
		vector2 infoboxPos;
		vector2 infoboxSize = (380,400);
		
		//normal
		let box2 = BW_ZF_BoxTextures.createTextureNormalized("graphics/Menu/bgboxa2.png",(0.25,0.25),(0.75,0.75),true,true);
		//hover
		let box3 = BW_ZF_BoxTextures.createTextureNormalized("graphics/Menu/bgboxb.png",(0.25,0.25),(0.75,0.75),true,true);
		//click
		let box4 = BW_ZF_BoxTextures.createTextureNormalized("graphics/Menu/bgboxc.png",(0.25,0.25),(0.75,0.75),true,true);
		//disabled
		let box5 = BW_ZF_BoxTextures.createTextureNormalized("graphics/Menu/bgboxd.png",(0.25,0.25),(0.75,0.75),true,true);
		
		
		
		//choose episode label
		BW_ZF_Label TitleLabel = BW_ZF_Label.create(initposer
		,(200,40),text: "Choose Episode", fnt:bwfon,wrap:true,textScale:1.2,textColor:font.cr_yellow);
		TitleLabel.pack(mainframe);
		
		
		//keep track of the first and last element
		BW_ZF_Element head,tail;
		
		
		//
		//create the droplist
		//
		
		selEpis = 0;	//set the selected episode by default to 0
		if(mDesc.mSelectedItem < Episodes.size())
			selEpis = mDesc.mSelectedItem; //if theres a valid one already selected, set it here
		
		list1 = new("BW_ZF_DropdownItems");
		for(int i = 0; i < episodes.size(); i++)
		{
			list1.items.push(episodes[i].displayname);
		}
		
		vector2 dlistsize = (200,30);
		let dlist = BW_ZF_DropdownList.create(initpos,dlistsize,list1,fnt:bwfon,textScale:0.6,
		textColor:Font.CR_WHITE,
		boxBg: box2, listBg:box3,highlightBg: box4,
		dropTex:"dropsel", defaultSelection: selEpis,cmdHandler:cmd,command:'Epis',
		bindingFrame:NULL);
		dlist.pack(mainframe);
		initpos.x += dlistsize.x + 10;
		
		infoboxPos = (initpos.x + butsize.x + 10, initpos.y);
		
		
		//start the snake
		head = dlist;
		tail = dlist;
		
		
		//the choose skill label
		BW_ZF_Label SkillLabel = BW_ZF_Label.create((initpos.x,initposer.y)
		,(200,40),text: "Choose Skill", fnt:bwfon,wrap:true,textScale:1.2,textColor:font.cr_yellow);
		SkillLabel.pack(mainframe);
		
		
		
		//fallback
		if(ev._skillinfo.size() < 1)
		{
			TitleLabel.destroy();
			dlist.destroy();
			SkillLabel.destroy();
			BW_ZF_Label FailLabel = BW_ZF_Label.create((35,20)
			,(200,40),text: "Something went Wrong", fnt:bwfon,wrap:true,textScale:1.2,textColor:font.cr_yellow);
			FailLabel.pack(mainframe);
			
			let buttoFail = BW_ZF_Button.create((70,100),(100,50),"Start anyways"
			,cmd,"Start",inactive:null,hover: null,click: null, disabled: null
			,bwfon,0.7);
			setfocus(buttoFail,BW_ZF_NavEventType_Tab);
			buttoFail.pack(mainframe);
			return;		//shouldnt happen, i think
		}
				
		
		//
		//Here we set the Skill selector Buttons, only one can be active at a time
		//
		butsize = (50,70);
		vr = new("BW_ZF_RadioController");
		for(int i = 0; i < ev._skillInfo.size(); i++)
		{
			
			skils.push(BWSkillInfoGrab.from(ev._skillInfo[i].displayname,ev._skillInfo[i].description,ev._skillInfo[i].pic,i));
			
			vector2 ipos = initpos + (butsize.x, 0);
			
			let radb = BW_ZF_RadioButton.create(ipos,butsize,vr,i
			,inactive:box2,hover:box3,click:box4,disabled:box5
			,text:"" //ev._skillInfo[i].displayname
			,fnt:bwfon,textScale:0.80,cmdHandler:cmd,command:"Skill");
			radb.pack(mainframe);
			
			//the actual image of the skill
			string locater = "$BWDIFIC_"..cleartosearch(ev._skillInfo[i].displayname);
			string imgsearch = stringtable.localize(locater);
			if(imgsearch == locater)	//not defined
				imgsearch = "dif3";
			
			let texid = texman.checkfortexture(imgsearch);
			let [wd,hg] = texman.getsize(texid);
			
			vector2 scal = ((butsize.x * 0.9) / wd, (butsize.y * 0.9) / hg);
			
			let img = BW_ZF_Image.create(
			ipos + (butsize.x * 0.05,butsize.y * 0.05)		//correctly center it 
			,butsize
			, image: imgsearch
			,alignment:BW_ZF_ELEMENT.AlignType_TopLeft,imageScale: scal);
			img.setDontBlockMouse(true);
			img.pack(mainframe);
			
			initpos.y += butsize.y + 5;
			
			
			
			if(!head)
			{
				head = radb;
			}
			if(tail)
			{
				radb.setFocusNeighbor(BW_ZF_NavEventType_Up,tail);
				tail.setFocusNeighbor(BW_ZF_NavEventType_Down,radb);
				tail = radb;
			}
					
			if(!tail)
				tail = radb;
						
			radb.setFocusNeighbor(BW_ZF_NavEventType_Left,dlist);
			radb.setFocusNeighbor(BW_ZF_NavEventType_Right,dlist);
			
			if(!i)
			{
				dlist.setFocusNeighbor(BW_ZF_NavEventType_Right,radb);
				dlist.setFocusNeighbor(BW_ZF_NavEventType_Left,radb);
			}
			
			
			
		}
		
		selSkill = 2;
		vr.curval = selSkill;
		
		butsize = (200,50);
		initpos.y += dlistsize.y;
		initpos.x -= dlistsize.x + 10;
		
		//
		//start game button
		//
		let butto = BW_ZF_Button.create(initpos,butsize,"Start Game"
		,cmd,"Start",inactive:box2,hover: box3,click: box4, disabled: box5
		,bwfon,0.7);
		butto.pack(mainframe);
		
		butto.setFocusNeighbor(BW_ZF_NavEventType_Up,tail);
		tail.setFocusNeighbor(BW_ZF_NavEventType_Down,butto);
		tail = butto;
		
		//
		//back/exitmenu button
		//
		let exitbut = BW_ZF_Button.create(initpos + (butsize.x + 5,0),butsize,"Back"
		,cmd,"GoBack",inactive:box5,hover: box3,click: box4, disabled: box5
		,bwfon,0.7);
		exitbut.pack(mainframe);
		
		exitbut.setFocusNeighbor(BW_ZF_NavEventType_Up,tail);
		tail.setFocusNeighbor(BW_ZF_NavEventType_Down,exitbut);
		tail = exitbut;
		
		butto.setFocusNeighbor(BW_ZF_NavEventType_Right,exitbut);
		exitbut.setFocusNeighbor(BW_ZF_NavEventType_Left,butto);
		
		//button selection loop, the last element redirects to the first
		//basically, a snake eating its tail
		if(head && tail)
		{
			head.setFocusNeighbor(BW_ZF_NavEventType_Up,tail);
			tail.setFocusNeighbor(BW_ZF_NavEventType_Down,head);
			focusDefaults[BW_ZF_NavEventType_Down] = head;
			focusDefaults[BW_ZF_NavEventType_Up] = tail;
			
			setfocus(head,BW_ZF_NavEventType_Tab);
		}
		
		
		BW_ZF_Label LevelInfLabel = BW_ZF_Label.create((infoboxpos.x,initposer.y)
		,(200,40),text: "Level info", fnt:bwfon,wrap:true,textScale:1.2,textColor:font.cr_yellow);
		LevelInfLabel.pack(mainframe);
		
		//this is the part that provides info about episodes and skills
		//this way we dont need the mustconfirm menu
		let infobg = BW_ZF_BoxImage.create(infoboxpos, infoboxsize, box2);
		infobg.pack(mainframe);
		
		infopanelLabel = BW_ZF_Label.create(infoboxpos + (10,10)
		,infoboxsize - (30,30),text: "Choose an episode!", fnt:bwfon,wrap:true,textScale:0.8,textColor:font.cr_white);
		infopanelLabel.pack(mainframe);
		
		updateLevelInfoLabel(true,true);	//fill the label 
		
		
	}
	
	int selEpis;
	int selSkill;
	int bwmap;
	BW_ZF_RadioController vr;
	BW_ZF_DropdownItems list1;
	BW_ZF_Label infopanelLabel;
	string difInfo, skilInfo;
	
	override void setupFocusIndicator()
	{
		let focusBox = BW_ZF_BoxTextures.createTextureNormalized ("Graphics/Menu/foc_us.png",
		(0.25, 0.25),(0.75, 0.75),true,true);
		
		let focusBox2 = BW_ZF_BoxTextures.createTextureNormalized ("Graphics/Menu/foc_usi.png",
		(0.25, 0.25),(0.75, 0.75),true,true);
		
		let bw = BWFocuser.Create((0,0),(0,0),focusBox, focusBox2);
		setFocusIndicator(bw);
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
		if(!oldfocus && newfocus ||oldfocus && newfocus && oldfocus != newfocus)
		{
			menusound("menu/cursor");
			focusedtics = 0;
		}
	}
	
	//called everytime the skill or episode changes
	void updateLevelInfoLabel(bool updateEpisode, bool updateSkill)
	{
		if(updateEpisode || difInfo == "")	
		{
			if(selEpis > -1)
				difInfo = "Current mission: \cf"..stringtable.localize(Episodes[selEpis].displayname).."\c-\n\n";
			else
				difInfo = "Current mission: \cbUnselected\c-\n\n";
		}
		
		if(updateSkill || skilInfo == "")
			skilInfo = string.format("\nCurrent skill: \cf%s\c-: \n\n\cg%s \n",skils[selSkill].displayname,skils[selSkill].description);
		
		infopanelLabel.settext(string.format("%s%s",difInfo,skilInfo));
	}
	
	//strip any non letter, maybe theres a better way to do this and im just lazy
	string cleartosearch(string tx)
	{
		int len = tx.length();
		int it;
		string ret;
		while(it < len)
		{
			let [chr, next] = tx.GetNextCodePoint(it);
			
			if(isLetter(chr))
				ret.appendformat("%c",chr);
			
			it = next;
		}
		return ret;
	}
	
	bool isLetter(int c)
	{
		return (c <= 122 && c >= 97) //lower
		|| (c <= 90 && c >= 65); //upper
	}
	
}


class BW_EpiSkillHandler : BW_ZF_Handler
{
	BW_Epismenu destmen;
	int destEpisode;
	int destSkill;
	
	Override void ElementHoverChanged(BW_ZF_Element caller, Name command, bool unhovered)
	{
		if(unhovered)
			return;
		destmen.SetFocus(caller,BW_ZF_NavEventType_Tab);
	}
	
	override void radioButtonChanged(BW_ZF_RadioButton caller, Name command, BW_ZF_RadioController variable)
	{
		if(command == "skill")
		{
			destmen.selSkill = variable.curval;
			destmen.MenuSound("menu/advance");
			destmen.updateLevelInfoLabel(false,true);
		}
	}
	
	override void dropdownChanged(BW_ZF_DropdownList caller, Name command)
	{
		if(command == 'Epis')
		{	
			destmen.selEpis = caller.getselection();
			destmen.mDesc.mSelectedItem = destmen.selEpis;
			destmen.MenuSound("menu/advance");
			destmen.updateLevelInfoLabel(true,false);
			
		}
	}
	
	override void buttonClickCommand(BW_ZF_Button caller, Name command)
	{
		if(command == 'Start')
		{
			
			if(destmen.selEpis > destmen.Episodes.size() || destmen.selEpis < 0)
			{
				console.printf("\cgInvalid episode selected. cant start game");
				destmen.menusound("menu/backup");
				return;
			}
			if(destmen.selSkill > destmen.skils.size() || destmen.selSkill < 0)
			{
				destmen.menusound("menu/backup");
				console.printf("\cgInvalid Skill Selected. cant start game");
				return;
			}
			
			//console.printf("\cdNEW GAME SKILL: %d [%s]",skl,destmen.skils[skl].displayname);
			//,destmen.bwmap + destmen.selEpis
			destmen.MenuSound("menu/advance");
			destmen.startgamedirect(true,false,PlayerClasses[0].type.getclassname(),destmen.selEpis,destmen.selSkill);
		}
		else if(command == 'GoBack')
		{
			destmen.menusound("menu/close");
			destmen.close();
		}
	}
}