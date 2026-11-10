//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/resources-and-atomics.md#buffer-load-and-store
//META: purpose=`StructuredBuffer::Load(idx, out status)` (the documented status-overload that would surface `structuredBufferLoadStatus`) is rejected with `E36107` on the `compute` stage for `spirv` per the existing doc-gap finding.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative probe: the `buffer-load-and-store` table lists
// `structuredBufferLoadStatus` produced by the `Load(idx, out status)`
// overload, but this overload requires a capability that is not
// available in the `compute` stage on the `spirv` target. The
// resulting error is `E36107` "unavailable features in entry point".
// This is recorded as a doc-gap in README.md.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target spirv -stage compute -entry main

uniform StructuredBuffer<int> sbuf;
uniform RWStructuredBuffer<int> rwbuf;

void main(uint3 tid : SV_DispatchThreadID)
/*CHECK:
     ^^^^ unavailable features in entry point
*/
// CHECK: E36107
{
    int idx = (int)tid.x;
    uint status;
    int v = sbuf.Load(idx, status);
    rwbuf[idx] = v;
}
