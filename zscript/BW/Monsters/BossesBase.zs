Class BW_Boss : BW_MonsterBase
{
    default
    {
        +BOSS;
        +DONTMORPH;
        +BOSSDEATH;
        +NoInfighting;
        tag "BW Boss";
    }

    bool Alerted;

    bool isAlerted()
    {
        return self.alerted;
    }

    void setAlerted(bool set = true)
    {
        self.alerted = set;
    }

    state A_jumpifNotAlerted(statelabel st)
    {
        if(!isAlerted())
        {
            setAlerted(true);
            return resolvestate(st);
        }
        return resolvestate(null);
    }

    virtual void RequestBossBar(bossbarinfo bi)
    {
        if(!bi.ready)
            return;
        //console.printf("requesting boss bar");
        BW_BossBarHandler.RequestInitBossBar(bi,self);        
    }

    //set the music if the current level name coincides with the desired level name
    //level name refers to the name you use with the Map console command, e.g. "BW1M9"
    void SetBossMusic(string mus,string ifmap = "")
    {
        if(level.Mapname == ifmap)
            level.SetInterMusic(mus);
    }
}


struct bossbarinfo
{
    string portrait;
    string angryPortrait;
    string presentation;   
    int maxhp;
    bool ready;
}