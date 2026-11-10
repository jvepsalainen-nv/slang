//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=The runtime array inside a StructuredBuffer block carries an ArrayStride decoration matching the element size in bytes.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V requires every runtime-array used in a buffer block to
// have an ArrayStride decoration so the driver can compute
// element addresses. Slang emits ArrayStride 4 for an int array
// (matching the 4-byte int element size).

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x) ^ 15;
}

// CHECK: OpDecorate %_runtimearr_int ArrayStride 4
