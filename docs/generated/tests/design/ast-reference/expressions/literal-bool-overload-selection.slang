//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#literalexpr-family
//META: purpose=Verifies that a BoolLiteralExpr `true`/`false` is typed as `bool` and steers overload resolution to the bool candidate (not to int).
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Type-level observation of BoolLiteralExpr. Two overloads — one
// for int and one for bool — let the literal pick the bool path.

//TEST:INTERPRET(filecheck=CHECK):

int which(int v)  { return 1; }
int which(bool v) { return 2; }

void main()
{
    // CHECK: t=2
    printf("t=%d\n", which(true));
    // CHECK: f=2
    printf("f=%d\n", which(false));
}
