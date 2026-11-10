//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#layout-and-binding
//META: purpose=Expansion (boundary): the string-hash pass produces a numeric constant for `getStringHash("")` (empty input) — the empty string literal does not survive in the HLSL emit.
//META: intent=expansion
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary axis on string-hash: the empty string. The pass still
// replaces the intrinsic with a numeric hash value; no
// `getStringHash` call remains and the empty literal `""` does not
// leak.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = getStringHash("");
}

// HLSL: void main
// HLSL-NOT: getStringHash
