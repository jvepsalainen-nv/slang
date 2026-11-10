//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/02-parse-ast.md#interface-associated-type-and-__constraint-requirements
//META: purpose=A `__constraint` outside an interface or generic (here, in a struct body) is rejected by the central decl-nesting check with E30102.
//META: intent=negative
//META: pipeline_stage=parse
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the documented central legality rule: the constraint decl
// a `__constraint` produces is only permitted as a member of an
// interface or generic. Placing one in a struct body is diagnosed as
// a misplaced declaration; CHECK pins the code E30102.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

interface IFoo
{
    int f();
}

struct Bad
{
    __constraint int : IFoo;
//CHECK:             ^ error E30102
//CHECK:             ^ GenericTypeConstraintDecl is not allowed here.
}
