//TEST_INPUT: ubuffer(data=[0], stride=4):out,name outputBuffer
RWStructuredBuffer<int> outputBuffer;

{{TEXTURE_INPUT}}

[shader("fragment")]
void fragMain()
{
    int ret = 0;
    {{TEXTURE_OP}}
    outputBuffer[0] = 0x12345 + ret;
}

[numthreads(4, 1, 1)]
void computeMain()
{
    int ret = 0;
    {{TEXTURE_OP}}
    outputBuffer[0] = 0x12345 + ret;
}
