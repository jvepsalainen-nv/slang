//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#layout-and-binding
//META: purpose=The layout pass adds resource binding decorations; the SPIR-V emit carries explicit `Binding N` / `DescriptorSet 0` decorations for each declared resource.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `slang-ir-layout.cpp` computes IR-level layout for resources.
// The SPIR-V emit reports each resource with `OpDecorate ... Binding`
// and `OpDecorate ... DescriptorSet 0` decorations.

//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -stage compute -entry main

uniform RWStructuredBuffer<int> buf0;
uniform RWStructuredBuffer<int> buf1;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf0[0] = 1;
    buf1[0] = 2;
}

// SPIRV: OpDecorate {{.*}} Binding
// SPIRV: OpDecorate {{.*}} DescriptorSet
