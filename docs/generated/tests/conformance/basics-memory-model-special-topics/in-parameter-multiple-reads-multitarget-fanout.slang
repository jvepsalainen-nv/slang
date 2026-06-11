//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#function-parameters-with-inout-inout-modifiers
//META: doc_section_digest=50b3040fe642ee135f57002e37f20cd9b949f33677eec525295c406b3b231822
//META: purpose=`in` parameter may be read any number of times: GLSL, Metal, CUDA, C++, and WGSL each emit a plain value parameter that appears multiple times in an addition expression.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the multi-target `in`-multiple-reads claim
// (in-parameter-multiple-reads-glsl-emission.slang) to HLSL and SPIR-V. `sumOfReads`
// reads `val` three times; HLSL emits a plain `int` value parameter read repeatedly
// in the addition, and SPIR-V emits a value-typed OpFunctionParameter feeding an
// OpIAdd that reads %val twice.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> output;

[noinline]
void sumOfReads(in int val)
{
    int r = val + val + val;
    output[0] = r;
}

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int x = output[1];
    sumOfReads(x);
}

// HLSL: void sumOfReads_{{[0-9]+}}(int val_{{[0-9]+}})
// HLSL: val_{{[0-9]+}} + val_{{[0-9]+}} + val_{{[0-9]+}}

// SPV: %val{{.*}} = OpFunctionParameter %int
// SPV: OpIAdd %int %val{{.*}} %val{{.*}}
