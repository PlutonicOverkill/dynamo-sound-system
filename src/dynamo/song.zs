class DynamoSong {
    private uint bpm;
    private Array<DynamoBlock> blocks;

    void SetBpm(uint bpm)
    {
        self.bpm = bpm;
    }

    // uses a depth-first search to find the fastest route from current to target.
    // If two routes are of equal length, one of the two is randomly chosen.
    DynamoRoute FindRoute(DynamoBlock current, DynamoBlock target, uint searchDepth) const
    {
        if (current == target) {
            // found what we were looking for
            Route route = New(Route);
            route.Add(current);
            return route;
        }

        if (searchDepth >= blocks.Size()) {
            // stuck in a loop, so go back and retry
            return New(Route);
        }

        uint candidates = 0;
        Route route = New(Route);

        for (int i = 0; i != current.NextBlocks().Size(); ++i)
        {
            DynamoBlock next = current.NextBlocks()[i];
            Route tempRoute = FindRoute(next, target, searchDepth + 1);
            tempRoute.Add(current);

            if (tempRoute.Length() < route.Length()) {
                // found a faster route
                route = tempRoute;
            }
            else if (tempRoute.Length() == route.Length() && Random(0, i++) == 0) {
                // randomly choose one of them
                route = tempRoute;
            }
        }

        return route;
    }
}
