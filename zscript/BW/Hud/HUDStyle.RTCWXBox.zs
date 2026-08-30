Extend Class BW_Hud
{
	void DrawRTCWXBoxHUD()
	{
		if(NoHud)
			return;
		let pl = Cplayer.mo;

		//health
		int hl = DV_Health.getvalue();//pl.health;
		//drawstring(BWFont,formatnumber(hl),(45,-40),DI_SCREEN_LEFT_BOTTOM | DI_TEXT_ALIGN_CENTER,healthcol);
		DrawBar("Graphics/HUD/RTCWXBox/Health100.png", "Graphics/HUD/RTCWXBox/Health.png", hl, 100, (50,-50), 0, SHADER_VERT | SHADER_REVERSE, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, 1);
		if(hl > 100)
			DrawBar("Graphics/HUD/RTCWXBox/Health200.png", "Graphics/HUD/RTCWXBox/Health100.png", hl-100, 100, (50,-50), 0, SHADER_VERT | SHADER_REVERSE, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, 1);
		//mugshot
		//let mg = getmugshot(5);
		//drawtexture(mg,(42,-45),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_CENTER_BOTTOM,1.0,(-1,-1),(2.0,2.0));//,DI_SCREEN_CENTER_BOTTOM|DI_ITEM_BOTTOM);
		//armor
		int amm = DV_Armor.getvalue();//GetArmorAmount();
		if(amm > 0)
		{
			//drawstring(BWFont,formatnumber(amm),(135,-40),DI_SCREEN_LEFT_BOTTOM | DI_TEXT_ALIGN_CENTER,Font.CR_YELLOW);
			TextureID armi;
			vector2 amivec;
			let ba = pl.findinventory("BasicArmor");
			[armi,amivec] = GetIcon(ba,0);
			//drawTexture(armi,(135,-45),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_CENTER_BOTTOM,1.0,(60,60),(4.0,4.0));
			DrawBar("Graphics/HUD/RTCWXBox/Armor100.png", "Graphics/HUD/RTCWXBox/ArmorEmpty.png", amm, 100, (100,-50), 0, SHADER_VERT | SHADER_REVERSE, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, 1);
			if(amm>100)
				DrawBar("Graphics/HUD/RTCWXBox/Armor200.png", "Graphics/HUD/RTCWXBox/Armor100.png", amm-100, 100, (100,-50), 0, SHADER_VERT | SHADER_REVERSE, DI_SCREEN_LEFT_BOTTOM | DI_ITEM_CENTER, 1);
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
				drawstring(BWFont,""..stam..am1,(-75,-60),DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT);
				TextureID armi;
				vector2 amivec;
				[armi,amivec] = GetIcon(Primary,0);
				drawTexture(armi,(-50,-55),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER,1.0,(40,40),amivec * 2);
				//[Pop] This one is the Ammo Reserve icon
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
				drawstring(BWFont,""..stam..am2.."\ck/",(-115,-60),DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT,Font.CR_YELLOW);
				TextureID armi;
				vector2 amivec;
				[armi,amivec] = GetIcon(Secondary,0);
				//drawTexture(armi,(-80,-45),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER,1.0,(40,40),amivec * 2);
				//[Pop] This one is the Ammo in Gun icon
			}

			//
			bool isAkimbo;
			if(cplayer.readyweapon is "BW_DualWeapon")
			{
				if(BW_DualWeapon(cplayer.readyweapon).Hud_IsAkimbo())
				{
					isAkimbo = true;
					int am2 = DV_LeftAmmo.getvalue();	//Secondary.amount;
					int max2 = BW_DualWeapon(cplayer.readyweapon).Ammoleft.maxamount;
					string stam = "\ck";
					if(am2 < max2)
						stam = "\cj";
					if(am2 < 1)
						stam = "\ca";
					drawstring(BWFont,""..stam..am2.."\ck/",(-150,-60),DI_SCREEN_RIGHT_BOTTOM | DI_TEXT_ALIGN_RIGHT,Font.CR_YELLOW);
				}
			}
			
			
			//grenades
			int GrenadeCount = CPlayer.mo.CountInv("BW_GrenadeAmmo");
			for (GrenadeCount > 0; GrenadeCount--;)
			{
				DrawImage("GRNDA", (-140 + (GrenadeCount * -5), -25), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER);
			}
			
			//axes
			int AxeCount = CPlayer.mo.CountInv("BW_AxeAmmo");
			for (AxeCount > 0; AxeCount--;)
			{
				DrawImage("IZRAS", (-90 + (AxeCount * -5), -25), DI_SCREEN_RIGHT_BOTTOM | DI_ITEM_CENTER);
			}
			
			//weapon image
			textureid wimg;	vector2 wimgsc;
			[wimg,wimgsc] = geticon(cplayer.readyweapon,DI_SKIPICON|DI_SKIPALTICON);
			if(cplayer.readyweapon.GetTag() != "Melee") //[Pop] Dont draw if its melee, no point in naming your fists aye?
			{
				if(wimg.isvalid())
				{
					drawtexture(wimg,(-115,-70),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER_BOTTOM,1.0,(90,60),(wimgsc.x*2,wimgsc.y*2));
					if(isAkimbo)
						drawtexture(wimg,(-125,-80),DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER_BOTTOM,1.0,(90,60),(wimgsc.x*2,wimgsc.y*2));
				}
				//weapon tag
				//drawstring(BWFont,cplayer.readyweapon.gettag(),(-190,-40),DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_RIGHT);
			}
		}
		
		//DrawLevelInfo((40, 20), DI_SCREEN_LEFT_TOP | DI_TEXT_ALIGN_LEFT);
		DrawComboScore((-170, 30), DI_SCREEN_RIGHT_TOP | DI_TEXT_ALIGN_LEFT, DI_SCREEN_RIGHT_TOP);
		DrawOxygen((45,-130), DI_SCREEN_LEFT_BOTTOM | DI_TEXT_ALIGN_CENTER);
		
		//slide thing
		//if(pl.findinventory("NoSliding"))
		//	DrawImage("MYLEG",(110,-30),DI_SCREEN_LEFT_BOTTOM|DI_ITEM_LEFT_BOTTOM,0.5 + alfadeofs,(100,100),(2.0,2.0));
		
		//keys
		DrawKeys((45,25), 10, 20, DI_SCREEN_LEFT_TOP | DI_ITEM_CENTER);
		//if(curammolist)
			//drawammolist(Primary, (-100,-140), DI_SCREEN_RIGHT_BOTTOM|DI_TEXT_ALIGN_CENTER, DI_SCREEN_RIGHT_BOTTOM|DI_ITEM_CENTER);
	}
}