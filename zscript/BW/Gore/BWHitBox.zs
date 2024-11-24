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

    States
    {
        spawn:
            TNT1 A -1;
            stop;
        Death:
            TNT1 AA 0 A_Spawnitem("Blood");
            TNT1 A 1 {if(tracer)tracer.destroy();}
            stop;
    }

    static void BW_CreateGibHitBox(actor own)
    {
        if(!own)
            return;
        let sp = spawn("BW_GibHitBox",own.pos);
        if(sp)
        {
            sp.tracer = own;                    //keep track of the original gib
            sp.CopyBloodColor(own);
            sp.A_setsize(own.radius,own.height);
            sp.settag(own.gettag());
        }
    }

}