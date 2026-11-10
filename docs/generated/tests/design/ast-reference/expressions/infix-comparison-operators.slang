//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An InfixExpr can be a comparison operator; the result is a bool that reflects the comparison.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// InfixExpr is documented as the binary-operator AST kind. The
// comparison operators yield bool results, which we print as 0/1.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    bool a = 3 < 5;
    bool b = 5 < 3;
    bool c = 5 == 5;
    bool d = 5 != 5;
    // CHECK: a=1
    printf("a=%d\n", int(a));
    // CHECK: b=0
    printf("b=%d\n", int(b));
    // CHECK: c=1
    printf("c=%d\n", int(c));
    // CHECK: d=0
    printf("d=%d\n", int(d));
}
