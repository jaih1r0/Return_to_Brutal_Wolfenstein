Class BW_Key : Key
{
	string actualKey;
	property actualKey:actualKey;
	//[Pop] This should only be used for special keys, like the Diamond Key and Black Key
	//use Species for everything else
	//[Pop] NERVERMIND, until we rewrite the ACS for maps to check for Species instead of set key
	
	
    color keycolor;
	property keycolor:keycolor;
    default
    {
		Radius 20;
		Height 16;
		+NOTDMATCH;
		+DONTGIB;
		+FLOORCLIP;
		Inventory.InterHubAmount 0;
        Inventory.PickupSound "pickup/key";
        Inventory.PickupMessage "You picked up a Key";
        +inventory.ALWAYSPICKUP;
        BW_Key.keycolor 0xFFFFFF;
		BW_Key.actualKey "";
        //+INVENTORY.NOSCREENFLASH;
    }
	
    override bool trypickup(in out actor toucher)
    {
        if(toucher && toucher.player && actualKey != "")
            toucher.A_setinventory(actualKey,1);
        if(keycolor)
			toucher.A_setblend(keycolor,0.3,10);
        return super.trypickup(toucher);
    }
	
    override void PlayPickupSound(actor toucher)
	{
		double atten;
		int flags = CHANF_OVERLAP|CHANF_MAYBE_LOCAL;
		if(bNoAttenPickupSound) atten = ATTN_NONE;
		else atten = ATTN_NORM;
		if(toucher && toucher.CheckLocalView()) flags |= CHANF_NOPAUSE;
		toucher.A_StartSound(PickupSound,1002,flags,1.0,atten);
	}
}

Class BW_BlackKey : BW_Key
{
    default
    {
        Inventory.PickupMessage "You picked up the Black Key";
        +inventory.ALWAYSPICKUP;
        Inventory.Icon "TNT1A0";
		BW_Key.actualKey "HasPickedUpBlackKey";
    }
    states
    {
        spawn:
            NKEY A -1;
            stop;
    }
}

Class BW_DiamondKey : BW_Key
{
    default
    {
        +inventory.ALWAYSPICKUP;
		Inventory.PickupMessage "You picked up the Diamond Key";
        BW_Key.actualKey "HasPickedUpDiamondKey";
		Inventory.Icon "TNT1A0";
    }
    states
    {
        spawn:
            DMEY A -1;
            stop;
    }
}

Class HasPickedUpBlackKey : Inventory
{
	Default
	{
		Inventory.Icon "NMEYA0";
	}
	
	states
    {
        spawn:
            NKEY A -1;
            stop;
    }
}

Class HasPickedUpDiamondKey : Inventory
{
	Default
	{
		Inventory.Icon "DMEYA0";
	}
	
	states
    {
        spawn:
            DMEY A -1;
            stop;
    }
}

Class BW_YellowKey : BW_Key replaces YellowCard
{
    Default
	{
		Inventory.Pickupmessage "$GOTGOLDKEY";
		Inventory.Icon "YKEYA0";
        Species "YellowCard";
		BW_Key.actualKey "YellowCard";
        BW_Key.keycolor 0xFFDE60;
	}
	States
	{
        Spawn:
            YKEY A 10;
            YKEY B 10 bright;
            loop;
	}
}

class BW_BlueKey : BW_Key replaces BlueCard
{
	Default
	{
		Inventory.Pickupmessage "$GOTSILVERKEY";
		Inventory.Icon "BKEYA0";
        Species "BlueCard";
		BW_Key.actualKey "BlueCard";
        BW_Key.keycolor 0xCECECE;
	}
	States
	{
        Spawn:
            BKEY A 10;
            BKEY B 10 bright;
            loop;
	}
}

Class BW_RedKey : BW_Key replaces RedCard
{
    Default
	{
		Inventory.Pickupmessage "$GOTCOPPERKEY";
		Inventory.Icon "RKEYA0";
        Species "RedCard";
		BW_Key.actualKey "RedCard";
        BW_Key.keycolor 0xEC0B0D;
	}
	States
	{
        Spawn:
            RKEY A 10;
            RKEY B 10 bright;
            loop;
	}
}