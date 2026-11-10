//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A uint to int integer reinterpret cast emits an OpBitcast in the SPIR-V module.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SV_DispatchThreadID exposes uint3; storing one of its components
// into an int buffer requires a same-size reinterpret cast.
// SPIR-V emits OpBitcast %int %uintValue. lowerBitCast is gated on
// reqSet.bitcast and runs before Phase D emit.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = asint(tid.x + 1u);
}

// CHECK: OpBitcast %int %{{[a-zA-Z_0-9]+}}
