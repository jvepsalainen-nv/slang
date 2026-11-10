//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#preludes
//META: purpose=The prelude registered for the emitted source language is written right after the front matter: CUDA emits `slang-cuda-prelude.h`, C++ emits `slang-cpp-prelude.h`, and the HLSL prelude contributes the `SLANG_HLSL_ENABLE_NVAPI`-guarded NVAPI extension include.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the prelude selection and its placement. Sequential (not -DAG)
// CHECKs assert the prelude precedes the module body, which is the stitching
// order the emit stage uses: front matter, prelude, then declarations. The
// include paths are absolute in the emitted text, so only the file names are
// matched. HLSL is the odd one out: its prelude contributes a conditional
// NVAPI include rather than an unconditional Slang header, so the HLSL prefix
// pins the guard macro instead of a `slang-*-prelude.h` name.

//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry main -stage compute
//TEST:SIMPLE(filecheck=CPP):-target cpp -entry main -stage compute
//TEST:SIMPLE(filecheck=HLSL):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[0] = int(tid.x);
}

// CUDA: slang-cuda-prelude.h
// CUDA: struct GlobalParams_

// CPP: slang-cpp-prelude.h
// CPP: struct GlobalParams_

// HLSL: {{^}}#ifdef SLANG_HLSL_ENABLE_NVAPI
// HLSL: RWStructuredBuffer<int
