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
    }
    states
    {
        spawn:
            CLIP A -1;
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
    }
    states
    {
        spawn:
            SHEL A -1;
            stop;
    }
}