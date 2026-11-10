//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=TryCheckOverloadCandidateArity rejects a call below the required argument count and the finalize re-check emits not-enough-arguments.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower edge of the arity step: a two-parameter callable invoked
// with one argument. The single candidate is still kept as the least-bad one,
// so the ForReal re-check reports the arity failure; CHECK pins that message
// at the call site.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

int add(int a, int b) { return a + b; }

void main()
{
    int v = add(7);
//CHECK:       ^ not enough arguments to call
    printf("%d\n", v);
}
