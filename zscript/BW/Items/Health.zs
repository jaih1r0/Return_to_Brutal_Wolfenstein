
Class BW_HealthItem : Health
{
    default
    {
        inventory.amount 1;
        inventory.maxamount 100;
    }
    bool Used;
    override bool tryPickup(in out actor toucher)
    {
        if(Used || !toucher || !toucher.player || toucher.health >= maxamount)
            return false;
        PrevHealth = toucher.player != NULL ? toucher.player.health : toucher.health;
        Used = true;
        toucher.givebody(amount,maxamount); //actually give health
        bool localview = toucher.CheckLocalView();
        PrintPickupMessage(localview,PickupMessage());
        PlayPickupSound (toucher);

        DoPickupSpecial (toucher);
        //A_ChangeLinkFlags(true);
        if (!bNoScreenFlash && toucher.player.playerstate != PST_DEAD)  //funny yellow pickup flash
            toucher.player.bonuscount = BONUSADD;
        
        if(resolvestate("Consumed") != null)    //set it to consumed state if any
            setstatelabel("Consumed");

        return false;   //dont pick it up anyways
    }

    //returns amount,maxamount depending on skill, currently unused
    virtual int,int gethealAmount()
    {
        return amount;
    }

    void itemthrust(int force = 5)
    {
        vel.z += force;
    }
    
}

Class BW_BonusHealth : BW_HealthItem replaces healthbonus
{
    default
    {
        Inventory.PickupSound "Health/Food";
        Inventory.Amount 4;
        Inventory.MaxAmount 100;
        Inventory.PickupMessage "Ate some Dog Food,WOOF!";
    }
    states
    {
        Spawn:
            BON1 A -1;
            stop;
        Consumed:
            TNT1 A 0 itemthrust();
            DOGF B -1;
            stop;
    }
}

Class BW_Stimpack : BW_HealthItem replaces Stimpack
{
    default
    {
        Inventory.PickupSound "Health/Food";
        Inventory.Amount 10;
        Inventory.PickupMessage "Cold Plate of Food";
    }
    states
    {
        spawn:
            STIM A -1;
            stop;
        Consumed:
            TNT1 A 0 itemthrust();
            CHIC B -1;
            stop;
    }
}

Class BW_Medikit : BW_HealthItem replaces medikit
{
    default
    {
        Inventory.PickupSound "Health/Medikit";
        Inventory.Amount 25;
        Inventory.PickupMessage "Medkit!";
        Health.LowMessage 25, "Thanks God! A first-Aid Kit!";
    }
    states
    {
        spawn:
            MEDI A -1;
            stop;
        Consumed:
            TNT1 A 0 itemthrust();
            FAID B -1;
            stop;
    }
}


Class BW_UberHealth : Health    //9090
{
    default
    {
        Inventory.PickupMessage "Uber-Health";
        Health.LowMessage 25, "Now i've got your ticket to hell";
        Inventory.Amount 200;
        Inventory.MaxAmount 200;
        //Inventory.PickupSound "SAMUELE";
    }
    states
    {
        Spawn:
            MGH1 A -1;
            stop;
    }
}
