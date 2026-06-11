//META: generated=true
//META: model=claude-opus-4-8[1m]
//META: generated_at=2026-06-11T00:00:00+00:00
//META: source_commit=3250005059a2746ebc504a9d3f71ed112f1f2b94
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#preludes
//META: doc_section_digest=e35f51be3beae3d8e169e53667630c421c042fdc0c864ef7e4a6aea3014b6b82
//META: purpose=Targets that ship a `prelude/` header (HLSL, CUDA, C++) emit text that references it. GLSL, Metal, and WGSL do not include a `prelude/` header (Metal pulls in metal_stdlib, which is the platform's system header, not the Slang `prelude/`).
//META: intent=expansion
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Fan-out of the preludes claim onto Metal and SPIR-V — the existing
// sibling (preludes-included-by-c-and-cuda.slang) covers HLSL/CUDA/C++
// (positive) and GLSL/WGSL (negative) but not Metal or SPIR-V. Both are
// in the "no Slang prelude" group: Metal includes only the platform
// `metal_stdlib` system header, and SPIR-V assembly has no `#include`
// grammar at all. CHECK pins each target's own non-prelude marker and
// forbids any `slang-*-prelude.h` reference.

//TEST:SIMPLE(filecheck=METAL):-target metal -entry main -stage compute
//TEST:SIMPLE(filecheck=SPIRV):-target spirv-asm -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// METAL: #include <metal_stdlib>
// METAL-NOT: slang-cpp-prelude.h
// METAL-NOT: slang-cuda-prelude.h
// METAL-NOT: slang-hlsl-prelude.h
// METAL-NOT: slang-metal-prelude.h

// SPIRV: OpCapability Shader
// SPIRV-NOT: slang-cpp-prelude.h
// SPIRV-NOT: slang-cuda-prelude.h
// SPIRV-NOT: slang-hlsl-prelude.h
// SPIRV-NOT: #include
