//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#lambdaexpr-and-lambdadecl
//META: purpose=Stresses LambdaExpr nesting: a curried `(int x) => (int y) => x + y` parses, captures `x` into the inner lambda, and yields the documented sum.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Two LambdaExpr nodes nested. The inner lambda captures the outer
// lambda's parameter `x`. Currying `add(5)(7)` must yield 12.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    var add = (int x) => (int y) => x + y;
    var addToFive = add(5);
    // CHECK: r=12
    printf("r=%d\n", addToFive(7));
}
