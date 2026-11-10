//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/modifiers.md#nodes
//META: purpose=`[ForceUnroll]` unrolls the loop inside Slang, so no loop remains in the emitted HLSL.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies `[ForceUnroll]` is stronger than the `[unroll]` hint: Slang performs
// the unrolling itself instead of deferring it downstream. The loop body depends
// on the thread id so it cannot be folded away wholesale, yet CHECK-NOT asserts
// no `for(` survives in the emitted HLSL while CHECK asserts the entry point is
// still there -- i.e. the loop was replaced by its unrolled body.

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry main -stage compute

RWStructuredBuffer<int> outBuf;

[numthreads(1,1,1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    int total = int(tid.x);
    [ForceUnroll]
    for (int j = 0; j < 3; ++j)
    {
        total = total * 2 + j;
    }
    outBuf[tid.x] = total;
}

//CHECK: void main
//CHECK-NOT: for(
