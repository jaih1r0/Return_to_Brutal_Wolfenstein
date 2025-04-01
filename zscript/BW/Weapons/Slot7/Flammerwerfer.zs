Class BW_FlameThrower : BaseBWWeapon
{
    default
    {
        weapon.slotnumber 7;
        Weapon.AmmoType "BW_GasCan";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 30;
    }

    action void FireFlames()
    {
        A_Fireprojectile("BW_FlameProjectile",0,0);
        BW_HandleWeaponFeedback(2, 3, -0.20, frandom(+0.15, -0.15), 0, 0, 0);
        invoker.ammo1.amount--;
    }

    action void fireStreamFlame()
    {
        double pz = height * 0.5 - floorclip + player.mo.AttackZOffset * player.crouchFactor;
        pz -= 5;
        invoker.ammo1.amount--;
		FLineTraceData t;
        self.LineTrace(angle, 300, pitch, offsetz: pz, data: t);
        if(t.hitactor != null)
        {
            t.hitactor.damagemobj(self,self,12,'Fire');
            t.hitactor.A_GiveInventory("BW_BurningHandler",1);
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
            TNT1 A -1;
            stop;
        Select:
            TNT1 A 0 BW_WeaponRaise();
            BFLU ABCD 1;
            goto ready;
        Deselect:
            TNT1 A 0 A_clearoverlays(-5,-5);
            BFLU FGHI 1;
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
            BFLF A 1 bright FireFlames();
            BFLF BCD 1 bright;
            TNT1 A 0 A_refire();
            goto ready;

        AltFire:    //altfire is the same as Fire, just with a different method of spawning the flames 
            TNT1 A 0 BW_PrefireCheck(1,"DryFire","DryFire",true);
            TNT1 A 0 A_clearoverlays(-5,-5);
            BFLF A 1 bright fireStreamFlame();
            BFLF BCD 1 bright;
            TNT1 A 0 A_refire();
            goto ready;
        DryFire:
            BFLU E 2;
            goto ready;
        
        IdleFlameOverlay:
            BFLI ABCDEFGHIJK 1 bright;
            loop;
        
        KickFlash:
            TNT1 A 0 A_clearoverlays(-5,-5);
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BFLK ABC 1;
			BFLK DEF 1;
			TNT1 A 0 A_StartSound("Generic/rattle/small", 0, CHANF_OVERLAP, 1);
			BFLK GGG 1;
			BFLK FEDCBA 1;
			goto ready;
		SlideFlash:
            TNT1 A 0 A_clearoverlays(-5,-5);
			TNT1 A 0 A_StartSound("Generic/Cloth/Medium", 0, CHANF_OVERLAP, 1);
			BFLK ABCD 1;
			BFLK EFGH 1;
			TNT1 A 0 A_StartSound("Generic/Rattle/Medium", 0, CHANF_OVERLAP, 1);
			BFLK IJH 1;
			BFLK IJH 1;
			BFLK IJH 1;
			BFLK IJH 1;
			BFLK IJH 1;
			BFLK IJH 1;
		SlideFlashEnd:
			TNT1 A 0 A_StartSound("Generic/Cloth/short", 0, CHANF_OVERLAP, 1);
			BFLK FEDCBA 1;
			goto ready;
		KnifeGunFlash:
            TNT1 A 0 A_clearoverlays(-5,-5);
            BFLU FGHI 1;	//temporary
			TNT1 A 5;
			//TNT1 A 4;
			BFLU ABCD 1;
			stop;
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

Class BW_GasCan : ammo
{
    Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 60;
		Ammo.BackpackAmount 0;
		Ammo.BackpackMaxAmount 60;
        inventory.icon "CELLA0";
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
		scale 0.3;
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
			//stop;
		Death:
			TNT1 A 0 {A_Stop(); bnogravity = true;}
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
		if(victim) //&& victim.health < 10)
		{
			victim.A_GiveInventory("BW_BurningHandler",1);
		}
		return damage;
	}

	void spawnFlameTrail(vector3 position)
	{
		FSpawnParticleParams FTrail;
		//string f = String.Format("%c", int("G") + random(0,5));
		FTrail.Texture = TexMan.CheckForTexture("FRPRC0");
		FTrail.Color1 = "FFFFFF";
		FTrail.Style = STYLE_ADD;
		FTrail.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		FTrail.Vel = (frandom(-1.5,1.5),frandom(-1.5,1.5),frandom(-1.5,1.5)); 
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

Class BW_BurningHandler : inventory
{
	uint oldTranslation;
	int burnTics;
	bool burned;
	override void attachtoowner(actor other)
	{
		super.attachtoowner(other);
		oldTranslation = other.translation;
		burnTics = TICRATE * random(5,10);
		other.A_SetTranslation("BW_Burning");
		other.bBright = true;
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
			spawnFxFire((owner.pos.xy,owner.pos.z + random(0,owner.height * 0.75)));
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
		WTFSMK.Startroll = 180;//random(0,360);
		WTFSMK.RollVel = frandom(-1,1);
		WTFSMK.StartAlpha = 0.75;
		WTFSMK.Size = frandom(35,48);
		WTFSMK.SizeStep = -4;
		WTFSMK.Lifetime = Random(5,8); 
		WTFSMK.FadeStep = WTFSMK.StartAlpha / WTFSMK.Lifetime;
		WTFSMK.Vel = (frandom(-2.2,2.2),frandom(-2.2,2.2),frandom(-0.1,2.2));
		Level.SpawnParticle (WTFSMK);
	}
}