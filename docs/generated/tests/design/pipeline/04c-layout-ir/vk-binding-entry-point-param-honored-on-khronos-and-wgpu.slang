//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#explicit-vkbinding-on-entry-point-parameters
//META: purpose=An explicit vk::binding on an entry-point parameter is honored on the Khronos targets (SPIR-V, GLSL) and on WGSL.
//META: intent=functional
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the binding/set requested on an entry-point *parameter* is
// actually placed on the targets whose gate accepts it. The parameter asks
// for binding 3 in set 1 while the module-scope `outBuf` takes the default
// slot; each prefix asserts the emitted resource declaration carries 3/1
// rather than a positionally defaulted slot.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main([[vk::binding(3, 1)]] uniform StructuredBuffer<int> inBuf)
{
    outBuf[0] = inBuf[0];
}

// SPV-DAG: OpDecorate %entryPointParams_inBuf{{[A-Za-z0-9_]*}} Binding 3
// SPV-DAG: OpDecorate %entryPointParams_inBuf{{[A-Za-z0-9_]*}} DescriptorSet 1

// GLSL-DAG: binding = 3, set = 1

// WGSL-DAG: @binding(3) @group(1)
