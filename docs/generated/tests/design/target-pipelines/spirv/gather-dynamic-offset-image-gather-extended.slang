//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#capabilities-and-extensions-decided-at-emit-time
//META: purpose=A Gather with a runtime-computed offset falls through to the Offset image operand and requests OpCapability ImageGatherExtended.
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the dynamic half of the same emit-time decision: only a
// non-constant offset needs the extended-gather capability. The offset is
// derived from the dispatch thread id so the emitter cannot recognize it as a
// constant; CHECK asserts both that OpCapability ImageGatherExtended is
// declared and that the gather uses the plain Offset operand rather than
// ConstOffset.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

Texture2D<float4> tex;
SamplerState samp;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int2 off = int2(tid.xy);
    outBuf[tid.x] = tex.GatherRed(samp, float2(0.5, 0.5), off);
}

// CHECK-DAG: OpCapability ImageGatherExtended
// CHECK-DAG: OpImageGather {{.*}} Offset %{{[a-zA-Z_0-9]+}}
