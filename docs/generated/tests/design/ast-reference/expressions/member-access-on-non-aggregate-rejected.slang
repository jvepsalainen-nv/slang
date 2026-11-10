//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=A MemberExpr `a.b` where the base is a scalar (`int`) with no field `foo` is rejected with the same "member not found" diagnostic as a missing struct field.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Negative shape for MemberExpr resolution: a non-aggregate base
// type has no fields. The diagnostic should name `foo` as not a
// member of `int`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):

void main()
{
    int x = 7;
    int y = x.foo;
//CHECK:      ^^^ member not found
//CHECK:      ^^^ 'foo' is not a member of 'int'.
// CHECK: E30027
}
