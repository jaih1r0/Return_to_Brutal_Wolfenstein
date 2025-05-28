class BW_Math abstract
{
	
}

//[inkoalawetrust] CheckActorExists(), IsDead(), and IsInState() are copied from my KAI library.
Mixin Class BW_CheckFunctions
{
	ClearScope Bool CheckActorExists (Name ActorClass)
	{
		Class<Actor> Act = ActorClass;
		Return !!Act;
	}
	
	ClearScope Bool IsDead (Actor Other)
	{
		If (!Other) Return False;
		Return (Other.Player ? Other.Player.PlayerState == PST_DEAD : Other.Health <= 0);
	}
	
	ClearScope Bool IsInState (Actor Other, StateLabel CheckFor = "Spawn", Bool Exact = False)
	{
		If (!Other) Return False;
		Return (Other.InStateSequence(Other.CurState,Other.FindState (CheckFor,Exact)));
	}
}

mixin class BW_BetterPickupSound
{
	override void PlayPickupSound(actor toucher)
	{
		let hnd  = BW_EventHandler(EventHandler.Find("BW_EventHandler"));
		if(hnd)
		{
			if(hnd.pickuptic[toucher.PlayerNumber()]==gametic) return;
			hnd.pickuptic[toucher.PlayerNumber()] = gametic;
		}
		double atten;
		int flags = CHANF_OVERLAP|CHANF_MAYBE_LOCAL;
		if(bNoAttenPickupSound) atten = ATTN_NONE;
		else atten = ATTN_NORM;
		if(toucher && toucher.CheckLocalView()) flags |= CHANF_NOPAUSE;
		toucher.A_StartSound(PickupSound,1002,flags,1.0,atten);
	}
}