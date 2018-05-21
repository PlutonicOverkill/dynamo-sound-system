class Dynamo play {
    static void Init()
    {
        Console.printf("Initialising Dynamo...");

        let globals = DynamoGlobals.Get();

        globals.song.SetBpm(125);
        globals.song.SetBarGrouping(2);

        DynamoBlock musicIntro = DynamoBlock.Create();
        DynamoBlock musicStart = DynamoBlock.Create();
        DynamoBlock musicBuildup = DynamoBlock.Create();
        DynamoBlock musicDrop = DynamoBlock.Create();
        DynamoBlock musicLoop = DynamoBlock.Create();

        musicDrop.SetFill(true);

        musicIntro.AddChannel("dynamo/intro_l");
        musicIntro.AddChannel("dynamo/intro_m");
        musicIntro.AddChannel("dynamo/intro_r");
        musicIntro.SetLength(2)

        musicStart.AddChannel("dynamo/start_l");
        musicStart.AddChannel("dynamo/start_m");
        musicStart.AddChannel("dynamo/start_r");
        musicStart.SetLength(2)

        musicBuildup.AddChannel("dynamo/buildup_l");
        musicBuildup.AddChannel("dynamo/buildup_m");
        musicBuildup.AddChannel("dynamo/buildup_r");
        musicBuildup.SetLength(4);

        musicDrop.AddChannel("dynamo/drop_l");
        musicDrop.AddChannel("dynamo/drop_m");
        musicDrop.AddChannel("dynamo/drop_r");
        musicDrop.SetLength(2);

        musicLoop.AddChannel("dynamo/loop_l");
        musicLoop.AddChannel("dynamo/loop_m");
        musicLoop.AddChannel("dynamo/loop_r");
        musicLoop.SetLength(16);

        musicIntro.SetNextBlock(musicStart);

        musicStart.SetNextBlock(musicStart);
        musicStart.SetNextBlock(musicBuildup);

        musicBuildup.SetNextBlock(musicBuildup);
        musicBuildup.SetNextBlock(musicDrop);

        musicDrop.SetNextBlock(musicLoop);

        musicLoop.SetNextBlock(musicLoop);
        musicLoop.SetNextBlock(musicStart);

        globals.song.AddBlock(musicIntro);
        globals.song.AddBlock(musicStart);
        globals.song.AddBlock(musicBuildup);
        globals.song.AddBlock(musicDrop);
        globals.song.AddBlock(musicLoop);

        globals.song.Start();
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
