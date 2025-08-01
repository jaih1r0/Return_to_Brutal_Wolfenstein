extend class BW_MonsterBase
{
	int EnemyLastSighted;
	bool Wandering;
	bool willBeLooking;
	int heardOpponent;
	
	bool kickeddown;
	
	int ActiveSoundPlayChance;
	int MissileChance;
	int FallbackChance;
	
	int AttackDelay;
	
	int enemyRange;
	Property AttackRange : enemyRange;
	//the enemies attack range, in case you wanted some enemies to be CQC mainly, or snipe
	
	bool canRoll;
	property CanIRoll : canRoll;
	//bools controlling whether an enemy can Dodge if the player is looking at them
	bool canReload;
	property CanIReload : canReload;
	
	string soundBase;
	Property SoundCategory : soundBase;
	//used for A_SmartPain
	
	double Mana; //For Demons, or anything else that itd make sense on.
	
	int AmmoInMag;
	int Timer;
	
	//The main custom A_Chase function
	
	void AI_SmartChase()
	{
		if(!target)	//looking cycle
		{
			if(Wandering)
			{
				A_Wander();
				A_LookEx();
				return;
			}
			else
				Wandering = true;
		}
		else		//chasing cycle, only enter if target != null
		{
			if(isFriend(target))
			{
				A_ClearTarget();
				return;
			}

			if(target.health < 0)
			{
				Wandering = true;
				A_ClearTarget();
				return;
			}

			A_Fallback();

			if(waterlevel >= 1 && Target.Pos.Z > (self.Pos.Z + 10))
			{
				A_FaceTarget(30);
				A_Recoil(-3);
				ThrustThingZ(0, 5, 0, 1);
			}

			if (CheckSight(target) == true && CheckIfCloser(target, 3000))
			{
				double dist = Distance3D(target);

				MissileChance = (random(1,300));
				ActiveSoundPlayChance = (random(1,300));

				//check if sight of player or close enough to "hear" player for memory
				if (CheckSight(target) || CheckIfCloser(target, 500))
				{
					EnemyLastSighted = Level.MapTime;
					Wandering = false;
				}

				if(canRoll)
				{
					//dodging system check
					LookExParams look;
					look.FOV = 2;
					int chance = (random(1,300));
					
					if(target.IsVisible(self, false, look) && chance <= 10 && dist <= 1500 && resolvestate("Roll"))
					{
						A_FaceTarget();
						SetStateLabel("Roll");
					}
					
				}
				A_Chase();

			}
			else if (CheckSight(target) == false && abs(Level.MapTime - EnemyLastSighted) < 360)
			{
				ActiveSoundPlayChance = (random(1,300));
				//because 1 tic A_Chase calls spams this lol
				if((ActiveSoundPlayChance > 5 ))
				{
					A_Chase("_a_chase_default", "_a_chase_default", CHF_NOPLAYACTIVE);
				}
				else
				{
					A_Chase();
				}

				int chanceR = (random(1,10));
			
				// Do our Reload checks while the player is out of sight.
				if(bFRIGHTENED && canReload && chanceR <= 5 && ResolveState("Reload"))
				{
					SetStateLabel("Reload");
					return;
				}
			}
			else
			{
				Wandering = true;
				A_ClearTarget();
			}

			
		}
		
	}
	
	//Extra functions for firing checks and pain checks
	
	void A_CheckLOFRanged(statelabel jumpstate, statelabel dodgestate, statelabel seeContinuestate = "SeeContinue")
	{
		if(!target)
			return;
		double dist = Distance3D(target);
		let aimActor = AimTarget();
		
		if(dist > self.enemyRange) // Too far away.
		{
			//Console.PrintF("Not Closer");
			SetStateLabel(seeContinuestate);
		}
		else if(CheckLOF() && dist <= self.enemyRange) /*(aimActor is "PlayerPawn" && dist <= self.enemyRange)*/ // Can aim at the player.
		{
			//Console.PrintF("Closer and LOF");
			SetStateLabel(jumpstate);
		}
		else // Aim obstructed
		{
			//Console.PrintF("Else Failed, Dodging");
			if(self.canRoll == true)
			{				
				SetStateLabel(dodgestate);
			}
			else
			{
				SetStateLabel(seeContinuestate);
			}
		}
	}
	
	void A_Fallback(statelabel fallbackstate = "Fallback")
	{
		FallbackChance = (random(1,300));
		
		if (CheckIfCloser(target, 150) && !CheckIfCloser(target, 100) && CheckSight(target) && (FallbackChance < 25))
		{
			SetStateLabel(fallbackstate);
		}
	}
	
	int footstepWait;
	//Tick and PostBeginPlay stuff
	override void Tick()
	{
		Super.Tick();
		AttackDelay--;
		if(AttackDelay < 0)
		{
			AttackDelay = 0;
		}
		
		//if(vel.xy.length() > 1)	//monster do not get vel when walking
		//	PlayFootsteps();
		//this would be more accurate if done in the states, but its easier to do it from here
		if(footstepWait-- <= 0 && pos.z <= floorz + 1 && levellocals.Vec2Diff(prev.xy,pos.xy).length() > 3)
		{
			PlayFootsteps();
			footstepWait = 9;
		}

		if(BW_Debug == 1)
		{
			testhitzones();
		}
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		heardOpponent = 0;
		AttackDelay = 25;
		kickeddown = false;
		if(StringTable.Localize("$OPTVAL_MBF21STRICT") != "OPTVAL_MBF21STRICT")	//only triggered when loaded in gzdoom 4.13
		{
			YscaleFix = scale.y * level.pixelstretch;	//should look good in gzdoom 4.13+
			A_SetScale(scale.x,YscaleFix);
		}
		else
			YscaleFix = scale.y;
	}
	
	default
	{
		BW_MonsterBase.CanIRoll false;
		BW_MonsterBase.CanIReload true;
	}
}