
Class BW_Tesla : BaseBWWeapon
{
	default
	{
		weapon.slotnumber 7;
		weapon.ammotype1 "BW_TeslaCell";
		weapon.ammotype2 "TeslaAmmo";
		weapon.ammogive1 50;
		BaseBWWeapon.FullMag 50;
		scale 0.8;
		Inventory.Pickupmessage "[Slot 7] TeslaGewehr 1942";
		Tag "TeslaGewehr";
		Inventory.PickupSound "Generic/Pickup/Launcher";
	}
	int fired;
	states
	{
		spawn:
			TLPK A -1;
			stop;
			
		Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Launcher/Raise");
			BTSU AB 1;
			TNT1 A 0 A_StartSound("Tesla/Raise", 0, CHANF_OVERLAP, 1);
			BTSU CD 1;
			goto ready;
			
		Deselect:
			TNT1 A 0 BW_SetReloading(false);
			TNT1 A 0 A_Startsound("Tesla/Drop",0,CHANF_OVERLAP);
			BTSU FG 1;
			TNT1 A 0 A_StartSound("Generic/Launcher/Holster", 0, CHANF_OVERLAP, 1);
			BTSU HI 1;
			TNT1 A 0 BW_WeaponLower();
			wait;
			
		Ready:
			BTSU E 1 {
				resetcharge();
				return BW_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWUSER3);
			}
			loop;
			
		Fire:
			TNT1 A 0 BW_PrefireCheck(1,"Reload","DryFire");
			TNT1 A 0 A_startsound("Tesla/StartFire",31);
			BTSF A 1 bright;
		FireSpinLoop:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"AltFireSpinLoop1");
			TNT1 A 0 A_StartSound("Tesla/Spin",17);
			TNT1 A 0 A_Weaponoffset(0 + random(-1,1),32 + random(-1,0));
			BTSF B 1 bright FireSeekerLight();//firebeam();
			BTSF C 1 bright;
			
			TNT1 A 0 A_Weaponoffset(0,32);
			BTSF D 1 bright FireSeekerLight();//firebeam();
			BTSF E 1 bright;
			TNT1 A 0 A_Refire("FireSpinLoop2");
			goto StopSpin2;
			
		FireSpinLoop2:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 1,"AltFireSpinLoop2");
			TNT1 A 0 A_StartSound("Tesla/Spin",17);
			TNT1 A 0 A_Weaponoffset(0 + random(-1,1),32 + random(-1,0));
			BTSF F 1 bright FireSeekerLight();//firebeam();
			BTSF G 1 bright;
			BTSF H 1 bright;
			TNT1 A 0 A_Weaponoffset(0,32);
			BTSF I 1 bright FireSeekerLight();//firebeam();
			BTSF J 1 bright;
			TNT1 A 0 A_refire("FireSpinLoop");
			goto StopSpin;
		
		DryFire:
			TNT1 A 0 A_StartSound("Tesla/Spin",17);
			BTSB BCDEFGHIJ 1;
			goto ready;
		NoAmmo:
			BTSU E 1;
			goto ready;
			
		StopSpin:
			TNT1 A 0 A_StartSound("Tesla/StopSpin",17);
			BTSS BCDEFG 1;
			BTSB HIJ 1;
			goto ready;
		StopSpin2:
			TNT1 A 0 A_StartSound("Tesla/StopSpin",17);
			BTSS FG 1;
			BTSB HI 1;
			goto ready;
		
		AltStopSpin:
			TNT1 A 0 A_StartSound("Tesla/StopSpin",17);
			BTSB BCDEFG 1;
			BTSB HIJ 1;
			goto ready;
		AltStopSpin2:
			TNT1 A 0 A_StartSound("Tesla/StopSpin",17);
			BTSB FGHI 1;
			BTSB BCDEFGHIJ 1;
			goto ready;
		
		AltStopSpin3:
			TNT1 A 0 A_StartSound("Tesla/StopSpin",17);
			BTSS BCDEFG 1;
			BTSB HIJ 1;
			goto ready;
		AltStopSpin4:
			TNT1 A 0 A_StartSound("Tesla/StopSpin",17);
			BTSS FGHI 1;
			BTSB BCDEFGHIJ 1;
			goto ready;
		
		AltFire:
			BTSB A 1;
		AltFireSpinLoop1:
			TNT1 A 0 A_StartSound("Tesla/Spin",17);
			TNT1 A 0 resetcharge();
			BTSB BCDE 1;
			TNT1 A 0 A_refire("AltFireSpinLoop2");
			goto AltStopSpin2;
		AltFireSpinLoop2:
			TNT1 A 0 A_StartSound("Tesla/Spin",17);
			TNT1 A 0 resetcharge();
			BTSB FGHIJ 1;
			TNT1 A 0 A_refire("AltFireActualSpin1");
			goto AltStopSpin;
		
		AltFireActualSpin1:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 5,"AltFireSpinLoop1");
			TNT1 A 0 A_StartSound("Tesla/Spin",17);
			BTSS BCDE 1 {
				if(tappedButton(BT_ATTACK))
				{
					if(invoker.ammo2.amount > 4 && !invoker.fired)
					{
						invoker.fired = 3;
						firerail();
					}
					else
					{
						//play dryfire sound
					}
				}
				if(invoker.fired)
				{
					BW_ChangePsprite("BTSF");
					invoker.fired--;
				}
			}
			TNT1 A 0 A_refire("AltFireActualSpin2");
			goto AltStopSpin4;
		AltFireActualSpin2:
			TNT1 A 0 A_jumpif(invoker.ammo2.amount < 5,"AltFireSpinLoop2");
			TNT1 A 0 A_StartSound("Tesla/Spin",17);
			BTSS FGHIJ 1 {
				if(tappedButton(BT_ATTACK))
				{
					if(invoker.ammo2.amount > 4 && !invoker.fired)
					{
						invoker.fired = 3;
						firerail();
					}
					else
					{
						//play dryfire sound
					}
				}
				if(invoker.fired)
				{
					BW_ChangePsprite("BTSF");
					invoker.fired--;
				}
			}
			TNT1 A 0 A_refire("AltFireActualSpin1");
			goto AltStopSpin3;
			
		Reload:
			TNT1 A 0 BW_CheckReload(null,"Ready","NoAmmo",50,1);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BTSR ABCD 1;
			BTSR EFGH 1;
			BTSR IJKL 1;
			BTSR MNOP 1;
			TNT1 A 0 A_startsound("tesla/reltake",CHAN_AUTO);
			BTSR QRST 1;
			BTSR UVWX 1;
			BTSR YZZZZ 1;
			TNT1 A 0 A_Startsound("Generic/Cloth/Short",0);
			BTSC ABCD 1;
			BTSC EFGH 1;
			TNT1 A 0 BW_AmmoIntoMag(invoker.ammotype2.getclassname(),invoker.ammotype1.getclassname(),50,1);
			TNT1 A 0 A_startsound("tesla/relIns",CHAN_AUTO);
			BTSC IJKL 1;
			BTSC MNOP 1;
			BTSC QQQQQRSTU 1;
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BTSC V 1;
			BTSR GFEDCBA 1;
			goto ready;
		
		KickFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BTSK ABC 1;
			BTSK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			BTSK GHHHG 1;
			BTSK FEDCBA 1;
			goto ready;	
		SlideFlash:
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BTSK ABCD 1;
			BTSK EFGH 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			BTSK HHH 1;
			BTSK HHH 1;
			BTSK HHH 1;
			BTSK HHH 1;
			BTSK HHH 1;
			BTSK HHH 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BTSK FEDCBA 1;
			goto ready;
	}
	
	action void resetcharge()
	{
		invoker.fired = 0;
	}
	
	const beamdist = 50; //distance each individual beam will cover
	action void firebeam(int dmg = 45, int max = 5)
	{
		
		vector3 fw = (cos(angle),sin(angle),0);
		int playerz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
		playerz -= 6;
		
		
		//get the pitch and adjust the forward offset if looking up/down
		//cos(pitch) < 1.0, and get closer to 0 when looking up/down, ig sin(pitch) ** 2 could also work (yes,this time the calculator wasnt in radians :D)
		double pt = cos(pitch);
		if(pt < 1.0)
		{
			if(pt < 0.1) //if pt is lower than 0.1, set it as 0.1, so it doesnt spawn at player feets
				pt = 0.1;
			fw *= (pt*pt);
		}
		
		//double pit = clamp(pitch,-4,30); //clamp the pitch, so the beams always go forward, like the rtcw tesla gun
		
		double pit = pitch;
		//we'll fire 5 beams
		for(int i = 0; i < max; i++)
		{
			flinetracedata t;
			//randomize the beam direction
			double actpitch = pit + frandom(-4,10);
			double actangle = angle + frandom(-10,10);
			
			bool shouldEnd;	//indicates this beam should stop, since it either hit geometry or hit an actor or went too far
			int maxdistTravel = 450; //9 segments if it goes the full path
			bool isFirst = true;
			vector3 cursp = (pos.xy + fw.xy,pos.z + playerz);
			
			vector2 prevangles = (actangle,actpitch);
			vector3 hitloc;
			actor from;		//pointer to the last dummy puff, used to fire linetraces
			int safety = 0;	//just in case, we dont want infinite loops
			bool landed;	
			
			//fire the linetraces
			while(!shouldEnd)
			{
				bool avoid = false;
				if(safety > 12)	//normally no iteration should go this far, but just in case
				{
					shouldend = true;
					break;
				}
				
				if(isFirst)	//fire the trace from the player
				{
					linetrace(actangle,beamdist,actpitch,0,playerz,1,0,t);
					isFirst = false;
					avoid = true;
				}
				else		//fire the trace from the dummy puff
				{
					if(!from)
					{
						shouldend = true;
						break;
						return;
					}
					from.linetrace(prevangles.x,beamdist,prevangles.y,0,1,-1,0,t);
					
				}
				
				//substract the traveled distance
				maxdistTravel -= t.distance;
				
				//indicates the beam hit geometry
				if(t.hittype == TRACE_HitFloor ||
				t.hittype == TRACE_HitCeiling  ||
				t.hittype == TRACE_HitWall )
				{
					shouldEnd = true;
					landed = true;
				}
				
				//hit an actor
				if(t.hitactor != null)
				{
					if(from)
						t.hitactor.damagemobj(from,self,35,'Electric');
					else
						t.hitactor.damagemobj(self,self,35,'Electric');
					shouldEnd = true;
				}
				
				//check the distance left to travel
				if(maxdistTravel <= 0)
					shouldEnd = true;
				
				if(!avoid)	//skip the first beam
					drawbeam(cursp,t.hitlocation - t.hitdir,prevangles);
					
				safety++;
				//update variables
				cursp = t.hitlocation - t.hitdir;
				prevangles += (frandom(-15,15),frandom(15,-3));	//randomize the next beam direction
				hitloc = t.hitlocation - t.hitdir;
				from = spawn("TeslaPosPuff",cursp);		//spawn a dummy puff
				
			}
			//vector3 ds = levellocals.vec3diff(pos + (0,0,playerz),hitloc);
			//double di = ds.length();
			//console.printf("");
			//console.printf("hit %d took %d interations (maxdist: %d, traveled: %f)",i,ite,maxdisttravel,di);
			if(landed)
			{
				actor spk = spawn("EndFx",hitloc);
				if(spk)
					spk.A_Startsound("Tesla/Sparks");
					spk.A_startsound("Tesla/FireAdd",CHAN_AUTO, CHANF_OVERLAP, 1);
			}
			
		}
		
		BW_QuakeCamera(4, 1);
		BW_WeaponRecoilBasic(-0.1, frandom(-0.2,0.2));
		A_startsound("Tesla/Fire",32);
		A_startsound("Tesla/FireAdd",CHAN_AUTO, CHANF_OVERLAP, 1);
		A_SpawnItemEx("PlayerMuzzleFlash_Blue",30,0,45);
		if(invoker.ammo2.amount)
			invoker.ammo2.amount--;
	}
	
	action void drawbeam(vector3 cur, vector3 next,vector2 angles, bool islong = false)
	{
		actor beam;
		cur.z -= 5;
		
		vector3 diff = levellocals.vec3diff(cur,next);
		double dist = diff.length();
		
		beam = spawn("Tesla_Beam",cur);
		if(beam)
		{
			beam.angle = angles.x;
			beam.pitch = (angles.y - 90);
			beam.scale.y = (dist + 5);
			if(islong)
				beam.setstatelabel("LongSpawn");
		}
	}
	
	const teslaRailDist = 200;
	action void firerail()
	{
		double rad = radius;
		vector3 fw = (cos(angle) * rad,sin(angle) * rad,0);	//offset the spawn pos forward by radius of the player, so it doesnt spawn inside the player
		int playerz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
		playerz -= 6;
		
		
		//get the pitch and adjust the forward offset if looking up/down
		//cos(pitch) < 1.0, and get closer to 0 when looking up/down, ig sin(pitch) ** 2 could also work (yes,this time the calculator wasnt in radians :D)
		double pt = cos(pitch);
		if(pt < 1.0)
		{
			if(pt < 0.1) //if pt is lower than 0.1, set it as 0.1, so it doesnt spawn at player feets
				pt = 0.1;
			fw *= (pt*pt);
		}
		
		
		
		//quats works fine for the first beam, but the next ones will be misplaced for some reason
		/*quat base = quat.fromangles(angle,pitch,roll);
		vector3 ofs = base * (10,0,-5);
		vector3 spawnpos = levellocals.vec3offset((pos.xy,player.viewz),ofs);
		int playerz = spawnpos.z;*/
		
		//double pit = clamp(pitch,-4,30); //clamp the pitch, so the beams always go forward, like the rtcw tesla gun
		
		double pit = pitch;
		
		
		flinetracedata t;
		//randomize the beam direction
		double actpitch = pit;
		double actangle = angle;
		
		bool shouldEnd;	//indicates this beam should stop, since it either hit geometry or hit an actor or went too far
		int maxdistTravel = 2000; //9 segments if it goes the full path
		bool isFirst = true;
		vector3 cursp = (pos.xy + fw.xy,pos.z + playerz);
		
		vector2 prevangles = (actangle,actpitch);
		vector3 hitloc;
		actor from;		//pointer to the last dummy puff, used to fire linetraces
		int safety = 0;	//just in case, we dont want infinite loops
		bool landed;	
		
		//fire the linetraces
		while(!shouldEnd)
		{
			bool avoid = false;
			if(safety > 12)	//normally no iteration should go this far, but just in case
			{
				shouldend = true;
				break;
			}
			
			if(isFirst)	//fire the trace from the player
			{
				linetrace(actangle,radius*2,actpitch,0,playerz,1,0,t);
				isFirst = false;
				avoid = true;
			}
			else		//fire the trace from the dummy puff
			{
				if(!from)
				{
					shouldend = true;
					break;
					return;
				}
				from.linetrace(prevangles.x,max(maxdistTravel < teslaRailDist ? maxdistTravel : teslaRailDist,0),prevangles.y,0,1,-1,0,t);
				
			}
			
			//substract the traveled distance
			maxdistTravel -= t.distance;
			
			//indicates the beam hit geometry
			if(t.hittype == TRACE_HitFloor ||
			t.hittype == TRACE_HitCeiling  ||
			t.hittype == TRACE_HitWall )
			{
				shouldEnd = true;
				landed = true;
			}
			
			//hit an actor
			if(t.hitactor != null && t.hitactor != self)
			{
				if(from)
					t.hitactor.damagemobj(from,self,100,'Electric');
				else
					t.hitactor.damagemobj(self,self,100,'Electric');
				shouldEnd = true;
				landed = true;
			}
			
			//check the distance left to travel
			if(maxdistTravel <= 0)
				shouldEnd = true;
			vector3 zofs = (0,0,7 * sin(-prevangles.y));
			/*if(avoid)	//first beam
				drawbeam(cursp + zofs,t.hitlocation - t.hitdir,prevangles,true);
			else	//the next beams needs this little offset to look correct
			{
				drawbeam(cursp + zofs,t.hitlocation - t.hitdir,prevangles,true);
			}*/
			
			if(!avoid)
				drawbeam(cursp + zofs,t.hitlocation - t.hitdir,prevangles,true);
			
			safety++;
			//update variables
			cursp = t.hitlocation - t.hitdir;
			//prevangles += (frandom(-7,7),frandom(5,-3));	//randomize the next beam direction
			prevangles += (frandom(-7,7),frandom(5,-3));
			hitloc = t.hitlocation - t.hitdir;
			from = spawn("TeslaPosPuff",cursp);		//spawn a dummy puff
			
		}

		if(landed)
		{
			actor spk = spawn("EndFx",hitloc);
			if(spk)
				spk.A_Startsound("Tesla/Sparks");
			spawn("TeslaSparkbig",hitloc);
		}
			
		if(from)
		{
			blockthingsiterator bti = blockthingsiterator.create(from,300);
			actor mo;
			while(bti.next())
			{
				mo = bti.thing;
				if(mo && (mo.bismonster || mo.bshootable) && 
				mo != self && from.checksight(mo))
					mo.damagemobj(from,self,50,'electric',DMG_USEANGLE,from.angleto(mo));
			}
		}
			
		A_SpawnItemEx("PlayerMuzzleFlash_Blue",30,0,45);
		BW_QuakeCamera(6, 2);
		BW_WeaponRecoilBasic(-3, frandom(-0.75,0.75));
		A_startsound("Tesla/Fire",32);
		if(invoker.ammo2.amount)
			invoker.ammo2.amount -= 5;
	}
	
	
	
	action void FireSeekerLight()
	{
		blockthingsiterator bti = blockthingsiterator.create(self,500);
		array<bw_teslatarget> vic;
		int maxbeams = random(2,4);
		
		while(bti.next())
		{
			actor mo = bti.thing;
			double an = deltaangle(angle,angleto(mo));
			
			if(mo && mo.bismonster && mo.health > 0 && maxbeams > 0
			&& abs(an) < 45 && distance3d(mo) <= 450 && checksight(mo))
			{
				vic.push(
				bw_teslatarget.addnew(mo,mo.pos + (0,0,mo.height * 0.5),angleto(mo),pitchto(mo),distance3d(mo))
				);
				maxbeams--;
			}
		}
		
		int maxranbeams = 6 - maxbeams;
		firebeam(maxranbeams);
		
		if(vic.size() <= 0)
			return;
		
		
		vector3 fw = (cos(angle),sin(angle),0);
		int playerz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
		playerz -= 6;
	
		//get the pitch and adjust the forward offset if looking up/down
		//cos(pitch) < 1.0, and get closer to 0 when looking up/down, ig sin(pitch) ** 2 could also work (yes,this time the calculator wasnt in radians :D)
		double pt = cos(pitch);
		if(pt < 1.0)
		{
			if(pt < 0.1) //if pt is lower than 0.1, set it as 0.1, so it doesnt spawn at player feets
				pt = 0.1;
			fw *= (pt*pt);
		}
		
		for(int i = 0; i < vic.size(); i++)
		{
			if(!vic[i])
				continue;
			flinetracedata t;
			//randomize the initial beam direction
			double actpitch = pitch + frandom(-7,12);
			double actangle = angle + frandom(-12,12);
			bool isFirst = true;
			int safety = 0;
			vector3 cursp = (pos.xy + fw.xy,pos.z + playerz);
			double disttravel = vic[i].dist;
			int its = vic[i].dist / beamdist;
			its = max(1,its);
			vector2 prevangles = (actangle,actpitch);
			vector3 hitloc;
			bool landed;	
			bool shouldend;
			actor from;

			bool setted;
			
			while(!shouldend)
			{
				bool avoid = false;
				if(safety > 14)	//normally no iteration should go this far, but just in case
				{
					shouldend = true;
					break;
				}
				
				if(isFirst)	//fire the trace from the player
				{
					linetrace(actangle,beamdist,actpitch,0,playerz,1,0,t);
					isFirst = false;
					avoid = true;
				}
				else		//fire the trace from the dummy puff
				{
					if(!from)
					{
						shouldend = true;
						break;
						return;
					}
					from.linetrace(prevangles.x,
					max(disttravel < beamdist ? disttravel : beamdist,0)
					,prevangles.y,0,1,-1,0,t);
					
				}
				
				disttravel -= t.distance;
				
				if(disttravel <= 0)
				{
					shouldend = true;
					break;
				}
				safety++;
				if(!avoid)
					drawbeam(cursp,t.hitlocation - t.hitdir,prevangles);
				//update variables
				cursp = t.hitlocation - t.hitdir;
				//prevangles += (frandom(-7,7),frandom(5,-3));	//randomize the next beam direction
				if(safety < 2)
					prevangles += (frandom(-7,7),frandom(5,-3));
				else
				{
					if(!setted)
					{
						if(!from)
							from = spawn("TeslaPosPuff",cursp);
						//idk why i overcomplicated too much with this
						/*vector3 diffr = levellocals.vec3diff(from.pos,vic[i].tpos);
						vector3 dir = diffr.unit();
						double angh = atan2(dir.y,dir.x);
						double angv = atan(-dir.z/dir.x);*/
						double angh = from.angleto(vic[i].targ);
						double angv = from.pitchto(vic[i].targ);
						prevangles = (angh,angv);
						setted = true;
					}
					else
						prevangles += (frandom(-1.0,1.0),frandom(1.0,-1.0));
					
				}
				
				hitloc = t.hitlocation - t.hitdir;
				from = spawn("TeslaPosPuff",cursp);		//spawn a dummy puff
				from.angle = prevangles.x;
				from.pitch = prevangles.y;
			}
			
			if(landed)
			{
				actor spk = spawn("EndFx",hitloc);
				if(spk)
					spk.A_Startsound("Tesla/Sparks");
			}
			
			if(vic[i] && vic[i].targ)
			{
				if(from)
					vic[i].targ.damagemobj(from,self,35,'electric',DMG_USEANGLE,from.angleto(vic[i].targ));
				else
					vic[i].targ.damagemobj(self,self,35,'electric',DMG_USEANGLE,self.angleto(vic[i].targ));
			}
		}
		
		
		A_SpawnItemEx("PlayerMuzzleFlash_Blue",30,0,45);
		BW_QuakeCamera(4, 1);
		BW_WeaponRecoilBasic(-0.1, frandom(-0.2,0.2));
		A_startsound("Tesla/Fire",32);
		A_startsound("Tesla/AltAdd",CHAN_AUTO, CHANF_OVERLAP, 1);
		if(invoker.ammo2.amount)
			invoker.ammo2.amount--;
	}
	
	action double lerp(double a, double b, double t) 
	{
		return a + t * (b - a);
	}
}


