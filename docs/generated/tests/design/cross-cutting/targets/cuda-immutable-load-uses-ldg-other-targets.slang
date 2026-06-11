//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T11:32:01+00:00
//META: source_commit=1ee81dae21143fb69ccb9999f0fd013b4db2d922
//META: doc_ref=docs/generated/design/cross-cutting/targets.md#how-target-choice-affects-ir
//META: doc_section_digest=96146019aaea16661ac66159cf8328c2ae1406fa65d0708df73480a207c02e9c
//META: purpose=The CUDA target-specific lowering pass (`slang-ir-cuda-immutable-load.cpp`, named in the doc) rewrites reads from `uniform` globals as `__ldg(...)` calls on CUDA only; HLSL/GLSL/SPIR-V/Metal/WGSL/CPP read the field directly.
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Companion to cuda-immutable-load-uses-ldg.slang. That file pins the
// `__ldg(` rewrite on CUDA and its absence on HLSL/CPP. This file fans
// the "read the field directly" half of the same claim across the
// remaining text-emit backends (GLSL/SPIR-V/Metal/WGSL): each CHECK
// asserts the plain field read of the `uniform` global and `-NOT`
// asserts no `__ldg` appears — only CUDA's dedicated pass synthesizes it.

//TEST:SIMPLE(filecheck=GLSL):-target glsl -entry main -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage compute
//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=WGSL):-target wgsl -entry main -stage compute

uniform int gValue;
uniform RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = gValue;
}

// GLSL: globalParams_0.gValue_{{[0-9]+}}
// GLSL-NOT: __ldg

// SPIRV: OpEntryPoint GLCompute
// SPIRV-NOT: __ldg

// METAL: globalParams_1->gValue_{{[0-9]+}}
// METAL-NOT: __ldg

// WGSL: globalParams_0.gValue_{{[0-9]+}}
// WGSL-NOT: __ldg
