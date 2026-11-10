//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#target-specific-lowering
//META: purpose=The CUDA immutable-load pass wraps read-only `StructuredBuffer` element loads in `__ldg(&...)` on the CUDA target.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The "CUDA immutable load" row of the target-specific lowering
// table (`slang-ir-cuda-immutable-load.cpp`) rewrites eligible
// global-memory loads from a read-only buffer into `__ldg(...)`
// intrinsic reads on the CUDA backend.

//TEST:SIMPLE(filecheck=CUDA):-target cuda -stage compute -entry main

StructuredBuffer<int> input;
RWStructuredBuffer<int> buf;

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = input[tid.x] + 1;
}

// CUDA: __ldg(
