//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:48:37+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-special-topics.md#function-parameters-with-inout-inout-modifiers
//META: doc_section_digest=50b3040fe642ee135f57002e37f20cd9b949f33677eec525295c406b3b231822
//META: purpose=`inout` parameter: SPIRV emits the argument as a Function-storage-class pointer, allowing multiple reads and writes within the function body.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Expansion of the SPIR-V `inout` claim (inout-parameter-spirv-emission.slang) to the
// remaining shader targets. The function reads and writes the `inout` parameter
// multiple times; HLSL and GLSL keep the `inout` keyword on the signature, Metal lowers
// to `int thread*`, and WGSL lowers to `ptr<function, i32>`.

//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=MTL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

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

// GLSL: void multiReadWrite_{{[0-9]+}}(inout int val_{{[0-9]+}})

// MTL: void multiReadWrite_{{[0-9]+}}(int thread* val_{{[0-9]+}})

// WGSL: fn multiReadWrite_{{[0-9]+}}( val_{{[0-9]+}} : ptr<function, i32>)
