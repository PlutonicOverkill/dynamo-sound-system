class DynamoUtil {
    // https://stackoverflow.com/a/3407254
    static int RoundUp(int numToRound, int multiple)
    {
        if (multiple == 0)
            return numToRound;

        int remainder = Abs(numToRound) % multiple;
        if (remainder == 0)
            return numToRound;

        if (numToRound < 0)
            return -(Abs(numToRound) - remainder);
        else
            return numToRound + multiple - remainder;
    }
}