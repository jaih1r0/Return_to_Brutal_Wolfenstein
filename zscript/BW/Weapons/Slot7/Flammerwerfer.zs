Class BW_FlameThrower : BaseBWWeapon
{
    default
    {
        weapon.slotnumber 7;
        Weapon.AmmoType "BW_GasCan";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 30;
		inventory.pickupmessage "[Slot 7] Flammenwerfer 35";
		tag "Flammenwerfer";
		scale 0.5;
    }

    action void FireFlames(bool take = true)
    {
        A_Fireprojectile("BW_FlameProjectile",0,0);
        BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15));
		if(take && invoker.ammo1.amount)
			invoker.ammo1.amount--;
    }

    action void fireStreamFlame(bool take = true)
    {
        double pz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
        pz -= 7;
		if(take)
			invoker.ammo1.amount--;
		FLineTraceData t;
        self.LineTrace(angle, 300, pitch,0, offsetz: pz,radius, data: t);
        if(t.hitactor != null && t.hitactor.health > 0)
        {
            t.hitactor.damagemobj(self,self,12,'Fire');
			//t.hitactor.GiveInventory("BW_BurningHandler",1);
        }
        vector3 cur = (pos.xy,pos.z + pz);
        vector3 dif = levellocals.vec3diff(cur,t.hitlocation);
        vector3 dir = dif.unit();
        int stps = (t.distance / 10) + 1;
        
        for(int i = 0; i < stps; i++)
        {
            cur += (dir * 10);
            spawnFlameTrail(cur);
        }

        BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15), 0, 0, 0);
    }

    states
    {
        spawn:
            BFLW A -1;
            stop;
        Select:
			TNT1 A 0 BW_WeaponRaise("Generic/Launcher/Raise");
            BFLU AB 1;
			TNT1 A 0 A_StartSound("Flamer/Draw", 0, CHANF_OVERLAP, 1);
			BFLU CD 1;
            goto ready;
        Deselect:
			TNT1 A 0 A_Stopsound(18);
            TNT1 A 0 A_clearoverlays(-5,-5);
			TNT1 A 0 A_StartSound("Flamer/Drop", 0, CHANF_OVERLAP, 1);
            BFLU FG 1;
			TNT1 A 0 A_StartSound("Generic/Launcher/Holster", 0, CHANF_OVERLAP, 1);
			BFLU HI 1;
            TNT1 A 0 BW_WeaponLower();
            wait;
        Ready:
            TNT1 A 0 {
                if(invoker.ammo1.amount > 0 && waterlevel < 1)
                    A_overlay(-5,"IdleFlameOverlay",true);
            }
            BFLU E 1 BW_WeaponReady();
            loop;
        Fire:
            TNT1 A 0 BW_PrefireCheck(1,"DryFire","DryFire",true);
            TNT1 A 0 A_clearoverlays(-5,-5);
			TNT1 A 0 A_Startsound("flamer/fireStart",17);
			BFLU E 1;
		FireLoop:
			TNT1 A 0 BW_PrefireCheck(1,"DryFire","DryFire",true);
			TNT1 A 0 A_Startsound("flamer/fireloop",18,CHANF_LOOPING);
            TNT1 A 0 A_Weaponoffset(0 + random(-1,1),32 + random(-1,0));
			BFLF A 1 bright FireFlames();
            BFLF B 1 bright;
			TNT1 A 0 A_Weaponoffset(0,32);
			BFLF C 1 bright FireFlames(false);
			BFLF D 1 bright;
            TNT1 A 0 A_refire("FireLoop");
			TNT1 A 0 A_Stopsound(18);
			TNT1 A 0 A_Startsound("flamer/hiss",17);
			BFLU E 1;
            goto ready;

       // AltFire:    //altfire is the same as Fire, just with a different method of spawning the flames 
            TNT1 A 0 BW_PrefireCheck(1,"DryFire","DryFire",true);
            TNT1 A 0 A_clearoverlays(-5,-5);
            BFLF A 1 bright fireStreamFlame();
            BFLF B 1 bright;
			BFLF C 1 bright fireStreamFlame(false);
			BFLF D 1 bright;
            TNT1 A 0 A_refire();
            goto ready;
        DryFire:
			TNT1 A 0 A_Stopsound(18);
            BFLU E 2;
            goto ready;
        
        IdleFlameOverlay:
            BFLI ABCDEFG 1 bright {
				if(waterlevel > 1)
					 A_clearoverlays(-5,-5);
			}
            loop;
        
        KickFlash:
			TNT1 A 0 A_clearoverlays(-5,-5);
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BFLK ABC 1 setpspriteifammo("BFLO");
			BFLK DEF 1 setpspriteifammo("BFLO");
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			BFLK GHHHG 1 setpspriteifammo("BFLO");
			BFLK FEDCBA 1 setpspriteifammo("BFLO");
			goto ready; 
		SlideFlash:
			TNT1 A 0 A_clearoverlays(-5,-5);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BFLK ABCD 1 setpspriteifammo("BFLO");
			BFLK EFGH 1 setpspriteifammo("BFLO");
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			BFLK GHG 1 setpspriteifammo("BFLO");
			BFLK HGH 1 setpspriteifammo("BFLO");
			BFLK GHG 1 setpspriteifammo("BFLO");
			BFLK HGH 1 setpspriteifammo("BFLO");
			BFLK GHG 1 setpspriteifammo("BFLO");
			BFLK HGH 1 setpspriteifammo("BFLO");
		SlideFlashEnd:
			TNT1 A 0 A_clearoverlays(-5,-5);
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BFLK FEDCBA 1 setpspriteifammo("BFLO");
			goto ready;
			
		KnifeGunFlash:
            TNT1 A 0 A_clearoverlays(-5,-5);
            BFLU FGHI 1;	//temporary
			TNT1 A 5;
			//TNT1 A 4;
			BFLU ABCD 1;
			stop;
		LoadSprites:
			BFLO A 0;
			stop;
    }
	
	action void setpspriteifammo(string spt)
	{
		if(invoker.ammo1.amount < 1 || waterlevel > 1)
			BW_ChangePsprite(spt);
	}

    action void spawnFlameTrail(vector3 position)
	{
		FSpawnParticleParams FTrail;
		//string f = String.Format("%c", int("G") + random(0,5));
		FTrail.Texture = TexMan.CheckForTexture("FRPRC0");
		FTrail.Color1 = "FFFFFF";
		FTrail.Style = STYLE_ADD;
		FTrail.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FTrail.Vel = (frandom(-1.5,1.5),frandom(-1.5,1.5),frandom(-1.5,1.5)); 
        FTrail.accel = (0,0,frandom(0.02,0.055));
		FTrail.Startroll = random(0,360);
		FTrail.RollVel = frandom(-3,3);
		FTrail.StartAlpha = 1.0;
		FTrail.FadeStep = 0.18;
		FTrail.Size = random(25,30);
		FTrail.SizeStep = random(-1,-4);
		FTrail.Lifetime = random(6,8); 
		FTrail.Pos = position;
		Level.SpawnParticle(FTrail);
	}

}



