class DynamoSong play {
    private uint bpm;
    private uint barGrouping;
    private Array<DynamoBlock> blocks;
    private Array<MapSpot> soundEmitters; // TODO change to custom class
    private Array<DynamoBeatCallback> beatCallbacks;
    private DynamoBlock currentBlock;
    private DynamoBlock targetBlock;
    private DynamoRoute route;
    private uint tics;
    private uint beats;
    private bool running;

    void SetBpm(uint val)
    {
        if (!val) {
            Console.Printf("Error: Set BPM of zero");
            return;
        }

        bpm = val;
    }

    void SetBarGrouping(uint val)
    {
        if (!val) {
            Console.Printf("Error: Set bar grouping of zero");
            return;
        }

        barGrouping = val;
    }

    DynamoBlock CreateBlock()
    {
        let block = DynamoBlock.Create();

        blocks.Push(block);
        return block;
    }

    void SetStartBlock(DynamoBlock block)
    {
        currentBlock = block;
        targetBlock = block;
    }

    void AddSoundEmitter(uint tid)
    {
        let iterator = ActorIterator.Create(tid); // TODO make this a custom class
        let spot = iterator.Next();

        if (!spot)
            Console.printf("Warning: spot with tid %d is null!", tid);
        else
            Console.printf("Added spot with tid %d", tid);

        soundEmitters.Push(spot);
    }

    void Start()
    {
        if (running)
            return;

        Console.printf("Dynamo started.");

        tics = 0;
        beats = 0;
        running = true;

        PlayCurrentTrack();
    }

    void Frame()
    {
        if (!running)
            return;

        ++tics;

        if (!currentBlock)
            return;

        uint lengthBeats = currentBlock.GetLength() * 4;
        uint currentBlockLengthTics = DynamoUtil.BeatsToTics(lengthBeats, bpm);
        uint nextBeatTic = currentBlockLengthTics * (beats + 1) / lengthBeats;

        // Console.printf("tics: %d\tcurrentBlockLength: %d", tics, currentBlockLengthTics);

        bool isBeat = false;
        bool isBar = false;

        if (tics >= nextBeatTic) {
            ++beats;
            isBeat = true;

            if (beats % 4 == 0)
                isBar = true;

            // Console.printf("Beat %d", beats);
        }

        currentBlock.ProcessBeatCallbacks(isBeat);

        bool endOfBlock = (tics >= currentBlockLengthTics);

        if (isBar) {
            if (!route || route.IsEmpty() || targetBlock != route.GetTarget()) { // route is out of date, recalculate
                Console.printf("Route invalid, recalculating...");
                route = FindRoute(currentBlock, targetBlock);
            }

            if (route) { // route should not now be empty
                DynamoBlock top = route.Top();
                uint bars = beats / 4;

                if (endOfBlock || top.IsFill() && currentBlock.IsFillBar(top, barGrouping, bars)) {

                    if (endOfBlock) {
                        Console.printf("End of block: %d >= %d", tics, currentBlockLengthTics);
                    }

                    if (top.IsFill() && currentBlock.IsFillBar(top, barGrouping, bars)) {
                        Console.printf("Playing fill on bar %d", bars);
                    }

                    tics = 0;
                    beats = 0;

                    currentBlock = route.Next();
                    PlayCurrentTrack();
                }
            }
            else { // no path, we'll just have to keep looping
                if (endOfBlock) {
                    Console.printf("No route available, looping.");

                    tics = 0;
                    beats = 0;
                    PlayCurrentTrack();
                }
            }
        }
    }

    void PlayCurrentTrack()
    {
        // Console.printf("soundEmitters.Size() == %d", soundEmitters.Size());

        Console.printf("Playing new track %s", currentBlock.GetChannel(0));

        for (uint i = 0; i != soundEmitters.Size() && i != currentBlock.ChannelAmount(); ++i) {
            String channel = currentBlock.GetChannel(i);
            MapSpot spot = soundEmitters[i];

            spot.A_PlaySound(channel, CHAN_BODY, 1.0, false, 0.1, false);
        }
    }

    void MusicSwitch(int track, bool stay)
    {
        // TODO stay flag
        if (track >= 0 && track < blocks.size()) {
            targetBlock = blocks[track];
        }
    }

    void PrecacheSounds(int tid) const
    {
        let iterator = ActorIterator.Create(tid);
        let spot = iterator.Next();

        if (!spot) {
            Console.printf("Warning: PrecacheSounds: spot with tid %d is null!", tid);
            return;
        }

        for (uint i = 0; i != blocks.Size(); ++i) {
            DynamoBlock block = blocks[i];

            for (uint j = 0; j != block.ChannelAmount(); ++j) {
                String channel = block.GetChannel(j);

                spot.A_PlaySound(channel, CHAN_BODY, 0.01 /*Double.Min_Normal*/, false, 100, false);
                // spot.A_StopSound(CHAN_BODY);
            }
        }
    }

    static DynamoSong Create()
    {
        let song = New("DynamoSong");

        song.bpm = 120;
        song.barGrouping = 4;
        song.running = false;

        return song;
    }

    DynamoRoute FindRoute(DynamoBlock current, DynamoBlock target) const
    {
        return FindRouteImpl(current, target, 0);
    }

    // uses a depth-first search to find the fastest route from current to target.
    // If two routes are of equal length, one of the two is randomly chosen.
    private DynamoRoute FindRouteImpl(DynamoBlock current, DynamoBlock target, uint searchDepth) const
    {
        if (current == target) { // found what we were looking for
            Console.printf("Target block found.");
            return DynamoRoute.Create(current, barGrouping);
        }

        if (searchDepth >= blocks.Size()) {
            Console.printf("Dead end");
            // stuck in a loop, so go back and retry
            return null;
        }

        uint candidates = 0;
        DynamoRoute route = null;

        for (uint i = 0; i != current.NextBlockCount(); ++i)
        {
            DynamoBlock next = current.NextBlock(i);

            Console.printf("Retrieved candidate %d", i);

            // check if we missed the fill cutoff
            if (searchDepth == 0 && next.IsFill() && currentBlock.NextFillBar(next, barGrouping, beats * 4) > current.GetLength()) {
                Console.printf("Missed fill cutoff");
                continue;
            }

            DynamoRoute tempRoute = FindRouteImpl(next, target, searchDepth + 1);

            if (!route) { // we don't currently have a path
                if (tempRoute) { // and we've found a new one
                    Console.printf("Route found.");
                    route = tempRoute; // set as the current path

                    if (searchDepth != 0) {
                        route.Add(current, barGrouping, (searchDepth) ? 0 : beats * 4); // add the node we took to get here
                    }
                }
            }
            else if (tempRoute) { // we have two possible paths
                if (searchDepth != 0) {
                    tempRoute.Add(current, barGrouping, (searchDepth) ? 0 : beats * 4); // add the direction we took to get here
                }

                uint routeLength = route.Length();
                uint tempRouteLength = tempRoute.Length();

                if (tempRouteLength < routeLength) {
                    Console.printf("Faster route found. (%d < %d)", tempRouteLength, routeLength);
                    // found a faster route
                    route = tempRoute;
                }
                else if (tempRouteLength == routeLength && Random(0, candidates++) == 0) {
                    Console.printf("Equal length route found. (%d)", routeLength);
                    // randomly choose one of them
                    route = tempRoute;
                }
            }
        }

        if (route)
            Console.printf("Returning route.");
        else
            Console.printf("No route found.");

        return route;
    }
}
