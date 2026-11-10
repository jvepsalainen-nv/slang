//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An InfixExpr evaluates a binary arithmetic operator; each operator yields the expected numeric result.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that each binary arithmetic operator evaluates to its documented
// result. Four operators are applied to the same operand pair and printed
// separately, so a single mis-mapped operator shows up as exactly one failing
// CHECK.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int add = 7 + 5;
    int sub = 7 - 5;
    int mul = 7 * 5;
    int div = 35 / 5;
    // CHECK: add=12
    printf("add=%d\n", add);
    // CHECK: sub=2
    printf("sub=%d\n", sub);
    // CHECK: mul=35
    printf("mul=%d\n", mul);
    // CHECK: div=7
    printf("div=%d\n", div);
}
