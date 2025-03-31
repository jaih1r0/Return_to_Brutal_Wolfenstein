Class BW_BlackKey : inventory
{
    default
    {
        Inventory.PickupSound "pickup/key";
        Inventory.PickupMessage "You picked up the Black Key";
        +inventory.ALWAYSPICKUP;
    }
    states
    {
        spawn:
            NKEY A -1;
            stop;
    }
    override bool trypickup(in out actor toucher)
    {
        if(toucher && toucher.player)
            toucher.giveinventory("HasPickedUpBlackKey",1);
        return super.trypickup(toucher);
    }
}

Class BW_DiamondKey : inventory
{
    default
    {
        Inventory.PickupSound "pickup/key";
        Inventory.PickupMessage "You picked up the Diamond Key";
    }
    states
    {
        spawn:
            DMEY A -1;
            stop;
    }
    override bool trypickup(in out actor toucher)
    {
        if(toucher && toucher.player)
            toucher.giveinventory("HasPickedUpDiamondKey",1);
        return super.trypickup(toucher);
    }
}

Class HasPickedUpBlackKey : inventory
{

}

Class HasPickedUpDiamondKey : inventory
{

}