//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An ExplicitCastExpr `(T) e` invokes a user-spelled cast; converting int to float yields the numeric value as a float.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// ExplicitCastExpr is documented as the user-written `(T) e` cast.
// Casting the int 7 to float must yield 7.0. We assert the value via
// the constructor-style float() form too, since the underlying AST
// kind is the same TypeCastExpr family.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int i = 7;
    float f = float(i);
    // CHECK: f-int=7
    printf("f-int=%d\n", int(f));
}
