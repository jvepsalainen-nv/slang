//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#atomics
//META: purpose=All atomic modifications of a single variable occur in a total order: two concurrent `InterlockedAdd` increments on a 0-initialized variable always result in a final value of 3 (the modifications are serialized).
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that atomic modifications to a single variable are serialized in a total
// order: 64 threads each do InterlockedAdd(+1) on a zero-initialized counter, and
// the final result must be exactly 64. If any increment were lost due to a race,
// the value would be less; 64 proves all 64 operations were serialized.
// GPU-only; CI nightly validates.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-dx12 -output-using-type

RWStructuredBuffer<uint> outputBuffer;

[numthreads(64,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    uint old;
    InterlockedAdd(outputBuffer[0], 1u, old);
}

// Final value must be exactly 64: all 64 increments serialized in total order.
// CHECK: 64
