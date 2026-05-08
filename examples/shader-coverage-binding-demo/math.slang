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

public uint softenBurst(uint value, uint lane)
{
    uint softened = value;
    uint burstBucket = lane % 4u;

    if (burstBucket == 0u)
    {
        softened += 13u;
    }
    else if (burstBucket == 1u)
    {
        softened += 3u;
    }
    else if (burstBucket == 2u)
    {
        softened += lane % 9u;
    }
    else
    {
        softened += lane % 5u;
    }

    if ((lane % 13u) == 0u)
        softened += 29u;

    return softened;
}

public uint finalizeEnergy(uint value, uint lane)
{
    uint finalized = value;

    if ((lane % 8u) == 0u)
    {
        finalized += 31u;
    }
    else if ((lane % 8u) < 3u)
    {
        finalized += 9u;
    }
    else
    {
        finalized += 4u;
    }

    if ((lane % 10u) == 0u)
        finalized /= 2u;
    else if ((lane % 9u) == 0u)
        finalized += 27u;

    return clampToRange(finalized, 500000u);
}
