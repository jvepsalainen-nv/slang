//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:00:00Z
//META: source_commit=ed8f508fc647eecd788a4bd2bb63a4a6f5c80246
//META: doc_ref=docs/generated/design/ast-reference/values.md#modifier-values
//META: doc_section_digest=4364bf363a9056edbfcf69ad936b2e8f4e1ebe8e3f8cb1be0e64a5bc9da138b1
//META: purpose=UNormModifierVal is the type-level ModifierVal for an unorm resource-format modifier; a `Texture2D<unorm float4>` declaration preserves the unorm modifier through to the emitted HLSL surface.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the `unorm` resource-format modifier on a `Texture2D<unorm float4>`
// survives lowering on the SPIR-V back-end. SPIR-V has no `unorm` keyword; the
// modifier instead selects the image's format operand. The CHECK pins the
// OpTypeImage line to the `Rgba8` (unorm) format token — a plain
// `Texture2D<float4>` emits `Unknown` there, so observing `Rgba8` proves the
// modifier was carried through to emit.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -stage compute -entry main

[[vk::binding(0, 0)]]
Texture2D<unorm float4> tex;

[[vk::binding(1, 0)]]
RWStructuredBuffer<float4> outBuf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = tex.Load(int3(0, 0, 0));
}

// CHECK: OpTypeImage %{{[a-z0-9]+}} 2D 2 0 0 1 Rgba8
