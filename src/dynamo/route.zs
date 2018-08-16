class DynamoRoute {
    private Array<DynamoBlock> blocks;
    private uint len;
    // blocks[0] is target block and blocks[size-1] is next block to change to

    DynamoBlock Next()
    {
        uint size = blocks.Size();

        DynamoBlock next = size ? blocks[size - 1] : null;

        blocks.Pop();
        return next;
    }

    DynamoBlock Top() const
    {
        uint size = blocks.Size();

        return size ? blocks[size - 1] : null;
    }

    bool IsEmpty() const
    {
        return !blocks.Size();
    }

    // WARNING : if you use Next() to pop off the next blocks the length won't be updated properly.
    // currently this shouldn't affect anything (?) but don't call this after using Next()...
    uint Length() const
    {
        return len;
    }

    void Add(DynamoBlock block, uint barGrouping, uint playBar = 0)
    {
        uint size = blocks.Size();
        DynamoBlock prev = size ? blocks[size - 1] : null;
        bool prevFill = prev ? prev.IsFill() : false;

        blocks.Push(block);

        if (block.IsFill()) {
            len += block.GetLength();
        }
        else {
            if (prevFill) {
                len += block.NextFillBar(prev, barGrouping, playBar);
            }
            else {
                len += block.GetLength();
            }
        }
    }

    DynamoBlock GetTarget() const
    {
        uint size = blocks.Size();

        return size ? blocks[0] : null;
    }

    static DynamoRoute Create(DynamoBlock block, uint barGrouping)
    {
        DynamoRoute route = New("DynamoRoute");
        route.Add(block, barGrouping);
        route.len = block.GetLength();
        return route;
    }
}