Class BW_FlameProjectile : Actor
{
	default
	{
		+missile;
		projectile;
		speed 35;
		radius 5;
		height 5;
		renderstyle "add";
		damagetype "Fire";
		scale 0.32;
		damage 2;
		decal "Scorch";
		+ripper;
		+bright;
		+rollsprite;
		+rollcenter;
		+BLOODLESSIMPACT;
		-nogravity;
	}
	states
	{
		Spawn:
			FRPR CCCCCCCCC 1;
			goto fade;
			//stop;
		Death:
			//TNT1 A 0 {A_Stop(); bnogravity = true;}
			TNT1 A 0 {
				actor fl = spawn("BW_GroundFire",pos);
				if(!fl)
					return;
				fl.target = target;
				if(pos.z > floorz + 35)
					fl.bnogravity = true;
			}
			TNT1 A 0 A_Explode(5,60,0);
			TNT1 A 1;
			stop;
		fade:
		Xdeath:
		Crash:
			TNT1 A 0 A_Explode(5,60,0);
			DB54 ABCDEFGHIJKLMNOPQR 1;
			stop;
	}
	override void postbeginplay()
	{
		super.postbeginplay();
		A_SetRoll(random(0,360));
		A_Attachlightdef('FlameLight','GunMuzzleFlash');
	}
	bool ticked;
	override void tick()
	{
		super.tick();
		if(isfrozen())
			return;
		if(!ticked)
		{
			ticked = true;
			return;
		}
		vector3 dif = levellocals.vec3diff(pos,prev);
		vector3 dir = dif.unit();
		double lng = dif.length();
		int stp = max(1,int(lng / 10));
		vector3 actpos = pos;
		for(int i = stp; i > 0; i--)
		{
			spawnFlameTrail(actpos);
			actpos += (dir * 10);
		}
		
	}

	override int DoSpecialDamage (Actor victim, int damage, Name damagetype)
	{
		if(victim && victim.health > 0) //&& victim.health < 10)
		{
			victim.A_GiveInventory("BW_BurningHandler",1);
		}
		return damage;
	}

	void spawnFlameTrail(vector3 position)
	{
		FSpawnParticleParams FTrail;
		//string f = String.Format("%c", int("G") + random(0,5));
		FTrail.Texture = TexMan.CheckForTexture("DB54G0");//("FRPRC0");
		FTrail.Color1 = "FFFFFF";
		FTrail.Style = STYLE_ADD;
		FTrail.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FTrail.Vel = (frandom(-2.5,2.5),frandom(-2.5,2.5),frandom(-2.5,2.5)); 
		FTrail.Startroll = random(0,360);
		FTrail.RollVel = frandom(-15,15);
		FTrail.StartAlpha = 1.0;
		FTrail.FadeStep = 0.18;
		FTrail.Size = random(27,35);
		FTrail.SizeStep = random(-1,-4);
		FTrail.Lifetime = random(6,8); 
		FTrail.Pos = position;
		Level.SpawnParticle(FTrail);
	}

}

