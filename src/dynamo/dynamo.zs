class Dynamo {
    static void Init()
    {
        Console.printf("Initialising Dynamo...");
    }

    static void DeInit()
    {
        Console.printf("Deinitialising Dynamo...");
    }

    static void MusicSwitch(int track)
    {
        Console.printf("Switched to track %d", track);
    }

    static void Tick()
    {

    }

    DynamoSong song;
    DynamoRoute route;
}
