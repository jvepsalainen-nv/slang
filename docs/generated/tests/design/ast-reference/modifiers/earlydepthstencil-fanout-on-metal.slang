//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:04:52Z
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#stage-specific-entry-point-attributes
//META: doc_section_digest=c70214a3d38c8f47b31dbc3940b51ba5fcdeb6d61435076d7a051fbb6e018f86
//META: purpose=`EarlyDepthStencilAttribute` (`[earlydepthstencil]`) on a fragment entry point survives to emitted HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `[earlydepthstencil]` claim onto Metal. The attribute lowers
// to Metal's `[[early_fragment_tests]]` function qualifier on the fragment
// entry point; CHECK pins the bare `early_fragment_tests` token (the `[[ ]]`
// brackets are a FileCheck variable reference and cannot be matched literally),
// proving the attribute reaches the emitted Metal entry-point signature.

//TEST:SIMPLE(filecheck=CHECK):-target metal -entry main -stage fragment

[earlydepthstencil]
float4 main(float4 pos : SV_Position) : SV_Target
{
    return float4(pos.x, pos.y, 0.0f, 1.0f);
}

//CHECK: early_fragment_tests