Class BW_BurningHandler : inventory
{
	uint oldTranslation;
	int burnTics;
	bool burned;
	override void attachtoowner(actor other)
	{
		super.attachtoowner(other);
		oldTranslation = other.translation;
		burnTics = TICRATE * random(3,7);
		other.A_SetTranslation("BW_Burning");
		other.bBright = true;
		//other.bnoblood = true;
		if(other.target && other.target.player)
			tracer = other.target;
	}
	override void detachfromowner()
	{
		owner.translation = oldTranslation;
	}
	override void doeffect()
	{
		super.doeffect();
		if(!owner)
			return;
		if(burnTics)
		{
			burnTics--;
			spawnFxFire((owner.pos.xy,owner.pos.z + random(0,owner.height * 1.1)));
			if(burnTics % 15 == 0)
			{
				if(tracer)
					owner.DamageMobj(self,tracer,1,'Burn');
				else
					owner.DamageMobj(self,self,1,'Burn');
			}
		}
			//spawn fire fx
		
		if(burntics <= 0 && !burned)
		{
			burned = true;
			owner.A_SetTranslation("BW_Burned");
			owner.bBright = false;
		}
	}

	void spawnFxFire(vector3 ps)
	{
		FSpawnParticleParams WTFSMK;
		WTFSMK.Pos = ps;
		WTFSMK.Texture = TexMan.CheckForTexture("FLMEA0");//("FRPRC0");
		WTFSMK.Color1 = 0xFFFFFF;
		WTFSMK.Style = STYLE_ADD;
		WTFSMK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		WTFSMK.Startroll = random(170,190);//180;//random(0,360);
		WTFSMK.RollVel = frandom(-2,2);
		WTFSMK.StartAlpha = 0.75;
		WTFSMK.Size = frandom(35,48);
		WTFSMK.SizeStep = -4;
		WTFSMK.Lifetime = Random(5,8); 
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		WTFSMK.Vel = (frandom(-2.2,2.2),frandom(-2.2,2.2),frandom(-0.5,0.75));
		WTFSMK.accel = (0,0,frandom(0.15,0.35));
		Level.SpawnParticle (WTFSMK);
	}
}

Class BW_GroundFire : Actor
{
	default
	{
		renderstyle "add";
		+bright;
		scale 0.4;
		damagetype "Fire";
		+noblockmap;
		+forcexybillboard;
	}
	states
	{
		Spawn:
			CFCF ABCDEFGHIJKLM 1;
			loop;
	}
	int lifetime, burnRate;
	textureID flaregfx;
	override void postbeginplay()
	{
		super.postbeginplay();
		lifetime = random(2,4) * TICRATE;
		A_Setscale(scale.x + frandom(-0.15,0.18));
		bxflip = random(0,1);
		burnRate = random(15,35);
		switch(random(0,2))
		{
			case 0:	flaregfx = texman.CheckForTexture("LENYA0");	break;
			case 1:	flaregfx = texman.CheckForTexture("LENRA0");	break;
			case 2:	flaregfx = texman.CheckForTexture("LEYSO0");	break;
		}
	}
	override void tick()
	{
		super.tick();
		lifetime--;
		if(lifetime < 20)
		{
			A_Fadeout(0.05);
			A_Setscale(scale.x * 0.95);
		}

		if(getage() % burnRate == 0 && lifetime > 0)
			A_Explode(5,64,XF_THRUSTLESS);
		if(lifetime > 4 && getage() % 4 == 0)
			SpawnFireFlare(pos + (0,0,height * 0.5));
	}

	void SpawnFireFlare(vector3 position)
	{
		FSpawnParticleParams FLARPUF;
		FLARPUF.Texture = flaregfx;
		FLARPUF.Style = STYLE_ADD;
		FLARPUF.Color1 = "FFFFFF";
		FLARPUF.Flags = SPF_FULLBRIGHT;
		FLARPUF.StartRoll = 0;
		FLARPUF.StartAlpha = 1.0;
		FLARPUF.FadeStep = 0.25;
		FLARPUF.Size = scale.x * 120;
		FLARPUF.SizeStep = 1;
		FLARPUF.Lifetime = 4; 
		FLARPUF.Pos = position;
		Level.SpawnParticle(FLARPUF);
	}
}