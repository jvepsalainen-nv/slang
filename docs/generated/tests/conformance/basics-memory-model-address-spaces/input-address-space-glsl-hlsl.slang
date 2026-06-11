//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T10:38:40+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/basics-memory-model-address-spaces.md#address-spaces
//META: doc_section_digest=3851dfb34bba532778d07931eed37a5ffb7720f62c8acf95efe83c116ec49a46
//META: purpose=Entry-point input parameters (non-uniform) belong to the Input address space; SPIRV emits built-in inputs with `Input` storage class.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Per-target fan-out (GLSL, HLSL) of input-address-space-spirv.slang. The system-supplied
// per-thread `SV_DispatchThreadID` that SPIRV emits as an `Input` storage class variable maps to
// the GLSL `gl_GlobalInvocationID` built-in and stays `SV_DispatchThreadID` on HLSL; CHECK pins
// each target's input-builtin form.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry computeMain -stage compute

[numthreads(4, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID, RWStructuredBuffer<uint> output)
{
    output[tid.x] = tid.x;
}

// GLSL maps the non-uniform input parameter to the gl_GlobalInvocationID built-in.
// GLSL: gl_GlobalInvocationID
// HLSL keeps the input parameter with its SV_DispatchThreadID semantic.
// HLSL: SV_DispatchThreadID
