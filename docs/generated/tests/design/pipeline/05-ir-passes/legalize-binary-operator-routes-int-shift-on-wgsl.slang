//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#type-and-value-legalization
//META: purpose=The legalize-binary-operator pass adjusts a shift's RHS so it matches the target's signedness rules — on WGSL the shift count is a `u32`.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "Legalize binary operator" row of the type-and-value
// legalization table (`slang-ir-legalize-binary-operator.cpp`)
// performs per-target binary-op legalization. WGSL requires the
// shift count to be `u32`; the emit shows a cast / conversion of
// the shift amount to the unsigned type.

//TEST:SIMPLE(filecheck=WGSL):-target wgsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;
uniform int a;
uniform int n;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = a << n;
}

// WGSL: fn main
// WGSL: u32(
