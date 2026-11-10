//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=`ConstantBuffer<T>` belongs to the Uniform address space; SPIRV emits the variable with `Uniform` storage class.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `ConstantBuffer<T>` belongs to the Uniform address space in SPIRV.
// The shader reads `scale` and `offset` from the buffer and writes the sum to an output so
// the resource is not DCE'd; CHECK asserts the SPIRV assembly contains an
// `OpVariable ... Uniform`, confirming the Uniform address-space-to-storage-class mapping.

//TEST:SIMPLE(filecheck=CHECK):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

struct Params {
    float scale;
    int   offset;
};

ConstantBuffer<Params> cb;

[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<float> output)
{
    output[0] = cb.scale + float(cb.offset);
}

// CHECK: OpVariable {{.*}} Uniform
// Metal maps ConstantBuffer to constant address space pointer.
// METAL: constant* cb_
// WGSL maps ConstantBuffer to var<uniform>.
// WGSL: var<uniform> cb_
// GLSL emits the Uniform address space as a std140 uniform block.
// GLSL: layout(std140) uniform block_Params_
// GLSL: }cb_
// HLSL emits it as a cbuffer on a `b` register.
// HLSL: cbuffer cb_{{.*}} : register(b
