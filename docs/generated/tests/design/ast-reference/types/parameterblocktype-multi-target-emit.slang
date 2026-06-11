//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=4a91b58b87e4619ffd76f313e7ae2164d1bd288a
//META: doc_ref=docs/generated/design/ast-reference/types.md#parameter-group-constant-buffer-types
//META: doc_section_digest=a62b9719fec7c122df80f8f50c81b7a71a2f4deb2062c135375ac53227244677
//META: purpose=A ParameterBlockType<T> uniform is the AST type for `ParameterBlock<T>`; the HLSL backend lowers it through the parameter-group machinery to a cbuffer block of T's fields.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the ParameterBlock<T> emission claim out to the four non-HLSL
// shader text targets. ParameterBlockType shares the
// UniformParameterGroupType machinery with ConstantBuffer, so each
// target wraps T's fields in a uniform block, but a parameter block is
// additionally placed in its *own* descriptor set/space. The CHECKs pin
// both the uniform-block shape and the distinct binding space: GLSL
// emits `uniform block_Frame` at `set = 1`, SPIR-V an `OpVariable ...
// Uniform` at `DescriptorSet 1`, WGSL `var<uniform>` at `@group(1)`,
// and Metal a `constant*` pointer parameter. Copied verbatim from
// slangc.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

struct Frame { float time; int frameIndex; }

ParameterBlock<Frame> g_frame;
RWStructuredBuffer<float> g_out;

//GLSL-DAG: uniform block_Frame
//GLSL-DAG: set = 1
//METAL: Frame{{.*}} constant* g_frame
//SPV-DAG: %g_frame = OpVariable %_ptr_Uniform_Frame_std140 Uniform
//SPV-DAG: OpDecorate %g_frame DescriptorSet 1
//WGSL: @group(1) var<uniform> g_frame
[numthreads(1, 1, 1)]
void main()
{
    g_out[0] = g_frame.time * float(g_frame.frameIndex);
}
