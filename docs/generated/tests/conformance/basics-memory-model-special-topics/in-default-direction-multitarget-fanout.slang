//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#function-parameters-with-inout-inout-modifiers
//META: doc_section_digest=50b3040fe642ee135f57002e37f20cd9b949f33677eec525295c406b3b231822
//META: purpose=`in` is the default parameter direction: GLSL, Metal, CUDA, C++, and WGSL each emit both implicit and explicit `in` parameters as plain value parameters (no pointer or reference indirection).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the multi-target `in`-default claim (in-default-direction-glsl-emission.slang)
// to HLSL and SPIR-V so the fan-out gate covers every shader target. HLSL emits both
// the implicit and explicit `in` parameter as plain `int` value parameters; SPIR-V
// emits each as an OpFunctionParameter of value type %int (not a Function pointer).

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> output;

[noinline]
void readImplicit(int val)
{
    output[2] = val;
}

[noinline]
void readExplicit(in int val)
{
    output[3] = val;
}

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int x = output[0];
    readImplicit(x);
    readExplicit(x);
}

// HLSL: void readImplicit_{{[0-9]+}}(int val_{{[0-9]+}})
// HLSL: void readExplicit_{{[0-9]+}}(int val_{{[0-9]+}})

// SPV: %readImplicit = OpFunction %void DontInline
// SPV: %val{{.*}} = OpFunctionParameter %int
// SPV: %readExplicit = OpFunction %void DontInline
// SPV: %val{{.*}} = OpFunctionParameter %int
