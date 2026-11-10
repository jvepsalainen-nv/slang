//META: generated=true
//META: doc_ref=docs/language-reference/basics-memory-model-consistency.md#atomics
//META: purpose=Release-acquire ordering: thread A writing a payload and performing atomic store-release, followed by thread B atomic load-acquire observing that store, causes thread B to see all thread A side effects before the store.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the release-acquire cross-thread synchronization guarantee: thread A writes
// a payload value then performs a store-release on a flag; thread B spin-waits with
// load-acquire on the flag and, once it observes the flag set, reads the payload.
// CHECK asserts the payload value is 42 — observable only if the memory ordering
// guarantee propagated thread A's write to thread B. GPU-only; CI nightly validates.

//TEST:COMPARE_COMPUTE(filecheck-buffer=CHECK):-dx12 -output-using-type

RWStructuredBuffer<uint> payload;
RWStructuredBuffer<Atomic<uint>> flag;
RWStructuredBuffer<uint> result;

[numthreads(2,1,1)]
void computeMain(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x == 0)
    {
        // Thread A: write payload then signal with release store
        payload[0] = 42u;
        flag[0].store(1u, MemoryOrder.Release);
    }
    else
    {
        // Thread B: spin-wait on acquire load; once observed, read payload
        uint observed = 0u;
        while (observed == 0u)
        {
            observed = flag[0].load(MemoryOrder.Acquire);
        }
        result[0] = payload[0];
    }
}

// Thread B must see payload[0] == 42 after acquiring the flag.
// CHECK: 42
