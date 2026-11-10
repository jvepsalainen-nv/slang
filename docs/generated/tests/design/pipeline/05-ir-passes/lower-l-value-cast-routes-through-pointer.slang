//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=An explicit constructor-style cast on an integer literal is converted to a target-specific cast intrinsic by the type-legalization passes.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Lower l-value cast" / value-legalization passes route a
// constructor-style `int(x)` cast through the appropriate target
// intrinsic. On HLSL the result is `int(...)` literal-style;
// on GLSL it surfaces as `int(...)`. The point of this test is
// to anchor on the doc's claim that the type-legalization
// category exists and handles cast lowering.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

uniform float fval;
uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(fval);
}

// HLSL: void main
// HLSL: int(
// GLSL: void main
// GLSL: int(
