Class BW_Statics abstract
{
    clearScope Static Double LinearMap(Double Val, Double O_Min, Double O_Max, Double N_Min, Double N_Max) 
	{
		Return (Val - O_Min) * (N_Max - N_Min) / (O_Max - O_Min) + N_Min;
	}

	clearScope static Double lerp(Double a, Double b, Double t) 
	{
		return a + t * (b - a);
	}

	clearScope static vector3 V3lerp(vector3 from, vector3 to, double t)
	{
		return (
			lerp(from.x,to.x,t),
			lerp(from.y,to.y,t),
			lerp(from.z,to.z,t)
		);
	}
	
	static void SpawnIndicator(vector3 where, string tex = "YAE4A0")
	{
		FSpawnParticleParams 	PLASPRK;
		PLASPRK.Texture = 		TexMan.CheckForTexture(tex);
		PLASPRK.Color1 = 		"FFFFFF";
		PLASPRK.Style = 		STYLE_Add;
		PLASPRK.Flags = 		SPF_ROLL|SPF_FULLBRIGHT;
		PLASPRK.Vel = 			(0,0,0);
		PLASPRK.accel = 		(0,0,0);
		PLASPRK.Startroll = 	randompick(0,90,180,270,360);
		PLASPRK.RollVel = 		0;
		PLASPRK.StartAlpha = 	1.0;
		PLASPRK.FadeStep = 		0.075;
		PLASPRK.Size = 			random(8,14);
		PLASPRK.SizeStep = 		-0.5;
		PLASPRK.Lifetime = 		random(12,18); 
		PLASPRK.Pos = 			where;
		Level.SpawnParticle(PLASPRK);
	}

	// Returns the Z speed needed for a projectile to get from origin to dest when accounting for gravity.
	// * origin - The starting position of the projectile.
	// * dest - The desired position for the projectile.
	// * speed - The speed of the projectile.
	// * grav - How much gravity the projectile should have.
	// credits: Boondorl
	static double CalculateZSpeed(Vector3 origin, Vector3 dest, double speed, double grav)
	{
		if (speed < double.equal_epsilon || grav ~== 0.0)
			return 0.0;
	
		double travelTime = Level.Vec3Diff(origin, dest).Length() / speed;
		return (dest.Z - origin.Z - 0.5 * -grav * travelTime * travelTime) / travelTime;
	}
}