//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#finalize-phase-completeoverloadcandidate
//META: purpose=When no focused reason is recorded the inference failure falls through to the blanket could-not-specialize-generic diagnostic naming the argument types.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the Kind::None arm of the inference-failure switch. Nothing pins the
// pack-count parameter N here, so no focused reason is captured and the
// finalize phase emits the generic fallback. CHECK pins that fallback together
// with the argument-type list it renders.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

void load<let N : int, each TIndex>(TIndex indices) where countof(TIndex) == N
{
}

void main()
{
    load(1, 2, 3);
//CHECK:^ could not specialize generic for arguments of type (int, int, int)
}
