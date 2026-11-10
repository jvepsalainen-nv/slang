//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/06-emit.md#emit-dispatcher
//META: purpose=The C++ and CUDA header target variants (`-target hpp`, `-target cuh`) are routed through the same textual emit path as their source variants and emit an include guard plus the same prelude.
//META: intent=functional
//META: pipeline_stage=emit
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the header variants of the C-family source targets belong to
// the textual set the dispatcher hands to the source-emit path. The same
// kernel is compiled to `hpp` and `cuh`; each CHECK asserts the output opens
// with `#pragma once` and carries the prelude header of the corresponding
// source language, which is only true if the header variant was mapped to the
// C++ / CUDA emitter rather than rejected as an unknown target.

//TEST:SIMPLE(filecheck=HPP):-target hpp -entry main -stage compute
//TEST:SIMPLE(filecheck=CUH):-target cuh -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[shader("compute")]
[numthreads(4, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = int(tid.x) + 1;
}

// HPP: {{^}}#pragma once
// HPP: slang-cpp-prelude.h

// CUH: {{^}}#pragma once
// CUH-DAG: slang-cuda-prelude.h
// CUH-DAG: SLANG_globalParams
