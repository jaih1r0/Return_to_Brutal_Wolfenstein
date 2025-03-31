Class BW_Treasure : scoreitem
{
    default
    {
        +CountItem;
        +INVENTORY.ALWAYSPICKUP;
        +Inventory.Neverrespawn;
        Inventory.MaxAmount 0;
        Inventory.PickupSound "pickup/treasure";
        Inventory.PickupMessage "treasure";
    }
}

Class BW_Treasure_Cross : BW_Treasure
{
    default
    {
        Inventory.PickupMessage "Cross";
    }
    states
    {
        Spawn:
            TREA A -1 bright;
            stop;
    }
}

Class BW_Treasure_Chalice : BW_Treasure
{
    default
    {
        Inventory.PickupMessage "Chalice";
    }
    states
    {
        Spawn:
            TREA C -1 bright;
            stop;
    }
}

Class BW_Treasure_Chalice1 :BW_Treasure_Chalice
{}

Class BW_Treasure_Chest : BW_Treasure
{
    default
    {
        Inventory.PickupMessage "Chest";
    }
    states
    {
        Spawn:
            TREA D -1 bright;
            stop;
    }
}

Class BW_Treasure_Crown : BW_Treasure
{
    default
    {
        Inventory.PickupMessage "Crown";
    }
    states
    {
        Spawn:
            TREA B -1 bright;
            stop;
    }
}