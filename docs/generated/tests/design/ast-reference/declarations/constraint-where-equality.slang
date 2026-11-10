//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/declarations.md#generictypeconstraintdecl-as-an-interface-requirement
//META: purpose=A `where T == U` clause is the equality spelling of a generic constraint and is satisfied when both parameters are inferred to the same type.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that the `==` spelling of a `where` clause is accepted and
// satisfiable. The generic takes two independent type parameters constrained
// to be equal and is called with two `int` arguments; the CHECK asserts the
// body's marker value, which only prints if the equality constraint was
// discharged.

//TEST:INTERPRET(filecheck=CHECK):

int sameType<T, U>(T a, U b) where T == U { return 7; }

void main()
{
    //CHECK: 7
    printf("%d\n", sameType(1, 2));
}
