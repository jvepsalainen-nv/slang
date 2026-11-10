//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-d-hlsl-emit-and-downstream-tools
//META: purpose=Expansion: emitter spells `*` and `+` binary expressions on uniform operands directly in HLSL text.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The shared C-like emitter writes arithmetic operators with the
// HLSL spelling. Uniform operands force the emitter to keep the
// binary op rather than constant-folding.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

cbuffer Params {
    int a;
    int b;
    int c;
};
RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = a + b * c;
}

// CHECK: +
// CHECK: *
