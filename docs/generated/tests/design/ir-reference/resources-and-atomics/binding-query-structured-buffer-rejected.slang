//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#resource-queries-and-modifiers
//META: purpose=Passing a `StructuredBuffer` to `__getRegisterIndex` is a type error (`E30019`) because the query is declared only for `_Texture` and `SamplerState`.
//META: intent=boundary
//META: pipeline_stage=lower
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The doc says the register queries accept only two resource kinds, so
// any other resource is a type mismatch rather than an unsupported query.

//TEST:SIMPLE(filecheck=DIAG,exit-code=-1):-target hlsl -stage compute -entry main

RWStructuredBuffer<uint> outBuf;
StructuredBuffer<uint> sb;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = __getRegisterIndex(sb);
}

// DIAG: E30019
