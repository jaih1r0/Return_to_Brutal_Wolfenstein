Class BWPlayer : PlayerPawn
{
	double StillRangeMulti;
	
	override void tick()
	{
		super.tick();
		player.damagecount = Clamp(player.damagecount, 0, 15);
	}
	
	override Vector2 BobWeapon(double ticFrac)
	{
		vector2 offset = super.BobWeapon(ticFrac);
		if(vel.xy.length() > 0)
		{
			stillrangemulti = 0;
			return offset;
		}
		//this comes from zmovement :D
		StillRangeMulti = min(StillRangeMulti + 0.001, 1);
		offset.Y = StillRangeMulti * sin(Level.maptime / 120. * 360.) + StillRangeMulti;
		
		return (offset);
	}
}