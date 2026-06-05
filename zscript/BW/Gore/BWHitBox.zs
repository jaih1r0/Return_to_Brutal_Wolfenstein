//
//
//  generic hitbox class for shootable gibs
//
//

Class BW_GibHitBox : Actor
{
    default
    {
        +shootable;
        +vulnerable;
        +NOTAUTOAIMED;
        radius 5;
        height 5;
        health 20;
    }
    override void beginplay()
    {
        ChangeStatNum(STAT_NashGore_Gore);
        super.beginplay();
    }
    bool extreme;
    States
    {
        spawn:
            TNT1 A -1;
            stop;
        Death:
            TNT1 A 0 A_jumpif(extreme,"XDeath");
            TNT1 AA 0 A_Spawnitem("Blood");
            TNT1 A 1 {if(tracer)tracer.destroy();}
            stop;
        XDeath:
            TNT1 A 0 {
                if(tracer)
                {
                    NashGoreGibs.SpawnGibs(tracer);
                    tracer.destroy();
                }
            }
            TNT1 A 1;
            stop;
    }

    static void BW_CreateGibHitBox(actor own, bool isExtreme = false)
    {
        if(!own)
            return;
        let sp = BW_GibHitBox(spawn("BW_GibHitBox",own.pos));
        if(sp)
        {
            sp.tracer = own;                    //keep track of the original gib
            sp.CopyBloodColor(own);
            sp.A_setsize(own.radius,own.height);
            sp.settag(own.gettag());
            sp.extreme = isExtreme;
        }
    }

}