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
            TREA A -1 bright light("TreasureLight");
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
            TREA C -1 bright light("TreasureLight");
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
            TREA D -1 bright light("TreasureLight");
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
            TREA B -1 bright light("TreasureLight");
            stop;
    }
}

//

Class BW_Radio : BW_Treasure    //600
{
    default
    {
        Inventory.PickupMessage "Radio";
    }
    states
    {
        Spawn:
            LATS A -1 bright light("TreasureLight");
            stop;
    }
}

Class BW_Plutonium : BW_Treasure //700
{
    default
    {
        Inventory.PickupMessage "Plutonium";
    }
    states
    {
        Spawn:
            LATS B -1 bright light("TreasureLight");
            stop;
    }
}

Class BW_Bomb1 : BW_Treasure //800
{
    default
    {
        Inventory.PickupMessage "Control Panel";
    }
    states
    {
        Spawn:
            LATS C -1 bright light("TreasureLight");
            stop;
    }
}

Class BW_Bomb2 : BW_Treasure //900
{
    default
    {
        Inventory.PickupMessage "Bomb";
    }
    states
    {
        Spawn:
            LATS D -1 bright light("TreasureLight");
            stop;
    }
}
