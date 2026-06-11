//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#function-parameters-with-inout-inout-modifiers
//META: doc_section_digest=50b3040fe642ee135f57002e37f20cd9b949f33677eec525295c406b3b231822
//META: purpose=`inout` parameter emission on non-HLSL/non-SPIRV backends: GLSL preserves the `inout` keyword; Metal, CUDA, and C++ lower to a pointer parameter; WGSL lowers to `ptr<function, i32>`.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the multi-target `inout` claim (inout-parameter-glsl-emission.slang) to
// HLSL and SPIR-V so the fan-out gate covers every shader target. HLSL preserves the
// `inout` keyword on the signature; SPIR-V passes the parameter as a Function-storage
// pointer (%_ptr_Function_int) allowing multiple OpLoad/OpStore in the body.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute

RWStructuredBuffer<int> output;

[noinline]
void multiReadWrite(inout int val)
{
    int r1 = val;
    int r2 = val;
    val = r1 + r2;
    int r3 = val;
    val = r3 * 2;
}

[numthreads(1,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    int x = output[0];
    multiReadWrite(x);
    output[0] = x;
}

// HLSL: void multiReadWrite_{{[0-9]+}}(inout int val_{{[0-9]+}})
// HLSL: val_{{[0-9]+}} =

// SPV: %_ptr_Function_int = OpTypePointer Function %int
// SPV: %val = OpFunctionParameter %_ptr_Function_int
// SPV: OpLoad %int %val
// SPV: OpStore %val
