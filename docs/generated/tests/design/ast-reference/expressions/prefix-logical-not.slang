//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A PrefixExpr `!x` is the logical-not unary prefix operator; it flips a bool value.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// PrefixExpr covers `!x` (the example given in the doc's Nodes row).
// Negating a true and a false confirms both polarities.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    bool t = true;
    bool f = false;
    // CHECK: !t=0
    printf("!t=%d\n", int(!t));
    // CHECK: !f=1
    printf("!f=%d\n", int(!f));
}
