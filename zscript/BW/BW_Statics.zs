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
}