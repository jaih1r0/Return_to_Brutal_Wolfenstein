Class BWGib : NashGoreGibs
{
	default
	{
		speed 6;
		NashGoreGibs.DoBoing false;
	}
}

Class BW_BGLeg : BWGib
{
	states
	{
		spawn:
			LEG1 K 0;
		SpawnLoop:
			"####" K 1 A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
			Loop;
		Death:
			"####" K 0
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
			}
			"####" KKKKKKKKKK 1
			{
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NashGoreBlood.BLOOD_FLAGS, 175);
			}
			"####" K -1;
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
			"####" A 1 A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
			Loop;
		Death:
			"####" A 0
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
			
			}
			"####" AAAAAAAAAA 1
			{
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NashGoreBlood.BLOOD_FLAGS, 175);
			}
			"####" A -1;
			Stop;
	}
}
//SAHDe0.png

Class BW_BGHead : BWGib
{
	states
	{
		spawn:
			SAHD E 0;
		SpawnLoop:
			"####" E 1 A_SetRoll(Roll + ((2.25 * Vel.Length()) * rollDir), SPF_INTERPOLATE);
			Loop;
		Death:
			"####" E 0
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
			}
			"####" EEEEEEEEEE 1
			{
				A_SpawnItemEx("NashGoreBloodFloorSplashSpawner",
					0, 0, 0,
					frandom(-4.0, 4.0), frandom(-4.0, 4.0), frandom(1.0, 4.0),
					frandom(0, 360), NashGoreBlood.BLOOD_FLAGS, 175);
			}
			"####" E -1;
			Stop;
	}
}