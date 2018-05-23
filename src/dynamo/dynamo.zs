class Dynamo play {
    static void Init()
    {
        Console.printf("Initialising Dynamo...");

        let globals = DynamoGlobals.Get();

        globals.song.SetBpm(125);
        globals.song.SetBarGrouping(2);

        DynamoBlockHandle musicIntro = globals.song.CreateBlock();
        DynamoBlockHandle musicStart = globals.song.CreateBlock();
        DynamoBlockHandle musicBuildup = globals.song.CreateBlock();
        DynamoBlockHandle musicDrop = globals.song.CreateBlock();
        DynamoBlockHandle musicLoop = globals.song.CreateBlock();

        globals.song.BlockSetFill(musicDrop, true);

        globals.song.BlockAddChannel(musicIntro, "dynamo/intro_l");
        globals.song.BlockAddChannel(musicIntro, "dynamo/intro_m");
        globals.song.BlockAddChannel(musicIntro, "dynamo/intro_r");
        globals.song.BlockSetLength(musicIntro, 2);

        globals.song.BlockAddChannel(musicStart, "dynamo/start_l");
        globals.song.BlockAddChannel(musicStart, "dynamo/start_m");
        globals.song.BlockAddChannel(musicStart, "dynamo/start_r");
        globals.song.BlockSetLength(musicStart, 2);

        globals.song.BlockAddChannel(musicBuildup, "dynamo/buildup_l");
        globals.song.BlockAddChannel(musicBuildup, "dynamo/buildup_m");
        globals.song.BlockAddChannel(musicBuildup, "dynamo/buildup_r");
        globals.song.BlockSetLength(musicBuildup, 4);

        globals.song.BlockAddChannel(musicDrop, "dynamo/drop_l");
        globals.song.BlockAddChannel(musicDrop, "dynamo/drop_m");
        globals.song.BlockAddChannel(musicDrop, "dynamo/drop_r");
        globals.song.BlockSetLength(musicDrop, 2);

        globals.song.BlockAddChannel(musicLoop, "dynamo/loop_l");
        globals.song.BlockAddChannel(musicLoop, "dynamo/loop_m");
        globals.song.BlockAddChannel(musicLoop, "dynamo/loop_r");
        globals.song.BlockSetLength(musicLoop, 16);

        globals.song.BlockAddNextBlock(musicIntro, musicStart);

        globals.song.BlockAddNextBlock(musicStart, musicStart);
        globals.song.BlockAddNextBlock(musicStart, musicBuildup);

        globals.song.BlockAddNextBlock(musicBuildup, musicBuildup);
        globals.song.BlockAddNextBlock(musicBuildup, musicDrop);

        globals.song.BlockAddNextBlock(musicDrop, musicLoop);

        globals.song.BlockAddNextBlock(musicLoop, musicLoop);
        globals.song.BlockAddNextBlock(musicLoop, musicStart);

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
