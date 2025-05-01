//
//
//	Base class for monsters
//
//
Class BW_MonsterBase : Actor
{
	double headheight;
	property headheight:headheight;
	double headshotmult;
	property HeadShotMult:HeadShotMult;
	double feetheight;
	property feetheight:feetheight;
	bool canReceiveHead;
	property HasHeadshot:canReceiveHead;
	bool onlyfronthead;
	property onlyfronthead:onlyfronthead;
	bool hasnuts;
	property nuts:hasnuts;
	name LastHit;

	double YscaleFix;	//this is the real scale.y value monsters should use, since it accounts for the pixel stretch
	
	default
	{
		BW_MonsterBase.headheight 38;
		BW_MonsterBase.feetheight 18;
		//thisll need to be adjusted on a monster per monster basis still.
		BW_MonsterBase.HeadShotMult 2.0;	//1.75
		BW_MonsterBase.HasHeadshot true;
		BW_MonsterBase.onlyfronthead false;	//head can only be hit by front attacks
		BW_MonsterBase.nuts false;			//self explanatory
		Monster;
		+FLOORCLIP;
		+SLIDESONWALLS;
		+DOHARMSPECIES;
		+HARMFRIENDS;
		+ROLLSPRITE;
		+ROLLCENTER;
		+FORCEPAIN;
		//+STRETCHPIXELS; //lzdoom compat
		
		health 100;
		MaxStepHeight 24;
		MaxDropOffHeight 32;
		//height 56
		//radius 20
	}

	states
	{
		Death.LF:
			"####" "###" 1;
			//TNT1 A 1;
			stop;
	}
	
	//
	//
	//	
	//
	//
	override int DamagemObj(Actor inflictor,Actor source,int damage,Name mod,int flags,double angle)
	{
		if(inflictor && canReceiveHead) //damaged by projectile or puff
		{
			vector3 hitpos = inflictor.pos;
			
			//if headheight/feetheight is negative, use it as a percentage instead
			int Headh = headheight >= 0 ? headheight : height * abs(headheight);
			int Feeth = feetheight >= 0 ? feetheight : height * abs(feetheight);

			double aa = deltaangle(self.angle,angleto(inflictor));
			//console.printf("deltaAngle: %f",aa);
			
			//this should be cleaner now
			if(hitpos.z - floorz > Headh)			// = hit head
			{
				if(onlyfronthead)
				{
					//	pretty much the middle body checks
					if(aa > -30 && aa < 30)				//hit front
						LastHit = 'Head';
					else if(aa >= 30 && aa < 150)		//hit left
						LastHit = 'LeftArm';
					else if(aa > -150 && aa <= -30)		//hit right
						LastHit = 'RightArm';
					else if((aa <= 180 && aa >= 150) || (aa >= -180 && aa <= -150))	//hit back
						LastHit = 'Back';
					else
						LastHit = 'Chest';
				}
				else
				{
					damage *= HeadShotMult;
					LastHit = 'Head';
				}
			}
			else if(hitpos.z - floorz < Feeth)		// = hit feet
			{
				if(hasnuts)
				{
					if(aa > -30 && aa < 30)				//hit front
						LastHit = 'Nuts';
					else if(aa >= 30 && aa < 180)		//hit left
						LastHit = 'LeftFoot';
					else		//hit right
						LastHit = 'RightFoot';
				}
				else
				{
					//i have only two sides usually
					if(aa >= 0)							//hit left
						LastHit = 'LeftFoot';
					else								//hit right
						LastHit = 'RightFoot';
				}
			}
			else									// = hit body
			{
				if(aa > -30 && aa < 30)				//hit front
					LastHit = 'Chest';
				else if(aa >= 30 && aa < 150)		//hit left
					LastHit = 'LeftArm';
				else if(aa > -150 && aa <= -30)		//hit right
					LastHit = 'RightArm';
				else if((aa <= 180 && aa >= 150) || (aa >= -180 && aa <= -150))	//hit back
					LastHit = 'Back';
				else
					LastHit = 'Chest';
			}

			if(BW_Debug == 2)
				console.printf("hit: \cd%s\c-'s \cy%s\c-, inflict: \ca%d\c- damage of type: \cy%s\cy",gettag(),lasthit,damage,mod);
			
		}
		return super.DamagemObj(inflictor,source,damage,mod,flags,angle);
	}
	
	static const double crd[] = {	//
		0,//front
		90,	//left
		180,//back
		-90,//right
		-180//back
	};
	int dx;
	void testhitzones(int tc = 35)
	{
		if(health < 1)
			return;
		int rd = radius; /// 2;
		for(int i = -radius; i <= radius; i+=rd)
		{
			for(int j = -radius; j <= radius; j+=rd)
			{
				self.A_spawnparticle("GREEN",SPF_FULLBRIGHT|SPF_RELATIVE ,tc,2,angle + dx,j,i,self.headheight);
				self.A_spawnparticle("RED",SPF_FULLBRIGHT|SPF_RELATIVE ,tc,2,angle + dx,j,i,self.feetheight);
			}
		}
		dx += 10;
		
	}
	
	virtual void PlayFootsteps()
	{
		if(health < 1)
			return;
		sound snd = BW_StaticHandler.getmaterialstep(texman.getname(floorpic));
		A_Startsound(snd,CHAN_AUTO,volume:BW_enemyFootstepsVol,attenuation:(1200/700));
		// 
	}
	
	name GetHitZone()
	{
		return LastHit;
	}
	
	bool HitHead()
	{
		return (GetHitZone() == 'Head');
	}
	
	bool HitChest()
	{
		return (GetHitZone() == 'Chest');
	}
	
	bool HitBack()
	{
		return (GetHitZone() == 'Back');
	}
	
	bool HitRightArm()
	{
		return (GetHitZone() == 'RightArm');
	}
	
	bool HitLefttArm()
	{
		return (GetHitZone() == 'LeftArm');
	}
	
	bool HitRightFoot()
	{
		return (GetHitZone() == 'RightFoot');
	}
	
	bool HitLeftFoot()
	{
		return (GetHitZone() == 'LeftFoot');
	}
	
	bool HitArms()
	{
		return (HitRightArm() || HitLefttArm());
	}
	
	bool HitFeet()
	{
		return (HitRightFoot() || HitLeftFoot());
	}

	//
	//
	//

	int getSkill()
    {
        return G_SkillPropertyInt(SKILLP_SpawnFilter);
    }

	void BW_FireMonsterBullet(string missile,int numbullets = 1,double angleOfs = 3, double pitchOfs = 3,int zofs = 32, int xyofs = 0)
	{
		int bul = max(1,abs(numbullets));
		int skil = getSkill();
		for(int i = 0; i < bul; i++)
		{
			actor bullet = A_SpawnProjectile(missile, zofs, xyofs, (frandom(angleOfs,-angleOfs)), CMF_AIMDIRECTION, self.pitch + (frandom(pitchOfs,-pitchOfs)));
			if(bullet)
			{
				//maybe turning this into an option instead of a skill thing would work better
				switch(skil)
				{
					case BW_Spawner.Skill_Baby:
					case BW_Spawner.Skill_Easy:						break;	//50

					case BW_Spawner.Skill_Normal:
					case BW_Spawner.Skill_Hard:	bullet.vel *= 2;	break;	//100

					case BW_Spawner.Skill_Uber:	bullet.vel *= 6;	break;	//300, same as player ones
				}
			}
		}
	}

	//
	//	death related fx
	//
	void spawnBloodSpurt(int amnt = 5,int zofs = -1)
	{
		if(zofs == -1)
			zofs = headheight;
		for(int i = 0; i < amnt; i++)
			A_SpawnItemEx("NashGoreBloodSpurt",
			frandom[rnd_SpawnBloodSpurt](-5.0, 5.0), frandom[rnd_SpawnBloodSpurt](-5.0, 5.0), zofs,
			frandom[rnd_SpawnBloodSpurt](-2.0, 2.0), frandom[rnd_SpawnBloodSpurt](-2.0, 2.0), frandom[rnd_SpawnBloodSpurt](4.0, 8.0),
			frandom[rnd_SpawnBloodSpurt](0.0, 360.0),
			NashGoreBloodBase.BLOOD_FLAGS);
	}

	void BW_SpawnGib(string type,vector3 spawnpos,double frontspeed = 1, double sidespeed = 1, double zpeed = 0)
	{
		if(!type)
			return;
		vector3 desVel = (0,0,0);
		if(frontspeed != 0)
		{
			vector3 fw = (cos(angle),sin(angle),0);
			desVel += (fw * frontspeed);
		}
		if(sidespeed != 0)
		{
			vector3 sd = (cos(angle-90),sin(angle-90),0);
			desVel += (sd * sidespeed);
		}
		if(zpeed != 0)
			desvel.z += zpeed;
		actor gibbie = spawn(type,spawnpos);
		if(gibbie)
		{
			gibbie.vel = desvel;
		}
	}
	
}

//
//
//
//

Class BW_DeathTokenBase : Inventory
{
	default
	{
		inventory.maxamount 1;
	}
	override void tick()
	{}
}

Class BW_HeadDeath : BW_DeathTokenBase
{}

Class BW_ArmDeath : BW_DeathTokenBase
{}

Class BW_LegDeath : BW_DeathTokenBase
{}
