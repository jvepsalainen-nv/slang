//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#function-parameters-with-inout-inout-modifiers
//META: doc_section_digest=50b3040fe642ee135f57002e37f20cd9b949f33677eec525295c406b3b231822
//META: purpose=`in` is the default parameter direction: a parameter declared without a direction modifier emits identically to one declared with explicit `in`, both without `inout`/`out` on the HLSL signature.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the HLSL `in`-default claim (in-default-direction-hlsl-emission.slang)
// to the remaining shader targets so the fan-out gate is satisfied. Both an
// implicit and an explicit `in` parameter emit as plain value parameters; on
// SPIR-V each is an OpFunctionParameter of value type %int (no Function pointer),
// and on GLSL/Metal/WGSL each is a plain value parameter with no out/inout/ptr.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=SPV):-target spirv-asm -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=MTL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

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

// GLSL: void readImplicit_{{[0-9]+}}(int val_{{[0-9]+}})
// GLSL: void readExplicit_{{[0-9]+}}(int val_{{[0-9]+}})

// SPV: %readImplicit = OpFunction %void DontInline
// SPV: %val{{.*}} = OpFunctionParameter %int
// SPV: %readExplicit = OpFunction %void DontInline
// SPV: %val{{.*}} = OpFunctionParameter %int

// MTL: void readImplicit_{{[0-9]+}}(int val_{{[0-9]+}}
// MTL: void readExplicit_{{[0-9]+}}(int val_{{[0-9]+}}

// WGSL: fn readImplicit_{{[0-9]+}}( val_{{[0-9]+}} : i32)
// WGSL: fn readExplicit_{{[0-9]+}}( val_{{[0-9]+}} : i32)
