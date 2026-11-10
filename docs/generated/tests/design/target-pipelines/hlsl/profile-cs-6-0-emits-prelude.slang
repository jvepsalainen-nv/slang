//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Boundary: an explicit cs_6_0 (lowest documented SM 6.x compute profile) still emits the canonical HLSL prelude pack_matrix(column_major).
//META: intent=boundary
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: profile lower edge — `-profile cs_6_0` is the
// lowest shader-model-6 compute profile. The emitter still
// writes the standard prelude.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -profile cs_6_0

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CHECK: #pragma pack_matrix(column_major)
