Class BW_Decoration : Actor abstract
{
    bool dorandomflipX;
    property randomflipX:dorandomflipX;
    default
    {
        BW_Decoration.randomflipX true;
    }
    override void postbeginplay()
    {
        super.postbeginplay();
        if(self.dorandomflipX)
            self.bXFLIP = random(0,1);
    }
    BW_Flare flare;
    void killFlare()
    {
        if(flare)
            flare.destroy();
    }

    void spawnDebris(string type,vector3 spos,int amount = 1,int maxforceXY = 10,int maxforceZ = 10)
	{
		if(amount < 1)
			return;
		for(int i = 0; i < amount; i++)
		{
			actor deb = spawn(type,spos);
			if(deb)
			{
				deb.vel = (random(-maxforceXY,maxforceXY),random(-maxforceXY,maxforceXY),random(-maxforceZ,maxforceZ));
			}
		}
	}
}


Class BW_ShootableDecoration : BW_Decoration abstract
{
    default
    {
        health 100;
        +shootable;
        +solid;
        +dontthrust;
        +noblood;
    }

    Void BW_SpawnSmokeFx(int zofs = 10,int life = 10,int size = 30, double initialAlpha = 0.5,string gfx = "SM7CA0")
	{
		FSpawnParticleParams Smkfx;
		Smkfx.Texture = TexMan.CheckForTexture (gfx);
		Smkfx.Color1 = "FFFFFF";
		Smkfx.Style = STYLE_Translucent;
		Smkfx.Flags = SPF_ROLL;
		Smkfx.Vel = (frandom[BWSDEC](0.3,-0.3),frandom[BWSDEC](0.3,-0.3),frandom[BWSDEC](0.5,0.5)); 
		Smkfx.Startroll = random(0,360);
		Smkfx.RollVel = random(3,3);
		Smkfx.StartAlpha = initialAlpha;
        Smkfx.Lifetime = life;
		Smkfx.FadeStep = initialAlpha/life;
		Smkfx.Size = size;
		Smkfx.SizeStep = 1.5;
		Smkfx.Pos = vec3offset(0,0,zofs);
		Level.SpawnParticle (Smkfx);
	}

    void BW_SpawnStickFx(int zoffset = 10,int size = 20)
    {
        FSpawnParticleParams StickFX;
		StickFX.Texture = TexMan.CheckForTexture ("WOODB0");
		StickFX.Color1 = "FFFFFF";
		StickFX.Style = STYLE_Translucent;
		StickFX.Flags = SPF_ROLL;
		StickFX.Vel = (FRandom (-5.1,5.1),FRandom (-5.1,5.1),FRandom (2.5,5.2)); 
		StickFX.accel = (0,0,frandom(-0.5,-1.0));
		StickFX.Startroll = random(0,360);
        StickFX.RollVel = (random(-20,20));
        StickFX.StartAlpha = 1.0;
		StickFX.FadeStep = 0.1;
		StickFX.Size = size;
		StickFX.SizeStep = 0;
		StickFX.Lifetime = random(10,15); 
		StickFX.Pos = vec3offset(random(-radius,radius),random(-radius,radius),zoffset);
		Level.SpawnParticle (StickFX);
    }

    void SpawnDieSpark(int zofs = 0,int sidethrust = 3)
	{
		FSpawnParticleParams PUFSPRK;
		PUFSPRK.Texture = TexMan.CheckForTexture("SPKOA0");
		PUFSPRK.Color1 = "FFFFFF";
		PUFSPRK.Style = STYLE_Add;
		PUFSPRK.Flags = SPF_ROLL|SPF_FULLBRIGHT;
		PUFSPRK.Vel = (random(-sidethrust,sidethrust),random(-sidethrust,sidethrust),random(-2,3));
		PUFSPRK.accel = (0,0,frandom(-1.75,-0.75));
		PUFSPRK.Startroll = randompick(0,90,180,270,360);
		PUFSPRK.RollVel = 0;
		PUFSPRK.StartAlpha = 1.0;
		PUFSPRK.FadeStep = 0.075;
		PUFSPRK.Size = random(8,14);
		PUFSPRK.SizeStep = -0.5;
		PUFSPRK.Lifetime = random(12,18); 
		PUFSPRK.Pos = pos + (0,0,zofs);
		Level.SpawnParticle(PUFSPRK);
	}

    void SpawnDyingFlare(int zofs = 0,int startsize = 28, int life = 35, double startalpha = 0.7, string gfx = "LENYA0")
	{
		FSpawnParticleParams FLARPUF;
		FLARPUF.Texture = TexMan.CheckForTexture(gfx);
		FLARPUF.Style = STYLE_ADD;
		FLARPUF.Color1 = "FFFFFF";
		FLARPUF.Flags =SPF_FULLBRIGHT;
		FLARPUF.StartRoll = 0;
		FLARPUF.StartAlpha = startalpha;
		FLARPUF.Size = startsize;
		FLARPUF.Lifetime = life; 
        FLARPUF.SizeStep = -startsize / life + 1;
        FLARPUF.FadeStep = startalpha/life;
		FLARPUF.Pos = pos + (0,0,zofs);
		Level.SpawnParticle(FLARPUF);
	}
}

Class BW_CeillingDecoration : BW_ShootableDecoration abstract
{
    default
    {
        +NOGRAVITY
        +NoBlood
        -solid
        +dontfall;
        +SpawnCeiling;
        health 20;
    }
    override void postbeginplay()
    {
        super.postbeginplay();
        setz(ceilingz - height);
    }
}