Class TeslaAmmo : Ammo
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 50;
	}
}

class bw_teslatarget
{
	actor targ;
	vector3 tpos;
	double ang,pit;
	double dist;
	
	static bw_teslatarget addnew(actor t,vector3 ps,double an,double pit,double dis)
	{
		let n = new("bw_teslatarget");
		n.targ = t;
		n.tpos = ps;
		n.ang = an;
		n.pit = pit;
		n.dist = dis;
		return n;
	}
}


Class Tesla_Beam : Actor
{
	default
	{
		renderstyle "add";
		+bright;
		+INTERPOLATEANGLES;
		+nointeraction;
		//+notimefreeze;
		alpha 1.1;
	}
	states
	{
		spawn:
			MODL AAA 1 A_Fadeout(0.335);
			stop;
		LongSpawn:
			MODL AAAAAA 1 A_Fadeout(0.175);
			stop;
	}
}

class TeslaPosPuff : actor
{
	default
	{
		+nointeraction;
		radius 1;
		height 1;
	}
	states
	{
	spawn:
		TNT1 A 1;
		stop;
	}
}

Class EndFx : Actor
{
	default
	{
		+nointeraction;
		renderstyle "Add";
		scale 0.12;
		+bright;
		+rollsprite;
		+rollcenter;
	}
	states
	{
		spawn:
			XELC A 1;
			TNT1 A 1;
			XELC B 1;
			TNT1 A 1;
			XELC C 1;
			TNT1 A 1;
			XELC D 1;
			TNT1 A 1;
			XELC E 1;
			TNT1 A 1;
			XELC F 1;
			stop;
			//DB21 BBBB 1 bright A_fadeout(0.33);
			//PLSE ABCDE 2 Bright;
			stop;
	}
	override void postbeginplay()
	{
		super.postbeginplay();
		A_SetRoll(random(0,360));
		A_Setscale(scale.x + frandom(-0.02,0.03));
		A_Attachlight('TatsuroYamashita',DynamicLight.Pointlight,0x80FAFF,15,22);
	}
}

Class TeslaSparkbig : actor
{
	default
	{
		+nointeraction;
		renderstyle "add";
		+bright;
		+rollsprite;
		+rollcenter;
		scale 0.5;
	}
	states
	{
		spawn:
			STFL AAAAAA 1 {
				A_Setscale(scale.x + frandom(0.05,0.1));
				A_SetRoll(roll + random(10,20));
				//A_Fadeout(0.1);
			}
			TNT1 A 0 A_Setscale(frandom(0.4,0.6));
			XELC CDEF 1;
			stop;
	}
	override void postbeginplay()
	{
		super.postbeginplay();
		bxflip = random(0,1);
		A_SetRoll(random(0,360));
		A_Attachlight('TatsuroYamashita',DynamicLight.Pointlight,0x80FAFF,60,70);
	}
}