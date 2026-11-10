//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#differentiate-family-expressions
//META: purpose=A BackwardDifferentiateExpr `__bwd_diff(f)` selects the backward-mode derivative; calling it with dL/dy propagates a gradient back into the input differential.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `__bwd_diff(f)` selects the backward-mode derivative of a
// [Differentiable] function. For f(x) = x*x the gradient is 2*x, so seeding
// dL/dy = 1 at x = 3 must leave 6 in the differential slot of the pair; the
// CHECK reads that slot back.

//TEST:INTERPRET(filecheck=CHECK):

[Differentiable]
float square(float x) { return x * x; }

void main()
{
    var dp = diffPair(3.0f, 0.0f);
    __bwd_diff(square)(dp, 1.0f);
    // CHECK: d=6
    printf("d=%d\n", int(dp.d));
}
