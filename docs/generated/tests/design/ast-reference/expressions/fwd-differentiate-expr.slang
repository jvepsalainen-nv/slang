//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#differentiate-family-expressions
//META: purpose=A ForwardDifferentiateExpr `__fwd_diff(f)` selects the forward-mode derivative of a [Differentiable] function.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that `__fwd_diff(f)` selects the forward-mode derivative of a
// [Differentiable] function. f(x) = x*x evaluated at x = 3 with dx = 1 must
// yield the primal 9 and the differential 6; the CHECKs read both halves of
// the returned pair.

//TEST:INTERPRET(filecheck=CHECK):

[Differentiable]
float square(float x) { return x * x; }

void main()
{
    DifferentialPair<float> r = __fwd_diff(square)(diffPair(3.0f, 1.0f));
    // CHECK: p=9
    printf("p=%d\n", int(r.p));
    // CHECK: d=6
    printf("d=%d\n", int(r.d));
}
