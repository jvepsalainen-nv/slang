import math;

public uint integrateMotion(uint x, uint frame)
{
    uint scaled = scaleByFactor(x + 1u, (frame % 5u) + 1u);
    uint adjusted = scaled;

    if ((x % 11u) == 0u)
    {
        adjusted += 19u;
    }
    else if ((x % 7u) == 0u)
    {
        adjusted += 7u;
    }
    else if ((x % 3u) == 0u)
    {
        adjusted += 3u;
    }

    return softenBurst(adjusted, x);
}

public uint applyMaterial(uint value, uint lane)
{
    uint shaded = value;

    if ((lane & 1u) == 0u)
        shaded += 2u;
    else
        shaded += 1u;

    uint materialBucket = lane % 5u;
    if (materialBucket == 0u)
    {
        shaded /= 2u + (lane % 3u);
    }
    else if (materialBucket == 1u)
    {
        shaded += 5u;
    }
    else if (materialBucket == 2u)
    {
        shaded += 11u;
    }
    else if (materialBucket == 3u)
    {
        shaded += 17u;
    }
    else
    {
        shaded += 23u;
    }

    return clampToRange(shaded, 400000u);
}
