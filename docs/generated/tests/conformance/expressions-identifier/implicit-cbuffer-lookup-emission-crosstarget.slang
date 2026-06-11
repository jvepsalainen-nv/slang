//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:23:45+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/expressions-identifier.md#implicit-lookup
//META: doc_section_digest=81444a04e3158afb0f979b5eaa4e66672a28128589f884b354ac44b03dbff7ad
//META: purpose=A bare identifier inside a function body resolves to a field declared inside a global-scope cbuffer, via implicit cbuffer lookup.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the implicit-cbuffer-lookup claim: the HLSL sibling
// (implicit-cbuffer-lookup-emission.slang) pins the same claim on HLSL. Here the
// bare names `scale`/`offset` resolve to the cbuffer fields, and on every other
// text-emit target the access emerges qualified through the parameter-group struct.
// Each CHECK pins the per-target qualified field access (real emitted text), proving
// the implicit lookup bound the bare names to the cbuffer members on that target.
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

cbuffer Params
{
    int scale;
    int offset;
}

RWStructuredBuffer<int> outBuf;

int compute(int x)
{
    // 'scale' and 'offset' are bare identifiers resolving to the cbuffer fields.
    return x * scale + offset;
}

[numthreads(1, 1, 1)]
void computeMain()
{
    outBuf[0] = compute(3);
}

// GLSL qualifies through the parameter-group block variable.
// GLSL-DAG: Params_{{[0-9]+}}.scale_{{[0-9]+}}
// GLSL-DAG: Params_{{[0-9]+}}.offset_{{[0-9]+}}

// SPIR-V names the parameter-group struct members from the cbuffer fields.
// SPV-DAG: OpName %Params "Params"
// SPV-DAG: OpMemberName %SLANG_ParameterGroup_Params_std140 0 "scale"
// SPV-DAG: OpMemberName %SLANG_ParameterGroup_Params_std140 1 "offset"

// Metal threads the parameter group through the kernel context pointer.
// METAL-DAG: kernelContext_{{[0-9]+}}->Params_{{[0-9]+}}->scale_{{[0-9]+}}
// METAL-DAG: kernelContext_{{[0-9]+}}->Params_{{[0-9]+}}->offset_{{[0-9]+}}

// WGSL qualifies through the uniform parameter-group variable.
// WGSL-DAG: Params_{{[0-9]+}}.scale_{{[0-9]+}}
// WGSL-DAG: Params_{{[0-9]+}}.offset_{{[0-9]+}}
