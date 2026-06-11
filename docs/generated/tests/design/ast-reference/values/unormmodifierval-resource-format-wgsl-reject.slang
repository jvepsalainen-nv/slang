//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00Z
//META: source_commit=ed8f508fc647eecd788a4bd2bb63a4a6f5c80246
//META: doc_ref=docs/generated/design/ast-reference/values.md#modifier-values
//META: doc_section_digest=4364bf363a9056edbfcf69ad936b2e8f4e1ebe8e3f8cb1be0e64a5bc9da138b1
//META: purpose=UNormModifierVal is the type-level ModifierVal for an unorm resource-format modifier; a `Texture2D<unorm float4>` declaration preserves the unorm modifier through to the emitted HLSL surface.
//META: intent=negative
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the WGSL back-end cannot express a `Texture2D<unorm float4>`. WGSL
// textures admit only f32/i32/u32 sampled types, so fetching from the
// unorm-formatted texture trips a static assertion in the core module during
// WGSL legalization. The CHECK pins the exact diagnostic code E41400 and its
// message text, confirming the modifier-bearing texture is rejected (not
// silently dropped) on WGSL.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target wgsl -stage compute -entry main

[[vk::binding(0, 0)]]
Texture2D<unorm float4> tex;

[[vk::binding(1, 0)]]
RWStructuredBuffer<float4> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = tex.Load(int3(0, 0, 0));
}

// CHECK-DAG: error[E41400]
// CHECK-DAG: WGSL supports only f32/i32/u32 type textures
