//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#phase-d-ir-to-spir-v-emit-simplification-loop-downstream-tools
//META: purpose=A groupshared module-scope array lowers to a Workgroup storage class OpVariable in SPIR-V.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// SPIR-V's Workgroup storage class corresponds to HLSL
// groupshared / GLSL shared. Slang's emit places the variable
// in Workgroup-storage with a pointer type to match.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute

groupshared int sharedMem[64];
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(64, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID, uint gi : SV_GroupIndex)
{
    sharedMem[gi] = int(tid.x);
    GroupMemoryBarrierWithGroupSync();
    outBuf[tid.x] = sharedMem[(gi + 1) % 64];
}

// CHECK: %sharedMem = OpVariable %{{[a-zA-Z_0-9]+}} Workgroup
