Class BW_Ammo : Ammo
{
    override Class<Ammo> GetParentAmmo()
	{
		class<Object> type = GetClass();
		while (type.GetParentClass() != "BW_Ammo" && type.GetParentClass() != null)
			type = type.GetParentClass();
		return (class<Ammo>)(type);
	}
	
	mixin BW_BetterPickupSound;

    int got;
    override bool trypickup(in out actor toucher)
    {
        class<Ammo> type = GetParentAmmo();
		double factor = G_SkillPropertyFloat(SKILLP_AmmoFactor) * (bDROPPED?-G_SkillPropertyFloat(SKILLP_DropAmmoFactor):1);
        if(toucher && toucher.player)
        {
            int amt = amount * factor;
            let am = toucher.findinventory(type,true);
            bool pack = toucher.findinventory("BackPack",true);
            int cap = maxamount;
            int cur = 0;
            if(pack)
                cap = BackpackMaxAmount;
            if(am)
                cur = am.amount;
            got = clamp(cap - cur,0,amt);
        }
        return Super.TryPickup(toucher);
    }

    override string Pickupmessage()
    {
        return string.format("%s%s (+%d)",gettag(),(got > 1 ? "s" : ""),got);
    }
}

Class BW_KarAmmo : BW_Ammo
{
    default
    {
        inventory.amount 5;
        inventory.maxamount 20;
        ammo.backpackamount 10;
        ammo.BackpackMaxAmount 50;
        tag "7.92 x 57 Bullet";
        scale 0.3;
        inventory.althudicon "K98WB0";
    }
    states
    {
        spawn:
            K98W B -1;
            stop;
    }
}

Class BW_MGAmmo : BW_Ammo
{
    default
    {
        inventory.amount 50;
        inventory.maxamount 200;
        ammo.backpackamount 50;
        ammo.BackpackMaxAmount 200;
        tag "7.92 x 57 Bullet"; //not sure if this is correct
        inventory.althudicon "HBUSE0";
        scale 0.6;
    }
    states
    {
        spawn:
            HBUS E -1;
            stop;
    }
}

Class BW_PistolAmmo : BW_Ammo
{
    default
    {
        inventory.amount 8;
        inventory.maxamount 128;
        ammo.backpackamount 8;
        ammo.BackpackMaxAmount 128;
        tag "9mm Bullet";
        scale 0.8;
        inventory.althudicon "CLIPA0";
    }
    states
    {
        spawn:
            CLIP A -1;
            stop;
    }
}

Class BW_USAPistolAmmo : BW_Ammo
{
    default
    {
        inventory.amount 8;
        inventory.maxamount 128;
        ammo.backpackamount 8;
        ammo.BackpackMaxAmount 128;
        tag "9mm Bullet";
        scale 0.8;
        inventory.althudicon "CLIPA0";
    }
    states
    {
        spawn:
            CLIP A -1;
            stop;
    }
}

Class BW_STGAmmo : BW_Ammo //idk how to call this ammo
{
    default
    {
        inventory.amount 10;
        inventory.maxamount 90;
        ammo.backpackamount 10;
        ammo.BackpackMaxAmount 180;
        tag "7.92 x 33mm Bullet";
        Scale 0.65;
        inventory.althudicon "KARMA0";
    }
    states
    {
        spawn:
            KARM A -1;
            stop;
    }
}

Class BW_ShotgunAmmo : BW_Ammo
{
    default
    {
        inventory.amount 4;
        inventory.maxamount 50;
        ammo.backpackamount 4;
        ammo.BackpackMaxAmount 50;
        tag "12ga Shell";
        scale 0.8;
        inventory.althudicon "SHELA0";
    }
    states
    {
        spawn:
            SHEL A -1;
            stop;
    }
}

Class BW_GasCan : BW_Ammo //replaces cell
{
    Default
	{
		Inventory.Amount 10;
		Inventory.MaxAmount 60;
		Ammo.BackpackAmount 10;
		Ammo.BackpackMaxAmount 60;
		tag "Gas can";
        inventory.icon "AGASA0";
		inventory.althudicon "AGASA0";
	}
	states
	{
		spawn:
			AGAS A -1;
			stop;
	}
}

Class BW_TeslaCell : BW_Ammo //7692
{
	default
	{
		scale 0.7;
		inventory.amount 25;
        inventory.maxamount 200;
        ammo.backpackamount 25;
        ammo.BackpackMaxAmount 300;
        tag "Tesla Cell";
		inventory.althudicon "TSAMA0";
	}
	states
	{
		spawn:
			TSAM A -1 bright;
			stop;
	}
}


Class BW_LFAmmo : BW_Ammo //7692
{
	default
	{
		scale 0.75;
		inventory.amount 3;
        inventory.maxamount 6;
        ammo.backpackamount 2;
        ammo.BackpackMaxAmount 12;
        tag "PlasmaSix Cell";
		inventory.althudicon "LFAMA0";
	}
	states
	{
		spawn:
			LFAM A -1 bright;
			stop;
	}
}