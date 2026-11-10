//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#linking-and-validation
//META: purpose=Boundary: the same one-row matrix that `validateVectorsAndMatrices` rejects elsewhere is accepted on HLSL, because the check is evaluated against the target's own matrix limits.
//META: intent=boundary
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the late vector / matrix validation is target-relative
// rather than absolute — the contrast case to the GLSL / SPIR-V
// rejection. The identical `matrix<float, 1, 3>` uniform compiles on
// HLSL and the CHECK asserts the native `float1x3` spelling reaches the
// emit, which can only happen if the check accepted the shape.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<float> buf;
uniform matrix<float, 1, 3> gM;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = gM[0][int(tid.x) % 3];
}

// HLSL: float1x3 gM_{{[0-9]+}};
// HLSL-NOT: matrices with 1 column or row
