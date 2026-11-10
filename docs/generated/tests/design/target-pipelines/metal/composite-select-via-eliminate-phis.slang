//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/metal.md#eliminatephis-with-default-options
//META: purpose=A struct-valued conditional lowers to an if/else assigning a local of the struct type even though the HLSL-only `legalizeNonVectorCompositeSelect` pass does not run for Metal.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that Metal reaches the same emitted shape as HLSL for a
// non-vector composite select by a different route: the HLSL-only
// select-legalization pass is filtered out, but default phi elimination
// already turns the merged struct value into per-branch writes to a local.
// CHECK asserts a local of the struct type is declared and that an
// if/else pair follows, rather than a ternary over whole structs.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage compute

struct Vec
{
    float4 v;
};

RWStructuredBuffer<float4> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    Vec a;
    a.v = float4(1, 0, 0, 1);
    Vec b;
    b.v = float4(0, 1, 0, 1);
    Vec c = (tid.x > 0u) ? a : b;
    outBuf[tid.x] = c.v;
}

// CHECK: Vec_{{[0-9]+}} c_{{[0-9]+}};
// CHECK: if(
// CHECK: else
