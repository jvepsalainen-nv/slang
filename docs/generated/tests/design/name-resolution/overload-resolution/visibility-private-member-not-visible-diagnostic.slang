//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=TryCheckOverloadCandidateVisibility drops a candidate that isDeclVisibleFromScope rejects, and the finalize re-check emits decl-is-not-visible.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the visibility filter step. `secret` is the only candidate and it is
// private to S, so the visibility step rejects it from a call site outside S.
// CHECK pins the not-accessible diagnostic on the member name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

struct S
{
    private int secret() { return 42; }
}

void main()
{
    S s;
    int v = s.secret();
//CHECK:      ^^^^^^ 'secret' is not accessible from the current context.
    printf("%d\n", v);
}
