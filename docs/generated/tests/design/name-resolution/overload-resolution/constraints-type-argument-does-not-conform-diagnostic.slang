//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=TryCheckOverloadCandidateConstraints rejects a generic candidate whose inferred type argument does not satisfy the declared interface conformance.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the constraint step. `describe` requires T : IShape; the call
// supplies an `int`, which has no IShape conformance, so the constraint check
// fails and the ForReal re-check reports it. CHECK pins the
// does-not-conform-to-interface error at the argument.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):

interface IShape { int kind(); }

int describe<T : IShape>(T s) { return s.kind(); }

void main()
{
    int r = describe(5);
//CHECK:            ^ type argument 'int' does not conform to the required interface 'IShape'
    printf("%d\n", r);
}
