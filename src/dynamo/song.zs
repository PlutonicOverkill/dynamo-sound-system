class DynamoSong {
    private uint bpm = 120;
    private uint barGrouping = 4;
    private Array<DynamoBlock> blocks;
    private Array<uint> soundEmitters;

    void SetBpm(uint val)
    {
        if (val == 0) {
            Console.Printf("Error: Set BPM of zero");
            return;
        }

        bpm = val;
    }

    void SetBarGrouping(uint val)
    {
        if (val == 0) {
            Console.Printf("Error: Set bar grouping of zero");
            return;
        }

        barGrouping = val;
    }

    DynamoBlockHandle CreateBlock()
    {
        uint index = blocks.Push(DynamoBlock.Create());
        return DynamoBlockHandle.Create(index);
    }

    void BlockSetFill(DynamoBlockHandle h, bool fill)
    {
        blocks[h.GetIndex()].SetFill(fill);
    }

    void BlockAddChannel(DynamoBlockHandle h, String chan)
    {
        blocks[h.GetIndex()].AddChannel(chan);
    }

    void BlockSetLength(DynamoBlockHandle h, uint len)
    {
        blocks[h.GetIndex()].SetLength(len);
    }

    void BlockAddNextBlock(DynamoBlockHandle h, DynamoBlockHandle next)
    {
        blocks[h.GetIndex()].AddNextBlock(next);
    }

    void Start()
    {

    }

    DynamoRoute FindRoute(DynamoBlock current, DynamoBlock target) const
    {
        return FindRouteImpl(current, target, 0);
    }

    // uses a depth-first search to find the fastest route from current to target.
    // If two routes are of equal length, one of the two is randomly chosen.
    private DynamoRoute FindRouteImpl(DynamoBlock current, DynamoBlock target, uint searchDepth) const
    {
        if (current == target) // found what we were looking for
            return DynamoRoute.Create(current);

        if (searchDepth >= blocks.Size()) {
            // stuck in a loop, so go back and retry
            return New("DynamoRoute");
        }

        uint candidates = 0;
        DynamoRoute route = New("DynamoRoute");

        for (int i = 0; i != current.NextBlockCount(); ++i)
        {
            DynamoBlock next = current.NextBlock(i);

            // check if we missed the fill cutoff
            if (searchDepth == 0 && next.IsFill() && NextFillBar(next) > current.Length())
                continue;

            DynamoRoute tempRoute = FindRouteImpl(next, target, searchDepth + 1);
            tempRoute.Add(current);

            if (tempRoute.Compare(route) < 0) {
                // found a faster route
                route = tempRoute;
            }
            else if (tempRoute.Compare(route) == 0 && Random(0, i++) == 0) {
                // randomly choose one of them
                route = tempRoute;
            }
        }

        return route;
    }

    private uint NextFillBar(DynamoBlock block) const
    {

    }
}

class DynamoBlockHandle {
    private uint index;

    uint GetIndex() const
    {
        return index;
    }

    static DynamoBlockHandle Create(uint i)
    {
        let handle = New("DynamoBlockHandle");
        handle.index = i;
        return handle;
    }
}
