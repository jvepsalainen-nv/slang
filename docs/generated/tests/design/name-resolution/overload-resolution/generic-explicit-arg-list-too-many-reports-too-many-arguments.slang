//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=An explicit generic-argument list with too many arguments is rejected by the arity step with too-many-arguments rather than by the generic-argument-list arity diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the doc's worked example for which step catches an oversized
// explicit generic-argument list. The arity step leaves `allowed` at the
// declared generic parameter count, so three arguments to a two-parameter
// generic are rejected there; CHECK pins the ordinary arity message and its
// got/expected counts.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

int g<T, U>(T a, U b) { return 1; }

void main()
{
    int tag = g<int, float, int>(1, 2.0f);
//CHECK:      ^ too many arguments to call (got 3, expected 2)
    printf("tag=%d\n", tag);
}
