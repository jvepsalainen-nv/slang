//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#finalize-phase-completeoverloadcandidate
//META: purpose=TryCheckOverloadCandidateClassNewMatchUp runs only in the finalize re-check and rejects a new expression whose candidate does not construct a class.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the new/class pairing step. The struct's constructor is a perfectly
// applicable candidate, so it wins the probe phase; only the ForReal re-check
// notices the surface form is `new` while the constructed type is a struct.
// CHECK pins that rejection.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct S { int v; }

void make()
{
    S s = new S();
//CHECK:  ^^^ `new` can only be used to initialize a class
    printf("%d\n", s.v);
}

void main() { make(); }
