//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/types.md#parameter-group-constant-buffer-types
//META: doc_section_digest=a62b9719fec7c122df80f8f50c81b7a71a2f4deb2062c135375ac53227244677
//META: purpose=A ConstantBufferType<T> uniform is the AST type for HLSL `cbuffer`; the HLSL emit renders it as the `cbuffer` keyword.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the ConstantBuffer<T> emission claim out to the four non-HLSL
// shader text targets the sibling constantbuffertype-hlsl-emit.slang
// does not cover. ConstantBufferType is a UniformParameterGroupType
// leaf, and its emitted *shape* differs per target: GLSL renders a
// `uniform block_*` interface block, Metal a `constant*` pointer
// parameter, SPIR-V an `OpVariable ... Uniform`, and WGSL a
// `var<uniform>`. Each CHECK pins the token that identifies that
// target's constant-buffer form (copied verbatim from slangc output).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

struct Params { float scale; int count; }

ConstantBuffer<Params> g_cb;
RWStructuredBuffer<float> g_out;

//GLSL: uniform block_Params
//METAL: Params{{.*}} constant* g_cb
//SPV: %g_cb = OpVariable %_ptr_Uniform_Params_std140 Uniform
//WGSL: var<uniform> g_cb_0 : Params_std140_0
[numthreads(1, 1, 1)]
void main()
{
    g_out[0] = g_cb.scale * float(g_cb.count);
}
