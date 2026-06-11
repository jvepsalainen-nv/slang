//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/ast-reference/types.md#parameter-group-constant-buffer-types
//META: doc_section_digest=a62b9719fec7c122df80f8f50c81b7a71a2f4deb2062c135375ac53227244677
//META: purpose=ParameterBlockType<T> with a struct-of-arrays payload still lowers through the parameter-group machinery to a cbuffer-like HLSL block.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fans the struct-of-arrays ParameterBlockType boundary emission claim
// out to the four non-HLSL shader text targets the sibling
// parameterblocktype-struct-of-arrays.slang does not cover. The
// fixed-size-array payload still lowers through the parameter-group
// machinery to each target's constant-buffer form: GLSL a `uniform
// block_SoA`, Metal a `SoA_default_0 constant*` pointer, SPIR-V an
// `OpVariable ... Uniform`, WGSL a `var<uniform>`. Each CHECK pins the
// token that identifies that target's parameter-block form (copied
// verbatim from slangc output).

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

struct SoA { float values[4]; int counts[4]; }

ParameterBlock<SoA> g_pb;
RWStructuredBuffer<float> g_out;

//GLSL: uniform block_SoA
//METAL: SoA_default_0 constant* g_pb
//SPV: %g_pb = OpVariable %_ptr_Uniform_SoA_std140 Uniform
//WGSL: var<uniform> g_pb_0 : SoA_std140_0
[numthreads(1, 1, 1)]
void main()
{
    g_out[0] = g_pb.values[0] + float(g_pb.counts[0]);
}
