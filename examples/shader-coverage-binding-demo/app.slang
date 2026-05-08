import math;
import physics;

RWStructuredBuffer<uint> outBuffer;

static const uint kItemCount = 100000u;

[shader("compute")]
[numthreads(64, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint i = tid.x;
    if (i >= kItemCount)
        return;

    uint integrated = integrateMotion(i, 17u);
    uint material = applyMaterial(integrated, i);
    outBuffer[i] = finalizeEnergy(material, i);
}
