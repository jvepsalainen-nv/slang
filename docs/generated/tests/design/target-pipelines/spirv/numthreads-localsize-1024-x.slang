//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=[numthreads(1024,1,1)] lowers to OpExecutionMode %main LocalSize 1024 1 1 (upper-edge X dimension typical of compute shaders).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary: the documented Vulkan minimum maxComputeWorkGroupSize
// is (1024,1024,64); 1024 is the typical Slang test upper edge.
// Verifies the literal numthreads(1024,1,1) flows through to
// LocalSize 1024 1 1.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1024, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: OpExecutionMode %main LocalSize 1024 1 1
