class DynamoBlock {
    private bool isFill = false;
    private uint length = 1;
    private Array<String> channels;
    private Array<DynamoBlockHandle> nextBlocks;

    uint NextBlockCount() const
    {
        return nextBlocks.Size();
    }

    DynamoBlock NextBlock(uint index) const
    {
        return nextBlocks[index];
    }

    void SetFill(bool fill)
    {
        isFill = fill;
    }

    void AddChannel(String chan)
    {
        channels.Push(chan);
    }

    void SetLength(uint len)
    {
        length = len;
    }

    void AddNextBlock(DynamoBlockHandle next)
    {
        nextBlocks.Push(next);
    }

    bool IsFill() const
    {
        return isFill;
    }

    // returns length, not including fill
    uint Length() const
    {

    }

    static DynamoBlock Create()
    {
        let block = New("DynamoBlock";)
        //
        return block;
    }
}
