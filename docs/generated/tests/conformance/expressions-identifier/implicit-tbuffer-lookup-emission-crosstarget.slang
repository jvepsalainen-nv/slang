//META: generated=true
//META: model=claude-opus-4-8
//META: generated_at=2026-06-11T11:23:45+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/language-reference/expressions-identifier.md#implicit-lookup
//META: doc_section_digest=81444a04e3158afb0f979b5eaa4e66672a28128589f884b354ac44b03dbff7ad
//META: purpose=A bare identifier resolves to a field declared inside a global-scope tbuffer, via implicit tbuffer lookup.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Back-end fan-out for the implicit-tbuffer-lookup claim (HLSL sibling pins it on HLSL).
// The bare name `multiplier` resolves to the tbuffer field; on each other text-emit
// target the access emerges qualified through the parameter-group. Each CHECK pins the
// per-target qualified field access (real emitted text). The spirv-asm target is NOT
// fanned out here: emitting a tbuffer to SPIR-V aborts with an unhandled-inst internal
// error (see Untested row + finding declarations-tbuffer-spirv-cuda-cpp-crash).
//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry computeMain -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry computeMain -stage compute

tbuffer TParams
{
    int multiplier;
}

RWStructuredBuffer<int> outBuf;

[numthreads(1, 1, 1)]
void computeMain()
{
    // 'multiplier' is a bare identifier resolving via implicit tbuffer lookup.
    outBuf[0] = multiplier * 2;
}

// GLSL qualifies through the parameter-group block variable.
// GLSL: TParams_{{[0-9]+}}.multiplier_{{[0-9]+}}

// Metal threads the texture_buffer parameter group through a pointer deref.
// METAL: TParams_{{[0-9]+}}->multiplier_{{[0-9]+}}

// WGSL qualifies through the uniform parameter-group variable.
// WGSL: TParams_{{[0-9]+}}.multiplier_{{[0-9]+}}
