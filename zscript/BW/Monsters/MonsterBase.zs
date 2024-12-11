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
	name LastHit;
	
	default
	{
		BW_MonsterBase.headheight 48;
		BW_MonsterBase.feetheight 15;
		BW_MonsterBase.HeadShotMult 1.75;
		BW_MonsterBase.HasHeadshot true;
		health 9000;
		//height 56
		//radius 20
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
			
			//string hitinfo = "Hit: ";
			
			if(aa > -60 && aa < 60)				//hit front
			{
				//hitinfo = hitinfo.."\cvFront\c-";
				LastHit = 'Front';
			}
			else if(aa >= 60 && aa < 135)		//hit left
			{
				//hitinfo = hitinfo.."\cvLeft Arm\c-";
				LastHit = 'LeftArm';
			}
			else if(aa > -135 && aa <= -60)		//hit right
			{
				//hitinfo = hitinfo.."\cvRight Arm\c-";
				LastHit = 'RightArm';
			}
			else if((aa <= 180 && aa >= 135) || (aa >= -180 && aa <= -135))	//hit back
			{
				//hitinfo = hitinfo.."\cvBack\c-";
				LastHit = 'Back';
			}
			//console.printf("hitposz: "..hitpos.z.."");
			if(hitpos.z - floorz > Headh)		//head
			{
				//hitinfo = hitinfo.." at \cdHead\c-";
				damage *= HeadShotMult;
				LastHit = 'Head';
			}
			else if(hitpos.z - floorz < Feeth)	//feet
			{
				//hitinfo = hitinfo.." at \cdFeet\c-";
				if(LastHit == 'RightArm')
				{
					LastHit = 'RightFoot';
				}
				else
				{
					LastHit = 'LeftFoot';
				}
			}
			else
			{
				//hitinfo = hitinfo.." at \cdBody\c-";
				if(LastHit != 'RightArm' && LastHit != "LeftArm" && LastHit != "Back")
					LastHit = 'Chest';
			}
			//hitinfo = hitinfo.." (angle: \cb"..aa.."\c-) damage dealt:	\cg"..damage.."\c-.";
			
			//console.printf("hit at: "..LastHit..", damage: "..damage.."( type: "..mod..") , Health now: "..(health - damage));
			
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
	
	Void PlayFootsteps()
	{
		if(health < 1)
			return;
		sound snd = BW_StaticHandler.getmaterialstep(texman.getname(floorpic));
		A_Startsound(snd,CHAN_AUTO);
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