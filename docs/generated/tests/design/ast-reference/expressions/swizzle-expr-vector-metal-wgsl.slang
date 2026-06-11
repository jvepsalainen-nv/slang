//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: doc_section_digest=5cae24401ed06bd3567242934951f344da434f10804637bdd679d55ab6b5bb2b
//META: purpose=A SwizzleExpr `v.zyx` reorders vector components; every text-emit target preserves the swizzle in a target-appropriate form.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Completes the per-target emission fan-out for the SwizzleExpr `.zyx`
// claim that the HLSL/GLSL/SPIR-V sibling left at three targets. Metal
// and WGSL both preserve the member-swizzle syntax `.zyx` rather than
// expanding to a shuffle/constructor, so each CHECK pins the literal
// `.zyx` token on the emitted store. The vector source is a uniform so
// DCE cannot fold the swizzle away before emit.

//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

uniform float3 v;
RWStructuredBuffer<float3> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = v.zyx;
    // METAL: globalParams_{{[0-9]+}}->v_{{[0-9]+}}.zyx
    // WGSL: globalParams_{{[0-9]+}}.v_{{[0-9]+}}.zyx
}
