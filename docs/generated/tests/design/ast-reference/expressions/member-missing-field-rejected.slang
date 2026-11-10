//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=A MemberExpr `a.b` where the base type does not have a member `b` is rejected with a "member not found" diagnostic.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// MemberExpr's name lookup on the base type produces an error when
// the named member doesn't exist on the base. We name a non-existent
// field `zzz` on a struct that only has `x` and `y`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

struct Pt { int x; int y; }

void main()
{
    Pt p;
    int z = p.zzz;
//CHECK:      ^^^ member not found
//CHECK:      ^^^ 'zzz' is not a member of 'Pt'.
// CHECK: E30027
}
