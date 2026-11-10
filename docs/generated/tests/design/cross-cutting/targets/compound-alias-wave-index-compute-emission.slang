//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/targets.md#auto-generated-reference
//META: purpose=The `subgroup_workgroup_index` compound alias admits `WaveGetWaveIndex` / `WaveGetNumWaves` in a compute entry point; the queries compile and surface subgroup constructs in the emitted HLSL, GLSL, SPIR-V assembly, Metal and WGSL.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Positive companion to the fragment-rejection probes: the same wave-index
// queries the compound alias restricts to compute-class stages must be
// accepted from a compute entry point on every shader text target. The
// results are written to a buffer so DCE cannot strip them; each CHECK
// asserts the emitted text contains that backend's subgroup construct,
// proving the queries passed the capability gate and lowered there.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(4, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = WaveGetWaveIndex() + WaveGetNumWaves();
}

// GLSL: {{[Ss]ubgroup}}
// SPIRV: {{Subgroup|GroupNonUniform}}

// The remaining shader text targets accept the same two queries and
// lower them to their own wave/subgroup vocabulary, so the alias is
// not a GLSL/SPIR-V-only affordance. HLSL reaches the wave size with
// the `WaveGetLaneCount()` intrinsic, Metal takes the SIMD-group
// index and width in as entry-point attributes, and WGSL has to turn
// the `subgroups` extension on and take the same two values as
// `@builtin` inputs.

// HLSL: WaveGetLaneCount()

// (`[[` starts a FileCheck variable reference, so the Metal attribute
// brackets are matched through a regex block rather than written raw.)
// METAL-DAG: {{\[\[}}simdgroup_index_in_threadgroup{{\]\]}}
// METAL-DAG: {{\[\[}}threads_per_simdgroup{{\]\]}}

// WGSL: enable subgroups;
// WGSL-DAG: @builtin(subgroup_id)
// WGSL-DAG: @builtin(num_subgroups)
