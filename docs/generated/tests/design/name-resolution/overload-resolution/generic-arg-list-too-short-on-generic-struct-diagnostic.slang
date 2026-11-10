//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/overload-resolution.md#probe-phase-trycheckoverloadcandidate
//META: purpose=A too-short explicit generic-argument list on a generic whose inner declaration is not a callable cannot be partially applied and reaches the generic-argument-list arity diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the carve-out that decides where a short explicit generic-argument
// list lands. The generic here wraps a struct rather than a callable, so no
// partial application is possible and the arity mismatch is reported against
// the generic's parameter list; CHECK pins that message with both counts. The
// declaration is indented so the reported caret column clears the CHECK prefix.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct Pair<T, U> { T a; U b; }

void main()
{
          Pair<int> p;
//CHECK:  ^^^^ wrong number of generic arguments
//CHECK:  ^^^^ generic 'Pair' expects 2 generic argument(s) but 1 were provided
    printf("tag=%d\n", 0);
}
