//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/04c-layout-ir.md#explicit-vkbinding-on-entry-point-parameters
//META: purpose=One entry point can mix an explicitly vk::binding-bound parameter with an implicitly bound one; the explicit reservation is kept and the implicit parameter is allocated around it.
//META: intent=boundary
//META: pipeline_stage=layout
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the per-parameter completion path: the explicit reservation must
// survive completion while the neighbouring implicit parameter still gets a
// real allocated binding from the global pool. CHECK asserts the explicit
// parameter keeps 9/2 and the implicit one lands at binding 1 of set 0,
// i.e. after the module-scope outBuf rather than at a field-relative offset.

//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void main(
    [[vk::binding(9, 2)]] uniform StructuredBuffer<int> explicitBuf,
    uniform StructuredBuffer<int> implicitBuf)
{
    outBuf[0] = explicitBuf[0] + implicitBuf[0];
}

// SPV-DAG: OpDecorate %entryPointParams_explicitBuf{{[A-Za-z0-9_]*}} Binding 9
// SPV-DAG: OpDecorate %entryPointParams_explicitBuf{{[A-Za-z0-9_]*}} DescriptorSet 2
// SPV-DAG: OpDecorate %entryPointParams_implicitBuf{{[A-Za-z0-9_]*}} Binding 1
// SPV-DAG: OpDecorate %entryPointParams_implicitBuf{{[A-Za-z0-9_]*}} DescriptorSet 0
