//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Expansion: bitwise & / | / ^ on uniform integer operands emit as the HLSL spellings.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// HLSL accepts the same bitwise operator spellings as C. The
// shared CLikeSourceEmitter passes them through unchanged.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

cbuffer Params {
    uint a;
    uint b;
    uint c;
};
RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    uint x = (a & b) | (a ^ c);
    outBuf[tid.x] = x;
}

// CHECK-DAG: &
// CHECK-DAG: |
// CHECK-DAG: ^
