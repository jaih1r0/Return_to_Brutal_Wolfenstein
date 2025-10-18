Class BW_HansGrosse : BW_Boss
{
    default
    {
        tag "Hans Grosse";
        Health 10000;
        Radius 32;
        Height 60;
        Mass 10000;
        Speed 5;
        painchance 20;
        BW_MonsterBase.headheight 50;
		BW_MonsterBase.feetheight 26;
        Obituary "%o tried to escape while Hans Grosse was on duty.";
        DeathSound "Hans/death";
        SeeSound "Hans/sight";
        PainSound "Hans/Pain";
    }

    states
    {
        Spawn:
            HANS A 1;
        Stand:
            HANS AAAA 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y+0.01);
			}
			HANS AAAA 5
			{
				A_LookEx();
				A_SetScale(scale.X,Scale.Y-0.01);
			}
			Loop;

        See:
            TNT1 A 0 A_SetScale(1,YscaleFix);
            TNT1 A 0 A_jumpifNotAlerted("FirstSight");
            HANS AABBCCDD 2 A_Chase;
            Loop;

        FirstSight:
            TNT1 A 0 RequestBossBar(null); //start the boss bar
            TNT1 A 0 SetBossMusic("grosse","BW1M9");
            HNHP ABABABAB 4;
            TNT1 A 0 A_StartSound("Shaiser");
            HANS E 30 A_FACETARGET();
            Goto WallOfBullets;
        
        Missile:
            TNT1 A 0 HansAttackHandler();
            //TNT1 A 0 A_jump(256,"Gutentag","Grenades","Ultimate","WallOfBullets");
            goto see;
        
        Gutentag:
            TNT1 A 0;
            TNT1 A 0 A_StartSound("Shaiser");
            HANS E 30 A_FACETARGET();
            Goto Chainguns;

        Chainguns:
            HANS F 1 FireDualChaingun();
            HANS G 2;
            HANS F 1 FireDualChaingun();
            HANS G 2;
            HANS F 1 FireDualChaingun();
            HANS G 2;
            HANS F 1 FireDualChaingun();
            HANS G 2 A_CposRefire();
            goto Chainguns+1;

        Grenades:
            TNT1 A 0 A_StartSound("Grenade/Pin");
            HNGR AA 3 A_FaceTarget();
            TNT1 A 0 A_StartSound ("Grenade/Throw");
            HNGR BB 3 A_FaceTarget();
            HNGR C 1 firegrenades();
            HNGR CC 3 A_FaceTarget();
            Goto See;
        
        Ultimate:
            HNCH A 2 A_FaceTarget();
            TNT1 A 0 A_StartSound("Hans/scream");
            HNCH BCBD 10 A_FaceTarget();
            TNT1 A 0 A_StartSound("Grenade/Pin");
            HNGR AA 3 A_FaceTarget();
            TNT1 A 0 A_StartSound ("Grenade/Throw");
            HNGR BB 3 A_FaceTarget();
            HNGR C 1 firegrenades();
            HNGR CC 3 A_FaceTarget();
            TNT1 A 0 A_StartSound("Grenade/Pin");
            HNGR AA 3 A_FaceTarget();
            TNT1 A 0 A_StartSound ("Grenade/Throw");
            HNGR BB 3 A_FaceTarget();
            HNGR C 1 firegrenades(30);
            HNGR CC 3 A_FaceTarget();
            TNT1 A 0 A_StartSound("Grenade/Pin");
            HNGR AA 3 A_FaceTarget();
            TNT1 A 0 A_StartSound ("Grenade/Throw");
            HNGR BB 3 A_FaceTarget();
            HNGR C 1 firegrenades(42);
            HNGR CC 3 A_FaceTarget();
            TNT1 A 0 A_jump(128,"Ultimate2");
            Goto Gutentag;
        
        Ultimate2:
            HNCH A 2 A_FaceTarget();
            TNT1 A 0 A_StartSound("Hans/scream");
            HNCH BCBD 10 A_FaceTarget();
        Ultimate2Refire:
            HANS F 1 fireAngledChaingun(90);
            HANS G 1;
            HANS F 1 fireAngledChaingun(85);
            HANS G 1;
            HANS F 1 fireAngledChaingun(80);
            HANS G 1;
            HANS F 1 fireAngledChaingun(75);
            HANS G 1;
            HANS F 1 fireAngledChaingun(70);
            HANS G 1;
            HANS F 1 fireAngledChaingun(65);
            HANS G 1;
            HANS F 1 fireAngledChaingun(60);
            HANS G 1;
            HANS F 1 fireAngledChaingun(55);
            HANS G 1;
            HANS F 1 fireAngledChaingun(50);
            HANS G 1;
            HANS F 1 fireAngledChaingun(45);
            HANS G 1;
            HANS F 1 fireAngledChaingun(40);
            HANS G 1;
            HANS F 1 fireAngledChaingun(30);
            HANS G 1;
            HANS F 1 fireAngledChaingun(20);
            HANS G 1;
            HANS F 1 fireAngledChaingun(10);
            HANS G 1;
            HANS F 1 fireAngledChaingun(5);
            HANS G 1;
            HANS F 1 FireDualChaingun();
            HANS G 1;
            TNT1 A 0 A_jump(32,"Ultimate2Refire");
            Goto see;

        WallOfBullets:
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            HANS F 1 fireWallOfBullets();
            HANS G 1;
            goto see;
        
        Tackle:
            HNFS AA 2 A_FaceTarget();
            TNT1 A 0 {vel.z += 2;}
            HNFS BBC 2 
            {
                RadiusAttack(self,10,radius * 2,'tackle',RADF_SOURCEISSPOT,radius);
                A_recoil(-4);
            }
            TNT1 A 0 A_QuakeEx(1,1,1,5,0,100,"",QF_SCALEDOWN);
            goto see;
        
        Melee:
            HNFS AA 2 A_FaceTarget();
            TNT1 A 0 A_jumpif(target && distance2d(target) > 300,"Tackle");
            HNFS BB 2 A_FaceTarget();
            HNFS C 1 {
				//Melee attack
				A_StartSound("Fists/Swing");
				A_CustomMeleeAttack(random(10, 30), "Fists/HitFlesh");
			}
            HNFS CC 2 A_FaceTarget();
            Goto See;
        
        Pain:
            HANS H 3;
            goto see;

        Death:
            TNT1 A 0 A_Scream();
            TNT1 A 0 A_NoBlocking();
            HADH AB 5;
            //
            HADH B 1;
            HANS KL 8;
            TNT1 A 0 A_spawnitem("YellowCard");
            HANS L -1;
            Stop;
    }

    state HansAttackHandler()
    {
        if(!target)
            return resolvestate("stand");
        
        bool inCriticalState = health < (spawnhealth() / 4);
        int targDist = distance2D(target);

        int grenadechance = 180;
        int ultimateChance = 220;
        int bulletHellChance = 220;
        int bulletWaveChance = 200;
        
        if(inCriticalState)
        {
            bulletHellChance = 100;
            ultimateChance = 100;
            bulletWaveChance = 50;
        }
        
        
        
        int chan = random[atk]();
        if(chan > ultimateChance)
            return resolvestate("Ultimate");
        
        chan = random[atk]();
        if(chan > bulletHellChance)
            return resolvestate("WallofBullets");

        chan = random[atk]();
        if(chan > bulletWaveChance)
            return resolvestate("Ultimate2");
        
        chan = random[atk]();
        if(chan > grenadechance)
            return resolvestate("grenades");
        
        return resolvestate("chainguns");
    }

    void fireWallOfBullets()
    {
        A_Startsound("STG/Fire", CHAN_AUTO, CHANF_OVERLAP, 0.65);   //replace those sounds when the actual chaingun sounds gets added
		A_Startsound("STG/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 1);
        A_spawnprojectile("BW_EnemyLugerBullets",32,16,random[rndang](-15,15),CMF_AIMDIRECTION,random[rndpt](-15,15));
        A_spawnprojectile("BW_EnemyLugerBullets",32,-16,random[rndang](-15,15),CMF_AIMDIRECTION,random[rndpt](-15,15));
    }

    void FireDualChaingun()
    {
        A_Startsound("STG/Fire", CHAN_AUTO, CHANF_OVERLAP, 0.65); //replace those sounds when the actual chaingun sounds gets added
		A_Startsound("STG/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 1);
        A_spawnprojectile("BW_EnemyLugerBullets",32,16,random[rndang](-2,2),CMF_AIMDIRECTION,random[rndpt](-1,1));
        A_spawnprojectile("BW_EnemyLugerBullets",32,-16,random[rndang](-2,2),CMF_AIMDIRECTION,random[rndpt](-1,1));
        //A_SpawnItem ("Mausercasespawn", 0, 30,0)
    }

    void fireAngledChaingun(double angleSep = 0)
    {
        A_Startsound("STG/Fire", CHAN_AUTO, CHANF_OVERLAP, 0.65); //replace those sounds when the actual chaingun sounds gets added
		A_Startsound("STG/FireAdd", CHAN_AUTO, CHANF_OVERLAP, 1);
        A_spawnprojectile("BW_EnemyLugerBullets",32,16,random[rndang](-2,2) - angleSep,CMF_AIMDIRECTION,random[rndpt](-1,1));
        A_spawnprojectile("BW_EnemyLugerBullets",32,-16,random[rndang](-2,2) + angleSep,CMF_AIMDIRECTION,random[rndpt](-1,1));
    }

    void firegrenades(int maxdispersion = 12)
    {
        FireGrenadeToTarget("BW_enemyGrenade",-maxdispersion);
        FireGrenadeToTarget("BW_enemyGrenade",0);
        FireGrenadeToTarget("BW_enemyGrenade",maxdispersion);
    }

    override void RequestBossBar(bossbarinfo bi)
    {
        bossbarinfo thisboss;
        thisboss.portrait = "graphics/BossPortraits/Hans.png";
        thisboss.angryPortrait = "graphics/BossPortraits/Hans_Struggle.png";
        thisboss.presentation = "The first boss";   //placeholder title
        thisboss.maxhp = self.spawnhealth();
        thisboss.ready = true;
        super.RequestBossBar(thisboss);
    }

    override void PlayFootsteps()
	{
		if(health < 1)
			return;
		//sound snd = BW_StaticHandler.getmaterialstep(texman.getname(floorpic));
		A_Startsound("Hans/step",CHAN_AUTO,volume:BW_enemyFootstepsVol,attenuation:(1200/700));
		
	}

}