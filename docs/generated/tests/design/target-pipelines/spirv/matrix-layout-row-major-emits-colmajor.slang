//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/spirv.md#option-set-toggles
//META: purpose=A row-major source matrix layout emits the transposed SPIR-V member decoration `ColMajor`, because what SPIR-V calls columns are what Slang calls rows.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the transposition between the source-level matrix layout and the
// emitted SPIR-V member decoration. The layout only reaches the decoration
// through a uniform-block member, so the matrix is placed in a
// ConstantBuffer and multiplied into a buffer write to keep it live. The
// CHECK pins ColMajor on the member even though the compile requested
// row-major, which is the whole point of the claim -- the naive expectation
// would be RowMajor.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage compute -matrix-layout-row-major

struct M { float4x4 m; };
ConstantBuffer<M> cb;
RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = mul(cb.m, float4(1, 2, 3, 4));
}

// CHECK-DAG: OpMemberDecorate {{%[a-zA-Z_0-9]+}} 0 ColMajor
// CHECK-DAG: OpMemberDecorate {{%[a-zA-Z_0-9]+}} 0 MatrixStride 16
