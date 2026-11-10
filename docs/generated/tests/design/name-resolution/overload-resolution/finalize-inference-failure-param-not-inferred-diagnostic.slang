//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#finalize-phase-completeoverloadcandidate
//META: purpose=When a candidate ends at GenericArgumentInferenceFailed with OrdinaryGenericParamNotInferred, CompleteOverloadCandidate emits the focused could-not-infer-parameter diagnostic naming the parameter.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the focused per-Kind diagnostic selection in the finalize phase.
// `unbox` needs T from a `Box<T>` argument, but the call passes a bare int, so
// T stays undetermined. CHECK pins the parameter-specific message rather than
// the blanket "could not specialize generic" fallback.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct Box<T> { T inner; }

T unbox<T>(Box<T> b) { return b.inner; }

void main()
{
    int x = unbox(42);
//CHECK:         ^ could not infer generic argument for parameter 'T'
    printf("%d\n", x);
}
