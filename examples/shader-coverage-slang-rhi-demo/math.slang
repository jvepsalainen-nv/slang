public uint scaleByFactor(uint value, uint factor)
{
    if (factor == 0)
    {
        return 0;
    }
    return value * factor;
}

public uint clampToRange(uint value, uint maxValue)
{
    if (value > maxValue)
        return maxValue;
    return value;
}
