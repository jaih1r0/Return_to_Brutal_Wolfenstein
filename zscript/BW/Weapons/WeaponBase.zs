//
//
//	Base class for weapons
//
//
Class BaseBWWeapon : DoomWeapon
{
	default
	{
		Weapon.BobRangeX 0.4;
		Weapon.BobRangeY 0.2;
		Weapon.BobSpeed 2.5;
		Weapon.BobStyle "InverseSmooth"; //"Smooth";//"InverseAlpha";
		BaseBWWeapon.FullMag 0;
		Weapon.WeaponScaleX 1.2;
		+dontgib;
	}

	enum BWWR_Flags {
		BWWF_NoAxe		= 1<<26,
		BWWF_NoGrenade 	= 1<<27,
		BWWF_NoKick 	= 1<<28,
		BWWF_NoSlide 	= 1<<28,
		BWWF_NoTaunt 	= 1<<29,
	};
	
	int FullMag;
	property FullMag:FullMag;
	
	protected int BraceTicker;
	bool GunBraced;

	states
	{
		DoKick:
			TNT1 A 0 A_jumpif(pos.z <= floorz + 2 && vel.xy.length() > 3 && (player.cmd.buttons & BT_CROUCH),"SlideKick");
			TNT1 A 0 handlekickFlash();
			TNT1 A 0 A_StartSound("Player/Kick", 0, CHANF_OVERLAP, 1);
			BWK1 ABCDE 1;
			BWK1 FGG 1;
			TNT1 A 0 A_QuakeEx(1,0,0,6,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
			BWK1 HIJ 1;
			BWK1 K 3 HandleKick();
			BWK1 LNO 1;
			TNT1 A 2;
			stop;

		SlideKick:
			TNT1 A 0 BW_SlideDirSet();
			TNT1 A 0 BW_SlideThrust(30);	//thrust relative to angle and input, aka slide in any direction, not just forward
			TNT1 A 0 handlekickFlash(1);
			//start sliding 8 frames
			TNT1 A 0 A_StartSound("Player/Slide", 0, CHANF_OVERLAP, 1);
			BWK2 ABC 1;
			TNT1 A 0 A_QuakeEx(1,0,0,20,0,10,"",QF_SCALEDOWN|QF_RELATIVE);
			BWK2 DEF 1;
			BWK2 GH 1;
			//slidin, 18 frames
			BWK2 IJK 1 SlideHandle("EndSlideKick",20);
			BWK2 IJK 1 SlideHandle("EndSlideKick",20);
			BWK2 IJK 1 SlideHandle("EndSlideKick",20);
			BWK2 IJK 1 SlideHandle("EndSlideKick",15);
			BWK2 IJK 1 SlideHandle("EndSlideKick",12);
			BWK2 IJK 1 SlideHandle("EndSlideKick",10);
		EndSlideKick:
			TNT1 A 0 {
				BW_SlideDirSet(true);	//reset direction
				//keep the weapon synced with the kick overlay
				State PSPState = player.GetPSprite(PSP_WEAPON).Curstate;
				if(InStateSequence(PSPState,invoker.ResolveState("SlideFlash")))
				{
					state endslide = invoker.resolvestate("SlideFlashEnd");
					if(endslide)
						player.SetPSprite(PSP_WEAPON,endslide);
				}
			}
			//end sliding 6 frames
			BWK2 H 1;
			BWK2 FDCBA 1;
			stop;
		
		//there was already an states block here lol
		User1: //replaces BD Weapon Special
			TNT1 A 1;
			Goto WeaponReady;
		
		User2:
		KnifeAttack:
			TNT1 A 0 handleKnifeFlash();
			TNT1 A 0 A_StartSound("Knife/Swing", 0, CHANF_OVERLAP, 1);
			TNT1 A 1;
			BWKF JIH 1;
			BWKF G 1;
			TNT1 A 0 A_QuakeEx(0,0.5,0,7,0,10,"",QF_SCALEDOWN|QF_RELATIVE,0,0,0,0,0,2,2);
			BWKF G 2 BW_HandleKnife(); //A_CustomPunch(12, 1, CPF_PULLIN | CPF_NOTURN, "BulletPuff", 64, 0, 0, "BasicArmorBonus", "melee/knife/hit");
			BWKF FEDCBA 1;
			TNT1 A 0 A_Jump(256, "Ready");
			goto ready;
		
		//old
			TNT1 A 0 handleKnifeFlash();
			TNT1 A 0 A_StartSound("Knife/Swing", 0, CHANF_OVERLAP, 1);
			BWKF ABC 1;
			BWKF DE 1;
			TNT1 A 0 A_QuakeEx(0,0.5,0,7,0,10,"",QF_SCALEDOWN|QF_RELATIVE,0,0,0,0,0,2,2);
			BWKF F 2 BW_HandleKnife(); //A_CustomPunch(12, 1, CPF_PULLIN | CPF_NOTURN, "BulletPuff", 64, 0, 0, "BasicArmorBonus", "melee/knife/hit");
			BWKF GGHIJ 1;
			TNT1 A 0 A_Jump(256, "Ready");
			goto ready;
			
			TNT1 A 0 A_StartSound("melee/knife/slash", 0, CHANF_OVERLAP, 1);
			KNI9 AB 1;
			KNI9 CDEF 1 A_CustomPunch(12, 1, CPF_PULLIN | CPF_NOTURN, "BulletPuff", 64, 0, 0, "BasicArmorBonus", "melee/knife/hit");
			KNI9 GHI 1;
			TNT1 A 0 A_Jump(256, "Ready");
			Goto Ready;
		
		KnifeGunFlash:
			TNT1 A 12;
			stop;
			

	}

	action bool isInReadyState()
	{
		State PSPState = player.GetPSprite(PSP_WEAPON).Curstate;
		return (
			InStateSequence(PSPState,invoker.ResolveState("Ready"))	||
			InStateSequence(PSPState,invoker.ResolveState("Ready2"))
		);
	}

	action void handlekickFlash(int type = 0)	//0 kick, 1 slide, 2 air
	{
		if(!isInReadyState())	//only when in ready state
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

	action void HandleKick(int dist = 60,int dmg = 20)
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

	action state BW_HandleKnife(int dist = 50, int dmg = 30)
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
					victim.damagemobj(puf,self,dmg,"Melee");
                    if(victim.bNOBLOOD || victim.bINVULNERABLE || victim.bDORMANT || 
						victim.bREFLECTIVE || (victim.bsolid && ! victim.bShootable))
						puf.A_Startsound("Knife/Wall", CHAN_AUTO, CHANF_OVERLAP, 0.75);	//non bleeding enemy
					else
					{
						puf.A_Startsound("Knife/Body", CHAN_AUTO, CHANF_OVERLAP, 0.75);  //impacted enemy
						victim.SpawnBlood(victim.pos,angle,ceil(dmg));
					}
				}
				return resolvestate(null);
            }
		}
		if(t.hitType == TRACE_HitWall || t.hitType == TRACE_HitCeiling || t.hitType == TRACE_HitFloor)
        {
			actor pf = spawnpuff("BW_KickPuff",t.hitlocation,angle,0,0);
            if(pf)
			{
                pf.A_Startsound("Knife/Wall", CHAN_AUTO, CHANF_OVERLAP, 0.75);   //impacted wall,floor,etc
				pf.A_SprayDecal("KnifeChip",10,(0,0,0),t.hitdir);
			}
        }
		return resolvestate(null);
	}

	Action State BW_WeaponReady(int BWRflags = 0)
	{
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
				A_fireprojectile(projectiletype,ang,0,0,0,0,ptc);
			}
		}
	}
	
	//[Pop] Putting this here since i dunno how BW_FireBullets works, and we are
	//having jank with projectiles right now anyways.
	action void BW_FireBullets2(string type,int amount,float angle,double offs,double height,float pitch)
	{
		for(int i=amount;i>0;i--)
		{
			A_FireProjectile(type,(frandom(angle,angle * -1)),0,offs,height,FPF_NOAUTOAIM,(frandom(pitch,pitch * -1)));
		}
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
	
	action void BW_HandleWeaponFeedback(int qDur, float camRoll, float pitchDelta, float angleDelta, double d1 = 0, double d2 = 0 , double d3 = 0)
	{
		BW_QuakeCamera(qDur, camRoll);
		BW_WeaponRecoilBasic(pitchDelta, angleDelta);
		BW_GunSmoke(d1, d2, d3);
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

	action state BW_JumpifAiming(statelabel jump)
	{
		if(findinventory("AimingToken"))
			return resolvestate(jump);
		return resolvestate(null);
	}

	Action Void BW_ChangePsprite(name spt, int layer = PSP_WEAPON)
	{
		let ps = player.findPSprite(layer);
		if(ps)
			ps.sprite = GetSpriteIndex(spt);
	}
	
	action void KickDoors(int dist = 70)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset*player.crouchFactor;
		FLineTraceData t;
		LineTrace(angle, dist, pitch, offsetz: pz, data: t);
		if(t.hitline)
			t.hitline.Activate(player.mo,t.lineside,SPAC_USE);
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
	
	const SlideSpeed = 17;
	
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
	
	Action void BW_GunSmoke(double xyofs = 0, double spawnheight = 0, double addangle = 0,string type = "BW_GunSmoke")
	{
		if(type)
		{
			FTranslatedLineTarget t;
			vector2 ofs = angletovector(angle,xyofs);
			double shootangle = self.angle + addangle;
			Actor misl, realmisl;
			[misl, realmisl] = SpawnPlayerMissile(type, shootangle, ofs.X, ofs.Y, spawnheight, t, false, 1);
			if(realmisl)
				realmisl.vel += vel;
			
		}
	}
	
	override void DoEffect()
	{
		super.doeffect();
		let pl = owner.player;
		if (pl && pl.readyweapon)
			pl.WeaponState |= WF_WEAPONBOBBING;
	}
	
	action void CustomFireFunction(double spreadx = 0,double spready = 0,int numbullets = 1,int dmg = 0, string puff = "Bulletpuff", name dmgtype = "Bullet",int fwofs = 0, int sdofs = 0)
	{
		double pz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
		pz -= 7;	//not sure why the height difference
		FLineTraceData t;
		int fb = numbullets == 0 ? 1 : abs(numbullets);
		for(int i = 0; i < fb; i++)
		{
			//vanilla behavior, first shot is 100% accurate if its only 1 bullet
			double spx = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spreadx,spreadx);
			double spy = (!player.refire && numbullets == 1) ? 0.0 : frandom(-spready,spready);
			
			
			self.LineTrace(angle + spx, 9000, pitch + spy, offsetz: pz, data: t);
			A_Fireprojectile("PlayerDecorativeTracer",spx,false,pitch:spy);
			
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
	
				/*string infomsg = "Fuck";
				if(mathit != 'null')
					infomsg = "\cd"..mathit.." \c-(\ck"..tx.."\c-)";
				else
					infomsg = "\ca"..mathit.." \c-(\ck"..tx.."\c-)";
				
				console.printf(infomsg);*/
				
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
		vz -= 5;
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
			A_Fireprojectile("PlayerDecorativeTracer",spx,false,pitch:spy);
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
	
	override void attachtoowner(actor other)
	{
		super.attachtoowner(other);
		if(FullMag > 0 && ammotype2)
			other.giveinventory(ammotype2,FullMag);
	}
	
	override void Tick()
	{
		Super.Tick();
		
		let plr = BWPlayer(Owner);
		if (!plr)
		{
			GunBraced = false;
			return;
		}
		
		if (plr.Player.ReadyWeapon != self)
		{
			GunBraced = false;
			return;
		}
		/*
		if (CountInv("ResetZoom") >= 1) {
			A_TakeInventory("ResetZoom", 1);
			A_ZoomFactor(1.0, ZOOM_INSTANT);
		}*/
		
		FLineTraceData dt1, dt2, dt3, dt4, dt5, dt6;
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, offsetside: -plr.Radius / 2, data: dt1);
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95 * 0.75, data: dt2);
		plr.LineTrace(plr.Angle, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, offsetside: plr.Radius / 2, data: dt3);
		
		plr.LineTrace(plr.Angle + 90, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, data: dt4);
		plr.LineTrace(plr.Angle + 180, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95 * 0.75, data: dt5);
		plr.LineTrace(plr.Angle - 90, plr.Radius * 3, plr.Pitch, TRF_NOSKY | TRF_THRUACTORS, plr.Height * 0.95, data: dt6);
		
		bool geometryBrace = dt1.HitType == FLineTraceData.TRACE_HitWall || dt2.HitType == FLineTraceData.TRACE_HitWall || dt3.HitType == FLineTraceData.TRACE_HitWall || dt4.HitType == FLineTraceData.TRACE_HitWall || dt5.HitType == FLineTraceData.TRACE_HitWall || dt6.HitType == FLineTraceData.TRACE_HitWall;
		
		if (!bMELEEWEAPON && (plr.Player.crouchfactor == 0.5 || geometryBrace) && plr.Vel.Length() < 6)
		{
			BraceTicker++;
			if (BraceTicker == 10)
			{
				GunBraced = true;
				plr.A_SetPitch(plr.Pitch - 0.2);
				Owner.A_StartSound("Weapon/Bracing", 19, 0, 0.30);
			}
			if (BraceTicker == 11)
			{
				plr.A_SetPitch(plr.Pitch + 0.2);
			}
		}
		else
		{
			GunBraced = false;
		}

		if (!GunBraced && BraceTicker > 13)
		{
			BraceTicker = 0;
		}
	}
	
}



