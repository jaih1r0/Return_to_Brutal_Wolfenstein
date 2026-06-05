//
//  unfinished for now
//
Class BW_MultiStageDeathBase : BW_MonsterBase abstract
{
    default
    {
        -countkill;
        -solid;
        +shootable;
        health 300;
        height 54;
        +dontthrust
        BW_MultiStageDeathBase.deathstates 1;
    }

    int existTime;
    int deathState;
    int deathstates;
    property deathstates:deathstates;
    int lifeperstate, cumulateddmg;

    void doSetup()
    {
        existTime = random(5,10) * thinker.ticrate;
        deathState = 0;
        lifeperstate = int(spawnhealth() / deathstates);
    }

    state tickDeath(statelabel endstate = null, int nextstatevalue = -1, statelabel nextstate = null)
    {
        if(nextstatevalue != -1 && deathState >= nextstatevalue)
            return resolvestate(nextstate);
        if(existTime > 0)
            existTime--;
        else
            return resolvestate(endstate);
        return resolvestate(null);
    }

    void doDead()
    {
        A_Scream();
        A_NoBlocking();
    }

    void advanceDeathState()
    {
        deathState++;
        cumulateddmg = 0;
    }

    override int DamagemObj(Actor inflictor,Actor source,int damage,Name mod,int flags,double angle)
    {
        
        int fuck = super.DamagemObj(inflictor,source,damage,mod,flags,angle);
        cumulateddmg += fuck;
        if(cumulateddmg >= lifeperstate && deathState < deathstates)
            advanceDeathState();
        
        return fuck;
    }
}


Class BW_BrownGuardMachineGunDeath : BW_MultiStageDeathBase
{
    default
    {
        BW_MultiStageDeathBase.deathstates 4;
    }
    states
    {
        Spawn:
            TNT1 A 0 nodelay doSetup();
        InitialState:
            ZZD1 A 1 tickDeath("Death",1,"NoHead");
            loop;
        NoHead:
            ZZD1 B 1 tickDeath("Death_NoHead",2,"AlmostDeath");
            loop;
        AlmostDeath:
            ZZD1 C 1 tickDeath("Death_Final",3,"Death_Final");
            loop;
        pain:
        Pain:
            TNT1 A 2;
            #### # 1 {
                A_Pain();
            }
            goto InitialState;

        Death:
            TNT1 A 0 {
                switch(deathState)
                {
                    case 1:
                        return resolvestate("Death_NoHead");    break;
                    case 2:
                    case 3:
                        return resolvestate("Death_Final"); break;
                }
                return resolvestate(null);
            }
            TNT1 A 0 doDead();
            ZZD2 H 3;
            ZZD3 D -1;
            stop;
        Death_NoHead:
            TNT1 A 0 doDead();
            NSGB A 3;
            NSGB B -1;
            stop;
        Death_Final:
            TNT1 A 0 doDead();
            ZZD1 FG 3;
            ZZD1 H -1;
            stop;

    }
}