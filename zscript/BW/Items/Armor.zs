// armor related things

Class BW_Helmet : BasicArmorbonus //132
{
    default
    {
        Radius 20;
        Height 8;
        Inventory.PickUpSound "pickup/armorbonus";
        Inventory.PickupMessage "Picked up a stahlhelm.";
        Armor.SavePercent 50;
        Armor.SaveAmount 25;
        Armor.maxSaveAmount 100;
        -INVENTORY.ALWAYSPICKUP;
        Inventory.Icon "BON2A0";
    }
    states
    {
        spawn:
            BON2 A -1;
            stop;
    }
}

Class BW_ArmorBonus : BW_Helmet replaces  ArmorBonus
{
    default
    {
        Armor.SaveAmount 5;
    }
}

Class BW_DroppedHelmet : BW_ArmorBonus
{
    default
    {
        Armor.maxSaveAmount 125;
    }
}

//couldnt find the respective actors in bw
Class BW_GreenArmor : GreenArmor
{}

Class BW_BlueArmor : BlueArmor
{}