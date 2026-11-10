//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=A MemberExpr `a.b` accesses a field on a value-typed base; the read returns the field's value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `a.b` on a value-typed base resolves to the named field and
// reads its stored value. Two distinct fields are written and then read back
// through separate member accesses, so the CHECKs fail if either access
// resolved to the wrong field.

//TEST:INTERPRET(filecheck=CHECK):

struct Pt { int x; int y; }

void main()
{
    Pt p = {3, 4};
    // CHECK: x=3
    printf("x=%d\n", p.x);
    // CHECK: y=4
    printf("y=%d\n", p.y);
}
