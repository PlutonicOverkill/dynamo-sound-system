class DynamoRoute {
    uint Length() const
    {
        return 0; // temp
    }

    void Add(DynamoBlock block)
    {
        blocks.Push(block);
    }

    static DynamoRoute Create(DynamoBlock block)
    {
        DynamoRoute route = New("DynamoRoute");
        route.Add(block);
        return route;
    }

    int Compare(DynamoRoute other) const
    {
        return 0; // TEMP
    }

    private Array<DynamoBlock> blocks;
}
