//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#parameter-group-constant-buffer-types
//META: doc_section_digest=a62b9719fec7c122df80f8f50c81b7a71a2f4deb2062c135375ac53227244677
//META: purpose=ConstantBufferType<T> with a single-scalar payload (struct of one float) still lowers to HLSL cbuffer at emit; the minimum payload exercises the small edge of the parameter-group machinery.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the single-scalar ConstantBufferType boundary emission claim out
// to the four non-HLSL shader text targets the sibling
// constantbuffertype-single-scalar.slang does not cover. The minimum
// one-field payload still reaches each target's constant-buffer form:
// GLSL a `uniform block_Single`, Metal a `Single_0 constant*` pointer,
// SPIR-V an `OpVariable ... Uniform`, WGSL a `var<uniform>`. Each CHECK
// pins the token that identifies that target's constant-buffer form
// (copied verbatim from slangc output).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

struct Single { float v; }

ConstantBuffer<Single> g_cb;
RWStructuredBuffer<float> g_out;

//GLSL: uniform block_Single
//METAL: Single_0 constant* g_cb
//SPV: %g_cb = OpVariable %_ptr_Uniform_Single_std140 Uniform
//WGSL: var<uniform> g_cb_0 : Single_std140_0
[numthreads(1, 1, 1)]
void main()
{
    g_out[0] = g_cb.v;
}
