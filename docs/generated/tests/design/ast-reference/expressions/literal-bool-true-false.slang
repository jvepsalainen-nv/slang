//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=A BoolLiteralExpr carries `true` or `false`; both spellings evaluate to their respective boolean values.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// The keywords `true` and `false` parse as BoolLiteralExpr nodes
// whose `value: bool` field is the corresponding boolean. Using them
// in conditionals selects the matching branch.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int t = true  ? 11 : 22;
    int f = false ? 11 : 22;
    // CHECK: t=11
    printf("t=%d\n", t);
    // CHECK: f=22
    printf("f=%d\n", f);
}
