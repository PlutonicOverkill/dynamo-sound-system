class DynamoBlock {
    uint NextBlockCount() const
    {
        return 0; // TEMP
    }

    DynamoBlock NextBlock(uint index) const
    {
        return New("DynamoBlock"); // TEMP
    }

    bool IsFill() const
    {
        return true; // TEMP
    }

    // returns length, not including fill
    uint Length() const
    {
        return 0; // TEMP
    }
}
