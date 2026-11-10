//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#finalize-phase-completeoverloadcandidate
//META: purpose=TryCheckOverloadCandidateClassNewMatchUp rejects a plain constructor call whose candidate constructs a class, which must be initialized with new.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the mirror arm of the new/class pairing step: the candidate is a
// class constructor but the surface form is a plain call. The mismatch is only
// detected in the finalize re-check; CHECK pins the resulting diagnostic.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

class C { int v; __init() { v = 7; } }

void make()
{
    C c = C();
//CHECK:   ^ a class can only be initialized by a `new` clause
    printf("%d\n", c.v);
}

void main() { make(); }
