//skeletons
Class BW_Skeleton1 : BW_ShootableDecoration replaces HangTSkull
{
    default
    {
        Radius 16;
        Height 64;
        health 50;
        deathheight 38;
    }
    states
    {
        spawn:
            HDB4 A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 {
                spawnDebris("BW_BoneDebris",(pos + (0,0,height * 0.5)),random(2,5));
                spawnDebris("BW_BoneHeadDebris",(pos + (0,0,height * 0.5)));
            }
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(20,40),35,45);
            SKPO B -1;
            stop;
    }
}

Class BW_BloodPool : BW_Decoration Replaces HangTNoBrain
{
    default
    {
        scale 0.5;
    }
    states
    {
        spawn:
            TNT1 A 0 nodelay {
                frame = random(0,7);
                scale *= frandom(0.9,2.5);
                angle = random(0,360);
            }
            NGMV # -1;
            stop;
    }
} 



Class BW_CagedSkelly : BW_ShootableDecoration replaces HangTLookingDown
{
    default
    {
        Radius 16;
        Height 54;
        health 15;
        deathheight 38;
    }
    states
    {
        spawn:
            HDB3 A -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 {
                spawnDebris("BW_BoneDebris",(pos + (0,0,height * 0.5)),random(2,5));
                spawnDebris("BW_BoneHeadDebris",(pos + (0,0,height * 0.5)));
            }
            TNT1 AAAA 0 BW_SpawnSmokeFx(random(20,40),35,45);
            GAB1 ABC 3;
            GAB1 D -1;
            stop;
    }
}

Class BW_CagedSkelly2 : BW_CagedSkelly //7051
{
    default
    {
        +nogravity;
        +SpawnCeiling;
    }
    /*override void postbeginplay()
    {
        super.postbeginplay();
        setz(ceilingz - height);
    }*/
}

Class BW_BoneStack : BW_ShootableDecoration replaces ColonGibs
{
    default
    {
        Radius 16;
        Height 20;
        health 150;
        deathheight 38;
        -solid;
    }
    states
    {
        spawn:
            POB1 A -1;
            stop;
        Death:
            TNT1 AA 0 BW_SpawnSmokeFx(5,35,30);
            TNT1 A 0 {
                spawnDebris("BW_BoneDebris",(pos + (0,0,height * 0.5)),random(2,4));
                spawnDebris("BW_BoneHeadDebris",(pos + (0,0,height * 0.5)));
            }
            TNT1 A 1;
            stop;
    }
}

Class BW_BloodyBoneStack : BW_BoneStack replaces Meat4
{
    states
    {
        spawn:
            HDB6 A -1;
            stop;
    }
    
}

Class BW_BloodyBoneStack2 : BW_BloodyBoneStack replaces nonsolidmeat4
{}

Class BW_Skelly : BW_BoneStack replaces BrainStem
{
    states
    {
        spawn:
            BRS1 A -1;
            stop;
    }
}

Class BW_MutantBasket : BW_ShootableDecoration
{
    default
    {
        //-noblood;
        bloodcolor "FF00FF";
        Radius 16;
        Height 30;
        health 40;
        deathheight 38;
    }
    states
    {
        spawn:
            YLBR C -1;
            stop;
        Death:
            TNT1 A 0 A_NoBlocking();
            TNT1 A 0 {
                nashgoregibs.spawngibs(self);   //need to change thisto proper mutant gibs
            }
            YLBR D -1;
            stop;
    }
}