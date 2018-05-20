class DynamoBlock {
    Array<DynamoBlock> NextBlocks() const
    {
        return New(Array<DynamoBlock>);
    }
}
