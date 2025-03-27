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
                pf.A_Startsound("Knife/Wall", CHAN_AUTO, CHANF_OVERLAP, 0.75);   //impacted wall,floor,etc
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
		if(SelectSound)
			A_Startsound(sound(SelectSound),7);
	}

	//BW default A_Lower function
	action void BW_WeaponLower()
	{
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

Class BW_BulletPuff : Actor replaces bulletpuff
{
	default
	{
		height 1;
		radius 1;
		+noblockmap;
		+nogravity;
		scale 0.1;
	}
	states
	{
		spawn:
			FX33 ABCDEFGHIJK 1 bright;
			stop;
	}
}

class BW_dmgpuff : BW_BulletPuff
{
	default
	{
		height 1;
		radius 1;
		+noblockmap;
	}
	states
	{
		spawn:
			TNT1 A 1;
			stop;
	}
}



class BW_impactpuff : BW_BulletPuff
{
	vector3 norm;
	name tp;
	vector3 impctDir;
	int impactType;
	double wang;
	default
	{
		+noblockmap;
		+nointeraction;
		height 1;
		radius 1;
		scale 0.1;
	}
	states
	{
		Spawn:
			TNT1 A 0;
			TNT1 A 1 a_spawnimpact();
			TNT1 A 0;
			stop;
	}
	
	enum Puff_ImpactType {
		IMP_WALL = 0,
		IMP_FLOOR = 1,
		IMP_CEIL = 2,
	}
	
	void a_spawnimpact()
	{
		//A_SprayDecal("BulletChip",10,(0,0,0),impctDir);
		DoDecal();
		if(waterlevel > 0)
		{
			SpawnPx_Bubbles();
			return;
		}
		
		switch(tp)
		{
			case 'Crystal':
			case 'Carpet':	SpawnImpact_Carpet();	spawnMainPuff();	break;
			case 'Marble':
			case 'PurpleStone':
			case 'Gravel':
			case 'BurnStone':
			case 'Stone':	SpawnImpact_Stone();	spawnMainPuff();	break;
			case 'Electric':
			case 'Metal':	SpawnImpact_Metal();	spawnMainPuff();	break;
			case 'Wood':	SpawnImpact_Wood();	spawnMainPuff();		break;
			case 'Dirt':	SpawnImpact_Dirt();	spawnMainPuff();		break;
			case 'Water':	SpawnImpact_water(tp);	spawnMainPuff();	break;
			case 'Slime':	SpawnImpact_water(tp);	spawnMainPuff();	break;
			case 'PurpleWater': SpawnImpact_water(tp);	spawnMainPuff();	break;
			case 'Blood': SpawnImpact_water(tp);	spawnMainPuff();	break;
			case 'Flesh': SpawnImpact_water(tp);	spawnMainPuff();	break;
			case 'Lava': SpawnImpact_water(tp);	spawnMainPuff();	break;
			case 'Sky':	break;
		}
	}
	
	void DoDecal()
	{
		
		if(impactType == IMP_WALL)
		{
			string typ = "Impact_Stone";
			switch(tp)
			{
				case 'Carpet':	typ = "BulletChip";	break;
				case 'Dirt':
				case 'PurpleStone':
				case 'Gravel':
				case 'Marble':
				case 'Stone':	typ = "Impact_Stone";	break;
				case 'Crystal':	typ = "Impact_Crystal";	break;
				case 'Electric':
				case 'Metal':	typ = "Impact_Metal";	break;
				case 'Wood':	typ = "Impact_Wood";		break;
				case 'Blood':
				case 'Water':	
				case 'Slime':	
				case 'PurpleWater': 
				case 'Lava':
				case 'Sky':	typ = "noDec";	break;
			}
			if(typ == "noDec")
				return;
			A_SprayDecal(typ,10,(0,0,0),impctDir);
		}
		else
		{
			double zfx = (impactType == IMP_FLOOR) ? self.floorz : self.ceilingz;
			double newpitch = atan2(norm.z,norm.x);
			string typ = "FlatDecal_Concrete";
			switch(tp)
			{
				case 'Carpet':	typ = "FlatDecal_Concrete";	break;
				case 'Dirt':
				case 'PurpleStone':
				case 'Gravel':
				case 'Stone':	typ = "FlatDecal_Concrete";	break;
				case 'Crystal':	typ = "FlatDecal_Concrete";	break;
				case 'Electric':
				case 'Metal':	typ = "FlatDecal_Metal";	break;
				case 'Wood':	typ = "FlatDecal_Wood";		break;
				case 'Blood':
				case 'Lava':
				case 'Water':	
				case 'Slime':	
				case 'PurpleWater': 
				case 'Sky':	typ = "noDec";	break;
			}
			if(typ == "noDec")
				return;
			actor fd = spawn(typ,(pos.xy,zfx));
			if(fd)
			{
				if(norm.z == -1.0 || norm.z == 1.0)
				{
					if(impactType == IMP_CEIL)
						fd.pitch = 180;
					else
						fd.pitch = 0;
					return;
				}
				Vector2 norm_p1 = (norm.X != 0 || norm.Y != 0) ? (norm.X, norm.Y).Unit() : (0, 0);
				Vector2 norm_p2 = ((norm.X, norm.Y).Length(), norm.Z);
				double dang = fd.Angle;
				double fang = atan2(norm_p1.Y, norm_p1.X);
				double fpitch = atan2(norm_p2.X, norm_p2.Y);
				double ddiff1 = sin(fang - (dang));
				double ddiff2 = cos(fang - dang);
				fd.Pitch = (fpitch * ddiff2);
				fd.Roll = -fpitch * ddiff1;
				fd.Angle = dang;
			}
		}
	}

	void spawnMainPuff()
	{
		if(random[PUFFX]() < 128)
			spawn("BW_PuffHit",pos);
	}
	
	void SpawnImpact_Stone()
	{
		/*FSpawnParticleParams Smkfx;
		//vector3 ofs = levellocals.vec3offset(pos,norm * frandom(0.5,1.75);
		Smkfx.Pos = pos; //+ ofs;
		Smkfx.Texture = TexMan.CheckForTexture("SM7CA0");//("SMK1I0");
		switch(random(1,3))
		{
			case 1:	Smkfx.Color1 = "5B5B5B";	break;
			case 2:	Smkfx.Color1 = "939393";	break;
			case 3:	Smkfx.Color1 = "FFFFFF";	break;
		}
		Smkfx.Style = STYLE_Translucent;
		Smkfx.Flags = SPF_ROLL;
		
		Smkfx.Startroll = random(0,360);
		Smkfx.RollVel = frandom(-5,5);
		Smkfx.StartAlpha = 0.65;
		Smkfx.Size = frandom(18,40);
		Smkfx.SizeStep = 1.5;
		Smkfx.Lifetime = Random(10,18); 
		Smkfx.FadeStep = Smkfx.StartAlpha / Smkfx.Lifetime;*/
		//spawnPx_Stone();
		for(int i = 0; i < random(1,2); i++)
		{
			actor fxs = spawn("GraySmoke",pos);
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			
			fxs.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			//Level.SpawnParticle (Smkfx);
		}
	}
	
	void SpawnImpact_Metal()
	{
		/*SpawnFlare(pos);
		FSpawnParticleParams MetalFx;
		MetalFx.Texture = TexMan.CheckForTexture("SPKOA0");//("SMK1I0");
		MetalFx.Color1 = "FFFFFF";
		MetalFx.Style = STYLE_ADD;
		MetalFx.Flags = SPF_FULLBRIGHT|SPF_ROLL;
		MetalFx.Startroll = random(0,360);
		MetalFx.RollVel = frandom(-5,5);
		MetalFx.StartAlpha = 0.75;
		MetalFx.Size = frandom(3,8);
		MetalFx.SizeStep = -0.2;
		MetalFx.Lifetime = Random(6,10); 
		MetalFx.FadeStep = 0.1;
		MetalFx.Pos = pos;
		vector3 tofs = (0,0,0);*/
		vector3 tofs = (0,0,0);
		SpawnFlare(pos);
		for(int i = 0; i < random(2,4); i++)
		{
			actor cs = spawn("BWSpark",pos);
			//MetalFx.accel = (0,0,frandom(-0.75,-0.2));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				tofs = (rotatevector((frandom(-4.5,4.5),frandom(-1.5,1.5)),wang),frandom(-1.5,1.5));
				cs.setxyz(pos + tofs);
				fs = (norm.x * frandom(0.75,2.55),norm.y * frandom(0.75,1.25),norm.z + frandom(0.75,1.8));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-3.5,3.5),norm.y + frandom(-3.5,3.5),norm.z * frandom(2.5,6.2));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			cs.Vel = norm + fs; //* random(2,5)) + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
		//	Level.SpawnParticle (MetalFx);
		}
	}
	
	void SpawnImpact_Wood()
	{
		/*FSpawnParticleParams WoodFx;
		WoodFx.Pos = pos;
		WoodFx.Texture = TexMan.CheckForTexture("SM7CA0");//("SMK1I0");
		WoodFx.Color1 = "CA9B7A";
		WoodFx.Style = STYLE_Translucent;
		WoodFx.Flags = SPF_ROLL;
		WoodFx.Startroll = random(0,360);
		WoodFx.RollVel = frandom(-5,5);
		WoodFx.StartAlpha = 0.65;
		WoodFx.Size = frandom(20,40);
		WoodFx.SizeStep = 1.5;
		WoodFx.Lifetime = Random(10,18); 
		WoodFx.FadeStep = WoodFx.StartAlpha / WoodFx.Lifetime;
		spawnPx_Wood();*/
		for(int i = 0; i < random(1,3); i++)
		{
			actor bs = spawn("brownsmoke",pos);
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			bs.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			//Level.SpawnParticle (WoodFx);
		}
	}
	
	void SpawnImpact_Dirt()
	{
		/*FSpawnParticleParams WoodFx;
		WoodFx.Pos = pos;
		WoodFx.Texture = TexMan.CheckForTexture("SM7CA0");//("SMK1I0");
		WoodFx.Color1 = "CA9B7A";
		WoodFx.Style = STYLE_Translucent;
		WoodFx.Flags = SPF_ROLL;
		WoodFx.Startroll = random(0,360);
		WoodFx.RollVel = frandom(-5,5);
		WoodFx.StartAlpha = 0.65;
		WoodFx.Size = frandom(20,40);
		WoodFx.SizeStep = 1.5;
		WoodFx.Lifetime = Random(10,18); 
		WoodFx.FadeStep = WoodFx.StartAlpha / WoodFx.Lifetime;*/
		for(int i = 0; i < random(1,3); i++)
		{
			actor bs = spawn("brownsmoke",pos);
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			bs.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			//Level.SpawnParticle (WoodFx);
		}
	}
	
	void SpawnImpact_Carpet()
	{
		/*FSpawnParticleParams Smkfx;
		Smkfx.Pos = pos;
		Smkfx.Texture = TexMan.CheckForTexture("SM7CA0");//("SMK1I0");
		Smkfx.Color1 = "FFFFFF";
		Smkfx.Style = STYLE_Translucent;
		Smkfx.Flags = SPF_ROLL;
		
		Smkfx.Startroll = random(0,360);
		Smkfx.RollVel = frandom(-5,5);
		Smkfx.StartAlpha = 0.45;
		Smkfx.Size = frandom(20,40);
		Smkfx.SizeStep = 1.5;
		Smkfx.Lifetime = Random(10,16); 
		Smkfx.FadeStep = Smkfx.StartAlpha / Smkfx.Lifetime;
		//spawnPx_Stone();*/
		for(int i = 0; i < random(1,2); i++)
		{
			actor fxs = spawn("GraySmoke",pos);
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.2,0.55),norm.y * frandom(0.2,0.55),norm.z * frandom(0.25,0.75));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x * frandom(-1.0,1.0),norm.y * frandom(-1.0,1.0),norm.z * frandom(0.2,0.5));
			}
			fxs.Vel = norm + fs;	//(frandom (0.1,-0.1),frandom (0.1,-0.1),frandom (0.6,1.5)); 
			//Level.SpawnParticle (Smkfx);
		}
	}
	
	void SpawnImpact_water(name type = 'water')
	{
		/*FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = pos;
		WTFSMK.Texture = TexMan.CheckForTexture("SM7CA0");//("SMK1I0");
		WTFSMK.Color1 = col;//"CA9B7A";
		WTFSMK.Style = STYLE_Translucent;
		WTFSMK.Flags = SPF_ROLL;
		WTFSMK.Startroll = random(0,360);
		WTFSMK.RollVel = frandom(-5,5);
		WTFSMK.StartAlpha = 0.65;
		WTFSMK.Size = frandom(20,40);
		WTFSMK.SizeStep = 1.5;
		WTFSMK.Lifetime = Random(10,18); 
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		WTFSMK.Vel = norm * 0.5;
		Level.SpawnParticle (WTFSMK);
		
		
		FSpawnParticleParams WTRPX;
		
		WTRPX.Texture = TexMan.CheckForTexture(splashsprite);//("SMK1I0");
		WTRPX.Color1 = "FFFFFF";
		WTRPX.Style = STYLE_Translucent;
		WTRPX.Flags = SPF_ROLL;
		WTRPX.Startroll = random(0,360);
		WTRPX.RollVel = frandom(-15,15);
		WTRPX.StartAlpha = 1.0;
		
		WTRPX.SizeStep = -2;
		WTRPX.Pos = pos;
		WTRPX.FadeStep = 0.075;
		vector3 tofs = (0,0,0);*/
		string tospawn = "BW_Splash";
		switch(type)
		{
			case 'Slime':
			case 'Water':		tospawn = "BW_Splash";	break;
			case 'PurpleWater':	tospawn = "BW_PurpleSplash"; break;
			case 'Flesh':
			case 'Blood':	ToSpawn = "BW_BloodSplash";	break;
			case 'Lava':	ToSpawn = "BW_LavaSplash";	break;
		}
		vector3 tofs = (0,0,0);
		for(int i = 0; i < random(2,5); i++)
		{
			actor ws = spawn(tospawn,pos);
			//WTRPX.Size = frandom(18,26);
			//WTRPX.Lifetime = Random(5,8); 
			//WTRPX.accel = (0,0,frandom(-0.75,-0.4));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				tofs = (rotatevector((frandom(-2.5,2.5),frandom(-0.5,0.5)),wang),frandom(-0.5,0.5));
				ws.setxyz(pos + tofs);
				fs = (norm.x * frandom(0.75,2.5),norm.y * frandom(0.75,2.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.0,2.0),norm.y + frandom(-2.0,2.0),norm.z * frandom(1.5,3.0));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			ws.Vel = norm + fs;//(norm * random(2,3));	
			//Level.SpawnParticle (WTRPX);
		}
	}
	
	
	void SpawnFlare(vector3 position, bool bigger = false)
	{
		spawn("BW_Flare",pos);
		/*FSpawnParticleParams FFLAR;
		FFLAR.Texture = TexMan.CheckForTexture("LENYA0");
		FFLAR.Color1 = "FFFFFF";
		FFLAR.Style = STYLE_ADD;
		FFLAR.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FFLAR.Vel = (0,0,0);
		FFLAR.Startroll = random(0,360);
		FFLAR.RollVel = frandom(-3,3);
		FFLAR.StartAlpha = 0.85;
		FFLAR.FadeStep = bigger ? 0.15 : 0.25;
		FFLAR.Size = random(24,28);
		FFLAR.SizeStep = 2;
		FFLAR.Lifetime = bigger ? random(3,6): 1; 
		FFLAR.Pos = position;
		Level.SpawnParticle(FFLAR);*/
	}
	
	void SpawnPx_Bubbles()
	{
		
		/*FSpawnParticleParams BUBBLEPX;
		BUBBLEPX.Pos = pos;
		BUBBLEPX.Texture = TexMan.CheckForTexture("BUBLA0");//("SMK1I0");
		BUBBLEPX.Color1 = "FFFFFF";//"CA9B7A";
		BUBBLEPX.Style = STYLE_Translucent;
		BUBBLEPX.Flags = SPF_ROLL;
		BUBBLEPX.Startroll = random(0,360);
		BUBBLEPX.RollVel = frandom(-5,5);
		BUBBLEPX.StartAlpha = 0.75;
		
		BUBBLEPX.SizeStep = 0.1;
		
		BUBBLEPX.FadeStep = 0.15;
		vector3 tofs = (0,0,0);*/
		vector3 tofs = (0,0,0);
		for(int j = 0; j < random(2,4); j++)
		{
			actor bbl = spawn("BW_Bubble",pos);
			//BUBBLEPX.Lifetime = Random(5,8); 
			//BUBBLEPX.Size = frandom(10,20);
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				tofs = (rotatevector((frandom(-2.5,2.5),frandom(-0.5,0.5)),wang),frandom(-0.5,0.5));
				bbl.Setxyz(pos + tofs);
				fs = (norm.x * frandom(0.5,1.75),norm.y * frandom(0.5,1.75),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			bbl.Vel = norm + fs;
			//Level.SpawnParticle (BUBBLEPX);
		}
	}
	
	void spawnPx_Wood()
	{
		/*FSpawnParticleParams WOODPX;
		WOODPX.Pos = pos;
		WOODPX.Texture = TexMan.CheckForTexture("WSPXA0");//("SMK1I0");
		WOODPX.Color1 = "FFFFFF";
		WOODPX.Style = STYLE_Translucent;
		WOODPX.Flags = SPF_ROLL;
		WOODPX.Startroll = random(0,360);
		WOODPX.RollVel = frandom(-5,5);
		WOODPX.StartAlpha = 1.0;
		WOODPX.Size = frandom(3,8);
		WOODPX.SizeStep = -0.2;
		WOODPX.Lifetime = Random(7,10); 
		WOODPX.FadeStep = 0.1;
		for(int i = 0; i < random(1,2); i++)
		{
			WOODPX.accel = (0,0,frandom(-0.6,-0.1));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.5,1.75),norm.y * frandom(0.5,1.75),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			WOODPX.Vel = norm + fs;//(norm * random(2,7));	
			Level.SpawnParticle (WOODPX);
		}*/
	}
	
	void spawnPx_Stone()
	{
		/*FSpawnParticleParams STNPX;
		STNPX.Pos = pos;
		STNPX.Texture = TexMan.CheckForTexture("D1BSA0");//("SMK1I0");
		STNPX.Color1 = "FFFFFF";
		STNPX.Style = STYLE_Translucent;
		STNPX.Flags = SPF_ROLL;
		STNPX.Startroll = random(0,360);
		STNPX.RollVel = frandom(-5,5);
		STNPX.StartAlpha = 1.0;
		STNPX.Size = frandom(3,5);
		STNPX.SizeStep = 0;
		STNPX.Lifetime = Random(5,7); 
		STNPX.FadeStep = 0.15;
		for(int i = 0; i < random(1,2); i++)
		{
			STNPX.accel = (0,0,frandom(-0.9,-0.35));
			vector3 fs = (0,0,0);
			if(impactType == IMP_WALL)
			{
				fs = (norm.x * frandom(0.5,1.75),norm.y * frandom(0.5,1.75),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_FLOOR)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.5,1.1));
			}
			else if(impacttype == IMP_CEIL)
			{
				fs = (norm.x + frandom(-2.5,2.5),norm.y + frandom(-2.5,2.5),norm.z * frandom(0.2,0.5));
			}
			STNPX.Vel = norm + fs;	
			//Level.SpawnParticle (STNPX);
		}*/
	}
	
}

Class BW_KickPuff : BW_BulletPuff
{
	default
	{
		projectilekickback 200;
	}
	states
	{
		spawn:
			TNT1 A 0; 
			TNT1 AAA 0 A_SpawnItemEx("GraySmoke",0,0,0,frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5));
			TNT1 A 1;
			stop;
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