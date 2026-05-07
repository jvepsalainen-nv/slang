import math;

public uint computeStep(uint x, uint frame)
{
    uint accelerated = scaleByFactor(x, frame + 1);
    if (accelerated > 1000)
    {
        return 1000;
    }
    return accelerated;
}

public uint applyDamping(uint value, uint factor)
{
    return clampToRange(value / factor, 500);
}
