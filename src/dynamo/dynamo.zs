class Dynamo play {
    static void Init()
    {
        Console.printf("Initialising Dynamo...");

        let globals = DynamoGlobals.Get();

        globals.song.SetBpm(125);
        globals.song.
    }

    static void DeInit()
    {
        Console.printf("Deinitialising Dynamo...");
    }

    static void MusicSwitch(int track)
    {
        Console.printf("Switched to track %d", track);
        DynamoGlobals.Get().song.MusicSwitch(track);
    }

    static void Frame()
    {

    }
}
