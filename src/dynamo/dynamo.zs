class Dynamo play {
    static void Init()
    {
        Console.printf("Initialising Dynamo...");

        let globals = DynamoGlobals.Get();

        globals.song.SetBpm(125);
        globals.song.SetBarGrouping(2);

        DynamoBlock musicIntro = globals.song.CreateBlock();
        DynamoBlock musicStart = globals.song.CreateBlock();
        DynamoBlock musicBuildup = globals.song.CreateBlock();
        DynamoBlock musicLoop = globals.song.CreateBlock();
        DynamoBlock musicDrop = globals.song.CreateBlock();

        musicDrop.SetFill(true);

        musicIntro.AddChannel("dynamo/intro_m");
        musicIntro.AddChannel("dynamo/intro_m");
        musicIntro.AddChannel("dynamo/intro_r");
        musicIntro.SetLength(2);

        musicStart.AddChannel("dynamo/start_l");
        musicStart.AddChannel("dynamo/start_m");
        musicStart.AddChannel("dynamo/start_r");
        musicStart.SetLength(2);

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

        musicIntro.AddNextBlock(musicStart);

        musicStart.AddNextBlock(musicStart);
        musicStart.AddNextBlock(musicBuildup);

        musicBuildup.AddNextBlock(musicBuildup);
        musicBuildup.AddNextBlock(musicDrop);

        musicDrop.AddNextBlock(musicLoop);

        musicLoop.AddNextBlock(musicLoop);
        musicLoop.AddNextBlock(musicStart);

        globals.song.SetStartBlock(musicIntro);

        globals.song.AddSoundEmitter(1);
        globals.song.AddSoundEmitter(2);
        globals.song.AddSoundEmitter(3);

        musicLoop.AddBeatCallback(DynamoFlashyGimmick.Create(5));

        globals.song.PrecacheSounds(6);
    }

    static void DeInit()
    {
        Console.printf("Deinitialising Dynamo...");
    }

    static void MusicSwitch(int track, bool stay)
    {
        let globals = DynamoGlobals.Get();

        globals.song.Start();

        Console.printf("Switched to track %d", track);
        DynamoGlobals.Get().song.MusicSwitch(track, stay);
    }

    static void Frame()
    {
        let globals = DynamoGlobals.Get();

        globals.song.Frame();
    }
}
