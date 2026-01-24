Class BWGib : NashGoreGibs
{
	default
	{
		speed 6;
		NashGoreGibs.DoBoing false;
	}
	override void postbeginplay()
	{
		super.postbeginplay();
		bXFLIP = random[rFlip](0,1);
	}
}

Class BW_BGLeg : BWGib
{
	states
	{
		spawn:
			LEG1 K 0;
		SpawnLoop:
			"####" # 1 //A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
			{
				A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
	
				// spawn some blood particles
				bool res;
				Actor mo;
				[res, mo] = A_SpawnItemEx("NashGoreBloodParticle1", flags: NashGoreBloodBase.BLOOD_FLAGS, 222);
				if (mo)
					mo.A_SetScale(frandom[rnd_GibParticleScale](0.14, 0.4));
			}
			Loop;
		Death:
			"####" # 0
			{
				A_SetRoll(0,SPF_INTERPOLATE);
				
				// clip gib into terrain
				let t = GetFloorTerrain();

				// clip by 2 map units; ignore the terrain's FootClip value
				if (t && t.FootClip > 0)
					FloorClip = 2.0;
				
				class<Actor> cls;
				if (nashgore_bloodtype == 0)		cls = "NashGoreBloodSpot";
				else if (nashgore_bloodtype == 1)	cls = "NashGoreBloodSpotClassic";
				A_SpawnItemEx(cls, flags: (NashGoreBloodBase.BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, 150);
				BW_GibHitBox.BW_CreateGibHitBox(self);
				NashGoreGameplayStatics.FixZFighting(self);
			}
			"####" ########## 1
			{
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NashGoreDefaultBlood.BLOOD_FLAGS, 175);
			}
			"####" # -1;
			Stop;
	}
}

Class BW_BGArm : BWGib
{
	states
	{
		spawn:
			SAAR A 0;
		SpawnLoop:
			"####" # 1 A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
			Loop;
		Death:
			"####" # 0
			{
				A_SetRoll(0);
				
				// clip gib into terrain
				let t = GetFloorTerrain();

				// clip by 2 map units; ignore the terrain's FootClip value
				if (t && t.FootClip > 0)
					FloorClip = 2.0;
				
				class<Actor> cls;
				if (nashgore_bloodtype == 0)		cls = "NashGoreBloodSpot";
				else if (nashgore_bloodtype == 1)	cls = "NashGoreBloodSpotClassic";
				A_SpawnItemEx(cls, flags: (NashGoreBloodBase.BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, 150);
			
				BW_GibHitBox.BW_CreateGibHitBox(self);
				NashGoreGameplayStatics.FixZFighting(self);
			}
			"####" ########## 1
			{
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NashGoreDefaultBlood.BLOOD_FLAGS, 175);
			}
			"####" # -1;
			Stop;
	}
}

Class BW_BGHead : BWGib
{
	states
	{
		spawn:
			SAHD A 0;
		SpawnLoop:
			"####" # 1 A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
			Loop;
		Death:
			"####" # 0
			{
				A_SetRoll(0);
				
				// clip gib into terrain
				let t = GetFloorTerrain();

				// clip by 2 map units; ignore the terrain's FootClip value
				if (t && t.FootClip > 0)
					FloorClip = 2.0;
				
				class<Actor> cls;
				if (nashgore_bloodtype == 0)		cls = "NashGoreBloodSpot";
				else if (nashgore_bloodtype == 1)	cls = "NashGoreBloodSpotClassic";
				A_SpawnItemEx(cls, flags: (NashGoreBloodBase.BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, 150);
				BW_GibHitBox.BW_CreateGibHitBox(self);
				NashGoreGameplayStatics.FixZFighting(self);
			}
			"####" ########## 1
			{
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NashGoreDefaultBlood.BLOOD_FLAGS, 175);
			}
			"####" # -1;
			Stop;
	}
}

Class BW_WOLeg : BWGib
{
	states
	{
		spawn:
			WTDZ A 0;
		SpawnLoop:
			"####" A 1 //A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
			{
				A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
	
				// spawn some blood particles
				bool res;
				Actor mo;
				[res, mo] = A_SpawnItemEx("NashGoreBloodParticle1", flags: NashGoreBloodBase.BLOOD_FLAGS, 222);
				if (mo)
					mo.A_SetScale(frandom[rnd_GibParticleScale](0.14, 0.4));
			}
			Loop;
		Death:
			"####" B 0
			{
				A_SetRoll(0,SPF_INTERPOLATE);
				
				// clip gib into terrain
				let t = GetFloorTerrain();

				// clip by 2 map units; ignore the terrain's FootClip value
				if (t && t.FootClip > 0)
					FloorClip = 2.0;
				
				class<Actor> cls;
				if (nashgore_bloodtype == 0)		cls = "NashGoreBloodSpot";
				else if (nashgore_bloodtype == 1)	cls = "NashGoreBloodSpotClassic";
				A_SpawnItemEx(cls, flags: (NashGoreBloodBase.BLOOD_FLAGS | SXF_TRANSFERPOINTERS) & ~SXF_NOCHECKPOSITION, 150);
				BW_GibHitBox.BW_CreateGibHitBox(self);
				NashGoreGameplayStatics.FixZFighting(self);
			}
			"####" BBBBBBBBB 1
			{
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NashGoreDefaultBlood.BLOOD_FLAGS, 175);
			}
			"####" B -1;
			Stop;
	}
}

Class BW_WOArm : BW_BGArm
{
	states
	{
		spawn:
			WTDZ C 0 { frame += random(0,1); }
			goto SpawnLoop;
	}
}

Class BW_WOHead : BW_BGHead
{
	states
	{
		spawn:
			WTDZ E 0;
			goto SpawnLoop;
	}
}