Class BW_PenetratorTracer : LineTracer
{
	actor shooter;
	array <TraceInfo> Ti;
	vector3 endpos;
	bool hitsky;
	line hitl;
	sector ss;
	textureID htx;
	int typehit;
	vector3 dirh;
	uint lsd;
	
	override ETraceStatus TraceCallback()
	{
		if(Results.HitType == TRACE_HasHitSky)
		{
			hitsky = true;
			endpos = Results.hitpos;
			ss = Results.HitSector;
			hitl = Results.HitLine;
			htx = Results.HitTexture;
			typehit = Results.hittype;
			dirh = Results.HitVector;
			lsd = Results.Side;
			return TRACE_Stop;
		}
		
		if(Results.hittype == TRACE_HitWall)
		{
			if (Results.Tier == TIER_Middle)
			{
				// Stop on one-sided or hitscan-blocking linedefs.
				if (Results.HitLine.Flags & Line.ML_TWOSIDED == 0 ||Results.HitLine.Flags & Line.ML_BLOCKHITSCAN > 0)
				{
					endpos = Results.hitpos;
					ss = Results.HitSector;
					hitl = Results.HitLine;
					htx = Results.HitTexture;
					typehit = Results.hittype;
					dirh = Results.HitVector;
					lsd = Results.Side;
					return TRACE_Stop;
				}
				return TRACE_Skip; // Pass through two-sided linedefs that don't block hitscans.
			}
			
			if(Results.tier == TIER_FFloor)
			{
				if(Results.ffloor.flags & F3DFloor.FF_SWIMMABLE)
					return TRACE_Skip;
			}
			
			endpos = Results.hitpos;
			ss = Results.HitSector;
			hitl = Results.HitLine;
			htx = Results.HitTexture;
			typehit = Results.hittype;
			dirh = Results.HitVector;
			lsd = Results.Side;
			return TRACE_Stop; // Don't pass through upper, lower, or 3D floors.
		}
		
		if(Results.hittype == TRACE_HitFloor || Results.hittype == TRACE_HitCeiling)
		{
			endpos = Results.hitpos;
			ss = Results.HitSector;
			hitl = Results.HitLine;
			htx = Results.HitTexture;
			typehit = Results.hittype;
			dirh = Results.HitVector;
			lsd = Results.Side;
			return TRACE_Stop;
		}
		
		if (Results.HitType == TRACE_HitActor)
		{
			// Ignore source
			if(Results.HitActor && Results.hitactor.bshootable)
			{
				if(shooter && results.hitactor == shooter)
					return TRACE_Skip;
				
				let inf = TraceInfo.create(Results.HitActor,Results.HitPos);
				if(inf)
					Ti.push(inf);
				return TRACE_Skip;
			}
			
			return TRACE_Skip;
		}
		
		endpos = Results.hitpos;
		ss = Results.HitSector;
		hitl = Results.HitLine;
		htx = Results.HitTexture;
		typehit = Results.hittype;
		dirh = Results.HitVector;
		lsd = Results.Side;
		return TRACE_Stop;
	}
}

Class TraceInfo
{
	actor who;
	vector3 location;

	static TraceInfo create(actor v, vector3 loc)
	{
		TraceInfo n = new("TraceInfo");
		if(n)
		{
			n.who = v;
			n.location = loc;
			return n;
		}
		return null;
	}
}

class AimingToken : Inventory
{
	Default
	{
		Inventory.MaxAmount 1;
	}
}

Class PlayerMuzzleFlash : Actor
{
	Default
	{
		Speed 0;
		PROJECTILE;
		+NOCLIP;
		+NOGRAVITY;
		+NOINTERACTION;
	}
	
	States
	{
		Spawn:
			TNT1 A 2 BRIGHT;
			Stop;
	}
}