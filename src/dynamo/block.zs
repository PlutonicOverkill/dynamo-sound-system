class DynamoBlock play {
    private bool fill;
    private uint length;
    private Array<String> channels;
    private Array<DynamoBlock> nextBlocks;
    private Array<DynamoBeatCallback> beatCallbacks;

    uint NextBlockCount() const
    {
        return nextBlocks.Size();
    }

    DynamoBlock NextBlock(uint index) const
    {
        return nextBlocks[index];
    }

    void SetFill(bool f)
    {
        fill = f;
    }

    void AddChannel(String chan)
    {
        channels.Push(chan);
    }

    uint ChannelAmount() const
    {
        return channels.size();
    }

    String GetChannel(uint i) const
    {
        return channels[i];
    }

    void SetLength(uint len)
    {
        length = len;
    }

    void AddNextBlock(DynamoBlock next)
    {
        nextBlocks.Push(next);
    }

    bool IsFill() const
    {
        return fill;
    }

    // returns next bar where we can start playing this fill (can include current bar)
    // should be called only at the start of a bar
    uint NextFillBar(DynamoBlock fill, uint barGrouping, uint playBar) const
    {
        uint numBarsToPlay = barGrouping - (fill.GetLength() % barGrouping);

        while (numBarsToPlay > self.GetLength()) {
            barGrouping >>>= 1; // halve bar grouping and try again
            numBarsToPlay = barGrouping - (fill.GetLength() % barGrouping);
        }

        while (numBarsToPlay < playBar) { // missed the cutoff, move it forward
            numBarsToPlay += barGrouping;
        }

        return numBarsToPlay;
    }

    uint FirstFillBar(DynamoBlock fill, uint barGrouping) const
    {
        return NextFillBar(fill, barGrouping, 0);
    }

    bool IsFillBar(DynamoBlock fill, uint barGrouping, uint playBar) const
    {
        return NextFillBar(fill, barGrouping, playBar) == playBar;
    }

    void AddBeatCallback(DynamoBeatCallback cb)
    {
        beatCallbacks.Push(cb);
    }

    void ProcessBeatCallbacks(bool isBeat) const
    {
        for (int i = 0; i != beatCallbacks.size(); ++i) {
            DynamoBeatCallback callback = beatCallbacks[i];

            callback.WorldTick();

            if (isBeat)
                callback.Call();
        }
    }

    // returns length, not including fill (what does this mean???)
    uint GetLength() const
    {
        return length; // TODO FIXME (?)
    }

    static DynamoBlock Create()
    {
        let block = New("DynamoBlock");

        block.fill = false;
        block.length = 1;

        return block;
    }
}
