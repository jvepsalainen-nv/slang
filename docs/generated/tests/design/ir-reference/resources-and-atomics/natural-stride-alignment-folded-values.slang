//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#getnaturalstride-and-getnaturalalignment
//META: purpose=Peephole folds both opcodes to literals before emit: `float4` has stride 16 and alignment 16, `float2` and `half4` have alignment 8, and `float3` has stride 12 but alignment 4 because 12 is not a power of two.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the worked values the natural-layout note gives, including
// the `float3` case where stride and alignment disagree. The results are
// written to an output buffer, so the CPU compute run reads the folded
// values back and the per-target emission directives show the same
// integers already baked into the generated source — evidence that
// neither opcode survives to emit.

//TEST:COMPARE_COMPUTE(filecheck-buffer=BUF):-cpu -output-using-type
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry computeMain -stage compute

//TEST_INPUT:ubuffer(data=[0 0 0 0 0 0], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    outputBuffer[0] = __naturalStrideOf<float4>();
    outputBuffer[1] = __naturalAlignmentOf<float4>();
    outputBuffer[2] = __naturalAlignmentOf<float2>();
    outputBuffer[3] = __naturalAlignmentOf<half4>();
    outputBuffer[4] = __naturalStrideOf<float3>();
    outputBuffer[5] = __naturalAlignmentOf<float3>();
}

// BUF: 16
// BUF-NEXT: 16
// BUF-NEXT: 8
// BUF-NEXT: 8
// BUF-NEXT: 12
// BUF-NEXT: 4

// HLSL-DAG: int(16)
// HLSL-DAG: int(12)
// HLSL-DAG: int(4)
// GLSL-DAG: 16
// GLSL-DAG: 12
// SPV-DAG: %int_16
// SPV-DAG: %int_12
// METAL-DAG: 16
// METAL-DAG: 12
// WGSL-DAG: 16
// WGSL-DAG: 12
// CUDA-DAG: 16
// CUDA-DAG: 12
// CPP-DAG: 16
// CPP-DAG: 12
