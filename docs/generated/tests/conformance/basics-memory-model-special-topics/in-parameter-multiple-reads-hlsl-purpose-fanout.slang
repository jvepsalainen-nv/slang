//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#function-parameters-with-inout-inout-modifiers
//META: doc_section_digest=50b3040fe642ee135f57002e37f20cd9b949f33677eec525295c406b3b231822
//META: purpose=`in` parameter: the function may read it any number of times; HLSL emits a plain value parameter that is read multiple times in the function body without restriction.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the HLSL `in`-multiple-reads claim (in-parameter-multiple-reads-hlsl-emission.slang)
// to the remaining shader targets. `sumOfReads` reads `val` three times; on GLSL/Metal/WGSL
// the parameter stays a plain value used repeatedly in the addition, and on SPIR-V the
// parameter is a value-typed OpFunctionParameter feeding two OpIAdd reading %val twice.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=MTL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

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

// GLSL: void sumOfReads_{{[0-9]+}}(int val_{{[0-9]+}})
// GLSL: val_{{[0-9]+}} + val_{{[0-9]+}} + val_{{[0-9]+}}

// SPV: %val{{.*}} = OpFunctionParameter %int
// SPV: OpIAdd %int %val{{.*}} %val{{.*}}

// MTL: void sumOfReads_{{[0-9]+}}(int val_{{[0-9]+}}
// MTL: val_{{[0-9]+}} + val_{{[0-9]+}} + val_{{[0-9]+}}

// WGSL: fn sumOfReads_{{[0-9]+}}( val_{{[0-9]+}} : i32)
// WGSL: val_{{[0-9]+}} + val_{{[0-9]+}} + val_{{[0-9]+}}
