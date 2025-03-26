Class BWFxBase : Actor
{
	default
	{
		+nointeraction;
		+noblockmap;
		+forcexybillboard;
	}
}

Class GraySmoke : BWFxBase
{
	default
	{
		renderstyle "Translucent";
		scale 0.05;
		alpha 0.80;
		+rollsprite;
		+rollcenter;
	}
	states
	{
		Spawn:
			TNT1 A 0 nodelay A_jump(256,"Smk1","Smk2");
		Smk1:
			//X102 ABCDEFGHIJ 1 dosmokeroll();
			//SMK3 ABCDEFGHIJKLM 1 dosmokeroll();
			SM7C AAAAAAAAAA 1 dosmokeroll();
			stop;
		Smk2:
			//X102 KLMNOPQRSTUV 1 dosmokeroll();
			//SMK3 ABCDEFGHIJKLM 1 dosmokeroll();
			SM7C CCCCCCCCC 1 dosmokeroll();
			stop;
	}
	uint rolldir;
	void dosmokeroll()
	{
		A_setroll(roll + rolldir);
		A_Fadeout(frandom(0.08,0.1));
		A_setscale(scale.x + frandom(0.01,0.04));
		vel *= 0.95;
	}

	override void beginplay()
	{
		rolldir = random(15,30);
		A_setroll(random(0,360));
		super.beginplay();
	}
}

class BrownSmoke : GraySmoke
{
	default
	{
			alpha 0.75;
		//translation "0:255=#[120,81,66]";
	}
	states
	{
		spawn:
			DIRP DDDDDDDD 1 dosmokeroll();
			stop;
	}
}



class BWSpark : BWFxBase
{
	default
	{
		renderstyle "Add";
		+bright;
		scale 0.04;
	}
	states
	{
		Spawn:
			SPKO AAAAAAAAA 1 {
				A_fadeout(0.1);
				A_setscale(self.scale.x - 0.002);
				vel.z -= 1.9;
			}
			stop;
	}
}

Class BW_Splash : BWFxBase
{
	default
	{
		renderstyle "translucent";
		alpha 0.8;
		//scale 0.1;
		scale 0.86;
		+rollsprite;
		+rollcenter
	}
	states
	{
		spawn:
			//WTXP ABCDEFGHIJKL 1;
			//WTXP MNOPQR 1 A_Fadeout(0.2);
			WSPH AAAAAABCD 1 {vel.z -= 0.5; }
			stop;
	}
	override void beginplay()
	{
		A_setscale(self.scale.x + frandom(-0.1,0.1));
		A_SetRoll(random(0,360));
		super.beginplay();
	}
}

class BW_PurpleSplash : BW_Splash
{
	states
	{	
		Spawn:
			PSPH AAAAAABCD 1 {vel.z -= 0.5; }
			stop;
	}
}

class BW_BloodSplash : BW_Splash
{
	states
	{	
		Spawn:
			BSPH AAAAAABCD 1 {vel.z -= 0.5; }
			stop;
	}
}

class BW_LavaSplash : BW_Splash
{
	default
	{
		scale 0.3;
		renderstyle "Add";
		+bright;
	}
	states
	{	
		Spawn:
			FRPR ABCDEFG 1 {vel.z -= 0.5; }
			//LVAS GHIJK 1 {vel.z -= 0.5; }
			stop;
	}
}

class BW_Bubble : BWFxBase
{
	default
	{
		renderstyle "translucent";
	}
	states
	{
		spawn:
			BUBL AAAAA 1 A_Fadeout(0.15);
			stop;
	}
}

Class BW_Flare : BWFxBase
{
	default
	{
		renderstyle "Add";
		scale 0.075;
		alpha 0.5;
		+bright;
		
	}
	states
	{
		spawn:
			LENY AAAAA 1 A_Fadeout(0.1);
			stop;
	}
}

