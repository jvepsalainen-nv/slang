//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#phase-c-hlsl-legalization-lowering-phi-elimination
//META: purpose=Boundary: a scalar `||` with a side-effecting RHS is lowered into an explicit if/else, preserving short-circuit semantics in the emitted HLSL.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: legalizeLogicalAndOr applied to `||`. DXC
// short-circuits `||` on scalars; Slang's IR rewrite makes the
// short-circuit observable as an if/else in the emitted text.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

int sideEffect(int x)
{
    outBuf[200] = x;
    return x;
}

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    bool b = (tid.x == 0) || (sideEffect(int(tid.x)) > 0);
    outBuf[tid.x] = b ? 1 : 0;
}

// CHECK: if(
// CHECK: sideEffect_{{[0-9]+}}(
// CHECK: else
