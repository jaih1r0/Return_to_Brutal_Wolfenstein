//
//
//	Base class for weapons
//  - functions
//
Extend Class BaseBWWeapon
{
    
    //////////////////////////////////////////////////////////////////////////////////////////////
    //  helper functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    action bool isInReadyState()
	{
		State PSPState = player.GetPSprite(PSP_WEAPON).Curstate;
		return (
			InStateSequence(PSPState,invoker.ResolveState("Ready"))	||
			InStateSequence(PSPState,invoker.ResolveState("Ready2")) ||
			InStateSequence(PSPState,invoker.ResolveState("Ready_Dual"))
		);
	}

    action state BW_JumpifAiming(statelabel jump)
	{
		if(BW_IsAiming())
			return resolvestate(jump);
		return resolvestate(null);
	}

	action bool BW_IsAiming()
	{
		return (findinventory("AimingToken"));
	}

	Action Void BW_ChangePsprite(name spt, int layer = PSP_WEAPON)
	{
		let ps = player.findPSprite(layer);
		if(ps)
			ps.sprite = GetSpriteIndex(spt);
	}

    action void BW_ChangePSFrame(int frame, int layer = PSP_WEAPON)
    {
        let ps = player.findPSprite(layer);
		if(ps)
			ps.frame = frame;
    }

    action bool pressingButton(int button)
    {
        return (player.cmd.buttons & button);
    }

    action bool tappedButton(int button)
    {
        return (player.cmd.buttons & button) && !(player.oldbuttons & button);
    }

    //[Pop]This function is so we can replace all of the shitty A_Quake or QuakeEx
	//whatever the fucks in the mod, ESPECIALLY on the weapon front
	//no more of these SHAKEYOURASSMINOR and SHAKEYOURASSMAJOR actor spawning garbage
	//its pretty bare bones but maybe we can extend it in the future if we need it
	action void BW_QuakeCamera(int qDur, float camRoll)
	{
		A_QuakeEx(0, 0, 0, qDur, 0, 100, "", 0, 1, 0, 0, 0, 0, (camRoll / 2), 1, 0, 0, 0);
		//also, camroll / 2, 2 should be made a scaling CVar at some point, or attach it to some other cvar
		//DONT FORGET DIPSHIT
	}
	
	action void BW_WeaponRecoilBasic(float pitchDelta, float angleDelta = 0)
	{
		double fac = 1.0;
		if (invoker.GunBraced)
		{
			fac *= 0.33;
		}
		
        A_SetPitch(self.pitch+(pitchDelta * fac));
        A_SetAngle(self.angle+(angleDelta * fac));
	}
	
	action void BW_HandleWeaponFeedback(int qDur, float camRoll, float pitchDelta, float angleDelta, double d1 = 12, double d2 = 0 , double d3 = -3)
	{
		BW_QuakeCamera(qDur, camRoll);
		BW_WeaponRecoilBasic(pitchDelta, angleDelta);
		BW_GunSmoke("PUF2U0",d1, d2, d3);
	}
	
	//A way to perform pretty much take all of the "Insertbullets" states and turn it into a function
	//An example of this action: PB_AmmoIntoMag("RifleAmmo","PB_HighCalMag",30,1) 
	action void BW_AmmoIntoMag(String AmmoMag_Action,String AmmoPool_Action,int MagazineMaxFill_Action, int takeReserve)
	{
		for(int i = 0; i < MagazineMaxFill_Action; i++)
		{
			if((CountInv(AmmoMag_Action) >= MagazineMaxFill_Action) || (!CountInv(AmmoPool_Action)))
				return;
			
			A_GiveInventory(AmmoMag_Action, 1);
			A_TakeInventory(AmmoPool_Action, takeReserve);
		}
	}

	action void BW_AmmointoMagSingle(int max = 1,int eq = 1,bool tosecundary = false)
	{
		let res = tosecundary ? invoker.ammo2 : invoker.ammo1;	//reserve
		let cham = tosecundary ? invoker.ammo1 : invoker.ammo2;	//in chamber
		if(cham.amount >= max)
			return;
		if(res.amount < eq)
			return;
		res.amount -= eq;
		cham.amount += 1;
	}
	
	action state BW_PrefireCheck(int min = 1,statelabel reloadstate = null, statelabel drystate = null,bool checkprimary = false)
	{
		int am_res = checkprimary ? invoker.ammo1.amount : invoker.ammo2.amount;	//just in case, ig
		if(am_res < min)
		{
			//probably cvar to allow autoreload whem empty instead of dryfiring
			/*if(BW_AutoReload)
				return resolvestate(reloadstate);
			else*/
				return resolvestate(drystate);
		}
		return resolvestate(null);
	}
	
	//this function assumes that ammo2 is the mag ammo and ammo1 is the reserve ammo
	action state BW_CheckReload(statelabel emptystate = null, statelabel fullstate = null, statelabel noAmmostate = null, int full = 1, int min = 1)
	{
		if(!invoker.ammo2 || !invoker.ammo1)
			return resolvestate(null);
		int am_mag = invoker.ammo2.amount;
		int am_res = invoker.ammo1.amount;
		
		if(am_mag >= full)	//is already full
			return resolvestate(fullstate);
		if(am_res < min)	//theres no ammo in reserve to reload
			return resolvestate(noAmmostate);
		if(am_mag < 1)		//the mag is empty, go to the empty reload if any, continue partial if not defined
			return resolvestate(emptystate);
		return resolvestate(null);	//continue normal
		
	}

    action bool BW_CangoDual()
    {
        return (invoker.canDual && invoker.amount > 1);
    }

    action bool BW_CheckAkimbo()
    {
        return invoker.Akimboing;
    }

	clearscope bool Hud_IsAkimbo()	//simple solutions to simple problems ig
	{
		return Akimboing;
	}

    action void BW_SetAkimbo(bool set = true)
    {
        invoker.Akimboing = set;
    }

    action state BW_jumpifAkimbo(statelabel jump)
    {
        if(BW_CheckAkimbo())
            return resolvestate(jump);
        return resolvestate(null);
    }

    action bool BW_isFiring(bool right = false)
    {
        return right ? invoker.firingRight:invoker.firingLeft;
    }

    action void BW_SetFiring(bool set = true,bool right = false)
    {
        if(right)
            invoker.firingRight = set;
        else
            invoker.firingLeft = set;
    }

    action void BW_ClearFiring()
    {
        invoker.firingRight = invoker.firingLeft = false;
    }

	action state BW_DualPrefire(statelabel dry, bool isLeft = false, int min = 1)
	{
		int amt = isLeft ? invoker.AmmoLeft.amount : invoker.ammo2.amount;
		if(amt < min)
			return resolvestate(dry);
		return resolvestate(null);
	}

	action void BW_ClearDualOverlays()
	{
		A_ClearOverlays(PSP_LeftGun,PSP_RightGun);
	}

	action bool notDualFiring()
	{
		return (!BW_isFiring(true) && !BW_isFiring(false));
	}

	action state BW_DualReady(bool left = false,statelabel firing = null)
	{
		bool pressing,hasammo;
		if(left)
		{
			pressing = pressingButton(BT_ATTACK);
			hasammo = invoker.ammoleft.amount > 0;
		}
		else
		{
			pressing = BW_DualFiremode == 1 ? pressingButton(BT_ATTACK) : pressingButton(BT_ALTATTACK);
			hasammo = invoker.ammo2.amount > 0;
		}

		if(pressing && hasammo)
			return resolvestate(firing);
		return resolvestate(null);
	}

	//idk what to call this function, it returns the button to check for refire when dual
	action int getRightfirebutton()
	{
		return BW_DualFiremode == 1 ? BT_ATTACK : BT_ALTATTACK;
	}

    //////////////////////////////////////////////////////////////////////////////////////////////
    // replacement for vanilla weapon handling functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    Action State BW_WeaponReady(int BWRflags = 0)
	{
		if(countinv("BW_grenadeAmmo") < 1)
		{
			if((player.cmd.buttons & BT_USER3) && !(player.oldbuttons & BT_USER3))
				A_Log("No grenades left.");
			BWRflags &= ~(WRF_ALLOWUSER3);	//disable the grenade button if no grenades
		}
		A_Weaponready(BWRflags);
		return resolvestate(null);
	}

	//BW default A_Raise function
	action void BW_WeaponRaise(string SelectSound = "")
	{
		A_weaponoffset(0,32);
		A_ZoomFactor(1.0);
		A_setinventory("AimingToken",0);
		if(SelectSound)
			A_Startsound(sound(SelectSound),7);
	}

	//BW default A_Lower function
	action void BW_WeaponLower()
	{
		A_ZoomFactor(1.0);
		A_setinventory("AimingToken",0);
		A_Lower(120);
	}

    //Like A_Refire, but you can choose wich button to check and set it to only work when not holding the button
	action state BW_QuickRefire(statelabel refireTo = null, int firedButton = BT_ATTACK,bool noHold = true)
	{
		int bt = player.cmd.buttons, oldbt = player.oldbuttons;
		bool canrefire = noHold ? ((bt & firedButton) && !(oldbt & firedButton)) :
		(bt & firedButton);
		if(canrefire)
			return resolvestate(refireTo);
		return resolvestate(null);
	}

    //wrapper function for bullet firing guns
	action void BW_FireBullets(string projectiletype = "BW_Projectile",double spreadx = 0,double spready = 0,int numbullets = 1,int dmg = 0, string puff = "Bulletpuff", name dmgtype = "Bullet",int maxpen = 0,int fwofs = 0, int sdofs = 0)
	{
		if(BW_BulletType == 0)	//hitscan
		{
			if(maxpen > 0)	//the attack is meant to work as a railgun
				CustomFireFunctionPenetrator(spreadx,spready,numbullets,dmg = 0,puff,dmgtype,maxpen,fwofs,sdofs);
			else			//normal hitscan
				CustomFireFunction(spreadx,spready,numbullets,dmg,puff,dmgtype,fwofs,sdofs);
		}
		else	//projectiles
		{
			int nb = max(1,abs(numbullets));
			for(int i = 0; i < nb; i++)
			{
				double ang = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spreadx,spreadx);	//preserve the vanilla first shoot accurate
				double ptc = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spready,spready);	
				A_fireprojectile(projectiletype,ang,0,sdofs,0,0,ptc);
			}
		}
	}




    //////////////////////////////////////////////////////////////////////////////////////////////
    //  effects spawning functions
    //////////////////////////////////////////////////////////////////////////////////////////////

    //spawn casings relative to the player view, also adds the current player velocity to them
	Action void BW_SpawnCasing(string casingtype,double fwofs = 3,double sdofs = -8.5, double zoff = 7, double xvel = 3,double yvel = 2,double zvel = 1)
	{
		Quat dir = Quat.FromAngles(angle,pitch,roll);
		vector3 ofs = dir * (fwofs, -sdofs,zoff);
		vector3 spawnpos = Level.vec3offset((pos.xy,player.viewz), ofs);
		vector3 vl = dir * (xvel,-yvel,zvel);
		let c = spawn(casingtype,spawnpos);
		if(c)
			c.vel = vl + vel;
	}
	
	Action void BW_GunSmoke(string gfx = "PUF2U0",double fwofs = 12,double sdofs = 0, double zoff = -2, double xvel = 4,double yvel = 0,double zvel = 0,int startsize = 9,double startalpha = 0.4, color col = 0xFFFFFF)
	{
		if(BW_disableGunSmoke)
			return;
		if(!gfx)
			return;
		Quat dir = Quat.FromAngles(angle,pitch,roll);
		vector3 ofs = dir * (fwofs, -sdofs,zoff);
		vector3 spawnpos = Level.vec3offset((pos.xy,player.viewz), ofs);
		vector3 vl = dir * (xvel,-yvel,zvel);
		vl += (vel * 0.5);
		FSpawnParticleParams WepSmk;
		WepSmk.Texture = TexMan.CheckForTexture(gfx);
		WepSmk.Color1 = col;
		WepSmk.Style = style_translucent;
		WepSmk.Flags = SPF_ROLL;
		WepSmk.vel = vl;
		WepSmk.Startroll = random(0,360);
		WepSmk.RollVel = frandom(-6.0,6.0);
		WepSmk.StartAlpha = startalpha;//0.4;
		WepSmk.Lifetime = random(10,14);
		WepSmk.FadeStep = WepSmk.StartAlpha / WepSmk.Lifetime;
		WepSmk.accel = -(vl * frandom(0.02,0.05));
		if(CeilingPic == SkyFlatNum)
			WepSmk.accel += getwinddir();
		WepSmk.Size = startsize;
		WepSmk.SizeStep = frandom(1.0,4.0);
		WepSmk.Pos = spawnpos;
		Level.SpawnParticle (WepSmk);
	}

	action void BW_GunBarrelSmoke(string gfx = "PUF2U0",vector3 ofsPos = (5,2,-3), vector3 ofsVel = (0.2,0,0.6),int startsize = 5, double startalpha = 0.35, color col = 0xFFFFFF, bool left = false)
	{
		if(!BW_GetBarrelHeat(left))
			return;
		BW_AddBarrelHeat(-1,false,left);
		if(BW_disableGunSmoke)
			return;
		if(WaterLevel > 1)
			BW_AddBarrelHeat(0,true,left);	//instacold in water

		/*let qpl = ZM_QuakePlayer(player.mo);
		if(qpl)
		{
			//account for weapon sway
			ofsPos.y += qpl.finalbob.x * 0.3;
			ofsPos.z -= qpl.finalbob.y * 0.25;
		}*/
		Quat dir = Quat.FromAngles(angle,pitch,roll);
		vector3 ofs = dir * (ofsPos.x, -ofsPos.y,ofsPos.z);
		vector3 spawnpos = Level.vec3offset((pos.xy,player.viewz), ofs);
		vector3 vl = dir * (ofsVel.x,-ofsVel.y,ofsVel.z);
		
		FSpawnParticleParams WepSmk;
		WepSmk.Texture = TexMan.CheckForTexture(gfx);
		WepSmk.Color1 = col;
		WepSmk.Style = style_translucent;
		WepSmk.Flags = SPF_ROLL|SPF_NOTIMEFREEZE;
		WepSmk.vel = vl;
		WepSmk.Startroll = random(0,360);
		WepSmk.RollVel = frandom(-6.0,6.0);
		WepSmk.StartAlpha = startalpha;
		WepSmk.Lifetime = random(7,8);
		WepSmk.FadeStep = WepSmk.StartAlpha / WepSmk.Lifetime;
		WepSmk.accel = -(vl * frandom(0.01,0.02));
		if(CeilingPic == SkyFlatNum)
			WepSmk.accel += getwinddir();
		WepSmk.Size = startsize;
		WepSmk.SizeStep = -frandom(0.02,0.07);
		WepSmk.Pos = spawnpos;
		Level.SpawnParticle (WepSmk);
	}

	action void BW_AddBarrelHeat(int amnt = 1, bool set = false, bool isLeft = false)
	{
		if(isLeft)
		{
			if(set)
				invoker.barrelHeatLeft = amnt;
			else
				invoker.barrelHeatLeft += amnt;
		}
		else
		{
			if(set)
				invoker.barrelHeat = amnt;
			else
				invoker.barrelHeat += amnt;
		}
	}

	action uint BW_GetBarrelHeat(bool left)
	{
		return left ? invoker.barrelHeatLeft : invoker.barrelHeat;
	}

	action vector3 getwinddir()
	{
		if(!level)
			return (0,0,0);
		switch(level.levelnum % 4)
		{
			case 0:	return (0.05,0.05,0.03);	break;
			case 1:	return (-0.05,0.05,0.03);	break;
			case 2:	return (0.05,-0.05,0.03);	break;
			case 3:	return (-0.05,-0.05,0.03);	break;
		}
		return (0,0,0);
	}






    //////////////////////////////////////////////////////////////////////////////////////////////
    //  melee related functions
    //////////////////////////////////////////////////////////////////////////////////////////////
	action void handlekickFlash(int type = 0)	//0 kick, 1 slide, 2 air
	{
		if(!isInReadyState())	//only when in ready state
			return;
		
		if(BW_CheckAkimbo() && !notDualFiring())	//is dual wielding and firing right now, dont interrupt that
			return;

		statelabel pendkf = "KickFlash";
		switch(type)
		{
			case 0:		pendkf = "KickFlash";	break;
			case 1:		pendkf = "SlideFlash";	break;
			case 2:		pendkf = "KickFlash";	break;
			//case 3:		pendkf = "KnifeFlash";	break;
		}
		let kf = invoker.resolvestate(pendkf);
		if(kf)
			player.SetPSprite(PSP_WEAPON,kf);
	}

	action void handleKnifeFlash()
	{
		statelabel pendkf = "KnifeGunFlash";
		A_Overlay(-4,pendkf);
		//let kf = invoker.resolvestate(pendkf);
		//if(kf)
		//	player.SetPSprite(-4,kf);
	}
	
	action state SlideHandle(statelabel cancel = null,int spd = 15, int dmg = 15)
	{
		if(!(player.cmd.buttons & BT_CROUCH))
			return resolvestate(cancel);
		
		//velfromangle(spd,angle);

		BW_SlideThrust(spd);

		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, 60, pitch, offsetz: pz, data: t);
		if(t.hitline)
			t.hitline.Activate(player.mo,t.lineside,SPAC_USE);


		if(t.hitactor != null)
		{
			actor victim = t.hitactor;
			if(victim.bsolid || victim.bshootable)
			{
				actor puf;
				puf = SpawnPuff("BW_KickPuff", t.hitlocation, angle, 0, 0, PF_HITTHING);
				
				if(puf)
				{
					victim.damagemobj(puf,self,dmg,"Kick");
					puf.A_Startsound("Fists/Hit");	//impacted enemy
				}
			}
		}

		if(t.hitType == TRACE_HitWall || t.hitType == TRACE_HitCeiling || t.hitType == TRACE_HitFloor)
		{
			actor pf = spawnpuff("BW_KickPuff",t.hitlocation,angle,0,0);
            if(pf)
                pf.A_Startsound("Player/KickWall");	//impacted wall,floor,etc
		}

		return resolvestate(null);
	}

	action void HandleKick(int dist = 70,int dmg = 20)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, dist, pitch, offsetz: pz, data: t);
		if(t.hitline)
			t.hitline.Activate(player.mo,t.lineside,SPAC_USE);
		
		if(t.hitactor)
		{
			actor victim = t.hitactor;
			if(victim.bsolid || victim.bshootable)
			{
				actor puf;
				puf = SpawnPuff("BW_KickPuff", t.hitlocation, angle, 0, 0, PF_HITTHING);
				if(puf)
				{
					victim.damagemobj(puf,self,dmg,"Kick");
					puf.A_Startsound("Fists/Hit");	//impacted enemy
				}
			}
		}
		if(t.hitType == TRACE_HitWall || t.hitType == TRACE_HitCeiling || t.hitType == TRACE_HitFloor)
		{
			actor pf = spawnpuff("BW_KickPuff",t.hitlocation,angle,0,0);
            if(pf)
                pf.A_Startsound("Player/KickWall");	//impacted wall,floor,etc
		}

	}

	action state BW_HandleKnife(int dist = 70, int dmg = 50, bool isAxe = false)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, dist, pitch, offsetz: pz, data: t);
		if(t.hitactor)
		{
			actor victim = t.hitactor;
			if(victim.bsolid || victim.bshootable)
			{
				actor puf = SpawnPuff("BW_KickPuff", t.hitlocation, angle, 0, 0, PF_HITTHING);
				if(puf)
                {
					if(!victim.target)	//wasnt alerted yet
						dmg *= 2;
					
                    if(victim.bNOBLOOD || victim.bINVULNERABLE || victim.bDORMANT || 
						victim.bREFLECTIVE || (victim.bsolid && ! victim.bShootable))
					{
						if(isAxe)
							puf.A_Startsound("Axe/HitWall", CHAN_AUTO, CHANF_OVERLAP, 0.75);
						else
							puf.A_Startsound("Knife/Wall", CHAN_AUTO, CHANF_OVERLAP, 0.75);	//non bleeding enemy
					}
					else
					{
						if(isAxe)
							puf.A_Startsound("Knife/Body", CHAN_AUTO, CHANF_OVERLAP, 0.75); 
						else
							puf.A_Startsound("Knife/Body", CHAN_AUTO, CHANF_OVERLAP, 0.75);  //impacted enemy
						victim.SpawnBlood(victim.pos,angle,ceil(dmg));
					}
					victim.damagemobj(puf,self,dmg,"Knife");
				}
				return resolvestate(null);
            }
		}
		if(t.hitType == TRACE_HitWall || t.hitType == TRACE_HitCeiling || t.hitType == TRACE_HitFloor)
        {
			actor pf = spawnpuff("BW_KickPuff",t.hitlocation,angle,0,0);
            if(pf)
			{
                if(isAxe)
				{
					pf.A_Startsound("Axe/HitWall", CHAN_AUTO, CHANF_OVERLAP, 0.75); 
					pf.A_SprayDecal("KnifeChip",10,(0,0,0),t.hitdir);	//this needs a different decal for axe
				}
				else
				{
					pf.A_Startsound("Knife/Wall", CHAN_AUTO, CHANF_OVERLAP, 0.75);   //impacted wall,floor,etc
					pf.A_SprayDecal("KnifeChip",10,(0,0,0),t.hitdir);
				}
			}
        }
		return resolvestate(null);
	}

	//slide related functions
	action void BW_SlideThrust(double force = 2)
	{
		let pl = BWPlayer(player.mo);
		velfromangle(force,pl.slideAngle);
	}
	
	action void BW_SlideDirSet(bool reset = false)
	{
		let pl = BWPlayer(player.mo);
		if(reset)
			pl.slideAngle = 0.0;
		else
			pl.slideAngle = Angle - VectorAngle(player.cmd.forwardmove, player.cmd.sidemove);
	}

    action void KickDoors(int dist = 70)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, dist, pitch, offsetz: pz, data: t);
		if(t.hitline)
			t.hitline.Activate(player.mo,t.lineside,SPAC_USE);
	}

	
	



	//////////////////////////////////////////////////////////////////////////////////////////////
    //hitscan attacks
    //////////////////////////////////////////////////////////////////////////////////////////////
	action void CustomFireFunction(double spreadx = 0,double spready = 0,int numbullets = 1,int dmg = 0, string puff = "Bulletpuff", name dmgtype = "Bullet",int fwofs = 0, int sdofs = 0)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
		//pz -= 7;	//not sure why the height difference
		FLineTraceData t;
		int fb = numbullets == 0 ? 1 : abs(numbullets);
		for(int i = 0; i < fb; i++)
		{
			//vanilla behavior, first shot is 100% accurate if its only 1 bullet
			double spx = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spreadx,spreadx);
			double spy = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spready,spready);
			
			
			self.LineTrace(angle + spx, 9000, pitch + spy, offsetz: pz, data: t);
			A_Fireprojectile("PlayerDecorativeTracer",spx,false,sdofs,pitch:spy);
			
			//console.printf("startpos: "..(pos.xy,pos.z + pz).."hitlocation: "..t.hitlocation..", dist: "..t.Distance);
			if(t.hitactor != null)	//hit something
			{
				//console.printf("Hit a: "..t.hitactor.gettag().." (classname: \cd"..t.hitactor.getclassname().."\c-).");
				if(t.hitactor.bsolid || t.hitactor.bshootable)
				{
					if(t.hitactor.bnoblood || t.hitactor.bdormant || t.hitactor.bINVULNERABLE || 
					t.hitactor.bREFLECTIVE ||(t.hitactor.bsolid && !t.hitactor.bshootable))
					{
						let p = spawn(puff,t.hitlocation - t.hitdir,ALLOW_REPLACE);
						if(p)
							t.hitactor.damagemobj(p,self,dmg,dmgtype,0,angle);
						continue;
					}
					else
					{
						let p = spawn("BW_dmgpuff",t.hitlocation);//,ALLOW_REPLACE);	//dummy puff needed for hit detection
						if(p)	
							t.hitactor.damagemobj(p,self,dmg,dmgtype,0,angle);
						
						t.hitactor.SpawnBlood(t.hitlocation,atan2(t.hitdir.y,t.hitdir.x),damage);
						continue;
					}
				}
				
			}
			
			if(t.HitType == TRACE_HitWall || t.HitType == TRACE_HitCeiling || t.HitType == TRACE_HitFloor)
			{
				string tx = texman.getname(t.HitTexture);
				name mathit = BW_StaticHandler.getmaterialname(tx);
				
				if(mathit != 'null')
				{
					vector3 hitx = t.hitlocation - t.hitdir - t.hitdir;
					let pf = BW_impactpuff(spawn("BW_impactpuff",hitx));
					if(!pf)
						continue;
					pf.tp = mathit;
					
					let sd = BW_StaticHandler.getmaterialSound(tx);
					if(sd)
						pf.A_Startsound(sd);
					
					vector3 nm = (0,0,0);
					if(t.hittype == TRACE_HitWall) //&& t.hitline != null)
					{
						vector2 nrm = GetLineNormal(t.LineSide,t.HitLine);
						double wn = -atan2(nrm.x, nrm.y);
						nm = (RotateVector((0, 1),wn), 0);
						pf.norm = nm;
						pf.impctDir = t.HitDir;
						pf.wang = wn;
						pf.impactType = BW_impactpuff.IMP_WALL;
						
					}
					else if(t.HitType == TRACE_HitCeiling) //&& t.hitsector != null)
					{
						nm = t.hitsector.ceilingplane.normal;	
						pf.norm = nm;
						pf.impctDir = t.HitDir;
						pf.impactType = BW_impactpuff.IMP_CEIL;
						
					}
					else if(t.HitType == TRACE_HitFloor) //&& t.hitsector != null)
					{
						
						nm = t.hitsector.floorplane.normal;
						pf.norm = nm;
						pf.impctDir = t.HitDir;
						pf.impactType = BW_impactpuff.IMP_FLOOR;
						
					}
					
					//pf.a_spawnimpact();
					
				}
				else
				{
					if(!tx)
						continue;
					//console.printf("[\caBW Materials\c-]: texture \cd"..tx.."\c- not found in level \cd"..level.Mapname.."\c- at pos \cd"..t.hitlocation.."\c-");
					let pf = spawn(puff,t.hitlocation - t.hitdir,ALLOW_REPLACE);
					if(pf)
						pf.A_Spraydecal("BulletChip",30,(0,0,0),t.HitDir);
				}
			}
			
		}
	}
	
	
	action void CustomFireFunctionPenetrator(double spreadx = 0,double spready = 0,int numbullets = 1,int dmg = 0, string puff = "Bulletpuff", name dmgtype = "Bullet",int maxpen = 1,int fwofs = 0, int sdofs = 0)
	{
		int fb = numbullets == 0 ? 1 : abs(numbullets);
		
		int dmgredc = dmg / max(maxpen,1);
		double vz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
		//vz -= 5;
		Vector3 start = pos + (0,0,vz);
		//console.printf("dir: "..dir);
		
		for(int i = 0; i < fb; i++)
		{
			double spx = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spreadx,spreadx);
			double spy = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spready,spready);
			Vector3 dir = (AngleToVector(angle + spx, cos(pitch)), -sin(pitch + spy));
			//dir.z += spy * 001;
			if(dir.z >= 1.0)
				dir.z = 0.995;
			if(dir.z <= -1.0)
				dir.z = -0.995;
			let tr = new("BW_penetratortracer");
			if(!tr)	
				return;
			A_Fireprojectile("PlayerDecorativeTracer",spx,false,sdofs,pitch:spy);
			tr.shooter = self;
			tr.Trace(start, CurSector, dir, 8000, TRACE_HitSky);
			int npn = maxpen;
			bool cantTouchGrass = false;
			if(tr.Ti.size() > 0)
			{
				
				for(int k = 0; k < tr.Ti.size(); k++)
				{
					//console.printf("hit num: "..k);
					
					//if(k == 0)
					//	continue;
					
					if(npn <= 0)
					{
						cantTouchGrass = true;
						continue;
					}
					
					actor v = tr.Ti[k].who;
					//console.printf("Hit "..k..": "..v.gettag().."");
					//console.printf("Hit %d: %s (\cd %s \c-)",k,v.gettag(),v.getclassname());
					//console.printf("Hit a: "..t.hitactor.gettag().." (classname: \cd"..t.hitactor.getclassname().."\c-).");
					if(v.bsolid || v.bshootable)
					{
						if(v.bnoblood || v.bdormant || v.bINVULNERABLE || 
						v.bREFLECTIVE ||(v.bsolid && !v.bshootable))
						{
							let p = spawn(puff,tr.endpos - tr.dirh,ALLOW_REPLACE);
							if(p)
								v.damagemobj(p,self,dmg,dmgtype,0,angle);
							
							if(v.bismonster)
								dmg -= dmgredc;
							//continue;
						}
						else
						{
							let p = spawn("BW_dmgpuff",tr.Ti[k].location);//,ALLOW_REPLACE);	//dummy puff needed for hit detection
							if(p)	
								v.damagemobj(p,self,dmg,dmgtype,0,angle);
							
							v.SpawnBlood(tr.Ti[k].location,atan2(tr.dirh.y,tr.dirh.x),dmg);
							
							if(v.bismonster)
								dmg -= dmgredc;
							//continue;
						}
						//console.printf("Hitn: "..k..", ".."pen: "..(tr.Ti.size())..", max: "..maxpen);
						npn--;
					}
					
				}
			}
			
			if(cantTouchGrass)
				return;
			//spawn("Bulletpuff",tr.endpos);
			//console.printf("fuck "..tr.endpos);
			if(tr.typehit == TRACE_HitWall || tr.typehit == TRACE_HitCeiling || tr.typehit == TRACE_HitFloor)
			{
					string tx = texman.getname(tr.htx);
					name mathit = BW_StaticHandler.getmaterialname(tx);
		
					/*string infomsg = "Fuck";
					if(mathit != 'null')
						infomsg = "\cd"..mathit.." \c-(\ck"..tx.."\c-)";
					else
						infomsg = "\ca"..mathit.." \c-(\ck"..tx.."\c-)";
					
					console.printf(infomsg);*/
					
					if(mathit != 'null')
					{
						vector3 hitx = tr.endpos - tr.dirh - tr.dirh;
						let pf = BW_impactpuff(spawn("BW_impactpuff",hitx));
						if(!pf)
							continue;
						pf.tp = mathit;
						let sd = BW_StaticHandler.getmaterialSound(tx);
						if(sd)
							pf.A_Startsound(sd);
						
						vector3 nm = (0,0,0);
						if(tr.typehit == TRACE_HitWall) //&& t.hitline != null)
						{
							vector2 nrm = GetLineNormal(tr.lsd,tr.hitl);
							double wn = -atan2(nrm.x, nrm.y);
							nm = (RotateVector((0, 1),wn), 0);
							pf.norm = nm;
							pf.impctDir = tr.dirh;
							pf.wang = wn;
							pf.impactType = BW_impactpuff.IMP_WALL;
							
						}
						else if(tr.typehit == TRACE_HitCeiling) //&& t.hitsector != null)
						{
							nm = tr.ss.ceilingplane.normal;	
							pf.norm = nm;
							pf.impctDir = tr.dirh;
							pf.impactType = BW_impactpuff.IMP_CEIL;
							
						}
						else if(tr.typehit == TRACE_HitFloor) //&& t.hitsector != null)
						{
							
							nm = tr.ss.floorplane.normal;
							pf.norm = nm;
							pf.impctDir = tr.dirh;
							pf.impactType = BW_impactpuff.IMP_FLOOR;
						}
						
						//pf.a_spawnimpact();
						
					}
					else
					{
						if(!tx)
							continue;
						//console.printf("[\caBW Materials\c-]: texture \cd"..tx.."\c- not found in level \cd"..level.Mapname.."\c- at pos \cd"..tr.endpos.."\c-");
						let pf = spawn(puff,tr.endpos - tr.dirh,ALLOW_REPLACE);
						if(pf)
							pf.A_Spraydecal("BulletChip",30,(0,0,0),tr.dirh);
						
					}
			}
		}
	}
	
	action vector2 GetLineNormal(int iSide, Line vLine)
	{
		vector2 lineNormal = (-vLine.delta.y, vLine.delta.x).Unit();

		if(!iSide)
			lineNormal *= -1;

		return lineNormal;
	}
	
}