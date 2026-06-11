//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T09:43:32Z
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#interpolation-modes
//META: doc_section_digest=56ca9a126bcfd98630fa52ffd0fc6f78b7bc23d5faf39fecb7d0bfc4e9576da6
//META: purpose=`sample` interpolation modifier is preserved through emitted HLSL.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the `sample` per-sample-interpolation claim onto SPIR-V. The
// modifier lowers to a `Sample` decoration on the input variable; CHECK pins
// the `OpDecorate ... Sample` line, proving the per-sample mode is preserved
// through SPIR-V codegen.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry main -stage fragment

struct VsOut
{
    float4 pos              : SV_Position;
    sample float4 perSample : COLOR0;
};

float4 main(VsOut v) : SV_Target
{
    return v.perSample;
}

//CHECK: OpDecorate %v_perSample Sample
