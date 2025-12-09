// THIS IS A GENERATED FILE. DO NOT EDIT!
// Generated from examples/metal-texture-capabilities.yaml
//
// Test: metal-textures - rwtexture2d
// Metal RWTexture2D capability test
//
//TEST:SIMPLE(filecheck=POSITIVE): -entry fragMain -stage fragment -target metal -profile metallib_2_3
//TEST(compute):COMPARE_COMPUTE(filecheck-buffer=POSITIVE_RESULT): -slang -shaderobj -mtl
//TEST_INPUT: ubuffer(data=[0], stride=4):out,name outputBuffer
RWStructuredBuffer<int> outputBuffer;

//TEST_INPUT: RWTexture2D(size=4, content=zero):name texHandle
RWTexture2D<float4> texHandle;


[shader("fragment")]
void fragMain()
{
    int ret = 0;
    ret = int((texHandle.Load(int2(0, 0))).x);
    outputBuffer[0] = 0x12345 + ret;
}

[numthreads(4, 1, 1)]
void computeMain()
{
    int ret = 0;
    ret = int((texHandle.Load(int2(0, 0))).x);
    outputBuffer[0] = 0x12345 + ret;
}


// POSITIVE: result code = 0

// POSITIVE_RESULT: 12345
