import math;
import physics;

RWStructuredBuffer<uint> outBuffer;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint i = tid.x;
    uint stepped = computeStep(i, 5);
    uint damped = applyDamping(stepped, 2);
    outBuffer[i] = damped;
}
