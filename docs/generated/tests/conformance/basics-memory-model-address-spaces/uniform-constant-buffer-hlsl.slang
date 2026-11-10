//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: purpose=`ConstantBuffer<T>` belongs to the Uniform address space; HLSL emits it as a `cbuffer` bound to a `b` register.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `ConstantBuffer<T>` belongs to the Uniform address space on HLSL.
// The shader reads two fields from the buffer; CHECK asserts the emitted HLSL declares a
// `cbuffer` bound to a `b` register, confirming the all-threads, constant-over-dispatch
// semantics produce the expected HLSL register class.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry computeMain -stage compute

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

// CHECK: cbuffer
// CHECK-DAG: register(b
// Metal maps ConstantBuffer to a constant* pointer parameter (constant address space).
// METAL: constant* cb_
// WGSL maps ConstantBuffer to var<uniform>.
// WGSL: var<uniform> cb_
// GLSL emits the Uniform address space as a std140 uniform block.
// GLSL: layout(std140) uniform block_Params_
// GLSL: }cb_
// SPIRV emits the same variable with the Uniform storage class.
// SPIRV: %cb = OpVariable {{.*}} Uniform
