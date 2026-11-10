//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=The lower-buffer-element-type pass renders the element type of an `RWStructuredBuffer<int>` as `int` in the GLSL SSBO and `int` in the HLSL register declaration.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Lower buffer element type" row of the type-and-value
// legalization table (`slang-ir-lower-buffer-element-type.cpp`)
// renders the buffer's element type as a target-native scalar
// type. On GLSL the SSBO carries `int _data[]`; on HLSL the
// declaration is `RWStructuredBuffer<int >`.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main
//TEST:SIMPLE(filecheck=GLSL):-target glsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = 1;
}

// HLSL: RWStructuredBuffer<int
// GLSL: int _data[
