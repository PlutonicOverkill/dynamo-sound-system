class DynamoGlobals : Thinker
{
    DynamoSong song;

    DynamoGlobals Init()
    {
        song = DynamoSong.Create();
        ChangeStatNum(STAT_STATIC);
        return self;
    }

    static DynamoGlobals Get()
    {
        ThinkerIterator it = ThinkerIterator.Create("DynamoGlobals", STAT_STATIC);
        let p = DynamoGlobals(it.Next());
        if (p == null)
            p = new("DynamoGlobals").Init();
        return p;
    }
}