Class BW_PuffHit : BWFxBase
{
	default
	{
		renderstyle "Add";
		+bright;
		+rollsprite;
		+rollcenter;
		scale 0.12;
	}
	states
	{
		spawn:
			FX33 ADF 1 light("BPUFF1");	
			FX33 HIJ 1 light("BPUFF2");
			FX33 K 1;
			stop;
	}
	override void beginplay()
	{
		super.beginplay();
		self.bxflip = random(0,1);
		A_setscale(scale.x + frandom(-0.02,0.02));
		A_setroll(random(0,360));
	}
}

Class BW_CasingBase : Actor
{
	override void beginplay()
	{
		changestatnum(STAT_CASING);
		super.beginplay();
	}
}

Class FlatDecal : BWFxBase
{
	default
	{
		renderstyle "translucent";
		+rollsprite;
		+rollcenter;
	}
	states
	{
		Spawn:
			DECA L -1;
			stop;
	}
	override void beginplay()
	{
		changestatnum(STAT_FLATDECAL);
		//A_setroll(random(0,360));
		//A_setangle(random(0,360));
		A_Setangle(RandomPick(0, 90, 180, 270));
		A_Setscale(self.scale.x + frandom(-0.1,0.3));
		super.beginplay();
	}
	
	override void postbeginplay()
	{
		super.postbeginplay();
	}
}

Class FlatDecal_Concrete : FlatDecal
{}

Class FlatDecal_Metal : FlatDecal
{}

Class FlatDecal_Wood : FlatDecal
{}



//
//	gun smoke
//

Class BW_GunSmoke : BWFxBase
{
	default
	{
		renderstyle "Translucent";
		+missile;
		speed 12;
		alpha 0.3;
		scale 0.02;
		+rollsprite;
	}
	states
	{
		Spawn:
			SM7C A 1 dosmokeroll();
			SM7C AAAAAAAA 1 {
				dosmokeroll();
			}
			stop;
	}
	
	uint rolldir;
	double accfac;
	void dosmokeroll()
	{
		A_setroll(roll + rolldir);
		A_Fadeout(frandom(0.025,0.05));
		A_setscale(scale.x + frandom(0.025,0.05));
		vel -= vel*accfac;
	}
	override void beginplay()
	{
		rolldir = random(15,35);
		accfac = frandom(0.1,0.15);
		A_setroll(random(0,360));
		super.beginplay();
	}
}

Class BW_BarrelExplosionFx : BWFxBase
{
	default
	{
		//scale 1.2;
	}
	states
	{
		spawn:
			DB27 ABCDEFGHIJKLMNOPQRS 1 bright;
			DB27 TUVWXYZ 1;
			stop;
	}
}


class TreasureFinder : inventory
{
	override void Doeffect()
	{
		if(isfrozen())
			return;
		
		if(!owner || !owner.player || owner.health < 1)
			return;
		
		int c = owner.player.cmd.buttons;
		int old = owner.player.oldbuttons;
		
		if((c & BT_Zoom) && !(old & BT_Zoom))
			lookfortreasures();
		
		if(sx.size() > 0)
		{
			//quat b = quat.fromangles(owner.angle,owner.pitch,owner.roll);
			//vector3 np = b * (30,0,0);
			vector3 aaa = (cos(owner.angle),sin(owner.angle),0);
			vector3 np = aaa * 45;
			for(int i = 0; i < sx.size(); i++)
			{
				sx[i].setorigin(levellocals.vec3offset(owner.pos,np),false);
			}
			sx.clear();
		}
		
	}
	array <actor> sx;
	void lookfortreasures()
	{
		sx.clear();
		let ti = thinkeriterator.create("Actor");
		actor mo;
		while(mo = Actor(ti.next()))
		{
			if(mo is "ScoreItem") //|| mo is "Cross" || mo is "Radio")
			{
				console.printf("Found a \cd"..mo.gettag().." in the pos: "..mo.pos);
				sx.push(mo);
			}
		}
	}
}