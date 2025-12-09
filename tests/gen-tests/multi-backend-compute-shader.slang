//TEST_INPUT: ubuffer(data=[0 0 0 0], stride=4):out,name outputBuffer
RWStructuredBuffer<int> outputBuffer;

[numthreads(4, 1, 1)]
void computeMain(uint3 tid: SV_DispatchThreadID)
{
    int index = tid.x;
    
    // Each thread writes to its own buffer element
    // Thread 0: writes 1, Thread 1: writes 2, Thread 2: writes 3, Thread 3: writes 4
    outputBuffer[index] = index + 1;
}

