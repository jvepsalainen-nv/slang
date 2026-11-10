//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/hlsl.md#wrapstructuredbuffersofmatrices
//META: purpose=Boundary: a StructuredBuffer<float> with a scalar (non-matrix) element type does NOT trigger the wrapper-struct rewrite.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis: paired counter-test to wrap-structured-buffer-of-matrix —
// `wrapStructuredBuffersOfMatrices` only fires when the element
// type is a matrix. A scalar `float` element passes through
// unwrapped.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

StructuredBuffer<float> inBuf;
RWStructuredBuffer<float> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = inBuf[tid.x] * 2.0;
}

// CHECK: StructuredBuffer<float{{.*}}> inBuf_{{[0-9]+}} : register(t{{[0-9]+}})
