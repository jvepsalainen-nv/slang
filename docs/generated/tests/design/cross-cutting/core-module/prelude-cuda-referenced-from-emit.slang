//META: generated=true
//META: doc_ref=docs/generated/design/cross-cutting/core-module.md#preludes
//META: purpose=The CUDA prelude is referenced from -target cuda output: the emitted text pulls in slang-cuda-prelude.h and declares the entry point with extern "C" __global__.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the CUDA back end reaches its prelude the same output-side
// way the C++ back end does. The shader is prelude-agnostic; the
// CHECKs pin the slang-cuda-prelude.h reference plus the
// extern "C" __global__ entry-point form whose helper types come from
// that header, which together show the emitted text depends on the
// prelude rather than on anything the front end checked.

//TEST:SIMPLE(filecheck=CUDA):-target cuda -entry computeMain -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(1, 1, 1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x);
}

// CUDA: slang-cuda-prelude.h
// CUDA: extern "C" __global__ void computeMain
