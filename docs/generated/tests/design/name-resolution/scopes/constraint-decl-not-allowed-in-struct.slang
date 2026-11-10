//META: generated=true
//META: doc_ref=docs/generated/design/name-resolution/scopes.md#edge-cases-and-failure-modes
//META: purpose=A __constraint written inside a struct is rejected by the placement rule with E30102, which is separate from the This-subject rule that applies once the decl is somewhere it is allowed.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// `isDeclAllowed` does not list `GenericTypeConstraintDecl` in its
// StructDecl / ClassDecl / EnumDecl arm, so the decl is rejected on
// placement alone -- before any question about what its subject resolves to.
// The interface below carries the same `__constraint` in a position the
// predicate does allow and is annotated with nothing, so exhaustive mode
// asserts the placement rule is not over-firing.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -entry main -stage compute

interface IBar {}

interface IAllowed
{
    associatedtype T;
    __constraint T : IBar;
}

struct Rejected
{
    __constraint int : IBar;
/*CHECK:
                     ^ error E30102
                     ^ GenericTypeConstraintDecl is not allowed here.
*/
}

RWStructuredBuffer<int> gOut;

[shader("compute")]
[numthreads(1, 1, 1)]
void main()
{
    gOut[0] = 1;
}
