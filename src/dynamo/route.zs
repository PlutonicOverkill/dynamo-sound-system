class DynamoRoute {
    uint Length() const
    {

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

    }

    private Array<DynamoBlock> blocks;
}
