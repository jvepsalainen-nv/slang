// THIS IS A GENERATED FILE. DO NOT EDIT!
// Generated from examples/metal-texture-capabilities.yaml
//
// Test: metal-textures - texture2dms
// Metal Texture2DMS capability test (disabled due to bug)
//
//DISABLE_TEST:SIMPLE(filecheck=POSITIVE): -entry fragMain -stage fragment -target metal -profile metallib_2_3
// Test disabled, see https://github.com/shader-slang/slang/issues/8457
//DISABLE_TEST(compute):COMPARE_COMPUTE(filecheck-buffer=POSITIVE_RESULT): -mtl
// Test disabled, see https://github.com/shader-slang/slang/issues/8457
//TEST_INPUT: ubuffer(data=[0], stride=4):out,name outputBuffer
RWStructuredBuffer<int> outputBuffer;

//TEST_INPUT: Texture2D(size=4, content=zero, sampleCount=two):name texHandle
Texture2DMS<float4> texHandle;


[shader("fragment")]
void fragMain()
{
    int ret = 0;
    ret = int((texHandle.Load(int3(0, 0, 0))).x);
    outputBuffer[0] = 0x12345 + ret;
}

[numthreads(4, 1, 1)]
void computeMain()
{
    int ret = 0;
    ret = int((texHandle.Load(int3(0, 0, 0))).x);
    outputBuffer[0] = 0x12345 + ret;
}


// POSITIVE: result code = 0

// POSITIVE_RESULT: 12345
